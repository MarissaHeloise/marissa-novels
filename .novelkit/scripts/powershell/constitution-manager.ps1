# PowerShell script for constitution management

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Create", "Show", "Update", "Check")]
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

$ConstitutionDir = Join-Path $RepoRoot ".novelkit\memory"
$ConstitutionFile = Join-Path $ConstitutionDir "constitution.md"
$TemplateFile = Join-Path $RepoRoot ".novelkit\templates\constitution.md"

# Ensure directories exist
if (-not (Test-Path $ConstitutionDir)) {
    New-Item -ItemType Directory -Path $ConstitutionDir -Force | Out-Null
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

# Action: Create
function Action-Create {
    if (Test-Path $ConstitutionFile) {
        Write-Error "Constitution already exists. Use update command instead."
        exit 1
    }
    
    Write-JsonOutput "create" @{
        constitution_file = $ConstitutionFile
        template_file = $TemplateFile
        exists = $false
    }
}

# Action: Show
function Action-Show {
    if (-not (Test-Path $ConstitutionFile)) {
        Write-Error "Constitution not found. Use create command first."
        exit 1
    }
    
    Write-JsonOutput "show" @{
        constitution_file = $ConstitutionFile
        exists = $true
    }
}

# Action: Update
function Action-Update {
    if (-not (Test-Path $ConstitutionFile)) {
        Write-Error "Constitution not found. Use create command first."
        exit 1
    }
    
    Write-JsonOutput "update" @{
        constitution_file = $ConstitutionFile
        exists = $true
    }
}

# Action: Check
function Action-Check {
    if (-not (Test-Path $ConstitutionFile)) {
        Write-Error "Constitution not found. Use create command first."
        exit 1
    }
    
    Write-JsonOutput "check" @{
        constitution_file = $ConstitutionFile
        exists = $true
    }
}

# Execute action
switch ($Action) {
    "Create" { Action-Create }
    "Show" { Action-Show }
    "Update" { Action-Update }
    "Check" { Action-Check }
    default {
        Write-Error "Unknown action: $Action"
        exit 1
    }
}

