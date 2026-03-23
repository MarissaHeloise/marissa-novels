---
name: "novel-faction-relationships"
description: "$ARGUMENTS Invoke when user wants to use novel.faction.relationships command."
---

# Novel Faction Relationships



## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). Support both faction ID (faction-xxx) and name matching, or "all" for world overview.

## Process Overview

This command maps out the political landscape for a specific faction or the entire world, and allows updating diplomatic relationships through an interactive process.

### Process Steps

1. **Identify Target**: Parse ID/name from `$ARGUMENTS` or use "all" for world overview
2. **Load Faction Profiles**: Read relevant faction files
3. **View Relationships**: Display current diplomatic relationships
4. **Interactive Update**: Allow user to change relationship status
5. **Consistency Check**: Verify relationships don't conflict
6. **Apply Changes**: Update faction profiles
7. **State Machine Update**: Update config.json

## View Relationships

### Step 1: Determine Scope

**If specific faction ID provided**:
- Show that faction's specific relations
- Display: Allies, Enemies, Rivals, Subjects, Overlords, Neutral

**If "all" or empty**:
- Show high-level summary of all faction relationships
- Display relationship matrix or network

### Step 2: Display Relationships

Format relationships:
- **Target Faction**: [Name]
- **Allies**: [List with relationship strength]
- **Enemies**: [List with conflict level]
- **Rivals**: [List with competition type]
- **Neutral**: [List]
- **Subjects/Overlords**: [List with hierarchy]

## Interactive Relationship Update

**The update is fully dynamic - you decide the questions, order, and depth based on context.**

### Interview Principles

1. **Question Format** (MANDATORY):
   - Each question must provide **at least 6 options** (A-F) plus Custom
   - Options must be **mutually exclusive and non-repetitive**
   - Clearly state: "You can also enter your own custom input if none of the options fit"
   - Show current relationship status before asking for change

2. **Dynamic Flow**:
   - Each round: AI decides whether to continue based on confirmed information
   - Questions adapt based on previous answers
   - Follow-up questions only when needed

3. **Information Confirmation**:
   - All changes must be marked as **"confirmed"** or **"unconfirmed"**
   - For unconfirmed changes, AI must continue asking or provide more options

4. **Completeness Threshold**:
   - Before final save, verify all changes are confirmed
   - If information is insufficient, actively point out missing items
   - Do NOT proceed to save until all changes are confirmed

### Update Process

#### Step 1: Select Target Faction

Present 6+ options:
- A) [Faction 1]
- B) [Faction 2]
- C) [Faction 3]
- D) [Faction 4]
- E) [Faction 5]
- F) [Faction 6]
- Custom: Enter faction ID or name

#### Step 2: Select Counter-Party Faction

Present 6+ options:
- A) [Faction 1]
- B) [Faction 2]
- C) [Faction 3]
- D) [Faction 4]
- E) [Faction 5]
- F) [Faction 6]
- Custom: Enter faction ID or name

#### Step 3: Select New Relationship Status

Present 6+ options (show current status):
- A) Ally (military/political alliance)
- B) Friendly (cooperation, trade)
- C) Neutral (no significant relationship)
- D) Hostile (tensions, conflicts)
- E) At War (active conflict)
- F) Rival (competition, but not necessarily hostile)
- Custom: [User input]

#### Step 4: Define Terms (with 6+ options)

Ask about relationship details:
- A) Military alliance
- B) Trade agreement
- C) Non-aggression pact
- D) Mutual defense
- E) Economic cooperation
- F) Other
- Custom: [User input]

#### Step 5: Reason for Change (with 6+ options)

Ask why relationship is changing:
- A) Recent event (battle, treaty, etc.)
- B) Strategic shift
- C) Leadership change
- D) Resource conflict
- E) Ideological difference
- F) Other
- Custom: [User input]

#### Step 6: Confirm

Show summary:
- Current relationship: [Old Status]
- New relationship: [New Status]
- Terms: [Details]
- Reason: [Justification]

Ask for confirmation before applying.

## Consistency Check

Before saving, check:

1. **Conflict Check**:
   - Does new relationship contradict existing treaties?
   - Example: Allying with an enemy's enemy might be fine
   - Example: Allying with an enemy's ally might be complex
   - Warn user if conflicts detected

2. **Reciprocity Check**:
   - Automatically update counter-party's file to reflect the change
   - Example: If A declares war on B, B is now at war with A
   - Ensure both sides are updated consistently

3. **Logical Consistency**:
   - Verify relationship makes sense given world state
   - Check if change aligns with recent events

If conflicts found: Warn user, explain conflicts, ask for confirmation or suggest alternatives.

## Apply Changes

For each confirmed change:

1. **Update Source Faction**:
   - Update relationship list in faction profile
   - Add relationship entry with status, terms, date

2. **Update Counter-Party Faction**:
   - Automatically update reciprocal relationship
   - Ensure consistency

3. **Update Relationship Network** (if applicable):
   - Update `./world/relationships/network.md` if faction relationships are tracked there

4. **Add Change Log**:
   - Add entry to Notes section with date, change description, and justification

## State Machine Update

After saving changes:

1. Read `.novelkit/memory/config.json`
2. Update `session.last_action`: "Updated faction relationships [faction-id] ([Name])"
3. Update `session.last_action_time`: [current timestamp]
4. Update `session.last_action_command`: "faction-relationships"
5. Update `session.last_modified_file`: `./world/factions/[faction-id]/faction.md`
6. Update `session.action_context`: "[Summary of changes made]"
7. Add to `history.recent_actions` array (keep last 20)
8. Update `last_updated`: [current timestamp]
9. Save updated config.json

## Important Notes

- **Dynamic interview**: Questions, order, and depth are determined by AI based on context
- **Minimum 6 options**: Every question must have at least 6 options (A-F) plus Custom
- **Show current status**: Always display current relationship before asking for change
- **Reciprocity**: Automatically update both factions for consistency
- **Consistency check**: Verify relationships don't conflict before saving
- **Information confirmation**: All changes must be confirmed before saving
- **User control**: User can skip, go back, or cancel at any time

