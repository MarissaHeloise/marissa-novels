---
name: "novel-constitution-update"
description: "$ARGUMENTS Invoke when user wants to use novel.constitution.update command."
---

# Novel Constitution Update



## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Interactive Update Process

This command uses an **interactive Q&A interview** approach to update the constitution. The process is **dynamic and adaptive**, focusing only on sections that need changes.

### Process Overview

1. **Load Current Constitution**: Read existing `.novelkit/memory/constitution.md`
2. **Display Current State**: Show key sections of current constitution
3. **Identify What to Change**: Ask which sections need updating
4. **Interactive Update Interview**: Ask targeted questions about changes
5. **Dynamic Question Flow**: Questions adapt based on what user wants to modify
6. **Impact Assessment**: Assess impact of changes on existing content
7. **Apply Changes**: Update the constitution with new values
8. **Update History**: Record changes in modification history
9. **Final Confirmation**: Review changes before saving
10. **Save Updated Constitution**: Write back to `.novelkit/memory/constitution.md`

## Interview Structure

### Phase 1: Identify What to Change

**Question 1: Which section would you like to update?**
Present 6+ options:
- A) Story Synopsis (theme, genre, conflict, direction, values)
- B) Narrative Perspective (POV type, restrictions)
- C) Target Audience (age, reading level, content rating)
- D) Tone & Style (tone, realism, language)
- E) Worldview Constraints (world type, rules, restrictions)
- F) Multiple sections (comprehensive update)
- Custom: [User input]

**Question 2: Specific Aspect to Update** (if user chose A-E above)
- Present 6+ sub-options based on the selected section
- Allow multiple selections
- Allow custom focus

### Phase 2: Story Synopsis Updates (if selected)

**Question 3: Core Theme** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) Growth and self-discovery
- C) Love and relationships
- D) Power and ambition
- E) Good vs Evil
- F) Other: [User input]

**Question 4: Story Genre** (if relevant)
Present 6+ options with current value highlighted:
- A) Keep current: [Current value]
- B) Fantasy
- C) Science Fiction
- D) Historical
- E) Modern/Contemporary
- F) Other: [User input]

[Continue with other Story Synopsis aspects...]

### Phase 3: Narrative Perspective Updates (if selected)

**Question 5: Point of View Type** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) First Person
- C) Third Person Limited
- D) Third Person Omniscient
- E) Multiple POV
- F) Other: [User input]

[Continue with POV-related questions...]

### Phase 4: Target Audience Updates (if selected)

**Question 6: Age Group** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) Children (8-12)
- C) Young Adult (13-18)
- D) Adult (18+)
- E) All ages
- F) Other: [User input]

**Question 7: Content Rating - Violence** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) None
- C) Mild
- D) Moderate
- E) Heavy
- F) Other: [User input]

[Continue with other audience aspects...]

### Phase 5: Tone & Style Updates (if selected)

**Question 8: Overall Tone** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) Serious and dramatic
- C) Light and humorous
- D) Dark and gritty
- E) Warm and optimistic
- F) Other: [User input]

[Continue with tone/style questions...]

### Phase 6: Worldview Updates (if selected)

**Question 9: World Type** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) Ancient/Historical
- C) Modern/Contemporary
- D) Future/Sci-Fi
- E) Alternate world
- F) Other: [User input]

[Continue with worldview questions...]

### Phase 7: Character Constraints Updates (if selected)

**Question 10: Character Types** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) Only humans
- C) Humans + fantasy races
- D) Any sentient beings
- E) Specific types
- F) Other: [User input]

[Continue with character constraint questions...]

### Phase 8: Plot Constraints Updates (if selected)

**Question 11: Plot Types** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) All plot types
- C) Adventure/action focused
- D) Character-driven only
- E) Mystery/investigation
- F) Other: [User input]

[Continue with plot constraint questions...]

### Phase 9: Time & Space Updates (if selected)

**Question 12: Time Span** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) Days/weeks
- C) Months
- D) Years
- E) Decades
- F) Other: [User input]

[Continue with time/space questions...]

### Phase 10: Impact Assessment

**Question 13: Assess Impact of Changes**
- List all changes made
- Identify potentially affected content:
  - Characters that may need updates
  - Plots that may need adjustment
  - Existing chapters that may violate new rules
- Ask: "Do you want to review affected content? (Yes/No)"

### Phase 11: Review & Confirmation

**Question 14: Review Changes**
- Display side-by-side comparison:
  - **Before**: [Current value]
  - **After**: [New value]
- Show all changes made
- Show impact assessment
- Ask: "Confirm these changes? (Yes/No/Modify more)"
- If Modify: Return to relevant questions
- If Yes: Save updates and record in history

## Interview Guidelines

### Dynamic Question Selection

- **Skip unchanged areas**: If user says "keep current", don't ask follow-ups
- **Focus on changes**: Only ask about sections user wants to modify
- **Adaptive depth**: If user wants "comprehensive update", ask more questions
- **Progressive refinement**: Later questions can refine earlier changes

### Question Presentation Format

Each question MUST be presented in this format:

```markdown
## Question [N]: [Question Title]

**Current value**: [Show current setting from constitution]

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

### User Response Handling

- **Accept letter choices**: A, B, C, D, E, F (case-insensitive)
- **Accept "keep" or "current"**: Preserve existing value
- **Accept custom input**: Any text input
- **Allow "skip"**: User can skip questions (keep current)
- **Allow "back"**: User can go back to previous questions
- **Allow "done"**: User can finish early if satisfied

### Change Tracking

- Track all changes: section name, field name, old value, new value
- Display change summary before saving
- Record in modification history table
- Update version number if major changes
- Preserve unchanged sections completely

### Impact Assessment

Before saving, assess impact:
- Which characters may be affected?
- Which plots may need adjustment?
- Which chapters may violate new rules?
- Provide recommendations for updates

## Output Format

After completing the update interview:

```markdown
✅ Novel constitution updated successfully!

**Constitution Version**: 1.1 (updated from 1.0)
**Last Updated**: 2025-01-15

**Changes Made**:
- Story Type: Fantasy → Urban Fantasy
- POV: Third Person Limited → Multiple POV
- Target Audience: Adult → Young Adult
- Content Rating - Violence: Moderate → Mild

**Impact Assessment**:
- 3 characters may need updates
- 2 plots may need adjustment
- 5 chapters may need review

**File**: .novelkit/memory/constitution.md

Use `/novel.constitution.check` to verify compliance.
Use `/novel.constitution.show` to view updated constitution.
```

## Important Notes

- **Minimum 6 options**: Every question must have at least 6 options (A-F) plus Custom
- **Dynamic flow**: Questions adapt based on what user wants to change
- **Preserve unchanged**: Only modify sections user explicitly changes
- **Show current values**: Always display current setting before asking for change
- **Impact assessment**: Always assess impact on existing content
- **User control**: User can skip, go back, or finish early
- **Change confirmation**: Always show summary of changes before saving
- **History tracking**: All changes recorded in modification history


