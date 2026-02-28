

## Process Overview

This command lists all main plots in the novel, providing a comprehensive summary of their status, theme, and key details.

### Process Steps

1. **Retrieve Plot Data**: Run script to get JSON list of all main plots
2. **Parse Plot Information**: Extract key details from each plot file
3. **Organize & Format**: Present plots in structured table/list
4. **Provide Interactive Options**: Allow filtering, sorting, and navigation

## Detailed Process

### Phase 1: Data Retrieval (Automatic)

#### Step 1: Run List Script

Execute the plot manager script to get a JSON list of all main plots:

```bash
./scripts/bash/plot-manager.sh list --type main
```

The script should:
- Scan `./plots/main/` directory (user space, project root)
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
- Core conflict or theme
- Key characters involved
- Current progress

**Note**: For performance, only read full files if user requests detailed view or if plot count is small (< 20).

### Phase 2: Data Organization

#### Step 3: Categorize Plots

Organize plots by:
- **Status**: Planned, Active, Resolved, Abandoned
- **Importance**: Core main plot, Important main plot, Minor main plot
- **Theme**: By conflict type or theme

#### Step 4: Extract Key Information

For each plot, extract:
- **ID**: `main-plot-xxx` format
- **Title**: Plot title
- **Status**: Current status (Planned/Active/Resolved/Abandoned)
- **Theme/Conflict**: Brief description of core conflict
- **Key Characters**: Main characters involved
- **Last Updated**: Last modification date

### Phase 3: Display Format

#### Step 5: Format Plot List

Present plots in a clear, organized format:

**Default Table View**:

```markdown
## Main Plot List

**Total Main Plots**: [COUNT]

| ID | Title | Status | Theme/Conflict | Last Updated |
|----|-------|--------|----------------|--------------|
| main-plot-001 | [Title] | Active | [Theme] | 2025-01-15 |
| main-plot-002 | [Title] | Planned | [Theme] | 2025-01-14 |
| main-plot-003 | [Title] | Resolved | [Theme] | 2025-01-13 |
```

**Grouped View** (by status):

```markdown
## Main Plot List

### Active
- main-plot-001: [Title] - [Brief description]

### Planned
- main-plot-002: [Title] - [Brief description]

### Resolved
- main-plot-003: [Title] - [Brief description]
```

**Display Columns** (configurable):
- **ID**: `main-plot-xxx`
- **Title**: Plot title
- **Status**: Planned / Active / Resolved / Abandoned
- **Theme/Conflict**: Brief description of core conflict
- **Key Characters**: Main characters involved (truncated if long)
- **Updated**: Last modified date (YYYY-MM-DD format)

### Phase 4: Interactive Features

#### Step 6: Provide Filtering Options

Offer filtering capabilities:
- **By Status**: Show only planned, active, resolved, or abandoned
- **By Theme**: Filter by conflict type or theme
- **By Character**: Show plots involving specific character
- **Search**: Filter by title or keyword

#### Step 7: Provide Sorting Options

Allow sorting by:
- Title (alphabetical)
- Status (active first, then planned, then resolved)
- Last Updated (newest first)
- Creation Date (oldest first)

#### Step 8: Provide Navigation Options

For each plot, provide quick actions:
- **View Details**: `/novel.plot.main.show [ID/Title]`
- **Update**: `/novel.plot.main.update [ID/Title]`
- **View Related Side Plots**: Show connected side plots

## Output Format

### Standard Output

```markdown
## Main Plot List

**Total**: [COUNT] main plots

| ID | Title | Status | Theme/Conflict | Last Updated |
|----|-------|--------|----------------|--------------|
| main-plot-001 | [Title] | Active | [Theme] | 2025-01-15 |
| main-plot-002 | [Title] | Planned | [Theme] | 2025-01-14 |

**Quick Actions**:
- Use `/novel.plot.main.show <ID>` to view detailed profile
- Use `/novel.plot.main.update <ID>` to modify plot
- Use `/novel.plot.main.new` to create new main plot
```

## Error Handling

- **No Plots Found**: 
  - Display: "No main plots found. Use `/novel.plot.main.new` to create your first main plot."
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
- **Sorting**: Default sort by status (active first), then by title
- **Summary Stats**: Show statistics like "X active, Y planned, Z resolved"
- **Quick Access**: Provide shortcuts to most common actions
