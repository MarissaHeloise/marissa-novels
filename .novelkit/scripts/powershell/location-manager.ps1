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

$LOCATIONS_DIR = Join-Path $REPO_ROOT "world\locations"
$STATE_FILE = Join-Path $REPO_ROOT ".novelkit\memory\config.json"
$TEMPLATE_FILE = Join-Path $REPO_ROOT ".novelkit	emplates\location.md"

# Ensure directories exist
if (-not (Test-Path $LOCATIONS_DIR)) {
    New-Item -ItemType Directory -Force -Path $LOCATIONS_DIR | Out-Null
}

# Check config.json exists
if (-not (Test-Path $STATE_FILE)) {
    Write-Error "Error: config.json not found in .novelkit/memory/. It should already exist."
    exit 1
}

# Get next location ID
function Get-NextLocationId {
    $highest = 0
    if (Test-Path $LOCATIONS_DIR) {
        $files = Get-ChildItem -Path $LOCATIONS_DIR -Filter "location-*.md"
        foreach ($file in $files) {
            if ($file.Name -match "location-(\d+)\.md") {
                $num = [int]$matches[1]
                if ($num -gt $highest) {
                    $highest = $num
                }
            }
        }
    }
    return "location-{0:d3}" -f ($highest + 1)
}

# Parse JSON output helper
function Out-Json {
    param ([hashtable]$obj)
    $obj | ConvertTo-Json -Depth 10 -Compress
}

# Find location by ID or name
function Find-Location {
    param ([string]$search)
    
    if (-not $search) { return $null }
    
    # Try exact ID match first
    $path = Join-Path $LOCATIONS_DIR "$search.md"
    if (Test-Path $path) {
        return $search
    }
    
    $path = Join-Path $LOCATIONS_DIR "location-$search.md"
    if (Test-Path $path) {
        return "location-$search"
    }
    
    # Try name matching
    $files = Get-ChildItem -Path $LOCATIONS_DIR -Filter "location-*.md"
    foreach ($file in $files) {
        $content = Get-Content -Path $file.FullName -Raw
        # Extract name from header
        if ($content -match "# 地点档案：(.*?)
?
") {
            $name = $matches[1].Trim()
            if ($name -match $search) {
                return $file.BaseName
            }
        }
        elseif ($content -match "# Location Profile: (.*?)
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
    $id = Get-NextLocationId
    $file = Join-Path $LOCATIONS_DIR "$id.md"
    $currentDate = Get-Date -Format "yyyy-MM-dd"
    
    if (Test-Path $TEMPLATE_FILE) {
        $content = Get-Content -Path $TEMPLATE_FILE -Raw
        $content = $content.Replace("[LOCATION_NAME]", $name)
        $content = $content.Replace("[NAME]", $name)
        $content = $content.Replace("[DATE]", $currentDate)
        $content = $content.Replace("[LOCATION_ID]", $id)
        $content = $content.Replace("[STATUS]", "Active")
        Set-Content -Path $file -Value $content -Encoding UTF8
    } else {
        $content = @"
# 地点档案：$name

**创建时间**：$currentDate
**最后更新**：$currentDate
**ID**：$id
**状态**：Active

## 1. 基本信息 (Basic Information)

- **名称**：$name
- **别名**：
- **类型**：
- **地理位置**：

[Content to be filled by AI]
"@
        Set-Content -Path $file -Value $content -Encoding UTF8
    }
    
    Out-Json @{
        action = "new"
        success = $true
        location_id = $id
        location_name = $name
        location_file = $file
        locations_dir = $LOCATIONS_DIR
    }
}

function Action-List {
    $list = @()
    
    if (Test-Path $LOCATIONS_DIR) {
        $files = Get-ChildItem -Path $LOCATIONS_DIR -Filter "location-*.md"
        foreach ($file in $files) {
            $id = $file.BaseName
            $content = Get-Content -Path $file.FullName -Raw
            
            $name = $id
            if ($content -match "# 地点档案：(.*?)
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
        locations = $list
    }
}

function Action-Show {
    param ([string]$search)
    
    $id = Find-Location $search
    
    if (-not $id) {
        Write-Error "{`"action`":`"show`",`"success`":false,`"error`":`"Location not found: $search`"}"
        exit 1
    }
    
    $file = Join-Path $LOCATIONS_DIR "$id.md"
    
    Out-Json @{
        action = "show"
        success = $true
        location_id = $id
        location_file = $file
    }
}

function Action-Update {
    param ([string]$argsStr)
    
    # Parse: id ...
    $firstWord = $argsStr.Split(" ")[0]
    $id = Find-Location $firstWord
    
    if (-not $id) {
        Write-Error "{`"action`":`"update`",`"success`":false,`"error`":`"Location not found: $firstWord`"}"
        exit 1
    }
    
    $file = Join-Path $LOCATIONS_DIR "$id.md"
    
    Out-Json @{
        action = "update"
        success = $true
        location_id = $id
        location_file = $file
    }
}

function Action-Delete {
    param ([string]$search)
    
    $id = Find-Location $search
    
    if (-not $id) {
         Write-Error "{`"action`":`"delete`",`"success`":false,`"error`":`"Location not found: $search`"}"
         exit 1
    }
    
    $file = Join-Path $LOCATIONS_DIR "$id.md"
    
    # Move to trash
    $trashDir = Join-Path $REPO_ROOT ".novelkit	rash"
    if (-not (Test-Path $trashDir)) {
        New-Item -ItemType Directory -Force -Path $trashDir | Out-Null
    }
    
    Move-Item -Path $file -Destination $trashDir -Force
    
    Out-Json @{
        action = "delete"
        success = $true
        location_id = $id
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
        Write-Error "Usage: location-manager.ps1 -Action {New|List|Show|Update|Delete} [-Arguments '...']"
        exit 1
    }
}
