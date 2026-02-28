

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Creation Modes

This command supports **two creation modes**:

1. **User-Specified Mode**: If `$ARGUMENTS` contains specific requirements (name, type, description, etc.), follow user's requirements closely while ensuring consistency with the world.
2. **Free Creation Mode**: If `$ARGUMENTS` is empty or vague, intelligently create a location that fits naturally into the existing world.

## Process Overview

1. **Context Loading** (Automatic): Read constitution, existing locations, world data
2. **Mode Detection**: Determine if user-specified or free creation mode
3. **Dynamic Interview**: Conduct adaptive Q&A based on context
4. **Constitution Compliance Check**: Validate location against constraints
5. **Profile Generation**: Assemble collected data into location template
6. **Final Confirmation**: Review generated profile before saving
7. **File Creation**: Create location file and save profile
8. **State Machine Update**: Update config.json with new location information

## Context Loading (Automatic)

**CRITICAL: You MUST intelligently read all relevant context before starting the interview.**

### Required Context

1. **Novel Constitution** (ALWAYS REQUIRED):
   - Read `.novelkit/memory/constitution.md`
   - Extract: worldview constraints, geography rules, location types allowed

2. **Existing Locations** (REQUIRED):
   - Scan `./world/locations/` directory (user space, project root)
   - Extract: location names, types, geography, affiliations
   - **Purpose**: Avoid duplicates, understand geographic landscape

3. **World Information** (REQUIRED):
   - Read `./world/worldview.md` for world rules and geography
   - Read `./world/timeline.md` for historical context
   - Check existing maps or geographic descriptions

4. **Faction Information** (If relevant):
   - Read `./world/factions/` to suggest rulers or influence
   - Extract: territorial control, faction locations

### Context Summary

After loading context, report to user:
- Constitution constraints summary
- Existing location landscape (types, geographic distribution)
- World geography and rules affecting location creation

## Dynamic Interview Process

**The interview is fully dynamic - you decide the questions, order, and depth based on context.**

### Interview Principles

1. **Adaptive Depth**: 
   - Major location (city, capital): 15-20 questions (comprehensive)
   - Medium location (town, important site): 12-15 questions (moderate)
   - Minor location (village, small site): 8-12 questions (essential only)

2. **Question Selection**:
   - Base questions on location template structure (Identity, Geography, Atmosphere, Population, Politics, Economy, History)
   - Skip irrelevant sections based on location type
   - Prioritize based on location importance

3. **Question Format** (MANDATORY):
   - Each question must provide **at least 6 options** (A-F) plus Custom
   - Options must be **mutually exclusive and non-repetitive**
   - Clearly state: "You can also enter your own custom input if none of the options fit"
   - Options should be context-aware (based on constitution, existing locations, world rules)
   - Show current context when relevant

4. **Dynamic Flow**:
   - Questions adapt based on previous answers
   - Each round: AI decides whether to continue based on confirmed information
   - Follow-up questions only when needed (avoid over-questioning)
   - Allow user to skip, go back, or review progress

5. **Information Confirmation**:
   - All information must be marked as **"confirmed"** or **"unconfirmed"**
   - For unconfirmed information, AI must continue asking or provide more options
   - Track confirmation status for each field

6. **Completeness Threshold**:
   - Before final generation, verify all necessary information is confirmed
   - If information is insufficient, actively point out missing items and continue guiding
   - Do NOT proceed to generation until all required fields are confirmed

7. **Interaction Control**:
   - AI designs question order, breaks down questions, merges answers
   - User only needs to answer, no need to plan the process

### Core Topics (Dynamic Selection)

Based on context, dynamically select and order questions from:

1. **Identity**: Name, Type (City/Village/Dungeon/Forest/etc.)
2. **Geography**: Where is it? Climate? Terrain? Geographic features?
3. **Atmosphere**: What does it feel/smell/sound like? (Sensory details)
4. **Population**: Demographics, size, density, key inhabitants
5. **Politics**: Who rules? Laws? Taboos? Governance structure?
6. **Economy**: Major exports, trade goods, wealth level, economic activity
7. **History**: Origins, legends, ruins, key historical events

**Note**: Not all topics need to be covered. AI decides based on location importance and context.

## Constitution Compliance Check

Before saving, check:
- Location type allowed in world?
- Geography consistent with world rules?
- Name/style appropriate for world?
- Features consistent with world rules (magic level, technology, etc.)?

If violations found: Warn user, suggest corrections, allow override with confirmation (log in Notes).

## Profile Generation

After interview completion:

1. **Assemble Profile**: Fill `templates/location.md` with all collected data
2. **Expand Descriptions**: Convert brief answers into rich, vivid descriptions
3. **Add Metadata**: Include creation date, ID, status
4. **Constitution Check**: Validate all constraints
5. **Final Review**: Show complete profile to user for confirmation

## File Creation & State Update

### Create Location File

Execute script:
```bash
./scripts/bash/location-manager.sh new "[Name]"
```

Script returns JSON with:
- Location ID (location-xxx)
- File path: `./world/locations/[location-id]/location.md`
- Created timestamp

Write the generated profile to the file path.

### Update State Machine

After saving:

1. Read `.novelkit/memory/config.json`
2. Update `statistics.locations_created`: increment by 1 (if field exists)
3. Update `world.total_locations`: increment by 1
4. Update `session.last_action`: "Created location [location-id] ([Name])"
5. Update `session.last_action_time`: [current timestamp]
6. Update `session.last_action_command`: "location-new"
7. Update `session.last_modified_file`: `./world/locations/[location-id]/location.md`
8. Add to `history.recent_actions` array (keep last 20):
   ```json
   {
     "action": "created_location",
     "location_id": "[location-id]",
     "location_name": "[Name]",
     "location_type": "[Type]",
     "timestamp": "[ISO 8601]",
     "command": "location-new"
   }
   ```
9. Update `last_updated`: [current timestamp]
10. Save updated config.json

## Output Format

After completion:

```markdown
✅ Location created successfully!

**Location ID**: location-001
**Name**: [Location Name]
**Type**: [Type]
**File**: ./world/locations/location-001/location.md
**Status**: Active

**Constitution Compliance**: ✅ All checks passed
(Or: ⚠️ Some warnings - see Notes section)

Summary of location:
- [Key characteristic 1]
- [Key characteristic 2]
- [Key characteristic 3]

Use `/novel.location.show location-001` to view full profile.
Use `/novel.location.update location-001` to modify location.
```

## Error Handling

- **Invalid Name**: Reject if name conflicts with existing locations or doesn't match world conventions
- **Duplicate Name**: List similar names, suggest variations (must be world-appropriate)
- **Constitution Violation**: List violations, suggest corrections, allow override with confirmation (log in Notes)
- **File Creation Error**: Report error, suggest manual creation steps
- **Missing Context**: Warn but allow creation (suggest creating missing context first)
- **Incomplete Interview**: Save partial profile (mark as incomplete), allow completion later

## Important Notes

- **Two creation modes**: Support both user-specified and free creation modes
- **Dynamic interview**: Questions, order, and depth are determined by AI based on context
- **Minimum 6 options**: Every question must have at least 6 options (A-F) plus Custom
- **Information confirmation**: All information must be confirmed before proceeding
- **Completeness check**: Verify all necessary information before generation
- **Avoid over-questioning**: Keep questions focused and relevant
- **Constitution first**: Always check constitution compliance before saving
- **User control**: User can skip, go back, or cancel at any time
