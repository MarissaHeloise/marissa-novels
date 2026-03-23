---
name: "novel-faction-show"
description: "$ARGUMENTS Invoke when user wants to use novel.faction.show command."
---

# Novel Faction Show



## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). Support both faction ID (faction-xxx) and name matching.

## Process Overview

This command retrieves and displays the full profile of a specified faction, including all details from the faction template. It also provides context by reading related information like relationships and member details.

### Process Steps

1. **Identify Faction**: Parse ID/name from `$ARGUMENTS` or prompt user
2. **Load Faction Profile**: Read the faction file
3. **Load Context**: Read related information (relationships, members, plots)
4. **Format Display**: Present profile in organized, readable format
5. **Provide Interactive Options**: Offer follow-up actions

## Detailed Process

### Phase 1: Faction Identification

#### Step 1: Parse Faction Identifier

**If `$ARGUMENTS` is provided**:
- Try to match as faction ID (format: `faction-xxx`)
- If not found, try name matching (fuzzy search)
- Support partial matches

**If `$ARGUMENTS` is empty**:
- Prompt user: "Which faction would you like to view?"
- Suggest: "Enter faction ID (faction-xxx) or name"
- Optionally list recent factions from config.json

#### Step 2: Run Show Script

Execute the faction manager script:

```bash
./scripts/bash/faction-manager.sh show "$ARGUMENTS"
```

The script should:
- Locate faction file in `./world/factions/[faction-id]/faction.md` (user space, project root)
- Return JSON with:
  - Faction ID
  - Faction name
  - File path
  - Last modified date
  - Status (if available)

#### Step 3: Handle Identification Errors

**If faction not found**:
- List similar names (fuzzy matching)
- Suggest: "Did you mean [similar name]?"
- Offer to create new faction: `/novel.faction.new`
- Offer to list all factions: `/novel.faction.list`

### Phase 2: Load Faction Profile

#### Step 4: Read Faction File

Read the full faction profile from the path returned by script:
- File location: `./world/factions/[faction-id]/faction.md` (user space, project root)
- Parse all sections according to faction template

#### Step 5: Extract Profile Information

Extract all sections from the faction template:

1. **Basic Information**:
   - Name, type, scale, status
   - Founding date, current leader

2. **Organization**:
   - Leadership structure, hierarchy
   - Membership rules, organization chart

3. **Goals & Philosophy**:
   - Public mission, hidden agenda
   - Core values, motto

4. **Resources & Power**:
   - Wealth, territory, military power
   - Special assets, influence

5. **Diplomacy**:
   - Allies, enemies, rivals
   - Relationship details

6. **History**:
   - Founding legend, key events
   - Recent developments

### Phase 3: Load Context Information

#### Step 6: Read Member Information

**If member list exists**:
- Read character profiles for key members
- Extract: member names, roles, importance
- Show member count and key members

#### Step 7: Read Relationship Network

**If relationship network exists**:
- Read `./world/relationships/network.md`
- Extract relationships involving this faction
- Show relationship dynamics and history

#### Step 8: Read Plot Involvement

**Check plot files for faction mentions**:
- Read active main plots: `./plots/main/[plot-id]/plot.md`
- Read active side plots: `./plots/side/[plot-id]/plot.md`
- Extract: faction's role in each plot, current plot status

### Phase 4: Format Display

#### Step 9: Organize Display Sections

Present faction profile in a structured, easy-to-read format:

**Header Section** (highlighted):
- Faction name (large, prominent)
- Faction ID
- Status badge (Active/Destroyed/etc.)
- Type badge (Kingdom/Guild/etc.)
- Last updated date

**Main Sections** (in order):
1. Basic Information
2. Organization
3. Goals & Philosophy
4. Resources & Power
5. Diplomacy
6. History
7. Notes

**Context Sections** (if available):
- Member Information
- Relationship Network
- Plot Involvement

#### Step 10: Format Each Section

Format each section clearly with proper markdown structure, ensuring readability.

### Phase 5: Interactive Actions

#### Step 11: Provide Follow-up Options

After displaying the profile, offer interactive actions:

**Primary Actions**:
- **Update Faction**: `/novel.faction.update [ID]` - Modify faction profile
- **View Members**: `/novel.faction.members [ID]` - Show member list
- **View Relationships**: `/novel.faction.relationships [ID]` - Show diplomatic relationships

**Secondary Actions**:
- **List All Factions**: `/novel.faction.list` - Return to faction list
- **Create Related Faction**: `/novel.faction.new` - Create faction with relationship

**Navigation**:
- **Previous Faction**: Navigate to previous faction in list
- **Next Faction**: Navigate to next faction in list
- **Related Factions**: Show factions with relationships

## Output Format

### Standard Display

```markdown
# Faction Profile: [FACTION_NAME]

**ID**: faction-001  
**状态**: Active ⭐  
**Type**: Kingdom  
**最后更新**: 2025-01-15

---

## Basic Information

[Full basic information section]

## Organization

[Full organization section]

[... all other sections ...]

---

## Quick Actions

- [Update Faction] [View Members] [View Relationships]
- [List All Factions] [Create Related Faction]
```

## Error Handling

- **Faction Not Found**: 
  - Show error: "Faction '[ID/Name]' not found."
  - List similar names
  - Suggest creating new faction

- **File Read Error**: 
  - Show error: "Unable to read faction file: [path]"
  - Check file permissions
  - Suggest manual file check

- **Missing Sections**: 
  - Show available sections
  - Note: "Some sections are incomplete. Use `/novel.faction.update` to complete."

- **Related Information Missing**: 
  - Show faction profile anyway
  - Note: "Some related information (members, relationships) not available."

## Guidelines

- **Complete Display**: Show all sections even if some are empty (mark as "未设置" or "Not set")
- **Link Navigation**: Provide links to related entities (members, other factions, plots)
- **Readability**: Use clear formatting, proper spacing, and visual hierarchy
- **Context Awareness**: Highlight faction's current relevance in story
- **Interactive**: Make it easy to navigate to related information

