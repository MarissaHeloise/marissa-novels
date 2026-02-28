

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). Support both plot ID (side-plot-xxx) and title matching.

## Process Overview

This command uses an **interactive Q&A interview** approach to update an existing side plot profile. The process is **dynamic and adaptive**, focusing only on areas that need changes.

### Process Steps

1. **Identify Plot**: Parse ID/title from `$ARGUMENTS` or prompt user
2. **Load Plot Profile**: Read existing plot file
3. **Load Context**: Read constitution, recent chapters, related main plots
4. **Display Current State**: Show key characteristics of current plot
5. **Interactive Update Interview**: Ask targeted questions about what to change
6. **Dynamic Question Flow**: Questions adapt based on what user wants to modify
7. **Constitution Compliance Check**: Validate changes against constraints
8. **Apply Changes**: Update specific sections of plot file
9. **Final Confirmation**: Review changes before saving
10. **State Machine Update**: Update config.json with update event

## Dynamic Update Interview

**The interview is fully dynamic - you decide the questions, order, and depth based on what needs to be changed.**

### Interview Principles

1. **Question Format** (MANDATORY):
   - Each question must provide **at least 6 options** (A-F) plus Custom
   - Options must be **mutually exclusive and non-repetitive**
   - Clearly state: "You can also enter your own custom input if none of the options fit"
   - Show current value before asking for change

2. **Dynamic Flow**:
   - Each round: AI decides whether to continue based on confirmed information
   - Questions adapt based on previous answers
   - Follow-up questions only when needed
   - Allow user to skip, go back, or review progress

3. **Information Confirmation**:
   - All changes must be marked as **"confirmed"** or **"unconfirmed"**
   - For unconfirmed changes, AI must continue asking or provide more options
   - Track confirmation status for each field

4. **Completeness Threshold**:
   - Before final save, verify all changes are confirmed
   - If information is insufficient, actively point out missing items
   - Do NOT proceed to save until all changes are confirmed

5. **Interaction Control**:
   - AI designs question order, breaks down questions, merges answers
   - User only needs to answer

### Update Types (Dynamic Selection)

Based on context and user needs, dynamically select questions from:

1. **Status Change**: Plan -> Active -> Completed/Abandoned
2. **Development**: Advance the sub-plot
3. **Merge**: Connect to main plot
4. **Character Update**: Change involved characters
5. **Connection Update**: Update relationship to main plot
6. **Resolution**: Update resolution approach
7. **Custom**: Freeform edit

**For each selected update type**:
- Ask what to change (with 6+ options)
- Ask for the **cause/justification** of the change (to maintain narrative logic)
- Confirm the change

## Constitution Compliance Check

Before saving, check:
- Do changes maintain allowed plot type?
- Is connection to main plot still logical?
- Are themes still consistent?

If violations found: Warn user, suggest corrections, allow override with confirmation (log in Notes).

## Change Application

For each confirmed change:

1. **Use `replace_in_file` or `search_replace`** to update specific sections
2. **Update Metadata**: Update `**最后更新**：[Current Date]` field
3. **Add Change Log**: Add entry to Notes section with date, change description, and justification

## State Machine Update

After saving changes:

1. Read `.novelkit/memory/config.json`
2. Update `session.last_action`: "Updated side plot [plot-id] ([Title])"
3. Update `session.last_action_time`: [current timestamp]
4. Update `session.last_action_command`: "plot-side-update"
5. Update `session.last_modified_file`: `./plots/side/[plot-id]/plot.md`
6. Update `session.action_context`: "[Summary of changes made]"
7. Add to `history.recent_actions` array (keep last 20)
8. Update `last_updated`: [current timestamp]
9. Save updated config.json

## Important Notes

- **Dynamic interview**: Questions, order, and depth are determined by AI based on what needs to be changed
- **Minimum 6 options**: Every question must have at least 6 options (A-F) plus Custom
- **Show current values**: Always display current setting before asking for change
- **Justification required**: Always ask why changes are being made
- **Information confirmation**: All changes must be confirmed before saving
- **Constitution first**: Always check constitution compliance before saving
- **User control**: User can skip, go back, or cancel at any time
