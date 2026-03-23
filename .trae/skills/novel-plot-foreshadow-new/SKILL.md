---
name: "novel-plot-foreshadow-new"
description: "$ARGUMENTS Invoke when user wants to use novel.plot.foreshadow.new command."
---

# Novel Plot Foreshadow New



## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Process Overview

1. **Context Loading** (Automatic): Read constitution, current chapter, target plots
2. **Dynamic Interview**: Conduct adaptive Q&A based on context
3. **Profile Generation**: Assemble collected data into foreshadowing template
4. **Final Confirmation**: Review generated profile before saving
5. **File Creation**: Create foreshadowing file and save profile
6. **State Machine Update**: Update config.json

## Context Loading (Automatic)

**CRITICAL: You MUST intelligently read all relevant context before starting the interview.**

### Required Context

1. **Novel Constitution** (ALWAYS REQUIRED):
   - Read `.novelkit/memory/constitution.md`
   - Extract: foreshadowing rules, plot constraints

2. **Current Chapter** (If available):
   - Read latest chapter from `config.json`
   - Extract: where this is being planted

3. **Target Plots** (REQUIRED):
   - Read related main plots: `./plots/main/[plot-id]/plot.md`
   - Read related side plots: `./plots/side/[plot-id]/plot.md`
   - Extract: what revelation this supports

4. **Existing Foreshadowing** (If relevant):
   - Scan `./plots/foreshadowing/` directory
   - Extract: existing hints, avoid repetition

## Dynamic Interview Process

**The interview is fully dynamic - you decide the questions, order, and depth based on context.**

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
   - All information must be marked as **"confirmed"** or **"unconfirmed"**
   - For unconfirmed information, AI must continue asking or provide more options

4. **Completeness Threshold**:
   - Before final generation, verify all necessary information is confirmed
   - If information is insufficient, actively point out missing items
   - Do NOT proceed to generation until all required fields are confirmed

### Core Topics (Dynamic Selection)

Based on context, dynamically select and order questions from:

1. **Clue**: What is the hint? (Object, dialogue, event, symbol)
2. **Subtlety**: Obvious or Hidden? How subtle?
3. **Target**: What does it point to? Which plot/revelation?
4. **Payoff Plan**: When/How should it be revealed?
5. **Planting Location**: Where is this being planted? (Chapter, scene)
6. **Connection**: How does it connect to target plot?

**Note**: Not all topics need to be covered. AI decides based on context.

## Constitution Compliance Check

Before saving, check:
- Foreshadowing rules followed?
- Connection to plot makes sense?
- Timing appropriate?

If violations found: Warn user, suggest corrections, allow override with confirmation (log in Notes).

## Profile Generation

After interview completion:

1. **Assemble Profile**: Fill `templates/plot.md` (simplified for foreshadowing) with all collected data
2. **Expand Descriptions**: Convert brief answers into rich descriptions
3. **Add Metadata**: Include creation date, ID, status
4. **Constitution Check**: Validate all constraints
5. **Final Review**: Show complete profile to user for confirmation

## File Creation & State Update

### Create Foreshadowing File

Execute script:
```bash
./scripts/bash/plot-manager.sh new --type foreshadow "[Name]"
```

Script returns JSON with:
- Foreshadowing ID (foreshadow-xxx)
- File path: `./plots/foreshadowing/[foreshadow-id]/foreshadow.md`
- Created timestamp

Write the generated profile to the file path.

### Update State Machine

After saving:

1. Read `.novelkit/memory/config.json`
2. Update `world.total_foreshadowing`: increment by 1
3. Update `session.last_action`: "Created foreshadowing [foreshadow-id] ([Name])"
4. Update `session.last_action_time`: [current timestamp]
5. Update `session.last_action_command`: "plot-foreshadow-new"
6. Update `session.last_modified_file`: `./plots/foreshadowing/[foreshadow-id]/foreshadow.md`
7. Add to `history.recent_actions` array (keep last 20)
8. Update `last_updated`: [current timestamp]
9. Save updated config.json

## Important Notes

- **Dynamic interview**: Questions, order, and depth are determined by AI based on context
- **Minimum 6 options**: Every question must have at least 6 options (A-F) plus Custom
- **Information confirmation**: All information must be confirmed before proceeding
- **Completeness check**: Verify all necessary information before generation
- **Constitution first**: Always check constitution compliance before saving
- **User control**: User can skip, go back, or cancel at any time

