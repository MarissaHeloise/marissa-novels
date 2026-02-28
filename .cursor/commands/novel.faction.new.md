

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Creation Modes

This command supports **two creation modes**:

1. **User-Specified Mode**: If `$ARGUMENTS` contains specific requirements (name, type, description, etc.), follow user's requirements closely while ensuring consistency with the world.
2. **Free Creation Mode**: If `$ARGUMENTS` is empty or vague, intelligently create a faction that fits naturally into the existing world.

## Process Overview

1. **Context Loading** (Automatic): Read constitution, existing factions, world data
2. **Mode Detection**: Determine if user-specified or free creation mode
3. **Dynamic Interview**: Conduct adaptive Q&A based on context
4. **Constitution Compliance Check**: Validate faction against constraints
5. **Profile Generation**: Assemble collected data into faction template
6. **Final Confirmation**: Review generated profile before saving
7. **File Creation**: Create faction file and save profile
8. **State Machine Update**: Update config.json with new faction information

## Context Loading (Automatic)

**CRITICAL: You MUST intelligently read all relevant context before starting the interview.**

### Required Context

1. **Novel Constitution** (ALWAYS REQUIRED):
   - Read `.novelkit/memory/constitution.md`
   - Extract: worldview constraints, power structures, political rules, faction types allowed

2. **Existing Factions** (REQUIRED):
   - Scan `./world/factions/` directory (user space, project root)
   - Extract: faction names, types, structures, goals, relationships
   - **Purpose**: Avoid duplicates, understand political landscape, identify gaps

3. **World Information** (If needed):
   - Read `./world/worldview.md` for world rules
   - Read `./world/timeline.md` for historical context
   - Read `./world/locations/` for territorial context

4. **Character Information** (If relevant):
   - Read key character profiles to understand potential faction leaders/members
   - Check character relationships for faction connections

### Context Summary

After loading context, report to user:
- Constitution constraints summary
- Existing faction landscape (types, power distribution)
- Political structure and relationships
- World rules affecting faction creation

## Dynamic Interview Process

**The interview is fully dynamic - you decide the questions, order, and depth based on context.**

### Interview Principles

1. **Adaptive Depth**: 
   - Major faction (kingdom, empire): 15-20 questions (comprehensive)
   - Medium faction (guild, organization): 12-15 questions (moderate)
   - Minor faction (small group): 8-12 questions (essential only)

2. **Question Selection**:
   - Base questions on faction template structure (Identity, Organization, Goals, Resources, Diplomacy, History)
   - Skip irrelevant sections based on faction type
   - Prioritize based on faction importance

3. **Question Format** (MANDATORY):
   - Each question must provide **at least 6 options** (A-F) plus Custom
   - Options must be **mutually exclusive and non-repetitive**
   - Clearly state: "You can also enter your own custom input if none of the options fit"
   - Options should be context-aware (based on constitution, existing factions, world rules)
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

1. **Identity**: Name, Type (Religious/Military/Merchant/Guild/Kingdom/etc.), Scale
2. **Organization**: Leadership structure, hierarchy, membership rules
3. **Goals**: Public mission vs. hidden agenda, short-term vs. long-term
4. **Resources**: Wealth, territory, military power, special assets
5. **Diplomacy**: Friends, enemies, rivals, relationships with existing factions
6. **History**: Founding legend, recent events, key turning points

**Note**: Not all topics need to be covered. AI decides based on faction importance and context.

## Constitution Compliance Check

Before saving, check:
- Faction type allowed in world?
- Power level within world constraints?
- Name/style appropriate for world?
- Goals consistent with world rules?
- Relationships make sense?

If violations found: Warn user, suggest corrections, allow override with confirmation (log in Notes).

## Profile Generation

After interview completion:

1. **Assemble Profile**: Fill `templates/faction.md` with all collected data
2. **Expand Descriptions**: Convert brief answers into rich, detailed descriptions
3. **Add Metadata**: Include creation date, ID, status
4. **Constitution Check**: Validate all constraints
5. **Final Review**: Show complete profile to user for confirmation

## File Creation & State Update

### Create Faction File

Execute script:
```bash
./scripts/bash/faction-manager.sh new "[Name]"
```

Script returns JSON with:
- Faction ID (faction-xxx)
- File path: `./world/factions/[faction-id]/faction.md`
- Created timestamp

Write the generated profile to the file path.

### Update State Machine

After saving:

1. Read `.novelkit/memory/config.json`
2. Update `statistics.factions_created`: increment by 1 (if field exists)
3. Update `world.total_factions`: increment by 1
4. Update `session.last_action`: "Created faction [faction-id] ([Name])"
5. Update `session.last_action_time`: [current timestamp]
6. Update `session.last_action_command`: "faction-new"
7. Update `session.last_modified_file`: `./world/factions/[faction-id]/faction.md`
8. Add to `history.recent_actions` array (keep last 20):
   ```json
   {
     "action": "created_faction",
     "faction_id": "[faction-id]",
     "faction_name": "[Name]",
     "faction_type": "[Type]",
     "timestamp": "[ISO 8601]",
     "command": "faction-new"
   }
   ```
9. Update `last_updated`: [current timestamp]
10. Save updated config.json

## Output Format

After completion:

```markdown
✅ Faction created successfully!

**Faction ID**: faction-001
**Name**: [Faction Name]
**Type**: [Type]
**File**: ./world/factions/faction-001/faction.md
**Status**: Active

**Constitution Compliance**: ✅ All checks passed
(Or: ⚠️ Some warnings - see Notes section)

Summary of faction:
- [Key characteristic 1]
- [Key characteristic 2]
- [Key characteristic 3]

Use `/novel.faction.show faction-001` to view full profile.
Use `/novel.faction.update faction-001` to modify faction.
```

## Error Handling

- **Invalid Name**: Reject if name conflicts with existing factions or doesn't match world conventions
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
