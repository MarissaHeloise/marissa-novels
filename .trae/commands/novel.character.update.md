

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). Support both character ID (character-xxx) and name matching.

## Interactive Update Process

This command uses an **interactive Q&A interview** approach to update an existing character profile. The process is **dynamic and adaptive**, focusing only on areas that need changes. It ensures changes are consistent with the current story state and constitution.

### Process Overview

1. **Identify Character**: Parse character ID/name from `$ARGUMENTS` or prompt user
2. **Load Character Profile**: Read existing character file
3. **Load Context**: Read constitution, recent chapters, related plots
4. **Display Current State**: Show key characteristics of current character
5. **Interactive Update Interview**: Ask targeted questions about what to change
6. **Dynamic Question Flow**: Questions adapt based on what user wants to modify
7. **Constitution Compliance Check**: Validate changes against constraints
8. **Apply Changes**: Update specific sections of character file
9. **Final Confirmation**: Review changes before saving
10. **State Machine Update**: Update config.json with update event

## Interview Structure

### Phase 1: Character Identification & Context Loading

#### Step 1: Identify Character

**If `$ARGUMENTS` is provided**:
- Try to match as character ID (format: `character-xxx`)
- If not found, try name matching (fuzzy search)
- Support partial matches

**If `$ARGUMENTS` is empty**:
- Prompt user: "Which character would you like to update?"
- Suggest: "Enter character ID (character-xxx) or name"
- Optionally list recent characters from config.json

#### Step 2: Run Update Script

Execute the character manager script:

```bash
./scripts/bash/character-manager.sh update "$ARGUMENTS"
```

The script should:
- Locate character file in `./world/characters/[character-id]/character.md` (user space, project root)
- Return JSON with:
  - Character ID
  - Character name
  - File path
  - Last modified date
  - Status

#### Step 3: Read Character Profile

Read the full character profile:
- File location: `./world/characters/[character-id]/character.md`
- Parse all sections according to character template
- Extract current values for all fields

#### Step 4: Load Context Information

**Read Novel Constitution** (ALWAYS REQUIRED):
- Read `.novelkit/memory/constitution.md`
- Extract: character constraints, ability limits, worldview rules
- **Purpose**: Check if changes violate constraints

**Read Recent Chapters** (if available):
- Read latest completed chapters from `config.json`
- Check for character mentions and development
- Extract: character's recent actions, growth, changes
- **Purpose**: Understand why update is needed

**Read Related Plots** (if character is plot-involved):
- Read active main plots: `./plots/main/[plot-id]/plot.md`
- Read active side plots: `./plots/side/[plot-id]/plot.md`
- Extract: character's role, plot requirements, story direction
- **Purpose**: Ensure updates align with plot needs

**Read Relationship Network** (if relationships changing):
- Read `./world/relationships/network.md`
- Extract: current relationships, relationship history
- **Purpose**: Ensure relationship changes are consistent

**Read Faction Information** (if faction-related):
- Read `./world/factions/[faction-id]/faction.md`
- Extract: faction status, member changes
- **Purpose**: Ensure faction updates are consistent

#### Step 5: Display Current Character State

Show key information about current character:

```markdown
## Current Character: [NAME]

**ID**: character-001
**Role**: Protagonist
**Status**: Active
**Last Updated**: 2025-01-10

**Key Characteristics**:
- [Current trait 1]
- [Current trait 2]
- [Current trait 3]

**Recent Story Context**:
- [Recent chapter events involving character]
- [Character development notes]
```

### Phase 2: Identify What to Update

#### Step 6: Ask What to Update

**Question 1: What would you like to update?**

Present 6+ options based on character profile structure:

- A) Basic Information (name, age, gender, identity)
- B) Appearance (physical features, clothing)
- C) Personality (traits, values, flaws)
- D) Abilities/Skills (powers, equipment, combat style)
- E) Background (origin, history, secrets)
- F) Relationships (connections, faction, attitude)
- G) Plot Relevance (goals, role, arc direction)
- H) Status Update (active/deceased/missing)
- I) Multiple areas (comprehensive update)
- Custom: [User input]

**Question 2: Specific Focus Area** (if user chose A-H above)

Present 6+ sub-options based on the selected area. For example, if user chose "Abilities/Skills":

- A) Add new ability
- B) Upgrade existing ability
- C) Change combat style
- D) Update equipment/weapons
- E) Modify skill level
- F) Remove/nerf ability
- Custom: [User input]

Allow multiple selections if user wants to update several things.

### Phase 3: Basic Information Updates (if selected)

#### Step 7: Update Basic Information

**Question 3: What basic information to change?**

Present options with current values:

- A) Name (Current: [Name])
- B) Age (Current: [Age])
- C) Gender (Current: [Gender])
- D) Identity/Occupation (Current: [Identity])
- E) Faction (Current: [Faction])
- F) Residence (Current: [Residence])
- Custom: [User input]

**For each selected field, ask update question:**

**If updating Name**:
- Show current name
- Ask: "What should the new name be?"
- Check for duplicates
- Confirm: "Change name from [Old] to [New]? (Yes/No)"

**If updating Age**:
- Show current age
- Present 6+ options:
  - A) Keep current: [Current age]
  - B) [Age option 1]
  - C) [Age option 2]
  - D) [Age option 3]
  - E) [Age option 4]
  - F) [Age option 5]
  - Custom: [User input]
- Ask for justification: "Why is the age changing? (plot event, time passage, correction)"

### Phase 4: Appearance Updates (if selected)

#### Step 8: Update Appearance

**Question 4: What appearance aspect to change?**

Present options with current values:

- A) Body Type (Current: [Body Type])
- B) Facial Features (Current: [Features])
- C) Hair/Eyes (Current: [Hair/Eyes])
- D) Clothing Style (Current: [Clothing])
- E) Distinguishing Marks (Current: [Marks])
- F) Aura/Presence (Current: [Aura])
- Custom: [User input]

**For each selected field, ask update question with current value shown.**

**Follow-up**: Ask for justification if appearance change is significant (e.g., "Did they undergo transformation? Was there an injury?")

### Phase 5: Personality Updates (if selected)

#### Step 9: Update Personality

**Question 5: What personality aspect to change?**

Present options with current values:

- A) Core Personality (Current: [Trait])
- B) Strengths (Current: [Strengths])
- C) Weaknesses (Current: [Weaknesses])
- D) Values (Current: [Values])
- E) Fears (Current: [Fears])
- F) Desires/Goals (Current: [Desires])
- G) Speaking Style (Current: [Style])
- Custom: [User input]

**For each selected field, ask update question.**

**Important**: For personality changes, always ask:
- **Justification**: "What plot event or character development triggered this change?"
- **Consistency Check**: "Does this align with previous character behavior?"

### Phase 6: Abilities & Skills Updates (if selected)

#### Step 10: Update Abilities

**Question 6: What ability aspect to change?**

Present options with current values:

- A) Core Ability (Current: [Ability])
- B) Add New Skill (Current skills: [List])
- C) Upgrade Existing Skill (Current: [Skill])
- D) Equipment/Weapons (Current: [Equipment])
- E) Combat Style (Current: [Style])
- F) Skill Level (Current: [Level])
- Custom: [User input]

**For each selected field, ask update question.**

**Constitution Check Required**:
- If adding/upgrading abilities, check against constitution limits
- If power level increases, verify it doesn't exceed constraints
- Warn if violation detected

**Justification Required**:
- Ask: "How did they gain this new ability? (training, plot event, awakening)"
- Ask: "What plot event triggered this power-up?"

### Phase 7: Background Updates (if selected)

#### Step 11: Update Background

**Question 7: What background aspect to change?**

Present options with current values:

- A) Origin (Current: [Origin])
- B) Key Life Events (Current: [Events])
- C) Secrets (Current: [Secrets])
- D) Add New Secret
- E) Reveal Existing Secret
- F) Update History
- Custom: [User input]

**For each selected field, ask update question.**

**Important**: For background changes, ask:
- **Justification**: "Why is this background information changing? (new revelation, correction, plot development)"
- **Consistency Check**: "Does this align with established world history?"

### Phase 8: Relationship Updates (if selected)

#### Step 12: Update Relationships

**Question 8: What relationship aspect to change?**

Present options:

- A) Add New Relationship
- B) Update Existing Relationship
- C) Remove Relationship
- D) Change Faction Affiliation (Current: [Faction])
- E) Update Attitude Toward Others (Current: [Attitude])
- F) Update Reputation (Current: [Reputation])
- Custom: [User input]

**If adding/updating relationship**:
- Ask: "Which character?"
- Present list of existing characters
- Ask: "What is the relationship type?" (ally, enemy, family, mentor, etc.)
- Ask: "What is the relationship strength?" (close, distant, etc.)
- Ask: "What is the relationship history?"

**If changing faction**:
- Present available factions
- Ask: "Why is faction changing?" (betrayal, recruitment, plot event)
- Check faction consistency

### Phase 9: Plot Relevance Updates (if selected)

#### Step 13: Update Plot Relevance

**Question 9: What plot aspect to change?**

Present options with current values:

- A) Role Type (Current: [Role])
- B) Main Goal (Current: [Goal])
- C) Side Quests (Current: [Quests])
- D) Current State (Current: [State])
- E) Character Arc Direction (Current: [Arc])
- F) Foreshadowing (Current: [Foreshadowing])
- Custom: [User input]

**For each selected field, ask update question.**

**Context Check**:
- Verify changes align with active plots
- Check if role change affects plot structure
- Ensure goals are consistent with story direction

### Phase 10: Status Updates (if selected)

#### Step 14: Update Character Status

**Question 10: What status change?**

Present options with current status highlighted:

- A) Active → Deceased
- B) Active → Missing
- C) Active → Inactive
- D) Missing → Active (return)
- E) Deceased → Active (resurrection - check world rules)
- F) Other status change
- Custom: [User input]

**For status changes, always ask**:

**If Deceased**:
- "How did they die?"
- "When did this happen? (chapter/event)"
- "Is this permanent or temporary?"
- "What impact does this have on the story?"

**If Missing**:
- "Why are they missing?"
- "When did they disappear?"
- "Will they return?"

**If Returning**:
- "How did they return?"
- "What changed during their absence?"

### Phase 11: Constitution Compliance Check

#### Step 15: Validate Changes

**Check All Constitution Rules**:

1. **Character Type Compliance**:
   - Do changes maintain allowed character type?
   - Are changes consistent with world rules?

2. **Ability/Power Level Compliance**:
   - Do ability changes exceed constitution limits?
   - Are new abilities consistent with world rules?
   - **Action**: If violation, warn and suggest adjustments

3. **Naming Compliance** (if name changed):
   - Does new name match constitution requirements?
   - **Action**: If violation, suggest alternatives

4. **Background Compliance** (if background changed):
   - Do background changes fit world history?
   - **Action**: If violation, suggest adjustments

5. **Role Compliance** (if role changed):
   - Does new role fit story needs?
   - **Action**: If concern, warn user

6. **Faction Compliance** (if faction changed):
   - Does new faction affiliation make sense?
   - **Action**: If issue, suggest alternatives

**Report Violations**:
- List all violations found
- Suggest specific corrections
- Allow user to:
  - Accept suggestions and modify
  - Override with explicit confirmation (log violation in Notes)
  - Cancel update

### Phase 12: Review & Confirmation

#### Step 16: Display Change Summary

Show side-by-side comparison of all changes:

```markdown
## Update Summary

### Changes to be made:

**Before** → **After**

1. **Name**: [Old Name] → [New Name]
2. **Status**: [Old Status] → [New Status]
3. **Ability**: [Old Ability] → [New Ability]
4. **Goal**: [Old Goal] → [New Goal]

**Justifications**:
- [Justification 1]
- [Justification 2]

**Constitution Compliance**: ✅ All checks passed
(Or: ⚠️ Warnings - see below)

**Confirm these changes?** (Yes/No/Modify more)
```

**Question 11: Review and Confirm**

Present options:
- A) Confirm and save (proceed with all changes)
- B) Modify specific changes (return to relevant questions)
- C) Cancel update (discard all changes)
- D) Save partial changes (save some, skip others)

### Phase 13: Apply Changes & State Update

#### Step 17: Apply Changes to File

For each confirmed change:

1. **Use `replace_in_file` or `search_replace`** to update specific sections:
   - Update relevant section in character file
   - Preserve formatting and structure
   - Update only changed fields

2. **Update Metadata**:
   - Update `**最后更新**：[Current Date]` field
   - Update `**状态**：[New Status]` if status changed

3. **Add Change Log to Notes**:
   - Add entry to `**备注**` section:
     ```markdown
     **更新记录**：
     - [Date]: [Change description] - [Justification]
     - [Date]: [Change description] - [Justification]
     ```

4. **Handle Constitution Violations** (if any overridden):
   - Add note in `**备注**` section:
     ```markdown
     **宪法合规性**：
     - ⚠️ [Violation description] - 用户确认覆盖
     ```

#### Step 18: Update State Machine

After saving changes:

1. **Read** `.novelkit/memory/config.json`
2. **Update** `session.last_action`: "Updated character [character-id] ([Name])"
3. **Update** `session.last_action_time`: [current timestamp]
4. **Update** `session.last_action_command`: "character-update"
5. **Update** `session.last_modified_file`: `./world/characters/[character-id]/character.md`
6. **Update** `session.action_context`: "[Summary of changes made]"
7. **Add to** `history.recent_actions` array (keep last 20):
   ```json
   {
     "action": "updated_character",
     "character_id": "[character-id]",
     "character_name": "[Name]",
     "changes": "[Summary of changes]",
     "timestamp": "[ISO 8601]",
     "command": "character-update"
   }
   ```
8. **Update** `last_updated`: [current timestamp]
9. **Save** updated config.json

## Interview Guidelines

### Question Presentation Format

Each question MUST be presented in this format:

```markdown
## Question [N]: [Question Title]

**Current value**: [Show current setting]

**What would you like to change it to?**

| Option | Choice | Description |
|--------|--------|-------------|
| A | Keep current | [Current value] |
| B | [Option B] | [What this means] |
| C | [Option C] | [What this means] |
| D | [Option D] | [What this means] |
| E | [Option E] | [What this means] |
| F | [Option F] | [What this means] |
| Custom | [Your own] | Enter your custom value |

**Your choice**: _[Wait for user response]_
```

### Dynamic Question Selection

- **Skip unchanged areas**: If user says "keep current", don't ask follow-ups
- **Focus on changes**: Only ask about areas user wants to modify
- **Adaptive depth**: If user wants "comprehensive update", ask more questions
- **Progressive refinement**: Later questions can refine earlier changes
- **Show current values**: Always display current setting before asking for change

### User Response Handling

- **Accept letter choices**: A, B, C, D, E, F (case-insensitive)
- **Accept "keep" or "current"**: Preserve existing value
- **Accept custom input**: Any text input
- **Allow "skip"**: User can skip questions (keep current)
- **Allow "back"**: User can go back to previous questions
- **Allow "done"**: User can finish early if satisfied

### Change Tracking

- Track all changes: field name, old value, new value, justification
- Display change summary before saving
- Allow user to undo specific changes
- Preserve unchanged fields completely

## Output Format

After completing the update:

```markdown
✅ Character updated successfully!

**Character**: character-001 ([Character Name])

**Changes Made**:
- Status: Active → Deceased
- Goal: [Old Goal] → [New Goal]
- Ability: Added [New Ability]
- Relationship: Added relationship with [Character Name]

**Justifications**:
- Status change: Character died in Chapter 15 during final battle
- Goal change: Character's goal evolved after plot event
- Ability: Character awakened new power during training arc
- Relationship: Character met [Character Name] in recent chapter

**Constitution Compliance**: ✅ All checks passed
(Or: ⚠️ Some warnings - see Notes section)

**File**: ./world/characters/character-001/character.md
**Last Updated**: 2025-01-15

Use `/novel.character.show character-001` to view updated profile.
```

## Error Handling

- **Character Not Found**: 
  - Show error: "Character '[ID/Name]' not found."
  - List similar names (fuzzy matching)
  - Suggest creating new character: `/novel.character.new`
  - Suggest listing all characters: `/novel.character.list`

- **File Read Error**: 
  - Show error: "Unable to read character file: [path]"
  - Check file permissions
  - Suggest manual file check

- **Constitution Violation**: 
  - List all violations clearly
  - Suggest specific corrections
  - Allow user to:
    - Accept suggestions (modify changes)
    - Override with confirmation (log in Notes)
    - Cancel update

- **Inconsistent Changes**: 
  - If changes conflict with recent chapters, warn user
  - Show conflict details
  - Ask for confirmation or suggest adjustments

- **Missing Context**: 
  - If constitution missing: Warn but allow update (suggest creating constitution)
  - If recent chapters missing: Proceed with basic validation

## Important Notes

- **Minimum 6 options**: Every question must have at least 6 options (A-F) plus Custom
- **Show current values**: Always display current setting before asking for change
- **Justification required**: Always ask why changes are being made (for consistency)
- **Constitution first**: Always check constitution compliance before saving
- **Change logging**: Log all changes in Notes section with dates and justifications
- **Preserve unchanged**: Only modify fields user explicitly changes
- **User control**: User can skip, go back, or cancel at any time
- **Change confirmation**: Always show summary of changes before saving
