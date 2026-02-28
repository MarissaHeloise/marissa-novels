# PowerShell script for chapter management

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Plan", "Write", "Polish", "Confirm", "Review", "Show", "List")]
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

# Directory paths
$ChaptersMetaDir = Join-Path $RepoRoot ".novelkit\chapters"  # Meta-space: plan, history, reports
$ChaptersUserDir = Join-Path $RepoRoot "chapters"             # User-space: chapter content
$ConfigFile = Join-Path $RepoRoot ".novelkit\memory\config.json"
$PlanTemplate = Join-Path $RepoRoot ".novelkit\templates\chapter.md"

# Ensure directories exist
if (-not (Test-Path $ChaptersMetaDir)) {
    New-Item -ItemType Directory -Path $ChaptersMetaDir -Force | Out-Null
}
if (-not (Test-Path $ChaptersUserDir)) {
    New-Item -ItemType Directory -Path $ChaptersUserDir -Force | Out-Null
}

# Check config.json exists (should already exist, don't create it)
if (-not (Test-Path $ConfigFile)) {
    Write-Error "config.json not found in .novelkit/memory/. It should already exist."
    exit 1
}

# Get user-space chapter file path from chapter ID and number
function Get-ChapterUserFile {
    param(
        [string]$ChapterId,
        [int]$ChapterNumber = 0
    )
    
    # Extract number from chapter_id if number not provided
    if ($ChapterNumber -eq 0) {
        if ($ChapterId -match 'chapter-(\d+)$') {
            $ChapterNumber = [int]$matches[1]
        } else {
            $ChapterNumber = 1
        }
    }
    
    # Format as chapter-001.md
    return "chapter-{0:D3}.md" -f $ChapterNumber
}

# Get next chapter ID
function Get-NextChapterId {
    $highest = 0
    if (Test-Path $ChaptersMetaDir) {
        Get-ChildItem -Path $ChaptersMetaDir -Directory -Filter "chapter-*" | ForEach-Object {
            $name = $_.Name
            if ($name -match 'chapter-(\d+)$') {
                $num = [int]$matches[1]
                if ($num -gt $highest) {
                    $highest = $num
                }
            }
        }
    }
    return "chapter-{0:D3}" -f ($highest + 1)
}

# Get next chapter number
function Get-NextChapterNumber {
    # Config file should already exist (checked at startup)
    try {
        $config = Get-Content $ConfigFile | ConvertFrom-Json
        $currentNumber = if ($config.current_chapter.number) { $config.current_chapter.number } 
                        elseif ($config.novel.total_chapters) { $config.novel.total_chapters }
                        else { 0 }
        return $currentNumber + 1
    } catch {
        return 1
    }
}

# Get current chapter from config
function Get-CurrentChapter {
    # Config file should already exist (checked at startup)
    try {
        $config = Get-Content $ConfigFile | ConvertFrom-Json
        return if ($config.current_chapter.id) { $config.current_chapter.id } else { "" }
    } catch {
        return ""
    }
}

# JSON output helper
function Write-JsonOutput {
    param(
        [string]$Action,
        [hashtable]$Data
    )
    
    $output = @{
        action = $Action
        success = $true
    } + $Data
    
    $output | ConvertTo-Json -Depth 10
}

# Action: Plan
function Action-Plan {
    $chapterId = Get-NextChapterId
    $chapterNumber = Get-NextChapterNumber
    $chapterDir = Join-Path $ChaptersMetaDir $chapterId
    
    if (-not (Test-Path $chapterDir)) {
        New-Item -ItemType Directory -Path $chapterDir -Force | Out-Null
    }
    
    $planFile = Join-Path $chapterDir "plan.md"
    
    if (-not (Test-Path $planFile)) {
        $planContent = @"
# Chapter Planning: $chapterId

**Chapter Number**: $chapterNumber  
**Status**: Planned  
**Created**: $(Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")

## Plot Summary

[To be filled by AI through interactive interview]

## Characters

[To be filled by AI]

## Location

[To be filled by AI]

## Key Events

[To be filled by AI]

## Foreshadowing & Clues

[To be filled by AI]

## Connections

[To be filled by AI]

"@
        Set-Content -Path $planFile -Value $planContent
    }
    
    Write-JsonOutput -Action "plan" -Data @{
        chapter_id = $chapterId
        chapter_number = $chapterNumber
        plan_file = $planFile
        chapters_meta_dir = $ChaptersMetaDir
    }
}

# Action: Write
function Action-Write {
    param([string]$ChapterId)
    
    if ([string]::IsNullOrEmpty($ChapterId)) {
        $ChapterId = Get-CurrentChapter
    }
    
    if ([string]::IsNullOrEmpty($ChapterId)) {
        Write-Error "No chapter ID provided and no current chapter"
        exit 1
    }
    
    $chapterMetaDir = Join-Path $ChaptersMetaDir $ChapterId
    $planFile = Join-Path $chapterMetaDir "plan.md"
    $chapterNumber = Get-NextChapterNumber - 1  # Current chapter number
    $chapterUserFile = Get-ChapterUserFile -ChapterId $ChapterId -ChapterNumber $chapterNumber
    $chapterFile = Join-Path $ChaptersUserDir $chapterUserFile
    
    if (-not (Test-Path $planFile)) {
        Write-Error "Plan file not found: $planFile"
        exit 1
    }
    
    if (-not (Test-Path $chapterFile)) {
        $chapterContent = @"
# Chapter Content: $ChapterId

**Status**: Written  
**Created**: $(Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")

[To be filled by AI based on plan and writer style]

"@
        Set-Content -Path $chapterFile -Value $chapterContent
    }
    
    # Count words (rough estimate)
    $content = Get-Content $chapterFile -Raw
    $wordCount = ($content -split '\s+').Count
    
    Write-JsonOutput -Action "write" -Data @{
        chapter_id = $ChapterId
        chapter_file = $chapterFile
        word_count = $wordCount
    }
}

# Action: Polish
function Action-Polish {
    param([string]$ChapterId)
    
    if ([string]::IsNullOrEmpty($ChapterId)) {
        $ChapterId = Get-CurrentChapter
    }
    
    if ([string]::IsNullOrEmpty($ChapterId)) {
        Write-Error "No chapter ID provided and no current chapter"
        exit 1
    }
    
    # Get chapter file from config or construct from ID
    $config = Get-Content $ConfigFile | ConvertFrom-Json
    if ($config.current_chapter.file_path) {
        $chapterFile = Join-Path $RepoRoot $config.current_chapter.file_path
    } else {
        # Fallback: construct from ID
        $chapterNumber = if ($ChapterId -match 'chapter-(\d+)$') { [int]$matches[1] } else { 1 }
        $chapterUserFile = Get-ChapterUserFile -ChapterId $ChapterId -ChapterNumber $chapterNumber
        $chapterFile = Join-Path $ChaptersUserDir $chapterUserFile
    }
    
    $chapterMetaDir = Join-Path $ChaptersMetaDir $ChapterId
    
    if (-not (Test-Path $chapterFile)) {
        Write-Error "Chapter file not found: $chapterFile"
        exit 1
    }
    
    # Count words before
    $content = Get-Content $chapterFile -Raw
    $wordCountBefore = ($content -split '\s+').Count
    
    # Create polish history file
    $polishHistory = Join-Path $chapterMetaDir "polish-history.md"
    if (-not (Test-Path $polishHistory)) {
        $historyContent = @"
# Polishing History

## $(Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") - Polish Session 1

[To be filled by AI]

"@
        Set-Content -Path $polishHistory -Value $historyContent
    }
    
    $wordCountAfter = $wordCountBefore
    
    Write-JsonOutput -Action "polish" -Data @{
        chapter_id = $ChapterId
        chapter_file = $chapterFile
        word_count_before = $wordCountBefore
        word_count_after = $wordCountAfter
    }
}

# Action: Confirm
function Action-Confirm {
    param([string]$ChapterId)
    
    if ([string]::IsNullOrEmpty($ChapterId)) {
        $ChapterId = Get-CurrentChapter
    }
    
    if ([string]::IsNullOrEmpty($ChapterId)) {
        Write-Error "No chapter ID provided and no current chapter"
        exit 1
    }
    
    # Get chapter file from config or construct from ID
    $config = Get-Content $ConfigFile | ConvertFrom-Json
    if ($config.current_chapter.file_path) {
        $chapterFile = Join-Path $RepoRoot $config.current_chapter.file_path
    } else {
        # Fallback: construct from ID
        $chapterNumber = if ($ChapterId -match 'chapter-(\d+)$') { [int]$matches[1] } else { 1 }
        $chapterUserFile = Get-ChapterUserFile -ChapterId $ChapterId -ChapterNumber $chapterNumber
        $chapterFile = Join-Path $ChaptersUserDir $chapterUserFile
    }
    
    if (-not (Test-Path $chapterFile)) {
        Write-Error "Chapter file not found: $chapterFile"
        exit 1
    }
    
    # Count words
    $content = Get-Content $chapterFile -Raw
    $wordCount = ($content -split '\s+').Count
    
    Write-JsonOutput -Action "confirm" -Data @{
        chapter_id = $ChapterId
        chapter_file = $chapterFile
        word_count = $wordCount
        status = "completed"
    }
}

# Action: Show
function Action-Show {
    param([string]$Search)
    
    $chapterId = ""
    
    if ([string]::IsNullOrEmpty($Search)) {
        $chapterId = Get-CurrentChapter
    } else {
        $chapterPath = Join-Path $ChaptersMetaDir $Search
        if (Test-Path $chapterPath -PathType Container) {
            $chapterId = $Search
        } else {
            # Try to find by partial match
            Get-ChildItem -Path $ChaptersMetaDir -Directory -Filter "chapter-*" | ForEach-Object {
                if ($_.Name -like "*$Search*") {
                    $chapterId = $_.Name
                    return
                }
            }
        }
    }
    
    if ([string]::IsNullOrEmpty($chapterId)) {
        Write-Error "Chapter not found: $Search"
        exit 1
    }
    
    # Try user space first, then meta space
    $chapterNumber = if ($chapterId -match 'chapter-(\d+)$') { [int]$matches[1] } else { 1 }
    $chapterUserFile = Get-ChapterUserFile -ChapterId $chapterId -ChapterNumber $chapterNumber
    $chapterFile = Join-Path $ChaptersUserDir $chapterUserFile
    if (-not (Test-Path $chapterFile)) {
        $chapterFile = Join-Path $ChaptersMetaDir "$chapterId\plan.md"
    }
    
    if (-not (Test-Path $chapterFile)) {
        Write-Error "Chapter file not found: $chapterFile"
        exit 1
    }
    
    Write-JsonOutput -Action "show" -Data @{
        chapter_id = $chapterId
        chapter_file = $chapterFile
    }
}

# Action: Review
function Action-Review {
    param([string]$ChapterId)
    
    if ([string]::IsNullOrEmpty($ChapterId)) {
        $ChapterId = Get-CurrentChapter
    }
    
    if ([string]::IsNullOrEmpty($ChapterId)) {
        Write-Error "No chapter ID provided and no current chapter"
        exit 1
    }
    
    # Get chapter file from config or construct from ID
    $config = Get-Content $ConfigFile | ConvertFrom-Json
    if ($config.current_chapter.file_path) {
        $chapterFile = Join-Path $RepoRoot $config.current_chapter.file_path
    } else {
        # Fallback: construct from ID
        $chapterNumber = if ($ChapterId -match 'chapter-(\d+)$') { [int]$matches[1] } else { 1 }
        $chapterUserFile = Get-ChapterUserFile -ChapterId $ChapterId -ChapterNumber $chapterNumber
        $chapterFile = Join-Path $ChaptersUserDir $chapterUserFile
    }
    
    $chapterMetaDir = Join-Path $ChaptersMetaDir $ChapterId
    
    if (-not (Test-Path $chapterFile)) {
        Write-Error "Chapter file not found: $chapterFile"
        exit 1
    }
    
    # Create review report file placeholder
    $reviewReport = Join-Path $chapterMetaDir "review-report.md"
    
    # Count words
    $content = Get-Content $chapterFile -Raw
    $wordCount = ($content -split '\s+').Count
    
    Write-JsonOutput -Action "review" -Data @{
        chapter_id = $ChapterId
        chapter_file = $chapterFile
        review_report = $reviewReport
        word_count = $wordCount
    }
}

# Action: List
function Action-List {
    $chapters = @()
    
    if (Test-Path $ChaptersMetaDir) {
        $current = Get-CurrentChapter
        
        Get-ChildItem -Path $ChaptersMetaDir -Directory -Filter "chapter-*" | ForEach-Object {
            $chapterId = $_.Name
            $planFile = Join-Path $_.FullName "plan.md"
            # Try user space chapter file
            $chapterNumber = if ($chapterId -match 'chapter-(\d+)$') { [int]$matches[1] } else { 1 }
            $chapterUserFile = Get-ChapterUserFile -ChapterId $chapterId -ChapterNumber $chapterNumber
            $chapterFile = Join-Path $ChaptersUserDir $chapterUserFile
            
            $status = "planned"
            $wordCount = 0
            $title = ""
            $number = ""
            
            if (Test-Path $planFile) {
                $planContent = Get-Content $planFile -Raw
                if ($planContent -match '^# Chapter.*: (.+)$') {
                    $title = $matches[1].Trim()
                }
                if ($planContent -match '\*\*Chapter Number\*\*: (\d+)') {
                    $number = $matches[1]
                }
            }
            
            if (Test-Path $chapterFile) {
                $status = "written"
                $content = Get-Content $chapterFile -Raw
                $wordCount = ($content -split '\s+').Count
            }
            
            $chapters += @{
                id = $chapterId
                title = $title
                number = $number
                status = $status
                word_count = $wordCount
                current = ($chapterId -eq $current)
            }
        }
    }
    
    Write-JsonOutput -Action "list" -Data @{
        chapters = $chapters
        current_chapter = (Get-CurrentChapter)
    }
}

# Main
switch ($Action) {
    "Plan" {
        Action-Plan
    }
    "Write" {
        $chapterId = if ($Arguments.Count -gt 0) { $Arguments[0] } else { $null }
        Action-Write -ChapterId $chapterId
    }
    "Polish" {
        $chapterId = if ($Arguments.Count -gt 0) { $Arguments[0] } else { $null }
        Action-Polish -ChapterId $chapterId
    }
    "Confirm" {
        $chapterId = if ($Arguments.Count -gt 0) { $Arguments[0] } else { $null }
        Action-Confirm -ChapterId $chapterId
    }
    "Review" {
        $chapterId = if ($Arguments.Count -gt 0) { $Arguments[0] } else { $null }
        Action-Review -ChapterId $chapterId
    }
    "Show" {
        $search = if ($Arguments.Count -gt 0) { $Arguments[0] } else { "" }
        Action-Show -Search $search
    }
    "List" {
        Action-List
    }
    default {
        Write-Error "Unknown action: $Action"
        exit 1
    }
}

