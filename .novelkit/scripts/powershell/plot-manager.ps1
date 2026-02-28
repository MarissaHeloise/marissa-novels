param (
    [string]$Action,
    [string]$Type,
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

$PLOTS_DIR = Join-Path $REPO_ROOT "plots"
$MAIN_PLOTS_DIR = Join-Path $PLOTS_DIR "main"
$SIDE_PLOTS_DIR = Join-Path $PLOTS_DIR "side"
$FORESHADOW_DIR = Join-Path $PLOTS_DIR "foreshadowing"
$STATE_FILE = Join-Path $REPO_ROOT ".novelkit\memory\config.json"
$TEMPLATE_FILE = Join-Path $REPO_ROOT ".novelkit	emplates\plot.md"

# Ensure directories exist
if (-not (Test-Path $MAIN_PLOTS_DIR)) { New-Item -ItemType Directory -Force -Path $MAIN_PLOTS_DIR | Out-Null }
if (-not (Test-Path $SIDE_PLOTS_DIR)) { New-Item -ItemType Directory -Force -Path $SIDE_PLOTS_DIR | Out-Null }
if (-not (Test-Path $FORESHADOW_DIR)) { New-Item -ItemType Directory -Force -Path $FORESHADOW_DIR | Out-Null }

# Check config.json exists
if (-not (Test-Path $STATE_FILE)) {
    Write-Error "Error: config.json not found in .novelkit/memory/. It should already exist."
    exit 1
}

# Get next plot ID
function Get-NextPlotId {
    param ([string]$type)
    $dir = ""
    $prefix = ""
    
    switch ($type) {
        "main" { $dir = $MAIN_PLOTS_DIR; $prefix = "main-plot" }
        "side" { $dir = $SIDE_PLOTS_DIR; $prefix = "side-plot" }
        "foreshadow" { $dir = $FORESHADOW_DIR; $prefix = "foreshadow" }
        default { Write-Error "Unknown plot type"; exit 1 }
    }
    
    $highest = 0
    if (Test-Path $dir) {
        $files = Get-ChildItem -Path $dir -Filter "$prefix-*.md"
        foreach ($file in $files) {
            if ($file.Name -match "$prefix-(\d+)\.md") {
                $num = [int]$matches[1]
                if ($num -gt $highest) {
                    $highest = $num
                }
            }
        }
    }
    return "$prefix-{0:d3}" -f ($highest + 1)
}

# Parse JSON output helper
function Out-Json {
    param ([hashtable]$obj)
    $obj | ConvertTo-Json -Depth 10 -Compress
}

# Find plot by ID or Title
function Find-Plot {
    param ([string]$search)
    
    if (-not $search) { return $null }
    
    # Try exact ID matches
    $dirs = @($MAIN_PLOTS_DIR, $SIDE_PLOTS_DIR, $FORESHADOW_DIR)
    
    # Check exact ID filename
    foreach ($dir in $dirs) {
        $path = Join-Path $dir "$search.md"
        if (Test-Path $path) { return $path }
        
        $path = Join-Path $dir "main-plot-$search.md"
        if (Test-Path $path) { return $path }
        
        $path = Join-Path $dir "side-plot-$search.md"
        if (Test-Path $path) { return $path }
        
        $path = Join-Path $dir "foreshadow-$search.md"
        if (Test-Path $path) { return $path }
    }
    
    # Search by Title
    foreach ($dir in $dirs) {
        if (-not (Test-Path $dir)) { continue }
        $files = Get-ChildItem -Path $dir -Filter "*.md"
        foreach ($file in $files) {
            $content = Get-Content -Path $file.FullName -Raw
            
            $title = ""
            if ($content -match "# 剧情档案：(.*?)
?
") {
                $title = $matches[1].Trim()
            }
            
            $titleField = ""
            if ($content -match "\- \*\*标题\*\*：(.*?)
?
") {
                $titleField = $matches[1].Trim()
            }
            
            if (($title -match $search) -or ($titleField -match $search)) {
                return $file.FullName
            }
        }
    }
    
    return $null
}

# Action handlers
function Action-New {
    param ([string]$type, [string]$argsStr)
    
    $title = $argsStr
    $id = Get-NextPlotId $type
    
    $dir = ""
    $typeDisplay = ""
    switch ($type) {
        "main" { $dir = $MAIN_PLOTS_DIR; $typeDisplay = "Main" }
        "side" { $dir = $SIDE_PLOTS_DIR; $typeDisplay = "Side" }
        "foreshadow" { $dir = $FORESHADOW_DIR; $typeDisplay = "Foreshadow" }
    }
    
    $file = Join-Path $dir "$id.md"
    $currentDate = Get-Date -Format "yyyy-MM-dd"
    
    if (Test-Path $TEMPLATE_FILE) {
        $content = Get-Content -Path $TEMPLATE_FILE -Raw
        $content = $content.Replace("[PLOT_NAME]", $title)
        $content = $content.Replace("[TITLE]", $title)
        $content = $content.Replace("[DATE]", $currentDate)
        $content = $content.Replace("[PLOT_ID]", $id)
        $content = $content.Replace("[PLOT_TYPE]", $typeDisplay)
        $content = $content.Replace("[STATUS]", "Planned")
        Set-Content -Path $file -Value $content -Encoding UTF8
    } else {
        $content = @"
# 剧情档案：$title

**创建时间**：$currentDate
**最后更新**：$currentDate
**ID**：$id
**类型**：$typeDisplay
**状态**：Planned

## 1. 核心概要 (Core Summary)

- **标题**：$title

[Content to be filled by AI]
"@
        Set-Content -Path $file -Value $content -Encoding UTF8
    }
    
    Out-Json @{
        action = "new"
        success = $true
        plot_id = $id
        plot_title = $title
        plot_type = $type
        plot_file = $file
    }
}

function Action-List {
    param ([string]$typeFilter)
    
    $list = @()
    $dirs = @()
    
    if (-not $typeFilter -or $typeFilter -eq "all") {
        $dirs = @($MAIN_PLOTS_DIR, $SIDE_PLOTS_DIR, $FORESHADOW_DIR)
    } elseif ($typeFilter -eq "main") {
        $dirs = @($MAIN_PLOTS_DIR)
    } elseif ($typeFilter -eq "side") {
        $dirs = @($SIDE_PLOTS_DIR)
    } elseif ($typeFilter -eq "foreshadow") {
        $dirs = @($FORESHADOW_DIR)
    }
    
    foreach ($dir in $dirs) {
        if (Test-Path $dir) {
            $files = Get-ChildItem -Path $dir -Filter "*.md"
            foreach ($file in $files) {
                $id = $file.BaseName
                $content = Get-Content -Path $file.FullName -Raw
                
                $title = $id
                if ($content -match "# 剧情档案：(.*?)
?
") {
                    $title = $matches[1].Trim()
                }
                
                $status = "Unknown"
                if ($content -match "\*\*状态\*\*：(.*?)
?
") {
                    $status = $matches[1].Trim()
                }
                
                $plotType = "Unknown"
                if ($content -match "\*\*类型\*\*：(.*?)
?
") {
                    $plotType = $matches[1].Trim()
                }
                
                $updated = ""
                if ($content -match "\*\*最后更新\*\*：(.*?)
?
") {
                    $updated = $matches[1].Trim()
                }
                
                $list += @{
                    id = $id
                    title = $title
                    type = $plotType
                    status = $status
                    updated = $updated
                }
            }
        }
    }
    
    Out-Json @{
        action = "list"
        success = $true
        plots = $list
    }
}

function Action-Show {
    param ([string]$search)
    
    $file = Find-Plot $search
    
    if (-not $file) {
        Write-Error "{`"action`":`"show`",`"success`":false,`"error`":`"Plot not found: $search`"}"
        exit 1
    }
    
    $id = [System.IO.Path]::GetFileNameWithoutExtension($file)
    
    Out-Json @{
        action = "show"
        success = $true
        plot_id = $id
        plot_file = $file
    }
}

function Action-Update {
    param ([string]$argsStr)
    
    $firstWord = $argsStr.Split(" ")[0]
    $file = Find-Plot $firstWord
    
    if (-not $file) {
        Write-Error "{`"action`":`"update`",`"success`":false,`"error`":`"Plot not found: $firstWord`"}"
        exit 1
    }
    
    $id = [System.IO.Path]::GetFileNameWithoutExtension($file)
    
    Out-Json @{
        action = "update"
        success = $true
        plot_id = $id
        plot_file = $file
    }
}

# Main script logic
switch ($Action.ToLower()) {
    "new" {
        if (-not $Type) { Write-Error "Error: Type required for new"; exit 1 }
        Action-New $Type $Arguments
    }
    "list" { Action-List $Type }
    "show" { Action-Show $Arguments }
    "update" { Action-Update $Arguments }
    default {
        Write-Error "Usage: plot-manager.ps1 -Action {New|List|Show|Update} [-Type {main|side|foreshadow}] [-Arguments '...']"
        exit 1
    }
}
