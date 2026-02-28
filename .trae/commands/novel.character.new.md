

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Creation Modes

This command supports **two creation modes**:

1. **User-Specified Mode**: If `$ARGUMENTS` contains specific requirements (name, role, description, etc.), follow user's requirements closely while ensuring consistency with the world.
2. **Free Creation Mode**: If `$ARGUMENTS` is empty or vague, intelligently create a character that fits naturally into the existing character network and world.

**CRITICAL**: In both modes, you **MUST** read the existing character relationship network to ensure the new character integrates logically with existing characters.

## Process Overview

1. **Context Loading** (Automatic): Read constitution, existing characters, **relationship network**, factions, and world data
2. **Mode Detection**: Determine if user-specified or free creation mode
3. **Dynamic Interview**: Conduct adaptive Q&A based on context and character importance
4. **Constitution Compliance Check**: Validate character against constraints
5. **Profile Generation**: Assemble collected data into character template
6. **Final Confirmation**: Review generated profile before saving
7. **File Creation**: Create character file and save profile
8. **State Machine Update**: Update config.json with new character information

## Context Loading (Automatic)

**CRITICAL: You MUST intelligently read all relevant context before starting the interview.**

### Required Context

1. **Novel Constitution** (ALWAYS REQUIRED):
   - Read `.novelkit/memory/constitution.md`
   - Extract: character constraints, worldview constraints, naming conventions, tone & style, plot constraints

2. **Existing Characters** (REQUIRED):
   - Scan `./world/characters/` directory (user space, project root)
   - Extract: names, roles, factions, key attributes
   - Read key character profiles (protagonists, antagonists, similar roles)
   - **Purpose**: Avoid duplicates, understand character landscape, identify gaps

3. **Character Relationship Network** (REQUIRED):
   - Read `./world/relationships/network.md` (user space, project root)
   - Extract: all relationships, relationship patterns, character clusters, isolated characters
   - **Purpose**: 
     - In **Free Creation Mode**: Generate character that naturally connects to existing characters
     - In **User-Specified Mode**: Ensure relationships are consistent with network
     - Suggest logical relationship opportunities

4. **Factions** (If relevant):
   - Scan `./world/factions/` directory
   - Extract: faction names, structures, goals, member lists

5. **World Information** (If needed):
   - Read `./world/worldview.md` for world rules
   - Read `./world/timeline.md` for historical context
   - Read `./world/locations/` for location context

6. **Plot Information** (If relevant):
   - Read active main plots: `./plots/main/[plot-id]/plot.md`
   - Read active side plots: `./plots/side/[plot-id]/plot.md`

### Context Summary

After loading context, report to user:
- Constitution constraints summary
- Existing character landscape (X protagonists, Y antagonists, etc.)
- Relationship network summary (key clusters, relationship opportunities)
- Available factions
- World rules affecting character creation
- Plot needs (if relevant)

## Dynamic Interview Process

**The interview is fully dynamic - you decide the questions, order, and depth based on context.**

### Interview Principles

1. **Adaptive Depth**: 
   - Protagonist: 20-30 questions (comprehensive)
   - Supporting character: 12-18 questions (moderate)
   - Minor character: 8-12 questions (essential only)

2. **Question Selection**:
   - Base questions on character template structure (Basic Info, Appearance, Personality, Abilities, Background, Relationships, Plot Relevance)
   - Skip irrelevant sections (e.g., skip combat questions for non-combat characters)
   - Prioritize based on character importance and role

3. **Question Format**:
   - Each question must provide **at least 6 options** (A-F) plus Custom
   - Options should be context-aware (based on constitution, existing characters, world rules)
   - Show current context when relevant

4. **Dynamic Flow**:
   - Questions adapt based on previous answers
   - Follow-up questions only when needed (avoid over-questioning)
   - Allow user to skip, go back, or review progress

### Critical Requirements

#### Naming Rules (CRITICAL - HARD CONSTRAINTS)

**ABSOLUTELY FORBIDDEN - AI Template Names (Highest Priority)**:

**Male Names (Directly Prohibited)**:
林然、顾言、陆沉、沈舟、沈砚、周野、程野、江澈、许墨、顾辰

**Female Names (Directly Prohibited)**:
苏念、林夏、安然、顾清、苏晚、许诺、沈知意、白月、叶然、温言

**Abstract Value Words as Names (Prohibited)**:
念、然、诺、安、言、知意、清、澈、温、野

**Reason**: These names appear with extremely high frequency in AI-generated content and form "statistical fingerprints" that immediately expose AI origin.

**Structural Prohibitions**:

1. **No "Neutral Perfect Names"**:
   - Names without era/period markers
   - Names without regional markers
   - Names without social class markers
   - Two-character names with smooth pronunciation and vague positive meanings
   - **Test**: If you cannot answer "Who named them?", "When/where were they named?", "Why this name?" → FORBIDDEN

2. **No "Literary Filter Surnames Concentration"**:
   - Avoid overuse of: 林、顾、陆、沈、白、许、江、温、叶
   - These exist in reality but are severely over-represented in AI text

**Semantic Prohibitions**:

1. **No Names with Built-in Character Arc**:
   - Names must NOT hint at personality
   - Names must NOT foreshadow fate
   - Names must NOT complete metaphors in advance
   - Character arcs must be achieved through plot, not naming shortcuts

**Requirements**:
- All names must match world naming conventions from constitution and existing characters
- Analyze naming patterns from existing characters (surnames, given names, regional variations)
- Names must reflect character's background, race, region, social status, and **birth era**
- Check against all existing character names to avoid duplicates
- Use diverse, natural naming patterns that sound like real-world names (not literary)

**Advanced: Reality Anchoring Rule** (Recommended):
Each character name must be accompanied by:
- Birth year/era range
- Parental education level
- Naming motivation (realistic, not symbolic)

If these cannot be determined, the name is invalid.

**Core Principle**: Good names are not "literary-like", but "household register-like". AI struggles most with household register-style names.

**If user provides inappropriate name**: Reject immediately, explain why (cite specific prohibition), provide 6+ world-appropriate alternatives that pass all checks.

#### Relationship Integration

**In Free Creation Mode**:
- Analyze relationship network to identify:
  - Characters who need more connections
  - Relationship gaps that make narrative sense
  - Natural interaction opportunities
- Suggest 3-5 specific relationship opportunities
- Prioritize relationship questions to ensure character integrates well

**In User-Specified Mode**:
- Present existing characters for relationship selection
- Suggest relationships based on character's role and background
- Ensure relationships are consistent with network

#### Constitution Compliance

Before saving, check:
- Character type allowed?
- Power level within limits?
- Name style appropriate?
- Background fits world history?
- Role fits story needs?
- Faction relationships consistent?

If violations found: Warn user, suggest corrections, allow override with confirmation (log in Notes).

## Profile Generation

After interview completion:

1. **Assemble Profile**: Fill `templates/character.md` with all collected data
2. **Expand Descriptions**: Convert brief answers into rich, vivid descriptions
3. **Add Metadata**: Include creation date, ID, status
4. **Constitution Check**: Validate all constraints
5. **Final Review**: Show complete profile to user for confirmation

## File Creation & State Update

### Create Character File

Execute script:
```bash
./scripts/bash/character-manager.sh new "[Name]"
```

Script returns JSON with:
- Character ID (character-xxx)
- File path: `./world/characters/[character-id]/character.md`
- Created timestamp

Write the generated profile to the file path.

### Update State Machine

After saving:

1. Read `.novelkit/memory/config.json`
2. Update `statistics.characters_created`: increment by 1
3. Update `session.last_action`: "Created character [character-id] ([Name])"
4. Update `session.last_action_time`: [current timestamp]
5. Update `session.last_action_command`: "character-new"
6. Update `session.last_modified_file`: `./world/characters/[character-id]/character.md`
7. Add to `history.recent_actions` array (keep last 20):
   ```json
   {
     "action": "created_character",
     "character_id": "[character-id]",
     "character_name": "[Name]",
     "role": "[Role]",
     "timestamp": "[ISO 8601]",
     "command": "character-new"
   }
   ```
8. Update `last_updated`: [current timestamp]
9. Save updated config.json

## Output Format

After completion:

```markdown
✅ Character created successfully!

**Character ID**: character-001
**Name**: [Character Name]
**Role**: [Role]
**File**: ./world/characters/character-001/character.md
**Status**: Active

**Constitution Compliance**: ✅ All checks passed
(Or: ⚠️ Some warnings - see Notes section)

Summary of character:
- [Key characteristic 1]
- [Key characteristic 2]
- [Key characteristic 3]

Use `/novel.character.show character-001` to view full profile.
Use `/novel.character.update character-001` to modify character.
```

## Error Handling

- **Invalid Name (AI Template or Prohibited)**:
  - Reject immediately if name matches any prohibited list (AI template names, abstract value words, etc.)
  - Reject if name fails structural checks (no era/region/class markers, cannot answer "who/when/why named")
  - Reject if name has built-in character arc (hints personality/fate)
  - Explain specific prohibition violated
  - Provide 6+ world-appropriate alternatives that pass all checks
  - Do NOT proceed until valid name is chosen

- **Duplicate Name**: List similar names, suggest variations (must be world-appropriate and pass all naming checks)
- **Constitution Violation**: List violations, suggest corrections, allow override with confirmation (log in Notes)
- **File Creation Error**: Report error, suggest manual creation steps
- **Missing Context**: Warn but allow creation (suggest creating missing context first)
- **Incomplete Interview**: Save partial profile (mark as incomplete), allow completion later

## Important Notes

- **Two creation modes**: Support both user-specified and free creation modes
- **Relationship network required**: MUST read and analyze relationship network
- **Naming rules are HARD CONSTRAINTS**: 
  - Absolutely forbidden AI template names (林然、顾言、苏念、陆沉等)
  - No abstract value words as names
  - No neutral perfect names without era/region/class markers
  - No names with built-in character arc
  - Names must be "household register-like", not "literary-like"
  - Advanced: Each name should have birth era, parental education level, naming motivation
- **Dynamic interview**: Questions, order, and depth are determined by AI based on context
- **Minimum 6 options**: Every question must have at least 6 options (A-F) plus Custom
- **Avoid over-questioning**: Keep questions focused and relevant
- **Constitution first**: Always check constitution compliance before saving
- **User control**: User can skip, go back, or cancel at any time
