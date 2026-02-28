

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). Support both plot ID (main-plot-xxx) and title matching.

## Process Overview

This command retrieves and displays the full profile of a specified main plot, including all details from the plot template. It also provides context by reading related information like characters and side plots.

### Process Steps

1. **Identify Plot**: Parse ID/title from `$ARGUMENTS` or prompt user
2. **Load Plot Profile**: Read the plot file
3. **Load Context**: Read related information (characters, side plots, chapters)
4. **Format Display**: Present profile in organized, readable format
5. **Provide Interactive Options**: Offer follow-up actions

## Detailed Process

### Phase 1: Plot Identification

#### Step 1: Parse Plot Identifier

**If `$ARGUMENTS` is provided**:
- Try to match as plot ID (format: `main-plot-xxx`)
- If not found, try title matching (fuzzy search)
- Support partial matches

**If `$ARGUMENTS` is empty**:
- Prompt user: "Which main plot would you like to view?"
- Suggest: "Enter plot ID (main-plot-xxx) or title"
- Optionally list recent plots from config.json

#### Step 2: Run Show Script

Execute the plot manager script:

```bash
./scripts/bash/plot-manager.sh show "$ARGUMENTS"
```

The script should:
- Locate plot file in `./plots/main/[plot-id]/plot.md` (user space, project root)
- Return JSON with:
  - Plot ID
  - Plot title
  - File path
  - Last modified date
  - Status (if available)

#### Step 3: Handle Identification Errors

**If plot not found**:
- List similar titles (fuzzy matching)
- Suggest: "Did you mean [similar title]?"
- Offer to create new plot: `/novel.plot.main.new`
- Offer to list all plots: `/novel.plot.main.list`

### Phase 2: Load Plot Profile

#### Step 4: Read Plot File

Read the full plot profile from the path returned by script:
- File location: `./plots/main/[plot-id]/plot.md` (user space, project root)
- Parse all sections according to plot template

#### Step 5: Extract Profile Information

Extract all sections from the plot template:

1. **Basic Information**:
   - Title, status, importance level
   - Start time, end time (if applicable)

2. **Plot Structure**:
   - Premise, core conflict
   - Stakes, inciting incident
   - Key events, turning points
   - Climax, resolution

3. **Characters**:
   - Main characters involved
   - Character roles in plot
   - Character arcs

4. **Theme**:
   - Underlying message
   - Themes explored

5. **Timeline**:
   - Plot timeline
   - Key events chronology

6. **Foreshadowing**:
   - Related foreshadowing elements

### Phase 3: Load Context Information

#### Step 6: Read Character Information

**For characters involved in plot**:
- Read character profiles: `./world/characters/[character-id]/character.md`
- Extract: character names, roles, current states
- Show character involvement in plot

#### Step 7: Read Related Side Plots

**Check for connected side plots**:
- Read side plot files: `./plots/side/[plot-id]/plot.md`
- Extract: side plots that connect to this main plot
- Show connections and relationships

#### Step 8: Read Chapter Involvement

**If config.json tracks chapter involvement**:
- Check `history.chapter_creations` for plot mentions
- List chapters where this plot appears
- Show plot progression over chapters

### Phase 4: Format Display

#### Step 9: Organize Display Sections

Present plot profile in a structured, easy-to-read format:

**Header Section** (highlighted):
- Plot title (large, prominent)
- Plot ID
- Status badge (Planned/Active/Resolved/etc.)
- Importance badge (if applicable)
- Last updated date

**Main Sections** (in order):
1. Basic Information
2. Plot Structure
3. Characters
4. Theme
5. Timeline
6. Foreshadowing
7. Notes

**Context Sections** (if available):
- Character Involvement
- Related Side Plots
- Chapter Involvement

#### Step 10: Format Each Section

Format each section clearly with proper markdown structure, ensuring readability.

### Phase 5: Interactive Actions

#### Step 11: Provide Follow-up Options

After displaying the profile, offer interactive actions:

**Primary Actions**:
- **Update Plot**: `/novel.plot.main.update [ID]` - Modify plot profile
- **View Related Side Plots**: Show connected side plots
- **View Characters**: Show all characters involved

**Secondary Actions**:
- **List All Plots**: `/novel.plot.main.list` - Return to plot list
- **Create Related Plot**: `/novel.plot.main.new` or `/novel.plot.side.new`

**Navigation**:
- **Previous Plot**: Navigate to previous plot in list
- **Next Plot**: Navigate to next plot in list
- **Related Plots**: Show connected plots

## Output Format

### Standard Display

```markdown
# Main Plot: [PLOT_TITLE]

**ID**: main-plot-001  
**状态**: Active ⭐  
**Importance**: Core  
**最后更新**: 2025-01-15

---

## Basic Information

[Full basic information section]

## Plot Structure

[Full plot structure section]

[... all other sections ...]

---

## Quick Actions

- [Update Plot] [View Related Side Plots] [View Characters]
- [List All Plots] [Create Related Plot]
```

## Error Handling

- **Plot Not Found**: 
  - Show error: "Main plot '[ID/Title]' not found."
  - List similar titles
  - Suggest creating new plot

- **File Read Error**: 
  - Show error: "Unable to read plot file: [path]"
  - Check file permissions
  - Suggest manual file check

- **Missing Sections**: 
  - Show available sections
  - Note: "Some sections are incomplete. Use `/novel.plot.main.update` to complete."

- **Related Information Missing**: 
  - Show plot profile anyway
  - Note: "Some related information (characters, side plots) not available."

## Guidelines

- **Complete Display**: Show all sections even if some are empty (mark as "未设置" or "Not set")
- **Link Navigation**: Provide links to related entities (characters, side plots, chapters)
- **Readability**: Use clear formatting, proper spacing, and visual hierarchy
- **Context Awareness**: Highlight plot's current status and progress
- **Interactive**: Make it easy to navigate to related information
