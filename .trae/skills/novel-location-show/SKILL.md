---
name: "novel-location-show"
description: "$ARGUMENTS Invoke when user wants to use novel.location.show command."
---

# Novel Location Show



## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). Support both location ID (location-xxx) and name matching.

## Process Overview

This command retrieves and displays the full profile of a specified location, including all details from the location template. It also provides context by reading related information like faction details and plot involvement.

### Process Steps

1. **Identify Location**: Parse ID/name from `$ARGUMENTS` or prompt user
2. **Load Location Profile**: Read the location file
3. **Load Context**: Read related information (factions, plots, nearby locations)
4. **Format Display**: Present profile in organized, readable format
5. **Provide Interactive Options**: Offer follow-up actions

## Detailed Process

### Phase 1: Location Identification

#### Step 1: Parse Location Identifier

**If `$ARGUMENTS` is provided**:
- Try to match as location ID (format: `location-xxx`)
- If not found, try name matching (fuzzy search)
- Support partial matches

**If `$ARGUMENTS` is empty**:
- Prompt user: "Which location would you like to view?"
- Suggest: "Enter location ID (location-xxx) or name"
- Optionally list recent locations from config.json

#### Step 2: Run Show Script

Execute the location manager script:

```bash
./scripts/bash/location-manager.sh show "$ARGUMENTS"
```

The script should:
- Locate location file in `./world/locations/[location-id]/location.md` (user space, project root)
- Return JSON with:
  - Location ID
  - Location name
  - File path
  - Last modified date
  - Status (if available)

#### Step 3: Handle Identification Errors

**If location not found**:
- List similar names (fuzzy matching)
- Suggest: "Did you mean [similar name]?"
- Offer to create new location: `/novel.location.new`
- Offer to list all locations: `/novel.location.list`

### Phase 2: Load Location Profile

#### Step 4: Read Location File

Read the full location profile from the path returned by script:
- File location: `./world/locations/[location-id]/location.md` (user space, project root)
- Parse all sections according to location template

#### Step 5: Extract Profile Information

Extract all sections from the location template:

1. **Basic Information**:
   - Name, type, affiliation, status
   - Geographic location, climate

2. **Atmosphere**:
   - Sensory details (sight, sound, smell, feel)
   - Overall mood and feeling

3. **Structure**:
   - Districts, zones, points of interest
   - Layout and geography

4. **Resources**:
   - Economy, trade goods, special resources
   - Wealth level

5. **Politics**:
   - Ruler, laws, taboos
   - Governance structure

6. **History**:
   - Origin, legends, key events
   - Recent developments

7. **Map** (if available):
   - Map visualization

### Phase 3: Load Context Information

#### Step 6: Read Faction Information

**If location has faction affiliation**:
- Read `./world/factions/[faction-id]/faction.md`
- Extract: faction name, structure, goals, current status
- Show location's position in faction territory

#### Step 7: Read Plot Involvement

**Check plot files for location mentions**:
- Read active main plots: `./plots/main/[plot-id]/plot.md`
- Read active side plots: `./plots/side/[plot-id]/plot.md`
- Extract: location's role in each plot, events that occurred here

#### Step 8: Read Nearby Locations (Optional)

**If geographic context needed**:
- Read related location files
- Extract: nearby locations, connections, travel routes

### Phase 4: Format Display

#### Step 9: Organize Display Sections

Present location profile in a structured, easy-to-read format:

**Header Section** (highlighted):
- Location name (large, prominent)
- Location ID
- Status badge (Active/Ruined/etc.)
- Type badge (City/Village/etc.)
- Last updated date

**Main Sections** (in order):
1. Basic Information
2. Atmosphere
3. Structure
4. Resources
5. Politics
6. History
7. Map (if available)
8. Notes

**Context Sections** (if available):
- Faction Information
- Plot Involvement
- Nearby Locations

#### Step 10: Format Each Section

Format each section clearly with proper markdown structure, ensuring readability.

### Phase 5: Interactive Actions

#### Step 11: Provide Follow-up Options

After displaying the profile, offer interactive actions:

**Primary Actions**:
- **Update Location**: `/novel.location.update [ID]` - Modify location profile
- **Show Map**: `/novel.location.map [ID]` - Generate or view map
- **View Faction**: Show full faction information (if applicable)

**Secondary Actions**:
- **List All Locations**: `/novel.location.list` - Return to location list
- **Create Related Location**: `/novel.location.new` - Create location with connection

**Navigation**:
- **Previous Location**: Navigate to previous location in list
- **Next Location**: Navigate to next location in list
- **Nearby Locations**: Show connected or nearby locations

## Output Format

### Standard Display

```markdown
# Location Profile: [LOCATION_NAME]

**ID**: location-001  
**状态**: Active ⭐  
**Type**: City  
**最后更新**: 2025-01-15

---

## Basic Information

[Full basic information section]

## Atmosphere

[Full atmosphere section]

[... all other sections ...]

---

## Quick Actions

- [Update Location] [Show Map] [View Faction]
- [List All Locations] [Create Related Location]
```

## Error Handling

- **Location Not Found**: 
  - Show error: "Location '[ID/Name]' not found."
  - List similar names
  - Suggest creating new location

- **File Read Error**: 
  - Show error: "Unable to read location file: [path]"
  - Check file permissions
  - Suggest manual file check

- **Missing Sections**: 
  - Show available sections
  - Note: "Some sections are incomplete. Use `/novel.location.update` to complete."

- **Related Information Missing**: 
  - Show location profile anyway
  - Note: "Some related information (factions, plots) not available."

## Guidelines

- **Complete Display**: Show all sections even if some are empty (mark as "未设置" or "Not set")
- **Link Navigation**: Provide links to related entities (factions, plots, other locations)
- **Readability**: Use clear formatting, proper spacing, and visual hierarchy
- **Context Awareness**: Highlight location's current relevance in story
- **Interactive**: Make it easy to navigate to related information

