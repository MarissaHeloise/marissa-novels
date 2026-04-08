---
name: "novel-location-list"
description: "This command lists all locations in the world, providing a comprehensive summary of their status, type, and key attributes. Invoke when user wants to use novel.location.list command."
---

# Novel Location List



## Process Overview

This command lists all locations in the world, providing a comprehensive summary of their status, type, and key attributes.

### Process Steps

1. **Retrieve Location Data**: Run script to get JSON list of all locations
2. **Parse Location Information**: Extract key details from each location file
3. **Organize & Format**: Present locations in structured table/list
4. **Provide Interactive Options**: Allow filtering, sorting, and navigation

## Detailed Process

### Phase 1: Data Retrieval (Automatic)

#### Step 1: Run List Script

Execute the location manager script to get a JSON list of all locations:

```bash
./scripts/bash/location-manager.sh list --json
```

The script should:
- Scan `./world/locations/` directory (user space, project root)
- Read metadata from each location file
- Return JSON with location list including:
  - Location ID
  - Location name
  - File path
  - Last modified date
  - Status (if available in metadata)

#### Step 2: Read Location Files (Optional, for detailed info)

For each location, optionally read the location file to extract:
- Location type (City, Village, Dungeon, etc.)
- Current status (Active/Ruined/Destroyed/etc.)
- Affiliation (if any)
- Key features

**Note**: For performance, only read full files if user requests detailed view or if location count is small (< 30).

### Phase 2: Data Organization

#### Step 3: Categorize Locations

Organize locations by:
- **Type**: City, Village, Dungeon, Forest, Building, etc.
- **Status**: Active, Ruined, Destroyed, Hidden
- **Affiliation**: By faction or independent

#### Step 4: Extract Key Information

For each location, extract:
- **ID**: `location-xxx` format
- **Name**: Full name
- **Type**: Primary type
- **Status**: Current story status
- **Affiliation**: Associated faction (if any)
- **Last Updated**: Last modification date
- **Key Attributes**: Brief summary (1-2 key traits)

### Phase 3: Display Format

#### Step 5: Format Location List

Present locations in a clear, organized format:

**Default Table View**:

```markdown
## Location List

**Total Locations**: [COUNT]

| ID | Name | Type | Status | Affiliation | Last Updated |
|----|------|------|--------|-------------|--------------|
| location-001 | [Name] | City | Active | [Faction] | 2025-01-15 |
| location-002 | [Name] | Village | Active | None | 2025-01-14 |
| location-003 | [Name] | Dungeon | Ruined | None | 2025-01-13 |
```

**Grouped View** (by type):

```markdown
## Location List

### Cities
- location-001: [Name] - [Status] - [Brief description]

### Villages
- location-002: [Name] - [Status] - [Brief description]

### Dungeons
- location-003: [Name] - [Status] - [Brief description]
```

**Display Columns** (configurable):
- **ID**: `location-xxx`
- **Name**: Location name
- **Type**: City / Village / Dungeon / Forest / Building / etc.
- **Status**: Active / Ruined / Destroyed / Hidden
- **Affiliation**: Faction name or "None"
- **Key Attributes**: 1-2 sentence summary
- **Updated**: Last modified date (YYYY-MM-DD format)

### Phase 4: Interactive Features

#### Step 6: Provide Filtering Options

Offer filtering capabilities:
- **By Type**: Show only cities, villages, dungeons, etc.
- **By Status**: Show only active, ruined, etc.
- **By Affiliation**: Show locations by faction
- **Search**: Filter by name or keyword

#### Step 7: Provide Sorting Options

Allow sorting by:
- Name (alphabetical)
- Type (grouped by type)
- Status (active first)
- Last Updated (newest first)
- Creation Date (oldest first)

#### Step 8: Provide Navigation Options

For each location, provide quick actions:
- **View Details**: `/novel.location.show [ID/Name]`
- **Update**: `/novel.location.update [ID/Name]`
- **Show Map**: `/novel.location.map [ID/Name]` (if available)

## Output Format

### Standard Output

```markdown
## Location List

**Total**: [COUNT] locations

| ID | Name | Type | Status | Affiliation | Last Updated |
|----|------|------|--------|-------------|--------------|
| location-001 | [Name] | City | Active | [Faction] | 2025-01-15 |
| location-002 | [Name] | Village | Active | None | 2025-01-14 |

**Quick Actions**:
- Use `/novel.location.show <ID>` to view detailed profile
- Use `/novel.location.update <ID>` to modify location
- Use `/novel.location.new` to create new location
```

## Error Handling

- **No Locations Found**: 
  - Display: "No locations found. Use `/novel.location.new` to create your first location."
  - Suggest creating a location

- **Script Error**: 
  - If script fails, try reading directory directly
  - Report error: "Unable to retrieve location list. Please check script permissions."

- **File Read Error**: 
  - If individual location file cannot be read, show ID and name only
  - Note: "Unable to read full profile for [ID]"

- **Empty Directory**: 
  - Display helpful message with link to create first location

## Guidelines

- **Performance**: For large location lists (>50), use pagination or lazy loading
- **Sorting**: Default sort by type, then by name
- **Summary Stats**: Show statistics like "X cities, Y villages, Z dungeons"
- **Quick Access**: Provide shortcuts to most common actions

