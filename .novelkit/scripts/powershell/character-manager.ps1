param (
    [string]$Action,
    [string]$Arguments,
    [switch]$Json
)

$ErrorActionPreference = "Stop"

# Colors (simulated)
function Write-Color([string]$text, [string]$color) {
    if ($color -eq "red") { Write-Host $text -ForegroundColor Red }
    elseif ($color -eq "green") { Write-Host $text -ForegroundColor Green }
    elseif ($color -eq "yellow") { Write-Host $text -ForegroundColor Yellow }
    else { Write-Host $text }
}

# Find repository root
function Find-RepoRoot {
    param ([string]$dir)
    $current = $dir
    while ($current -ne $null -and $current -ne "") {
        if ((Test-Path "$current\.git") -or (Test-Path "$current\.novelkit")) {
            return $current
        }
        $parent = Split-Path -Parent $current
        if ($parent -eq $current) { return $null }
        $current = $parent
    }
    return $null
}

$REPO_ROOT = Find-RepoRoot (Get-Location).Path
if (-not $REPO_ROOT) {
    Write-Error "Error: Could not find repository root"
    exit 1
}

$CHARACTERS_DIR = Join-Path $REPO_ROOT "world\characters"
$STATE_FILE = Join-Path $REPO_ROOT ".novelkit\memory\config.json"
$TEMPLATE_FILE = Join-Path $REPO_ROOT ".novelkit	emplates\character.md"

# Ensure directories exist
if (-not (Test-Path $CHARACTERS_DIR)) {
    New-Item -ItemType Directory -Force -Path $CHARACTERS_DIR | Out-Null
}

# Check config.json exists
if (-not (Test-Path $STATE_FILE)) {
    Write-Error "Error: config.json not found in .novelkit/memory/. It should already exist."
    exit 1
}

# Get next character ID
function Get-NextCharacterId {
    $highest = 0
    if (Test-Path $CHARACTERS_DIR) {
        $files = Get-ChildItem -Path $CHARACTERS_DIR -Filter "character-*.md"
        foreach ($file in $files) {
            if ($file.Name -match "character-(\d+)\.md") {
                $num = [int]$matches[1]
                if ($num -gt $highest) {
                    $highest = $num
                }
            }
        }
    }
    return "character-{0:d3}" -f ($highest + 1)
}

# Parse JSON output helper
function Out-Json {
    param ([hashtable]$obj)
    $obj | ConvertTo-Json -Depth 10 -Compress
}

# Find character by ID or name
function Find-Character {
    param ([string]$search)
    
    if (-not $search) { return $null }
    
    # Try exact ID match first
    $path = Join-Path $CHARACTERS_DIR "$search.md"
    if (Test-Path $path) {
        return $search
    }
    
    $path = Join-Path $CHARACTERS_DIR "character-$search.md"
    if (Test-Path $path) {
        return "character-$search"
    }
    
    # Try name matching
    $files = Get-ChildItem -Path $CHARACTERS_DIR -Filter "character-*.md"
    foreach ($file in $files) {
        $content = Get-Content -Path $file.FullName -Raw
        # Extract name from header
        if ($content -match "# 角色档案：(.*?)
?
") {
            $name = $matches[1].Trim()
            if ($name -match $search) {
                return $file.BaseName
            }
        }
        elseif ($content -match "# Character Profile: (.*?)
?
") {
             $name = $matches[1].Trim()
             if ($name -match $search) {
                return $file.BaseName
             }
        }
        
        # Check Name field
        if ($content -match "\- \*\*姓名\*\*：(.*?)
?
") {
             $nameField = $matches[1].Trim()
             if ($nameField -match $search) {
                return $file.BaseName
             }
        }
    }
    
    return $null
}

# Action handlers
function Action-New {
    param ([string]$argsStr)
    
    $charName = $argsStr
    $charId = Get-NextCharacterId
    $charFile = Join-Path $CHARACTERS_DIR "$charId.md"
    $currentDate = Get-Date -Format "yyyy-MM-dd"
    
    if (Test-Path $TEMPLATE_FILE) {
        $content = Get-Content -Path $TEMPLATE_FILE -Raw
        $content = $content.Replace("[CHARACTER_NAME]", $charName)
        $content = $content.Replace("[NAME]", $charName)
        $content = $content.Replace("[DATE]", $currentDate)
        $content = $content.Replace("[CHARACTER_ID]", $charId)
        $content = $content.Replace("[STATUS]", "Active")
        Set-Content -Path $charFile -Value $content -Encoding UTF8
    } else {
        $content = @"
# 角色档案：$charName

**创建时间**：$currentDate
**最后更新**：$currentDate
**ID**：$charId
**状态**：Active

## 1. 基本信息 (Basic Information)

- **姓名**：$charName
- **别名/称号**：
- **性别**：
- **年龄**：
- **种族**：
- **身份/职业**：
- **所属阵营**：
- **出生地**：
- **现居地**：

[Content to be filled by AI]
"@
        Set-Content -Path $charFile -Value $content -Encoding UTF8
    }
    
    Out-Json @{
        action = "new"
        success = $true
        character_id = $charId
        character_name = $charName
        character_file = $charFile
        characters_dir = $CHARACTERS_DIR
    }
}

function Action-List {
    $charsList = @()
    
    if (Test-Path $CHARACTERS_DIR) {
        $files = Get-ChildItem -Path $CHARACTERS_DIR -Filter "character-*.md"
        foreach ($file in $files) {
            $charId = $file.BaseName
            $content = Get-Content -Path $file.FullName -Raw
            
            $name = $charId
            if ($content -match "# 角色档案：(.*?)
?
") {
                $name = $matches[1].Trim()
            }
            
            $role = "未定义"
            if ($content -match "\- \*\*角色定位\*\*：(.*?)
?
") {
                $role = $matches[1].Trim()
            }
            
            $status = "Active"
            if ($content -match "\*\*状态\*\*：(.*?)
?
") {
                $status = $matches[1].Trim()
            }
            
            $updated = ""
            if ($content -match "\*\*最后更新\*\*：(.*?)
?
") {
                $updated = $matches[1].Trim()
            }
            
            $charsList += @{
                id = $charId
                name = $name
                role = $role
                status = $status
                updated = $updated
            }
        }
    }
    
    Out-Json @{
        action = "list"
        success = $true
        characters = $charsList
    }
}

function Action-Show {
    param ([string]$search)
    
    $charId = Find-Character $search
    
    if (-not $charId) {
        Write-Error "{`"action`":`"show`",`"success`":false,`"error`":`"Character not found: $search`"}"
        exit 1
    }
    
    $charFile = Join-Path $CHARACTERS_DIR "$charId.md"
    
    Out-Json @{
        action = "show"
        success = $true
        character_id = $charId
        character_file = $charFile
    }
}

function Action-Update {
    param ([string]$argsStr)
    
    # Parse: char_id ...
    $firstWord = $argsStr.Split(" ")[0]
    $charId = Find-Character $firstWord
    
    if (-not $charId) {
        Write-Error "{`"action`":`"update`",`"success`":false,`"error`":`"Character not found: $firstWord`"}"
        exit 1
    }
    
    $charFile = Join-Path $CHARACTERS_DIR "$charId.md"
    
    Out-Json @{
        action = "update"
        success = $true
        character_id = $charId
        character_file = $charFile
    }
}

function Action-Delete {
    param ([string]$search)
    
    $charId = Find-Character $search
    
    if (-not $charId) {
         Write-Error "{`"action`":`"delete`",`"success`":false,`"error`":`"Character not found: $search`"}"
         exit 1
    }
    
    $charFile = Join-Path $CHARACTERS_DIR "$charId.md"
    
    # Move to trash
    $trashDir = Join-Path $REPO_ROOT ".novelkit	rash"
    if (-not (Test-Path $trashDir)) {
        New-Item -ItemType Directory -Force -Path $trashDir | Out-Null
    }
    
    Move-Item -Path $charFile -Destination $trashDir -Force
    
    Out-Json @{
        action = "delete"
        success = $true
        character_id = $charId
    }
}

# Main script logic
switch ($Action.ToLower()) {
    "new" { Action-New $Arguments }
    "list" { Action-List }
    "show" { Action-Show $Arguments }
    "update" { Action-Update $Arguments }
    "delete" { Action-Delete $Arguments }
    default {
        Write-Error "Usage: character-manager.ps1 -Action {New|List|Show|Update|Delete} [-Arguments '...']"
        exit 1
    }
}
