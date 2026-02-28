param (
    [string]$Action,
    [string]$Arguments,
    [switch]$Json
)

$ErrorActionPreference = "Stop"

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

$FACTIONS_DIR = Join-Path $REPO_ROOT "worldactions"
$STATE_FILE = Join-Path $REPO_ROOT ".novelkit\memory\config.json"
$TEMPLATE_FILE = Join-Path $REPO_ROOT ".novelkit	emplatesaction.md"

# Ensure directories exist
if (-not (Test-Path $FACTIONS_DIR)) {
    New-Item -ItemType Directory -Force -Path $FACTIONS_DIR | Out-Null
}

# Check config.json exists
if (-not (Test-Path $STATE_FILE)) {
    Write-Error "Error: config.json not found in .novelkit/memory/. It should already exist."
    exit 1
}

# Get next faction ID
function Get-NextFactionId {
    $highest = 0
    if (Test-Path $FACTIONS_DIR) {
        $files = Get-ChildItem -Path $FACTIONS_DIR -Filter "faction-*.md"
        foreach ($file in $files) {
            if ($file.Name -match "faction-(\d+)\.md") {
                $num = [int]$matches[1]
                if ($num -gt $highest) {
                    $highest = $num
                }
            }
        }
    }
    return "faction-{0:d3}" -f ($highest + 1)
}

# Parse JSON output helper
function Out-Json {
    param ([hashtable]$obj)
    $obj | ConvertTo-Json -Depth 10 -Compress
}

# Find faction by ID or name
function Find-Faction {
    param ([string]$search)
    
    if (-not $search) { return $null }
    
    # Try exact ID match first
    $path = Join-Path $FACTIONS_DIR "$search.md"
    if (Test-Path $path) {
        return $search
    }
    
    $path = Join-Path $FACTIONS_DIR "faction-$search.md"
    if (Test-Path $path) {
        return "faction-$search"
    }
    
    # Try name matching
    $files = Get-ChildItem -Path $FACTIONS_DIR -Filter "faction-*.md"
    foreach ($file in $files) {
        $content = Get-Content -Path $file.FullName -Raw
        # Extract name from header
        if ($content -match "# 阵营档案：(.*?)
?
") {
            $name = $matches[1].Trim()
            if ($name -match $search) {
                return $file.BaseName
            }
        }
        elseif ($content -match "# Faction Profile: (.*?)
?
") {
             $name = $matches[1].Trim()
             if ($name -match $search) {
                return $file.BaseName
             }
        }
        
        # Check Name field
        if ($content -match "\- \*\*名称\*\*：(.*?)
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
    
    $name = $argsStr
    $id = Get-NextFactionId
    $file = Join-Path $FACTIONS_DIR "$id.md"
    $currentDate = Get-Date -Format "yyyy-MM-dd"
    
    if (Test-Path $TEMPLATE_FILE) {
        $content = Get-Content -Path $TEMPLATE_FILE -Raw
        $content = $content.Replace("[FACTION_NAME]", $name)
        $content = $content.Replace("[NAME]", $name)
        $content = $content.Replace("[DATE]", $currentDate)
        $content = $content.Replace("[FACTION_ID]", $id)
        $content = $content.Replace("[STATUS]", "Active")
        Set-Content -Path $file -Value $content -Encoding UTF8
    } else {
        $content = @"
# 阵营档案：$name

**创建时间**：$currentDate
**最后更新**：$currentDate
**ID**：$id
**状态**：Active

## 1. 基本信息 (Basic Information)

- **名称**：$name
- **别名**：
- **类型**：
- **规模**：

[Content to be filled by AI]
"@
        Set-Content -Path $file -Value $content -Encoding UTF8
    }
    
    Out-Json @{
        action = "new"
        success = $true
        faction_id = $id
        faction_name = $name
        faction_file = $file
        factions_dir = $FACTIONS_DIR
    }
}

function Action-List {
    $list = @()
    
    if (Test-Path $FACTIONS_DIR) {
        $files = Get-ChildItem -Path $FACTIONS_DIR -Filter "faction-*.md"
        foreach ($file in $files) {
            $id = $file.BaseName
            $content = Get-Content -Path $file.FullName -Raw
            
            $name = $id
            if ($content -match "# 阵营档案：(.*?)
?
") {
                $name = $matches[1].Trim()
            }
            
            $type = "未定义"
            if ($content -match "\- \*\*类型\*\*：(.*?)
?
") {
                $type = $matches[1].Trim()
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
            
            $list += @{
                id = $id
                name = $name
                type = $type
                status = $status
                updated = $updated
            }
        }
    }
    
    Out-Json @{
        action = "list"
        success = $true
        factions = $list
    }
}

function Action-Show {
    param ([string]$search)
    
    $id = Find-Faction $search
    
    if (-not $id) {
        Write-Error "{`"action`":`"show`",`"success`":false,`"error`":`"Faction not found: $search`"}"
        exit 1
    }
    
    $file = Join-Path $FACTIONS_DIR "$id.md"
    
    Out-Json @{
        action = "show"
        success = $true
        faction_id = $id
        faction_file = $file
    }
}

function Action-Update {
    param ([string]$argsStr)
    
    # Parse: id ...
    $firstWord = $argsStr.Split(" ")[0]
    $id = Find-Faction $firstWord
    
    if (-not $id) {
        Write-Error "{`"action`":`"update`",`"success`":false,`"error`":`"Faction not found: $firstWord`"}"
        exit 1
    }
    
    $file = Join-Path $FACTIONS_DIR "$id.md"
    
    Out-Json @{
        action = "update"
        success = $true
        faction_id = $id
        faction_file = $file
    }
}

function Action-Delete {
    param ([string]$search)
    
    $id = Find-Faction $search
    
    if (-not $id) {
         Write-Error "{`"action`":`"delete`",`"success`":false,`"error`":`"Faction not found: $search`"}"
         exit 1
    }
    
    $file = Join-Path $FACTIONS_DIR "$id.md"
    
    # Move to trash
    $trashDir = Join-Path $REPO_ROOT ".novelkit	rash"
    if (-not (Test-Path $trashDir)) {
        New-Item -ItemType Directory -Force -Path $trashDir | Out-Null
    }
    
    Move-Item -Path $file -Destination $trashDir -Force
    
    Out-Json @{
        action = "delete"
        success = $true
        faction_id = $id
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
        Write-Error "Usage: faction-manager.ps1 -Action {New|List|Show|Update|Delete} [-Arguments '...']"
        exit 1
    }
}
