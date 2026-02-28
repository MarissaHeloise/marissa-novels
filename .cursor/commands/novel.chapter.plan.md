

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Interactive Interview Process

This command uses an **interactive Q&A interview** approach to plan the next chapter. It automatically reads the latest completed chapter from `config.json` and analyzes it to generate intelligent suggestions.

### Process Overview

1. **Read Latest Chapter** (Automatic):
   - Read `.novelkit/memory/config.json` to get `current_chapter`
   - If no completed chapter exists, start from scratch
   - Read the latest completed chapter file
   - Analyze chapter content (plot, characters, locations, foreshadowing, etc.)

2. **Interactive Interview**: Conduct a series of questions about the next chapter
3. **Dynamic Question Flow**: Questions adapt based on previous answers and chapter analysis
4. **Auto-Generate 3 Versions** (if user is uncertain): Generate 3 different planning versions
5. **Final Confirmation**: Review and confirm before saving
6. **Save Plan**: Write to `.novelkit/chapters/[chapter-id]/plan.md` (meta-space, relative to project root)

## Interview Structure

### Phase 1: Intelligent Context Loading & Analysis (Automatic)

**CRITICAL: You MUST intelligently read all relevant context before planning.**

#### Step 1: Read Latest Chapter & Extract References

1. **Read Latest Completed Chapter**:
   - Read `.novelkit/memory/config.json` → `current_chapter` or `history.chapter_creations[-1]`
   - Read chapter file: `./chapters/chapter-001.md` (user space, project root, same level as `.novelkit/`)
   - Extract all mentioned entities:
     - Character names
     - Location names
     - Item names
     - Plot references
     - Faction names
     - Event references

#### Step 2: Intelligent Information Retrieval

**Based on extracted references, intelligently determine what to read:**

1. **Read Novel Constitution** (ALWAYS REQUIRED):
   - `.novelkit/memory/constitution.md`
   - Extract: story synopsis, POV rules, target audience, tone & style, worldview constraints, character constraints, plot constraints, time & space constraints

2. **Read Active Main Plots**:
   - Check `config.json` → `active_plot.main_plot_id`
   - Read `plots/main/[plot-id]/plot.md`
   - Extract: plot goals, key events, involved characters, timeline, status
   - **Also read**: Related main plots mentioned in chapter or config

3. **Read Active Subplots**:
   - Check `config.json` → `active_plot.side_plot_ids[]`
   - For each subplot ID, read `plots/side/[plot-id]/plot.md`
   - Extract: subplot goals, related main plot, involved characters, status
   - **Also read**: Subplots mentioned in latest chapter

4. **Read Character Profiles** (Based on chapter mentions):
   - For each character mentioned in latest chapter:
     - Read `world/characters/[character-id]/character.md`
     - Extract: basic info, abilities, relationships, background, current status, plot involvement
   - **Also read**: Characters likely to appear based on plot progression

5. **Read Location Information** (Based on chapter mentions):
   - For each location mentioned in latest chapter:
     - Read `world/locations/[location-id]/location.md`
     - Extract: description, rules, atmosphere, related events, related characters
   - **Also read**: Locations likely to be visited based on plot

6. **Read Item Information** (Based on chapter mentions):
   - For each item mentioned in latest chapter:
     - Read `world/items/[item-id]/item.md`
     - Extract: description, abilities, current owner, history, plot significance
   - **Also read**: Items likely to be relevant based on plot

7. **Read Faction Information** (If relevant):
   - For factions mentioned or related to characters:
     - Read `world/factions/[faction-id]/faction.md`
     - Extract: structure, members, goals, relationships, current status

8. **Read Relationship Network** (If relevant):
   - Read `world/relationships/network.md`
   - Extract: relationships between characters likely to appear

9. **Read Foreshadowing Records** (If relevant):
   - Check `plots/foreshadowing/` for active foreshadowing
   - Read foreshadowing files that are:
     - Not yet revealed
     - Related to current plot
     - Mentioned in latest chapter

10. **Read Worldview** (If world-building needed):
    - Read `world/worldview.md`
    - Extract: world rules, power systems, social structure, history

11. **Read Timeline** (If time continuity needed):
    - Read `world/timeline.md`
    - Extract: recent events, time markers, chronological context

#### Step 3: Analyze & Synthesize Context

**After reading all relevant information:**

1. **Plot Continuity Analysis**:
   - What plot threads are active?
   - What plot threads need advancement?
   - What plot threads can be introduced?
   - What plot threads need resolution?

2. **Character State Analysis**:
   - Current locations of key characters
   - Current relationships between characters
   - Character development arcs in progress
   - Character goals and motivations

3. **World State Analysis**:
   - Current world situation
   - Active conflicts
   - Recent events impact
   - Foreshadowing status

4. **Narrative Flow Analysis**:
   - Pacing needs (fast/slow)
   - Tone requirements
   - POV constraints
   - Audience expectations

**Present Comprehensive Context Summary to User**:
- Previous chapter summary with key plot points
- Active main plots and their status
- Active subplots and their status
- Characters who appeared and their current states
- Locations visited and their characteristics
- Items involved and their significance
- Foreshadowing clues detected
- Relationship changes
- Unresolved conflicts
- World state summary

### Phase 2: Plot Direction (5-8 questions)

**Question 1: What is the main plot direction for the next chapter?**
Present 6+ options:
- A) Continue current plotline (natural progression)
- B) Start new plotline (branch out)
- C) Resolve current conflict (climax/resolution)
- D) Introduce new conflict (escalation)
- E) Character development focus (internal growth)
- F) World-building expansion (explore setting)
- Custom: [User input]

**Question 2: What is the core conflict for this chapter?**
Present 6+ options:
- A) Character vs Character (interpersonal)
- B) Character vs Environment (survival/challenge)
- C) Character vs Self (internal struggle)
- D) Faction vs Faction (group conflict)
- E) Time pressure (deadline/urgency)
- F) Resource conflict (competition/need)
- Custom: [User input]

**Question 3: What is the chapter's pacing?**
Present 6+ options:
- A) Fast-paced (action-heavy, quick events)
- B) Medium-paced (balanced action and reflection)
- C) Slow-paced (contemplative, detailed)
- D) Variable (mix of fast and slow)
- E) Build-up (gradual tension increase)
- F) Climax (peak intensity)
- Custom: [User input]

**Question 4: How does this chapter connect to the main plot?**
Present 6+ options:
- A) Directly advances main plot (core progression)
- B) Develops subplot (side story)
- C) Foreshadows future events (setup)
- D) Resolves previous subplot (closure)
- E) Character development (growth arc)
- F) World-building (setting exploration)
- Custom: [User input]

### Phase 3: Character Planning (4-6 questions)

**Question 5: Which characters will appear in this chapter?**
- Automatically list characters from previous chapter
- Automatically list characters from related plotlines
- Present options:
  - A) Keep all previous chapter characters
  - B) Add new important character
  - C) Focus on specific character(s)
  - D) Introduce minor new character
  - E) Mix of existing and new
  - F) Let system suggest based on plot
  - Custom: [User input]

**Question 6: Do you want to introduce a new character?**
Present 6+ options:
- A) No, use existing characters only
- B) Yes, introduce minor character (supporting role)
- C) Yes, introduce important character (significant role)
- D) Yes, introduce antagonist/villain
- E) Yes, introduce ally/helper
- F) Unsure, let system suggest
- Custom: [User input]

**Question 7: What is the character focus?**
Present 6+ options:
- A) Protagonist focus (main character)
- B) Supporting character development
- C) Antagonist focus (villain)
- D) Ensemble cast (multiple characters)
- E) New character introduction
- F) Character relationship exploration
- Custom: [User input]

### Phase 4: Location & Setting (3-5 questions)

**Question 8: Where does this chapter take place?**
- Automatically list locations from previous chapter
- Automatically list locations from related plotlines
- Present options:
  - A) Continue in same location
  - B) Move to new location
  - C) Travel between locations
  - D) Return to previous location
  - E) Introduce new location
  - F) Let system suggest based on plot
  - Custom: [User input]

**Question 9: What is the setting atmosphere?**
Present 6+ options:
- A) Tense and dangerous (high stakes)
- B) Peaceful and calm (reflection)
- C) Mysterious and unknown (exploration)
- D) Familiar and safe (comfort)
- E) Hostile and threatening (conflict)
- F) Dynamic and changing (transition)
- Custom: [User input]

### Phase 5: Chapter Title & Structure (3-5 questions)

**Question 10: What style should the chapter title be?**
Present 6+ options:
- A) Plot summary style (e.g., "Entering the Secret Realm")
- B) Suspense question style (e.g., "Who's Behind This?")
- C) Character focus style (e.g., "Zhang San's Choice")
- D) Conflict highlight style (e.g., "Life and Death Duel")
- E) Poetic symbolic style (e.g., "Light in the Dark Night")
- F) Let system auto-generate
- Custom: [User input]

**Question 11: What is the chapter structure?**
Present 6+ options:
- A) Linear progression (chronological)
- B) Flashback/flashforward (time shifts)
- C) Multiple perspectives (POV switches)
- D) Parallel storylines (intercutting)
- E) Single scene focus (intensive)
- F) Multiple scenes (episodic)
- Custom: [User input]

### Phase 6: Foreshadowing & Clues (2-4 questions)

**Question 12: Should this chapter include foreshadowing?**
Present 6+ options:
- A) Yes, plant new foreshadowing
- B) Yes, develop existing foreshadowing
- C) Yes, reveal previous foreshadowing
- D) No, focus on current events
- E) Subtle hints only
- F) Let system suggest based on plot needs
- Custom: [User input]

**Question 13: What clues or information should be revealed?**
Present 6+ options:
- A) New world-building information
- B) Character backstory revelation
- C) Plot twist setup
- D) Item/artifact information
- E) Relationship dynamics
- F) Multiple revelations
- Custom: [User input]

### Phase 7: Auto-Generate 3 Versions (If User Uncertain)

**If user selects "unsure" or "let system suggest" for key questions:**

Generate 3 distinct planning versions:

**Version A: Conservative Continuation**
- Continues previous chapter naturally
- Maintains current plot momentum
- Focuses on existing characters
- Steady progression

**Version B: Turning Point Progression**
- Introduces new conflict
- Advances main plot significantly
- May introduce new elements
- Creates momentum shift

**Version C: Subplot Development**
- Develops side storylines
- Expands world-building
- Character development focus
- Enriches narrative depth

Each version includes:
- Chapter title suggestion
- Plot summary
- Character list
- Location
- Key events
- Foreshadowing clues
- Connection to main plot

**User selects one version or requests modifications.**

### Phase 8: Final Confirmation

**Review Complete Plan**:
- Chapter number (auto-increment from previous)
- Chapter title
- Plot summary
- Character list (with roles)
- Location(s)
- Key events sequence
- Foreshadowing elements
- Connection to main plot
- Connection to subplots
- Estimated word count range

**User confirms or requests adjustments.**

## State Machine Update

After saving the plan:

1. **Read** `.novelkit/memory/config.json`
2. **Update** `current_chapter`:
   - `id`: [new chapter ID, e.g., "chapter-001"]
   - `title`: [chapter title from plan]
   - `number`: [auto-increment from previous chapter or 1 if first]
   - `file_path`: `.novelkit/chapters/[chapter-id]/plan.md`
   - `status`: "planned"
   - `created_at`: [current timestamp ISO 8601]
   - `last_modified`: [current timestamp]
3. **Update** `statistics.chapters_created`: increment by 1
4. **Update** `session.last_action`: "Planned chapter [chapter-id] ([title])"
5. **Update** `session.last_action_time`: [current timestamp]
6. **Update** `session.last_action_command`: "chapter-plan"
7. **Update** `session.last_modified_file`: `.novelkit/chapters/[chapter-id]/plan.md`
8. **Add to** `history.recent_actions` array (keep last 20):
   ```json
   {
     "action": "planned_chapter",
     "chapter_id": "[chapter-id]",
     "chapter_title": "[title]",
     "chapter_number": [number],
     "timestamp": "[ISO 8601]",
     "command": "chapter-plan"
   }
   ```
9. **Update** `last_updated`: [current timestamp]
10. **Save** updated config.json

## Output Format

The plan should be saved as Markdown with the following structure:

```markdown
# Chapter [NUMBER]: [TITLE]

**Status**: Planned  
**Created**: [DATE]  
**Last Modified**: [DATE]

## Plot Summary

[Detailed plot summary]

## Characters

### Main Characters
- [Character Name] - [Role/Description]

### Supporting Characters
- [Character Name] - [Role/Description]

### New Characters (if any)
- [Character Name] - [Role/Description]

## Location

- **Primary Location**: [Location Name]
- **Secondary Locations**: [if any]

## Key Events

1. [Event 1]
2. [Event 2]
3. [Event 3]
...

## Foreshadowing & Clues

- [Clue/Foreshadowing element 1]
- [Clue/Foreshadowing element 2]
...

## Connections

### Main Plot
[How this chapter connects to main plot]

### Subplots
[How this chapter connects to subplots]

## Notes

[Any additional notes or considerations]
```

## Error Handling

- If no previous chapter exists: Start from scratch, ask about first chapter
- If previous chapter file is missing: Warn user, proceed with basic information
- If config.json is missing: Initialize with default structure
- If constitution doesn't exist: Warn user but allow planning (suggest creating constitution first)

