---
name: "novel-plot-side-new"
description: "$ARGUMENTS Invoke when user wants to use novel.plot.side.new command."
---

# Novel Plot Side New



## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Creation Modes

This command supports **two creation modes**:

1. **User-Specified Mode**: If `$ARGUMENTS` contains specific requirements (title, type, description, etc.), follow user's requirements closely while ensuring consistency with the world.
2. **Free Creation Mode**: If `$ARGUMENTS` is empty or vague, intelligently create a side plot that fits naturally into the existing story.

## Process Overview

1. **Context Loading** (Automatic): Read constitution, existing plots, characters, world data
2. **Mode Detection**: Determine if user-specified or free creation mode
3. **Dynamic Interview**: Conduct adaptive Q&A based on context
4. **Constitution Compliance Check**: Validate plot against constraints
5. **Profile Generation**: Assemble collected data into plot template
6. **Final Confirmation**: Review generated profile before saving
7. **File Creation**: Create plot file and save profile
8. **State Machine Update**: Update config.json with new plot information

## Context Loading (Automatic)

**CRITICAL: You MUST intelligently read all relevant context before starting the interview.**

### Required Context

1. **Novel Constitution** (ALWAYS REQUIRED):
   - Read `.novelkit/memory/constitution.md`
   - Extract: story synopsis, plot constraints, theme requirements

2. **Main Plots** (REQUIRED):
   - Read active main plots: `./plots/main/[plot-id]/plot.md`
   - Extract: plot goals, themes, characters, status
   - **Purpose**: Identify which main plot this supports, ensure connection

3. **Existing Side Plots** (REQUIRED):
   - Scan `./plots/side/` directory (user space, project root)
   - Extract: plot titles, types, connections, status
   - **Purpose**: Understand existing side plot landscape, avoid conflicts

4. **Characters** (REQUIRED):
   - Read character profiles for focus characters
   - Extract: character goals, arcs, relationships
   - **Purpose**: Identify characters for side plot

### Context Summary

After loading context, report to user:
- Constitution constraints summary
- Available main plots (for connection)
- Existing side plot landscape
- Available characters for plot

## Dynamic Interview Process

**The interview is fully dynamic - you decide the questions, order, and depth based on context.**

### Interview Principles

1. **Adaptive Depth**: 
   - Important side plot: 12-15 questions (comprehensive)
   - Medium side plot: 10-12 questions (moderate)
   - Minor side plot: 8-10 questions (essential only)

2. **Question Selection**:
   - Base questions on plot template structure (Focus, Type, Conflict, Connection, Resolution)
   - Skip irrelevant sections based on plot type
   - Prioritize connection to main plot

3. **Question Format** (MANDATORY):
   - Each question must provide **at least 6 options** (A-F) plus Custom
   - Options must be **mutually exclusive and non-repetitive**
   - Clearly state: "You can also enter your own custom input if none of the options fit"
   - Options should be context-aware (based on constitution, existing plots, characters, world rules)
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

1. **Focus**: Character-driven or Event-driven?
2. **Type**: Romance, Revenge, Mystery, Training, Character Development, etc.
3. **Conflict**: What prevents the goal? Obstacles?
4. **Connection**: How does it relate to Main Plot? (Crucial for cohesion)
5. **Resolution**: Intended outcome, how it resolves
6. **Characters**: Which characters are involved? Their roles?
7. **Timeline**: When does this plot occur? Duration?

**Note**: Not all topics need to be covered. AI decides based on plot importance and context. Connection to main plot is crucial.

## Constitution Compliance Check

Before saving, check:
- Plot type allowed in constitution?
- Themes consistent with story synopsis?
- Conflicts appropriate for target audience?
- Connection to main plot makes sense?

If violations found: Warn user, suggest corrections, allow override with confirmation (log in Notes).

## Profile Generation

After interview completion:

1. **Assemble Profile**: Fill `templates/plot.md` with all collected data
2. **Expand Descriptions**: Convert brief answers into rich, detailed descriptions
3. **Add Metadata**: Include creation date, ID, status
4. **Constitution Check**: Validate all constraints
5. **Final Review**: Show complete profile to user for confirmation

## File Creation & State Update

### Create Plot File

Execute script:
```bash
./scripts/bash/plot-manager.sh new --type side "[Title]"
```

Script returns JSON with:
- Plot ID (side-plot-xxx)
- File path: `./plots/side/[plot-id]/plot.md`
- Created timestamp

Write the generated profile to the file path.

### Update State Machine

After saving:

1. Read `.novelkit/memory/config.json`
2. Update `statistics.side_plots_created`: increment by 1 (if field exists)
3. Update `world.total_side_plots`: increment by 1
4. Update `session.last_action`: "Created side plot [plot-id] ([Title])"
5. Update `session.last_action_time`: [current timestamp]
6. Update `session.last_action_command`: "plot-side-new"
7. Update `session.last_modified_file`: `./plots/side/[plot-id]/plot.md`
8. Add to `history.recent_actions` array (keep last 20):
   ```json
   {
     "action": "created_side_plot",
     "plot_id": "[plot-id]",
     "plot_title": "[Title]",
     "timestamp": "[ISO 8601]",
     "command": "plot-side-new"
   }
   ```
9. Update `last_updated`: [current timestamp]
10. Save updated config.json

## Output Format

After completion:

```markdown
✅ Side plot created successfully!

**Plot ID**: side-plot-001
**Title**: [Plot Title]
**File**: ./plots/side/side-plot-001/plot.md
**Status**: Planned

**Constitution Compliance**: ✅ All checks passed
(Or: ⚠️ Some warnings - see Notes section)

Summary of plot:
- [Key characteristic 1]
- [Key characteristic 2]
- [Key characteristic 3]

Use `/novel.plot.side.show side-plot-001` to view full profile.
Use `/novel.plot.side.update side-plot-001` to modify plot.
```

## Error Handling

- **Invalid Title**: Reject if title conflicts with existing plots or doesn't match story style
- **Duplicate Title**: List similar titles, suggest variations
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
- **Connection to main plot**: Ensure side plot connects logically to main plot
- **Avoid over-questioning**: Keep questions focused and relevant
- **Constitution first**: Always check constitution compliance before saving
- **User control**: User can skip, go back, or cancel at any time

