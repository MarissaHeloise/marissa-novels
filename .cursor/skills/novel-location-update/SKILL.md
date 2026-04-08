---
name: "novel-location-update"
description: "$ARGUMENTS Invoke when user wants to use novel.location.update command."
---

# Novel Location Update



## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). Support both location ID (location-xxx) and name matching.

## Process Overview

This command uses an **interactive Q&A interview** approach to update an existing location profile. The process is **dynamic and adaptive**, focusing only on areas that need changes.

### Process Steps

1. **Identify Location**: Parse ID/name from `$ARGUMENTS` or prompt user
2. **Load Location Profile**: Read existing location file
3. **Load Context**: Read constitution, recent events, related plots
4. **Display Current State**: Show key characteristics of current location
5. **Interactive Update Interview**: Ask targeted questions about what to change
6. **Dynamic Question Flow**: Questions adapt based on what user wants to modify
7. **Constitution Compliance Check**: Validate changes against constraints
8. **Apply Changes**: Update specific sections of location file
9. **Final Confirmation**: Review changes before saving
10. **State Machine Update**: Update config.json with update event

## Context Loading

### Required Context

1. **Location Profile** (REQUIRED):
   - Read `./world/locations/[location-id]/location.md` (user space, project root)
   - Extract all current values

2. **Novel Constitution** (ALWAYS REQUIRED):
   - Read `.novelkit/memory/constitution.md`
   - Extract: worldview constraints, geography rules

3. **Recent Events** (If available):
   - Read latest completed chapters from `config.json`
   - Check for location mentions and developments

4. **Related Plots** (If relevant):
   - Read active main plots: `./plots/main/[plot-id]/plot.md`
   - Read active side plots: `./plots/side/[plot-id]/plot.md`

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

1. **Status Change**: Destruction, occupation, renovation, abandonment
2. **Political Shift**: New ruler, new laws, rebellion, regime change
3. **Economy**: Boom, bust, new resource discovery, trade route changes
4. **Discovery**: Uncovering hidden areas or ruins, new features
5. **Event Log**: Battle occurred here, important meeting, disaster, etc.
6. **Geography**: Terrain changes, climate shifts, geographic modifications
7. **Custom**: Freeform edit

**For each selected update type**:
- Ask what to change (with 6+ options)
- Ask for the **cause/justification** of the change (to maintain narrative logic)
- Confirm the change

## Constitution Compliance Check

Before saving, check:
- Do changes maintain allowed location type?
- Are geographic changes consistent with world rules?
- Are new features consistent with world rules (magic level, technology, etc.)?

If violations found: Warn user, suggest corrections, allow override with confirmation (log in Notes).

## Change Application

For each confirmed change:

1. **Use `replace_in_file` or `search_replace`** to update specific sections
2. **Update Metadata**: Update `**最后更新**：[Current Date]` field
3. **Add Change Log**: Add entry to Notes section with date, change description, and justification

## State Machine Update

After saving changes:

1. Read `.novelkit/memory/config.json`
2. Update `session.last_action`: "Updated location [location-id] ([Name])"
3. Update `session.last_action_time`: [current timestamp]
4. Update `session.last_action_command`: "location-update"
5. Update `session.last_modified_file`: `./world/locations/[location-id]/location.md`
6. Update `session.action_context`: "[Summary of changes made]"
7. Add to `history.recent_actions` array (keep last 20):
   ```json
   {
     "action": "updated_location",
     "location_id": "[location-id]",
     "location_name": "[Name]",
     "changes": "[Summary of changes]",
     "timestamp": "[ISO 8601]",
     "command": "location-update"
   }
   ```
8. Update `last_updated`: [current timestamp]
9. Save updated config.json

## Output Format

After completion:

```markdown
✅ Location updated successfully!

**Location**: location-001 ([Location Name])

**Changes Made**:
- Status: Active -> Destroyed
- Political: [Old Ruler] -> [New Ruler]
- Economy: [Old State] -> [New State]

**Justifications**:
- Status change: Location was destroyed in Chapter 15 during major battle
- Political change: New faction took control after battle
- Economy: Trade routes disrupted by conflict

**Constitution Compliance**: ✅ All checks passed
(Or: ⚠️ Some warnings - see Notes section)

**File**: ./world/locations/location-001/location.md
**Last Updated**: 2025-01-15

Use `/novel.location.show location-001` to view updated profile.
```

## Error Handling

- **Location Not Found**: List similar names, suggest creating new location
- **File Read Error**: Report error, check file permissions
- **Constitution Violation**: List violations, suggest corrections, allow override with confirmation
- **Inconsistent Changes**: If changes conflict with recent events, warn user and ask for confirmation
- **Missing Context**: Warn but allow update (suggest creating missing context)

## Important Notes

- **Dynamic interview**: Questions, order, and depth are determined by AI based on what needs to be changed
- **Minimum 6 options**: Every question must have at least 6 options (A-F) plus Custom
- **Show current values**: Always display current setting before asking for change
- **Justification required**: Always ask why changes are being made (for consistency)
- **Information confirmation**: All changes must be confirmed before saving
- **Constitution first**: Always check constitution compliance before saving
- **User control**: User can skip, go back, or cancel at any time

