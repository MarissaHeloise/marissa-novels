---
name: "novel-plot-side-list"
description: "This command lists all side plots in the novel, providing a comprehensive summary of their status, type, and key details. Invoke when user wants to use novel.plot.side.list command."
---

# Novel Plot Side List



## Process Overview

This command lists all side plots in the novel, providing a comprehensive summary of their status, type, and key details.

### Process Steps

1. **Retrieve Plot Data**: Run script to get JSON list of all side plots
2. **Parse Plot Information**: Extract key details from each plot file
3. **Organize & Format**: Present plots in structured table/list
4. **Provide Interactive Options**: Allow filtering, sorting, and navigation

## Detailed Process

### Phase 1: Data Retrieval (Automatic)

#### Step 1: Run List Script

Execute the plot manager script to get a JSON list of all side plots:

```bash
./scripts/bash/plot-manager.sh list --type side
```

The script should:
- Scan `./plots/side/` directory (user space, project root)
- Read metadata from each plot file
- Return JSON with plot list including:
  - Plot ID
  - Plot title
  - File path
  - Last modified date
  - Status (if available in metadata)

#### Step 2: Read Plot Files (Optional, for detailed info)

For each plot, optionally read the plot file to extract:
- Status (Planned/Active/Resolved/Abandoned)
- Plot type (Romance, Revenge, Mystery, etc.)
- Related main plot
- Key characters involved

**Note**: For performance, only read full files if user requests detailed view or if plot count is small (< 30).

### Phase 2: Data Organization

#### Step 3: Categorize Plots

Organize plots by:
- **Status**: Planned, Active, Resolved, Abandoned
- **Type**: Romance, Revenge, Mystery, Training, Character Development, etc.
- **Connection**: By related main plot

#### Step 4: Extract Key Information

For each plot, extract:
- **ID**: `side-plot-xxx` format
- **Title**: Plot title
- **Status**: Current status (Planned/Active/Resolved/Abandoned)
- **Type**: Plot type (Romance, Revenge, etc.)
- **Related Main Plot**: Connected main plot (if any)
- **Key Characters**: Main characters involved
- **Last Updated**: Last modification date

### Phase 3: Display Format

#### Step 5: Format Plot List

Present plots in a clear, organized format:

**Default Table View**:

```markdown
## Side Plot List

**Total Side Plots**: [COUNT]

| ID | Title | Type | Status | Related Main Plot | Last Updated |
|----|-------|------|--------|-------------------|--------------|
| side-plot-001 | [Title] | Romance | Active | [Main Plot] | 2025-01-15 |
| side-plot-002 | [Title] | Mystery | Planned | [Main Plot] | 2025-01-14 |
| side-plot-003 | [Title] | Training | Resolved | None | 2025-01-13 |
```

**Grouped View** (by type):

```markdown
## Side Plot List

### Romance
- side-plot-001: [Title] - [Status] - Related to [Main Plot]

### Mystery
- side-plot-002: [Title] - [Status] - Related to [Main Plot]

### Training
- side-plot-003: [Title] - [Status] - Standalone
```

**Display Columns** (configurable):
- **ID**: `side-plot-xxx`
- **Title**: Plot title
- **Type**: Romance / Revenge / Mystery / Training / etc.
- **Status**: Planned / Active / Resolved / Abandoned
- **Related Main Plot**: Connected main plot or "Standalone"
- **Key Characters**: Main characters involved (truncated if long)
- **Updated**: Last modified date (YYYY-MM-DD format)

### Phase 4: Interactive Features

#### Step 6: Provide Filtering Options

Offer filtering capabilities:
- **By Status**: Show only planned, active, resolved, or abandoned
- **By Type**: Show only romance, mystery, training, etc.
- **By Main Plot**: Show side plots for specific main plot
- **By Character**: Show plots involving specific character
- **Search**: Filter by title or keyword

#### Step 7: Provide Sorting Options

Allow sorting by:
- Title (alphabetical)
- Type (grouped by type)
- Status (active first, then planned, then resolved)
- Related Main Plot
- Last Updated (newest first)

#### Step 8: Provide Navigation Options

For each plot, provide quick actions:
- **View Details**: `/novel.plot.side.show [ID/Title]`
- **Update**: `/novel.plot.side.update [ID/Title]`
- **View Related Main Plot**: Link to connected main plot

## Output Format

### Standard Output

```markdown
## Side Plot List

**Total**: [COUNT] side plots

| ID | Title | Type | Status | Related Main Plot | Last Updated |
|----|-------|------|--------|-------------------|--------------|
| side-plot-001 | [Title] | Romance | Active | [Main Plot] | 2025-01-15 |
| side-plot-002 | [Title] | Mystery | Planned | [Main Plot] | 2025-01-14 |

**Quick Actions**:
- Use `/novel.plot.side.show <ID>` to view detailed profile
- Use `/novel.plot.side.update <ID>` to modify plot
- Use `/novel.plot.side.new` to create new side plot
```

## Error Handling

- **No Plots Found**: 
  - Display: "No side plots found. Use `/novel.plot.side.new` to create your first side plot."
  - Suggest creating a plot

- **Script Error**: 
  - If script fails, try reading directory directly
  - Report error: "Unable to retrieve plot list. Please check script permissions."

- **File Read Error**: 
  - If individual plot file cannot be read, show ID and title only
  - Note: "Unable to read full profile for [ID]"

- **Empty Directory**: 
  - Display helpful message with link to create first plot

## Guidelines

- **Performance**: For large plot lists (>30), use pagination or lazy loading
- **Sorting**: Default sort by type, then by status (active first)
- **Summary Stats**: Show statistics like "X romance, Y mystery, Z training plots"
- **Quick Access**: Provide shortcuts to most common actions

