#Requires -Version 5.1

param(
    [string]$NovelTitle = "",
    [switch]$Force,
    [switch]$Json
)

$ErrorActionPreference = "Stop"

# Find repository root
function Find-RepoRoot {
    param([string]$StartDir)
    
    $dir = $StartDir
    while ($dir -ne $null -and $dir -ne "") {
        if ((Test-Path (Join-Path $dir ".git")) -or (Test-Path (Join-Path $dir ".novelkit"))) {
            return $dir
        }
        $parent = Split-Path -Path $dir -Parent
        if ($parent -eq $dir) {
            break
        }
        $dir = $parent
    }
    return $null
}

$RepoRoot = Find-RepoRoot -StartDir (Get-Location).Path
if (-not $RepoRoot) {
    Write-Error "Could not find repository root"
    exit 1
}

$ConfigFile = Join-Path $RepoRoot ".novelkit\memory\config.json"

# Check prerequisites
function Test-Prerequisites {
    $novelkitDir = Join-Path $RepoRoot ".novelkit"
    if (-not (Test-Path $novelkitDir)) {
        Write-Error '{"success": false, "error": "Meta-space (.novelkit/) not found. Please install NovelKit properly."}'
        exit 1
    }
    
    if (-not (Test-Path $ConfigFile)) {
        Write-Error '{"success": false, "error": "config.json not found in .novelkit/memory/. It should already exist."}'
        exit 1
    }
    
    $scriptsDir = Join-Path $RepoRoot ".novelkit\scripts"
    if (-not (Test-Path $scriptsDir)) {
        Write-Error '{"success": false, "error": "Scripts directory not found in meta-space."}'
        exit 1
    }
    
    $templatesDir = Join-Path $RepoRoot ".novelkit\templates"
    if (-not (Test-Path $templatesDir)) {
        Write-Error '{"success": false, "error": "Templates directory not found in meta-space."}'
        exit 1
    }
}

# Check if already initialized
function Test-Initialized {
    $chaptersDir = Join-Path $RepoRoot "chapters"
    $worldDir = Join-Path $RepoRoot "world"
    $plotsDir = Join-Path $RepoRoot "plots"
    
    $dirsExist = (Test-Path $chaptersDir) -or (Test-Path $worldDir) -or (Test-Path $plotsDir)
    
    if ($dirsExist -and -not $Force) {
        Write-Error '{"success": false, "error": "User space directories already exist. Use -Force to re-initialize.", "already_initialized": true}'
        exit 1
    }
}

# Create user space directories
function New-UserSpaceDirectories {
    $dirs = @(
        "chapters",
        "world\characters",
        "world\items",
        "world\locations",
        "world\factions",
        "world\rules",
        "world\relationships",
        "plots\main",
        "plots\side",
        "plots\foreshadowing"
    )
    
    foreach ($dir in $dirs) {
        $fullPath = Join-Path $RepoRoot $dir
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
    }
}

# Create novel.md if not exists
function New-NovelFile {
    $novelFile = Join-Path $RepoRoot "novel.md"
    
    if (-not (Test-Path $novelFile)) {
        $title = if ($NovelTitle) { $NovelTitle } else { "[Novel Title]" }
        $date = Get-Date -Format "yyyy-MM-dd"
        
        $content = @"
# $title

**Status**: Draft  
**Created**: $date  
**Total Chapters**: 0  
**Total Words**: 0

## Synopsis

[Novel synopsis will be added here]

## Table of Contents

- Chapter 1: [Title] (Coming soon)

## Statistics

- **Total Chapters**: 0
- **Total Words**: 0
- **Average Words per Chapter**: 0

---

*This novel is being written with NovelKit.*
"@
        
        Set-Content -Path $novelFile -Value $content -Encoding UTF8
        return "novel.md"
    }
    return $null
}

# Update .gitignore if .git exists
function Update-Gitignore {
    $gitDir = Join-Path $RepoRoot ".git"
    if (-not (Test-Path $gitDir)) {
        return $null
    }
    
    $gitignore = Join-Path $RepoRoot ".gitignore"
    $needsUpdate = $false
    
    if (-not (Test-Path $gitignore)) {
        New-Item -ItemType File -Path $gitignore | Out-Null
        $needsUpdate = $true
    }
    
    $content = Get-Content $gitignore -Raw -ErrorAction SilentlyContinue
    if ($content -notmatch "\.novelkit/") {
        Add-Content -Path $gitignore -Value "`n# NovelKit meta-space (always ignore)`n.novelkit/`n.cursor/"
        $needsUpdate = $true
    }
    
    if ($needsUpdate) {
        return ".gitignore"
    }
    return $null
}

# Update config.json
function Update-Config {
    if (-not (Test-Path $ConfigFile)) {
        Write-Error '{"success": false, "error": "config.json not found. It should already exist."}'
        exit 1
    }
    
    try {
        $config = Get-Content $ConfigFile -Raw | ConvertFrom-Json
        $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        
        if (-not $config.novel.created_at) {
            $config.novel.created_at = $timestamp
        }
        
        if ($NovelTitle) {
            $config.novel.title = $NovelTitle
        }
        
        $config.novel.last_modified = $timestamp
        $config.session.last_action = "Project initialized"
        $config.session.last_action_time = $timestamp
        $config.session.last_action_command = "novel-setup"
        $config.session.last_modified_file = $null
        $config.last_updated = $timestamp
        
        $config | ConvertTo-Json -Depth 10 | Set-Content $ConfigFile -Encoding UTF8
    }
    catch {
        Write-Error "Failed to update config.json: $_"
        exit 1
    }
}

# Main execution
try {
    Test-Prerequisites
    Test-Initialized
    New-UserSpaceDirectories
    
    $novelFile = New-NovelFile
    $gitignore = Update-Gitignore
    
    Update-Config
    
    # Output JSON result
    $dirs = @(
        "chapters",
        "world/characters",
        "world/items",
        "world/locations",
        "world/factions",
        "world/rules",
        "world/relationships",
        "plots/main",
        "plots/side",
        "plots/foreshadowing"
    )
    
    $files = @()
    if ($novelFile) {
        $files += "novel.md"
    }
    
    $result = @{
        success = $true
        message = "NovelKit project initialized successfully"
        directories_created = $dirs
        files_created = $files
        config_updated = $true
        novel_title = if ($NovelTitle) { $NovelTitle } else { $null }
    }
    
    $result | ConvertTo-Json -Depth 10
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}

