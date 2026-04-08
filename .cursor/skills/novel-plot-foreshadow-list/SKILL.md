---
name: "novel-plot-foreshadow-list"
description: "This command lists all foreshadowing elements in the novel, providing a comprehensive summary of their status, target, and key details. Invoke when user wants to use novel.plot.foreshadow.list command."
---

# Novel Plot Foreshadow List



## Process Overview

This command lists all foreshadowing elements in the novel, providing a comprehensive summary of their status, target, and key details.

### Process Steps

1. **Retrieve Foreshadowing Data**: Run script to get JSON list of all foreshadowing elements
2. **Parse Foreshadowing Information**: Extract key details from each foreshadowing file
3. **Organize & Format**: Present foreshadowing in structured table/list
4. **Provide Interactive Options**: Allow filtering, sorting, and navigation

## Detailed Process

### Phase 1: Data Retrieval (Automatic)

#### Step 1: Run List Script

Execute the plot manager script to get a JSON list of all foreshadowing elements:

```bash
./scripts/bash/plot-manager.sh list --type foreshadow
```

The script should:
- Scan `./plots/foreshadowing/` directory (user space, project root)
- Read metadata from each foreshadowing file
- Return JSON with foreshadowing list including:
  - Foreshadowing ID
  - Foreshadowing name
  - File path
  - Last modified date
  - Status (if available in metadata)

#### Step 2: Read Foreshadowing Files (Optional, for detailed info)

For each foreshadowing element, optionally read the file to extract:
- Status (Planted/Revealed/Abandoned)
- Target plot or revelation
- Planting location (chapter)
- Subtlety level

**Note**: For performance, only read full files if user requests detailed view or if count is small (< 30).

### Phase 2: Data Organization

#### Step 3: Categorize Foreshadowing

Organize foreshadowing by:
- **Status**: Planted, Revealed, Abandoned
- **Target**: By related plot (main plot, side plot)
- **Timing**: By planting chapter or reveal chapter

#### Step 4: Extract Key Information

For each foreshadowing element, extract:
- **ID**: `foreshadow-xxx` format
- **Name**: Hint name or description
- **Status**: Current status (Planted/Revealed/Abandoned)
- **Target**: What it points to (plot, revelation)
- **Planting Location**: Where it was planted (chapter, if available)
- **Last Updated**: Last modification date

### Phase 3: Display Format

#### Step 5: Format Foreshadowing List

Present foreshadowing in a clear, organized format:

**Default Table View**:

```markdown
## Foreshadowing List

**Total Foreshadowing**: [COUNT]

| ID | Name | Status | Target | Planting Location | Last Updated |
|----|------|--------|--------|-------------------|--------------|
| foreshadow-001 | [Name] | Planted | [Plot] | Chapter 5 | 2025-01-15 |
| foreshadow-002 | [Name] | Revealed | [Plot] | Chapter 3 | 2025-01-14 |
| foreshadow-003 | [Name] | Abandoned | [Plot] | Chapter 2 | 2025-01-13 |
```

**Grouped View** (by status):

```markdown
## Foreshadowing List

### Planted (Not Yet Revealed)
- foreshadow-001: [Name] - Targets [Plot] - Planted in Chapter 5

### Revealed
- foreshadow-002: [Name] - Targets [Plot] - Revealed in Chapter 10

### Abandoned
- foreshadow-003: [Name] - Targets [Plot] - Abandoned
```

**Display Columns** (configurable):
- **ID**: `foreshadow-xxx`
- **Name**: Hint name or description
- **Status**: Planted / Revealed / Abandoned
- **Target**: Related plot or revelation
- **Planting Location**: Chapter or scene where planted
- **Updated**: Last modified date (YYYY-MM-DD format)

### Phase 4: Interactive Features

#### Step 6: Provide Filtering Options

Offer filtering capabilities:
- **By Status**: Show only planted, revealed, or abandoned
- **By Target**: Show foreshadowing for specific plot
- **By Timing**: Show by planting chapter or reveal chapter
- **Search**: Filter by name or keyword

#### Step 7: Provide Sorting Options

Allow sorting by:
- Name (alphabetical)
- Status (planted first, then revealed, then abandoned)
- Planting Location (chronological)
- Last Updated (newest first)
- Target Plot

#### Step 8: Provide Navigation Options

For each foreshadowing element, provide quick actions:
- **View Details**: `/novel.plot.foreshadow.show [ID/Name]` (if command exists)
- **Track/Update**: `/novel.plot.foreshadow.track [ID/Name]` - Update status
- **View Target Plot**: Link to related plot

## Output Format

### Standard Output

```markdown
## Foreshadowing List

**Total**: [COUNT] foreshadowing elements

| ID | Name | Status | Target | Planting Location | Last Updated |
|----|------|--------|--------|-------------------|--------------|
| foreshadow-001 | [Name] | Planted | [Plot] | Chapter 5 | 2025-01-15 |
| foreshadow-002 | [Name] | Revealed | [Plot] | Chapter 3 | 2025-01-14 |

**Quick Actions**:
- Use `/novel.plot.foreshadow.track <ID>` to update status
- Use `/novel.plot.foreshadow.new` to create new foreshadowing
```

## Error Handling

- **No Foreshadowing Found**: 
  - Display: "No foreshadowing elements found. Use `/novel.plot.foreshadow.new` to create your first foreshadowing."
  - Suggest creating foreshadowing

- **Script Error**: 
  - If script fails, try reading directory directly
  - Report error: "Unable to retrieve foreshadowing list. Please check script permissions."

- **File Read Error**: 
  - If individual file cannot be read, show ID and name only
  - Note: "Unable to read full profile for [ID]"

- **Empty Directory**: 
  - Display helpful message with link to create first foreshadowing

## Guidelines

- **Performance**: For large lists (>50), use pagination or lazy loading
- **Sorting**: Default sort by status (planted first), then by planting location
- **Summary Stats**: Show statistics like "X planted, Y revealed, Z abandoned"
- **Quick Access**: Provide shortcuts to most common actions

