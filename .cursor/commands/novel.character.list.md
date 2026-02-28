

## Process Overview

This command lists all characters in the novel world, providing a comprehensive summary of their status, role, and key attributes. It intelligently reads character data and presents it in an organized, filterable format.

### Process Steps

1. **Retrieve Character Data**: Run script to get JSON list of all characters
2. **Parse Character Information**: Extract key details from each character file
3. **Organize & Format**: Present characters in structured table/list
4. **Provide Interactive Options**: Allow filtering, sorting, and navigation

## Detailed Process

### Phase 1: Data Retrieval (Automatic)

#### Step 1: Run List Script

Execute the character manager script to get a JSON list of all characters:

```bash
./scripts/bash/character-manager.sh list --json
```

The script should:
- Scan `./world/characters/` directory (user space, project root)
- Read metadata from each character file
- Return JSON with character list including:
  - Character ID
  - Character name
  - File path
  - Last modified date
  - Status (if available in metadata)

#### Step 2: Read Character Files (Optional, for detailed info)

For each character, optionally read the character file to extract:
- Role type (Protagonist/Antagonist/Support/etc.)
- Current status (Active/Deceased/Missing/etc.)
- Faction affiliation
- Key relationships
- Plot relevance

**Note**: For performance, only read full files if user requests detailed view or if character count is small (< 20).

### Phase 2: Data Organization

#### Step 3: Categorize Characters

Organize characters by:
- **Role Type**: Protagonist, Antagonist, Supporting, Minor
- **Status**: Active, Deceased, Missing, Unknown
- **Faction**: Group by faction affiliation
- **Plot Relevance**: Main plot, Side plot, Background

#### Step 4: Extract Key Information

For each character, extract:
- **ID**: `character-xxx` format
- **Name**: Full name and aliases
- **Role**: Primary role in story
- **Status**: Current story status
- **Faction**: Associated faction (if any)
- **Last Updated**: Last modification date
- **Key Attributes**: Brief summary (1-2 key traits)

### Phase 3: Display Format

#### Step 5: Format Character List

Present characters in a clear, organized format with multiple view options:

**Default Table View**:

```markdown
## Character List

**Total Characters**: [COUNT]

| ID | Name | Role | Status | Faction | Last Updated |
|----|------|------|--------|---------|--------------|
| character-001 | [Name] | Protagonist | Active | [Faction] | 2025-01-15 |
| character-002 | [Name] | Antagonist | Active | [Faction] | 2025-01-14 |
| character-003 | [Name] | Support | Active | [Faction] | 2025-01-13 |
```

**Grouped View** (by role):

```markdown
## Character List

### Protagonists
- character-001: [Name] - [Status] - [Brief description]

### Antagonists
- character-002: [Name] - [Status] - [Brief description]

### Supporting Characters
- character-003: [Name] - [Status] - [Brief description]
```

**Display Columns** (configurable):
- **ID**: `character-xxx`
- **Name**: Character name (with aliases in parentheses if available)
- **Role**: Protagonist / Antagonist / Support / Minor / etc.
- **Status**: Active / Deceased / Missing / Unknown
- **Faction**: Faction name or "None"
- **Key Attributes**: 1-2 sentence summary
- **Updated**: Last modified date (YYYY-MM-DD format)

### Phase 4: Interactive Features

#### Step 6: Provide Filtering Options

Offer filtering capabilities:
- **By Role**: Show only protagonists, antagonists, etc.
- **By Status**: Show only active, deceased, etc.
- **By Faction**: Show characters from specific faction
- **By Plot**: Show characters involved in specific plot
- **Search**: Filter by name or keyword

#### Step 7: Provide Sorting Options

Allow sorting by:
- Name (alphabetical)
- Role (protagonist first)
- Status (active first)
- Last Updated (newest first)
- Creation Date (oldest first)

#### Step 8: Provide Navigation Options

For each character, provide quick actions:
- **View Details**: `/novel.character.show [ID/Name]`
- **Update**: `/novel.character.update [ID/Name]`
- **View Relationships**: Link to relationship network
- **View in Plot**: Link to relevant plot files

## Output Format

### Standard Output

```markdown
## Character List

**Total**: [COUNT] characters

| ID | Name | Role | Status | Faction | Last Updated |
|----|------|------|--------|---------|--------------|
| character-001 | Zhang San | Protagonist | Active | Hero Faction | 2025-01-15 |
| character-002 | Li Si | Antagonist | Active | Dark Faction | 2025-01-14 |
| character-003 | Wang Wu | Support | Active | Hero Faction | 2025-01-13 |

**Quick Actions**:
- Use `/novel.character.show <ID>` to view detailed profile
- Use `/novel.character.update <ID>` to modify character
- Use `/novel.character.new` to create new character
```

### Detailed Output (if requested)

```markdown
## Character List (Detailed)

### Protagonists (2)
1. **character-001: Zhang San**
   - Status: Active
   - Faction: Hero Faction
   - Key Attributes: Determined warrior, seeks justice
   - Last Updated: 2025-01-15
   - [View Details] [Update] [Relationships]

2. **character-002: ...**
```

## Error Handling

- **No Characters Found**: 
  - Display: "No characters found. Use `/novel.character.new` to create your first character."
  - Suggest creating a character

- **Script Error**: 
  - If script fails, try reading directory directly
  - Report error: "Unable to retrieve character list. Please check script permissions."

- **File Read Error**: 
  - If individual character file cannot be read, show ID and name only
  - Note: "Unable to read full profile for [ID]"

- **Empty Directory**: 
  - Display helpful message with link to create first character

## Guidelines

- **Performance**: For large character lists (>50), use pagination or lazy loading
- **Sorting**: Default sort by role (protagonist first), then by name
- **Highlighting**: Highlight characters that appeared in recent chapters (if available from config.json)
- **Summary Stats**: Show statistics like "X protagonists, Y antagonists, Z supporting characters"
- **Quick Access**: Provide shortcuts to most common actions
