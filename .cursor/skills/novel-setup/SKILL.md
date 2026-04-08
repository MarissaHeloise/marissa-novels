---
name: "novel-setup"
description: "$ARGUMENTS Invoke when user wants to use novel.setup command."
---

# Novel Setup



## User Input

```text
$ARGUMENTS
```

Optional arguments:
- `--novel-title "Title"` - Set novel title
- `--force` - Force re-initialization (will not delete existing content)

## Purpose

This command initializes the NovelKit project user space directories. **This is a prerequisite for all other NovelKit commands.**

**Important**: 
- Meta-space (`.novelkit/`) directories, scripts, commands, and templates already exist (distributed with NovelKit)
- This command only creates **user space** directories where users can see and edit their creative content
- `config.json` already exists in `.novelkit/memory/` and should NOT be created by scripts

## What This Command Does

### 1. Create User Space Directories

Creates the following user-visible directories (in project root, same level as `.novelkit/`):

```
./                                 # Project root (same level as .novelkit/ and .cursor/)
├── chapters/                      # Chapter content (user space)
├── world/                         # World-building data (user space)
│   ├── characters/
│   ├── items/
│   ├── locations/
│   ├── factions/
│   ├── rules/
│   └── relationships/
├── plots/                         # Plot data (user space)
│   ├── main/
│   ├── side/
│   └── foreshadowing/
└── novel.md                       # Novel main file (optional)
```

**Important**: All paths are relative to project root (`.`), which is the same directory level as `.novelkit/` and `.cursor/`.

### 2. Initialize Basic Files (Optional)

- Create `novel.md` with basic structure (if not exists)
- Create `.gitignore` entries for user space (if `.git` exists)

### 3. Update config.json

After successful initialization:
- Update `novel.created_at` if null
- Update `novel.title` if provided
- Update `session.last_action` to "Project initialized"
- Update `session.last_action_time` to current timestamp
- Update `session.last_action_command` to "novel-setup"

## Process

### Step 1: Check Prerequisites

1. **Verify meta-space exists**:
   - Check `.novelkit/` directory exists
   - Check `.novelkit/memory/config.json` exists (should already exist)
   - Check `.novelkit/scripts/` exists
   - Check `.novelkit/templates/` exists

2. **Check if already initialized**:
   - If user space directories already exist and `--force` not provided:
     - Show current status
     - **Interactive Confirmation** (MANDATORY):
       - Present **at least 6 options** (A-F) plus Custom:
         - A) Continue initialization (will not delete existing content)
         - B) Skip initialization (directories already exist)
         - C) Show detailed status first
         - D) Check what would be created
         - E) Cancel setup
         - F) Force re-initialization (same as --force flag)
         - Custom: [User input]
       - Clearly state: "You can also enter your own custom input if none of the options fit"
       - Wait for user confirmation before proceeding
       - If user confirms, proceed

### Step 2: Create User Space Directories

Create all required directories:

```bash
mkdir -p chapters
mkdir -p world/characters
mkdir -p world/items
mkdir -p world/locations
mkdir -p world/factions
mkdir -p world/rules
mkdir -p world/relationships
mkdir -p plots/main
mkdir -p plots/side
mkdir -p plots/foreshadowing
```

### Step 3: Initialize Basic Files (Optional)

#### Create novel.md (if not exists)

If `novel.md` doesn't exist, create it with basic structure:

```markdown
# [Novel Title]

**Status**: Draft  
**Created**: [Date]  
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
```

#### Create/Update .gitignore (if .git exists)

If `.git` directory exists, ensure `.gitignore` includes:

```gitignore
# NovelKit user space (optional - user may want to version control)
# Uncomment to ignore user space:
# /chapters/
# /world/
# /plots/
# novel.md

# NovelKit meta-space (always ignore)
.novelkit/
.cursor/
```

### Step 4: Update config.json

Read `.novelkit/memory/config.json` and update:

```json
{
  "novel": {
    "title": "[novel-title]" or null if not provided,
    "created_at": "[current-timestamp]" if currently null,
    "last_modified": "[current-timestamp]"
  },
  "session": {
    "last_action": "Project initialized",
    "last_action_time": "[current-timestamp]",
    "last_action_command": "novel-setup",
    "last_modified_file": null
  },
  "last_updated": "[current-timestamp]"
}
```

**Important**: Only update these fields. Do NOT create config.json if it doesn't exist (it should already exist).

### Step 5: Output Success Message

Output JSON result:

```json
{
  "success": true,
  "message": "NovelKit project initialized successfully",
  "directories_created": [
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
  ],
  "files_created": ["novel.md"],
  "config_updated": true,
  "novel_title": "[title]" or null
}
```

## Error Handling

- **Meta-space not found**: Error, prompt user to install NovelKit properly
- **config.json not found**: Error, prompt user that config.json should exist (do NOT create it)
- **Permission denied**: Error, check directory permissions
- **Already initialized**: Show status, ask for confirmation if `--force` not provided

## Next Steps

After initialization, users can:

1. Create constitution: `/novel.constitution.create`
2. Create writer: `/novel.writer.new`
3. Start chapter planning: `/novel.chapter.plan`

## Notes

- This command is **idempotent** - safe to run multiple times
- Existing user content will **NOT** be deleted
- Only creates missing directories
- Meta-space (`.novelkit/`) is assumed to already exist


