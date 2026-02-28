# PowerShell script for writer management

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("New", "List", "Show", "Update", "Switch")]
    [string]$Action,
    
    [Parameter(Mandatory=$false)]
    [switch]$Json,
    
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Arguments
)

$ErrorActionPreference = "Stop"

# Find repository root
function Find-RepoRoot {
    param([string]$StartDir)
    $dir = $StartDir
    while ($dir -ne $null -and $dir -ne "") {
        if ((Test-Path (Join-Path $dir ".git")) -or 
            (Test-Path (Join-Path $dir ".novelkit"))) {
            return $dir
        }
        $parent = Split-Path $dir -Parent
        if ($parent -eq $dir) { break }
        $dir = $parent
    }
    return $null
}

$RepoRoot = Find-RepoRoot (Get-Location)
if ($null -eq $RepoRoot) {
    Write-Error "Could not find repository root"
    exit 1
}

$WritersDir = Join-Path $RepoRoot ".novelkit\writers"
$StateFile = Join-Path $RepoRoot ".novelkit\memory\config.json"
$TemplateFile = Join-Path $RepoRoot ".novelkit\templates\writer.md"

# Ensure directories exist
if (-not (Test-Path $WritersDir)) {
    New-Item -ItemType Directory -Path $WritersDir -Force | Out-Null
}

# Check config.json exists (should already exist, don't create it)
if (-not (Test-Path $StateFile)) {
    Write-Error "config.json not found in .novelkit/memory/. It should already exist."
    exit 1
}

# Get next writer ID
function Get-NextWriterId {
    $highest = 0
    if (Test-Path $WritersDir) {
        Get-ChildItem -Path $WritersDir -Directory -Filter "writer-*" | ForEach-Object {
            $name = $_.Name
            if ($name -match 'writer-(\d+)$') {
                $num = [int]$matches[1]
                if ($num -gt $highest) {
                    $highest = $num
                }
            }
        }
    }
    return "writer-{0:D3}" -f ($highest + 1)
}

# Get current writer
function Get-CurrentWriter {
    if (Test-Path $StateFile) {
        $state = Get-Content $StateFile | ConvertFrom-Json
        return $state.current_writer.id
    }
    return $null
}

# Set current writer (note: AI will update this, not script)
function Set-CurrentWriter {
    param([string]$WriterId)
    # This function is kept for backward compatibility
    # Actual state update is done by AI in writer-switch command
    Write-Warning "Note: State update should be done by AI, not script"
}

# Find writer by ID or name
function Find-Writer {
    param([string]$Search)
    
    if ([string]::IsNullOrWhiteSpace($Search)) {
        return Get-CurrentWriter
    }
    
    # Try exact ID match
    $writerPath = Join-Path $WritersDir $Search
    if (Test-Path $writerPath) {
        return $Search
    }
    
    # Try name matching
    if (Test-Path $WritersDir) {
        Get-ChildItem -Path $WritersDir -Directory -Filter "writer-*" | ForEach-Object {
            $writerFile = Join-Path $_.FullName "writer.md"
            if (Test-Path $writerFile) {
                $content = Get-Content $writerFile -Raw
                if ($content -match '# Writer Profile:\s*(.+)') {
                    $name = $matches[1].Trim()
                    if ($name -like "*$Search*") {
                        return $_.Name
                    }
                }
            }
        }
    }
    
    return $null
}

# JSON output helper
function Write-JsonOutput {
    param(
        [string]$Action,
        [hashtable]$Data
    )
    
    $output = @{
        action = $Action.ToLower()
        success = $true
    } + $Data
    
    $output | ConvertTo-Json -Depth 10
}

# Action: New
function Action-New {
    $description = $Arguments -join " "
    $writerName = ""
    
    if ($description) {
        $words = $description -split '\s+' | Select-Object -First 3
        $writerName = ($words | ForEach-Object { $_.ToLower() }) -join "-"
        $writerName = $writerName -replace '[^a-z0-9-]', ''
    }
    
    $writerId = Get-NextWriterId
    $writerDir = Join-Path $WritersDir $writerId
    New-Item -ItemType Directory -Path $writerDir -Force | Out-Null
    
    $writerFile = Join-Path $writerDir "writer.md"
    $currentDate = Get-Date -Format "yyyy-MM-dd"
    
    if (Test-Path $TemplateFile) {
        $content = Get-Content $TemplateFile -Raw
        $content = $content -replace '\[WRITER_NAME\]', $writerName
        $content = $content -replace '\[DATE\]', $currentDate
        $content = $content -replace '\[WRITER_ID\]', $writerId
        Set-Content -Path $writerFile -Value $content
    } else {
        $content = @"
# Writer Profile: $writerName

**Created**: $currentDate
**Last Updated**: $currentDate
**Status**: Active
**Current Writer**: No
**ID**: $writerId

## Basic Information

- **Name**: $writerName
- **ID**: $writerId
- **Description**: $description

## Writing Style Characteristics

[To be filled by AI]
"@
        Set-Content -Path $writerFile -Value $content
    }
    
    Write-JsonOutput "new" @{
        writer_id = $writerId
        writer_name = $writerName
        writer_file = $writerFile
        writers_dir = $WritersDir
    }
}

# Action: List
function Action-List {
    $writers = @()
    $current = Get-CurrentWriter
    
    if (Test-Path $WritersDir) {
        Get-ChildItem -Path $WritersDir -Directory -Filter "writer-*" | ForEach-Object {
            $writerId = $_.Name
            $writerFile = Join-Path $_.FullName "writer.md"
            
            if (Test-Path $writerFile) {
                $content = Get-Content $writerFile -Raw
                $name = $writerId
                $status = "Active"
                $updated = ""
                $desc = ""
                
                if ($content -match '# Writer Profile:\s*(.+)') {
                    $name = $matches[1].Trim()
                }
                if ($content -match '\*\*Status\*\*:\s*(.+)') {
                    $status = $matches[1].Trim()
                }
                if ($content -match '\*\*Last Updated\*\*:\s*(.+)') {
                    $updated = $matches[1].Trim()
                }
                if ($content -match '\*\*Description\*\*:\s*(.+)') {
                    $desc = $matches[1].Trim()
                }
                
                $writers += @{
                    id = $writerId
                    name = $name
                    status = $status
                    updated = $updated
                    description = $desc
                    current = ($writerId -eq $current)
                }
            }
        }
    }
    
    Write-JsonOutput "list" @{
        writers = $writers
        current_writer = $current
    }
}

# Action: Show
function Action-Show {
    $search = $Arguments -join " "
    $writerId = Find-Writer $search
    
    if ([string]::IsNullOrWhiteSpace($writerId)) {
        Write-Error "Writer not found: $search"
        exit 1
    }
    
    $writerFile = Join-Path $WritersDir "$writerId\writer.md"
    if (-not (Test-Path $writerFile)) {
        Write-Error "Writer file not found: $writerFile"
        exit 1
    }
    
    Write-JsonOutput "show" @{
        writer_id = $writerId
        writer_file = $writerFile
    }
}

# Action: Update
function Action-Update {
    $argsStr = $Arguments -join " "
    $firstWord = ($Arguments | Select-Object -First 1)
    $rest = ($Arguments | Select-Object -Skip 1) -join " "
    
    $writerId = Find-Writer $firstWord
    if ([string]::IsNullOrWhiteSpace($writerId)) {
        $writerId = Get-CurrentWriter
        $updates = $argsStr
    } else {
        $updates = $rest
    }
    
    if ([string]::IsNullOrWhiteSpace($writerId)) {
        Write-Error "No writer specified and no current writer"
        exit 1
    }
    
    $writerFile = Join-Path $WritersDir "$writerId\writer.md"
    if (-not (Test-Path $writerFile)) {
        Write-Error "Writer file not found: $writerFile"
        exit 1
    }
    
    Write-JsonOutput "update" @{
        writer_id = $writerId
        writer_file = $writerFile
    }
}

# Action: Switch
function Action-Switch {
    $search = $Arguments -join " "
    $writerId = Find-Writer $search
    
    if ([string]::IsNullOrWhiteSpace($writerId)) {
        Write-Error "Writer not found: $search"
        exit 1
    }
    
    Set-CurrentWriter $writerId
    Write-JsonOutput "switch" @{
        writer_id = $writerId
        current_writer = $writerId
    }
}

# Execute action
switch ($Action) {
    "New" { Action-New }
    "List" { Action-List }
    "Show" { Action-Show }
    "Update" { Action-Update }
    "Switch" { Action-Switch }
    default {
        Write-Error "Unknown action: $Action"
        exit 1
    }
}

