---
name: "novel-faction-list"
description: "This command lists all factions in the novel world, providing a comprehensive summary of their status, type, and key attributes. Invoke when user wants to use novel.faction.list command."
---

# Novel Faction List



## Process Overview

This command lists all factions in the novel world, providing a comprehensive summary of their status, type, and key attributes.

### Process Steps

1. **Retrieve Faction Data**: Run script to get JSON list of all factions
2. **Parse Faction Information**: Extract key details from each faction file
3. **Organize & Format**: Present factions in structured table/list
4. **Provide Interactive Options**: Allow filtering, sorting, and navigation

## Detailed Process

### Phase 1: Data Retrieval (Automatic)

#### Step 1: Run List Script

Execute the faction manager script to get a JSON list of all factions:

```bash
./scripts/bash/faction-manager.sh list --json
```

The script should:
- Scan `./world/factions/` directory (user space, project root)
- Read metadata from each faction file
- Return JSON with faction list including:
  - Faction ID
  - Faction name
  - File path
  - Last modified date
  - Status (if available in metadata)

#### Step 2: Read Faction Files (Optional, for detailed info)

For each faction, optionally read the faction file to extract:
- Faction type (Guild, Kingdom, Sect, etc.)
- Current status (Active/Destroyed/Merged/etc.)
- Key relationships
- Power level or influence

**Note**: For performance, only read full files if user requests detailed view or if faction count is small (< 20).

### Phase 2: Data Organization

#### Step 3: Categorize Factions

Organize factions by:
- **Type**: Kingdom, Guild, Sect, Organization, etc.
- **Status**: Active, Destroyed, Merged, Hidden
- **Power Level**: Major, Medium, Minor (if applicable)

#### Step 4: Extract Key Information

For each faction, extract:
- **ID**: `faction-xxx` format
- **Name**: Full name
- **Type**: Primary type
- **Status**: Current story status
- **Last Updated**: Last modification date
- **Key Attributes**: Brief summary (1-2 key traits)

### Phase 3: Display Format

#### Step 5: Format Faction List

Present factions in a clear, organized format:

**Default Table View**:

```markdown
## Faction List

**Total Factions**: [COUNT]

| ID | Name | Type | Status | Last Updated |
|----|------|------|--------|--------------|
| faction-001 | [Name] | Kingdom | Active | 2025-01-15 |
| faction-002 | [Name] | Guild | Active | 2025-01-14 |
| faction-003 | [Name] | Sect | Destroyed | 2025-01-13 |
```

**Grouped View** (by type):

```markdown
## Faction List

### Kingdoms
- faction-001: [Name] - [Status] - [Brief description]

### Guilds
- faction-002: [Name] - [Status] - [Brief description]

### Sects
- faction-003: [Name] - [Status] - [Brief description]
```

**Display Columns** (configurable):
- **ID**: `faction-xxx`
- **Name**: Faction name
- **Type**: Kingdom / Guild / Sect / Organization / etc.
- **Status**: Active / Destroyed / Merged / Hidden
- **Key Attributes**: 1-2 sentence summary
- **Updated**: Last modified date (YYYY-MM-DD format)

### Phase 4: Interactive Features

#### Step 6: Provide Filtering Options

Offer filtering capabilities:
- **By Type**: Show only kingdoms, guilds, sects, etc.
- **By Status**: Show only active, destroyed, etc.
- **By Power Level**: Show only major, medium, minor factions
- **Search**: Filter by name or keyword

#### Step 7: Provide Sorting Options

Allow sorting by:
- Name (alphabetical)
- Type (grouped by type)
- Status (active first)
- Last Updated (newest first)
- Creation Date (oldest first)

#### Step 8: Provide Navigation Options

For each faction, provide quick actions:
- **View Details**: `/novel.faction.show [ID/Name]`
- **Update**: `/novel.faction.update [ID/Name]`
- **View Members**: `/novel.faction.members [ID/Name]`
- **View Relationships**: `/novel.faction.relationships [ID/Name]`

## Output Format

### Standard Output

```markdown
## Faction List

**Total**: [COUNT] factions

| ID | Name | Type | Status | Last Updated |
|----|------|------|--------|--------------|
| faction-001 | [Name] | Kingdom | Active | 2025-01-15 |
| faction-002 | [Name] | Guild | Active | 2025-01-14 |
| faction-003 | [Name] | Sect | Destroyed | 2025-01-13 |

**Quick Actions**:
- Use `/novel.faction.show <ID>` to view detailed profile
- Use `/novel.faction.update <ID>` to modify faction
- Use `/novel.faction.new` to create new faction
```

## Error Handling

- **No Factions Found**: 
  - Display: "No factions found. Use `/novel.faction.new` to create your first faction."
  - Suggest creating a faction

- **Script Error**: 
  - If script fails, try reading directory directly
  - Report error: "Unable to retrieve faction list. Please check script permissions."

- **File Read Error**: 
  - If individual faction file cannot be read, show ID and name only
  - Note: "Unable to read full profile for [ID]"

- **Empty Directory**: 
  - Display helpful message with link to create first faction

## Guidelines

- **Performance**: For large faction lists (>50), use pagination or lazy loading
- **Sorting**: Default sort by type, then by name
- **Summary Stats**: Show statistics like "X kingdoms, Y guilds, Z sects"
- **Quick Access**: Provide shortcuts to most common actions

