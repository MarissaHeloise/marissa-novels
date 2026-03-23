---
name: "novel-plot-foreshadow-track"
description: "$ARGUMENTS Invoke when user wants to use novel.plot.foreshadow.track command."
---

# Novel Plot Foreshadow Track



## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). Support both foreshadowing ID (foreshadow-xxx) and name matching.

## Process Overview

This command uses an **interactive Q&A interview** approach to update foreshadowing status. The process is **dynamic and adaptive**.

### Process Steps

1. **Identify Foreshadowing**: Parse ID/name from `$ARGUMENTS` or prompt user
2. **Load Foreshadowing Profile**: Read existing foreshadowing file
3. **Load Context**: Read related plots, recent chapters
4. **Display Current State**: Show current foreshadowing status
5. **Interactive Update Interview**: Ask targeted questions about status change
6. **Dynamic Question Flow**: Questions adapt based on update type
7. **Apply Changes**: Update foreshadowing file
8. **State Machine Update**: Update config.json

## Dynamic Update Interview

**The interview is fully dynamic - you decide the questions, order, and depth based on what needs to be changed.**

### Interview Principles

1. **Question Format** (MANDATORY):
   - Each question must provide **at least 6 options** (A-F) plus Custom
   - Options must be **mutually exclusive and non-repetitive**
   - Clearly state: "You can also enter your own custom input if none of the options fit"
   - Show current status before asking for change

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

### Update Types (Dynamic Selection)

Based on context, dynamically select questions from:

1. **Reveal**: The hint has been explained/used
   - Ask: In which chapter? How was it revealed?
   - Ask: What was the revelation? (with 6+ options)
   - Ask: Was it effective? (with 6+ options)

2. **Abandon**: The plot changed, this hint is now a red herring or error
   - Ask: Should it be retconned or left as a mystery? (with 6+ options)
   - Ask: What plot change caused this? (with 6+ options)

3. **Modify**: Update the foreshadowing content or target
   - Ask: What needs to be modified? (with 6+ options)
   - Ask: Why is this change needed? (with 6+ options)

**For each selected update type**:
- Ask what to change (with 6+ options)
- Ask for the **cause/justification** of the change
- Confirm the change

## Change Application

For each confirmed change:

1. **Use `replace_in_file` or `search_replace`** to update specific sections
2. **Update Status**: Update status field (Planted/Revealed/Abandoned)
3. **Update Metadata**: Update `**最后更新**：[Current Date]` field
4. **Add Change Log**: Add entry to Notes section with date, change description, and justification

## State Machine Update

After saving changes:

1. Read `.novelkit/memory/config.json`
2. Update `session.last_action`: "Updated foreshadowing [foreshadow-id] ([Name])"
3. Update `session.last_action_time`: [current timestamp]
4. Update `session.last_action_command`: "plot-foreshadow-track"
5. Update `session.last_modified_file`: `./plots/foreshadowing/[foreshadow-id]/foreshadow.md`
6. Update `session.action_context`: "[Summary of changes made]"
7. Add to `history.recent_actions` array (keep last 20)
8. Update `last_updated`: [current timestamp]
9. Save updated config.json

## Important Notes

- **Dynamic interview**: Questions, order, and depth are determined by AI based on what needs to be changed
- **Minimum 6 options**: Every question must have at least 6 options (A-F) plus Custom
- **Show current status**: Always display current status before asking for change
- **Justification required**: Always ask why changes are being made
- **Information confirmation**: All changes must be confirmed before saving
- **User control**: User can skip, go back, or cancel at any time

