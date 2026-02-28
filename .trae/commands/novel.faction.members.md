

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). Support both faction ID (faction-xxx) and name matching.

## Process Overview

This command lists the characters associated with a faction and allows for adding/removing members through an interactive process.

### Process Steps

1. **Identify Faction**: Parse ID/name from `$ARGUMENTS` or prompt user
2. **Load Faction Profile**: Read existing faction file
3. **View Members**: Display current members with their roles
4. **Interactive Management**: Offer options to add/remove/promote members
5. **Apply Changes**: Update character and faction profiles
6. **State Machine Update**: Update config.json

## View Members

### Step 1: Retrieve Member List

**Search for members**:
- Find all character files where `Affiliation` or `Faction` matches the target faction
- Read character profiles: `./world/characters/[character-id]/character.md`
- Extract: character name, ID, role within faction

### Step 2: Display Member List

Format and display:
- **Member Name** (with link to character profile)
- **Role in Faction** (Leader, Member, Traitor, etc.)
- **Join Date** (if available)
- **Status** (Active, Inactive, Expelled, etc.)

## Interactive Member Management

**The management is fully dynamic - you decide the questions, order, and depth based on context.**

### Interview Principles

1. **Question Format** (MANDATORY):
   - Each question must provide **at least 6 options** (A-F) plus Custom
   - Options must be **mutually exclusive and non-repetitive**
   - Clearly state: "You can also enter your own custom input if none of the options fit"

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

### Management Options

Present 6+ options:
- A) Add New Member
- B) Remove Member
- C) Promote Member (change rank/role)
- D) Demote Member (change rank/role)
- E) Update Member Status
- F) View Member Details
- Custom: [User input]

**For each selected option**:

#### Add New Member

1. **Select Character** (with 6+ options):
   - Present list of existing characters not in faction
   - Options: A) [Character 1], B) [Character 2], C) [Character 3], D) [Character 4], E) [Character 5], F) [Character 6]
   - Custom: Enter character ID or name

2. **Assign Role** (with 6+ options):
   - A) Leader
   - B) High-ranking Member
   - C) Regular Member
   - D) Initiate/Recruit
   - E) Advisor
   - F) Other
   - Custom: [User input]

3. **Join Reason** (with 6+ options):
   - A) Recruited
   - B) Joined voluntarily
   - C) Inherited position
   - D) Forced/Coerced
   - E) Strategic alliance
   - F) Other
   - Custom: [User input]

4. **Confirm**: Show summary, ask for confirmation

#### Remove Member

1. **Select Member** (with 6+ options):
   - Present list of current members
   - Options: A) [Member 1], B) [Member 2], C) [Member 3], D) [Member 4], E) [Member 5], F) [Member 6]
   - Custom: Enter character ID or name

2. **Removal Reason** (with 6+ options):
   - A) Expelled
   - B) Resigned
   - C) Defected
   - D) Died
   - E) Betrayed faction
   - F) Other
   - Custom: [User input]

3. **Confirm**: Show summary, ask for confirmation

#### Promote/Demote Member

1. **Select Member** (with 6+ options):
   - Present list of current members
   - Options: A) [Member 1], B) [Member 2], C) [Member 3], D) [Member 4], E) [Member 5], F) [Member 6]
   - Custom: Enter character ID or name

2. **New Role** (with 6+ options):
   - Present appropriate roles based on current role
   - Options: A) [Role 1], B) [Role 2], C) [Role 3], D) [Role 4], E) [Role 5], F) [Role 6]
   - Custom: [User input]

3. **Reason** (with 6+ options):
   - A) Merit/Achievement
   - B) Loyalty proven
   - C) Strategic need
   - D) Punishment
   - E) Political reason
   - F) Other
   - Custom: [User input]

4. **Confirm**: Show summary, ask for confirmation

## Apply Changes

For each confirmed change:

1. **Update Character Profile**:
   - For Add: Update character's `Affiliation` or `Faction` field
   - For Remove: Clear character's `Affiliation` field
   - For Promote/Demote: Update character's role in faction

2. **Update Faction Profile**:
   - Update member list (if tracked explicitly)
   - Update member roles
   - Add change log to Notes section

3. **Update Relationship Network** (if applicable):
   - Update `./world/relationships/network.md` if relationships change

## State Machine Update

After saving changes:

1. Read `.novelkit/memory/config.json`
2. Update `session.last_action`: "Updated faction members [faction-id] ([Name])"
3. Update `session.last_action_time`: [current timestamp]
4. Update `session.last_action_command`: "faction-members"
5. Update `session.last_modified_file`: `./world/factions/[faction-id]/faction.md`
6. Update `session.action_context`: "[Summary of changes made]"
7. Add to `history.recent_actions` array (keep last 20)
8. Update `last_updated`: [current timestamp]
9. Save updated config.json

## Important Notes

- **Dynamic interview**: Questions, order, and depth are determined by AI based on context
- **Minimum 6 options**: Every question must have at least 6 options (A-F) plus Custom
- **Information confirmation**: All changes must be confirmed before saving
- **Completeness check**: Verify all necessary information before applying changes
- **User control**: User can skip, go back, or cancel at any time
