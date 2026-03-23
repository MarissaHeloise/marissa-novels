---
name: "novel-chapter-write"
description: "$ARGUMENTS Invoke when user wants to use novel.chapter.write command."
---

# Novel Chapter Write



## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). If chapter ID is provided, use it; otherwise, use the current chapter from config.json.

## Interactive Interview Process

This command writes a chapter based on the planning document, using the current active writer profile. It strictly adheres to the novel constitution and performs consistency checks.

### Process Overview

1. **Preparation** (Automatic):
   - Read chapter plan from `.novelkit/chapters/[chapter-id]/plan.md` (meta-space)
   - Read current Writer profile from `config.json` → `current_writer.profile_path`
   - Read novel constitution from `.novelkit/memory/constitution.md`
   - Read related character profiles
   - Read related location information
   - Read related plot information (main/side plots)
   - Check constitution compliance

2. **Interactive Configuration**: Ask user about word count and writing preferences
3. **Writing Process**: Generate chapter content based on plan and writer style
4. **Constitution Check**: Verify content complies with constitution
5. **Consistency Check**: Verify consistency with previous chapters
6. **Save Chapter**: Write to `./chapters/chapter-001.md` (user space, project root)
7. **Update State Machine**: Update config.json

## Interview Structure

### Phase 1: Intelligent Context Loading & Preparation (Automatic)

**CRITICAL: You MUST intelligently read all relevant context before writing.**

#### Step 1: Read Chapter Plan & Extract References

1. **Read Chapter Plan**:
   - Read `.novelkit/chapters/[chapter-id]/plan.md`
   - Extract all mentioned entities:
     - Planned characters
     - Planned locations
     - Planned items
     - Plot connections (main/side)
     - Foreshadowing elements
     - Key events

#### Step 2: Intelligent Information Retrieval

**Based on plan content, intelligently determine what to read:**

1. **Read Novel Constitution** (ALWAYS REQUIRED):
   - `.novelkit/memory/constitution.md`
   - Extract: story synopsis, POV rules, target audience, tone & style, worldview constraints, character constraints, plot constraints, time & space constraints
   - **Purpose**: Ensure all writing complies with constitution

2. **Read Current Writer Profile** (ALWAYS REQUIRED):
   - Read `config.json` → `current_writer.profile_path`
   - Read writer profile file
   - Extract: vocabulary level, sentence structure, formality, dialogue style, description style, human-like features, anti-AI techniques
   - **Purpose**: Apply correct writing style

3. **Read Main Plots** (Based on plan connections):
   - For each main plot mentioned in plan:
     - Read `./plots/main/[plot-id]/plot.md` (user space, project root)
     - Extract: plot goals, key events, timeline, involved characters, current status, plot structure
   - **Also read**: Related main plots from `config.json` → `active_plot.main_plot_id`

4. **Read Subplots** (Based on plan connections):
   - For each subplot mentioned in plan:
     - Read `./plots/side/[plot-id]/plot.md` (user space, project root)
     - Extract: subplot goals, related main plot, involved characters, current status, connection points
   - **Also read**: Active subplots from `config.json` → `active_plot.side_plot_ids[]`

5. **Read Character Profiles** (For all planned characters):
   - For each character in plan:
     - Read `./world/characters/[character-id]/character.md` (user space, project root)
     - Extract: 
       - Basic info (name, age, appearance, personality)
       - Abilities and skills
       - Current status and location
       - Relationships with other characters
       - Background story
       - Character arc and development
       - Speech patterns and dialogue style
       - Behavior habits
       - Plot involvement
   - **Also read**: Characters likely to interact (based on relationships)

6. **Read Location Information** (For all planned locations):
   - For each location in plan:
     - Read `./world/locations/[location-id]/location.md` (user space, project root)
     - Extract:
       - Description and atmosphere
       - Geography and layout
       - Rules and special properties
       - Related events
       - Related characters
       - Related items
   - **Also read**: Nearby or connected locations

7. **Read Item Information** (For all planned items):
   - For each item in plan:
     - Read `./world/items/[item-id]/item.md` (user space, project root)
     - Extract:
       - Description and appearance
       - Abilities and properties
       - Current owner
       - History and significance
       - Plot connections
   - **Also read**: Related items (if item relationships exist)

8. **Read Faction Information** (If relevant to characters):
   - For factions related to planned characters:
     - Read `./world/factions/[faction-id]/faction.md` (user space, project root)
     - Extract: structure, members, goals, relationships, current status

9. **Read Relationship Network** (For character interactions):
   - Read `./world/relationships/network.md` (user space, project root)
   - Extract: relationships between planned characters
   - Understand relationship dynamics, strengths, history

10. **Read Foreshadowing Records** (For planned foreshadowing):
    - For foreshadowing elements in plan:
      - Read `./plots/foreshadowing/[foreshadow-id]/foreshadow.md` (user space, project root)
      - Extract: foreshadowing content, reveal method, related plots
    - **Also read**: Active foreshadowing that might be developed

11. **Read Previous Chapter** (For continuity):
    - Read latest completed chapter from `config.json`
    - Extract: ending state, unresolved threads, character positions, plot momentum

12. **Read Worldview** (If world-building needed):
    - Read `./world/worldview.md` (user space, project root)
    - Extract: world rules, power systems, social structure, cultural norms

13. **Read Timeline** (For chronological accuracy):
    - Read `./world/timeline.md` (user space, project root)
    - Extract: recent events, time markers, chronological context

14. **Read Rules** (If relevant):
    - Read relevant rule files from `./world/rules/[rule-id]/rule.md` (user space, project root)
    - Extract: rules that apply to planned events

#### Step 3: Synthesize Context for Writing

**After reading all relevant information, synthesize:**

1. **Plot Context**:
   - How does this chapter advance main plots?
   - How does this chapter develop subplots?
   - What plot threads are being continued?
   - What plot threads are being introduced?

2. **Character Context**:
   - Character current states and motivations
   - Character relationships and dynamics
   - Character development arcs
   - Character goals and conflicts

3. **World Context**:
   - World state and current situation
   - Location characteristics and atmosphere
   - World rules that apply
   - Cultural and social context

4. **Narrative Context**:
   - POV requirements from constitution
   - Tone requirements from constitution
   - Style requirements from writer profile
   - Audience expectations

5. **Continuity Context**:
   - How chapter connects to previous chapter
   - What needs to be continued
   - What needs to be resolved
   - What needs to be introduced

**Report Comprehensive Context to User**:
- Chapter plan summary
- Current writer name and key style characteristics
- Constitution compliance requirements
- Main plots being advanced (with status)
- Subplots being developed (with status)
- Characters involved (with current states)
- Locations involved (with characteristics)
- Items involved (with significance)
- Foreshadowing elements (with context)
- Relationship dynamics
- World state summary
- Continuity notes from previous chapter

### Phase 2: Writing Configuration (3-5 questions)

**Question 1: What is the target word count for this chapter?**
Present 6+ options:
- A) 3000 words (short chapter)
- B) 4000 words (standard, default)
- C) 5000 words (long chapter)
- D) 6000 words (extra long chapter)
- E) Custom word count
- F) Let system decide based on plot complexity
- Custom: [User input number]

**Question 2: Do you want to adjust the writing style?**
Present 6+ options:
- A) Use current Writer style (default)
- B) Temporarily switch to different Writer
- C) Mix multiple Writer styles
- D) Custom style parameters
- E) Keep default
- F) Let system adjust based on chapter type
- Custom: [User input]

**Question 3: What content should be emphasized?**
Present 6+ options:
- A) Action/fight scenes (intense, dynamic)
- B) Dialogue/exchange scenes (conversational)
- C) Internal monologue (psychological depth)
- D) Environmental description (atmospheric)
- E) Foreshadowing planting (subtle hints)
- F) Character growth (development focus)
- G) Balanced mix (all elements)
- Custom: [User input]

**Question 4: What is the narrative focus?**
Present 6+ options:
- A) Plot-driven (events and actions)
- B) Character-driven (emotions and relationships)
- C) World-building (setting and atmosphere)
- D) Theme-driven (ideas and messages)
- E) Balanced (multiple focuses)
- F) Let system decide based on plan
- Custom: [User input]

### Phase 3: Writing Process (Automatic)

**Writing Guidelines**:

1. **Follow Chapter Plan Strictly**:
   - Include all planned characters
   - Use planned locations
   - Follow planned event sequence
   - Include planned foreshadowing

2. **Apply Writer Style**:
   - Use writer's vocabulary level
   - Follow writer's sentence structure
   - Apply writer's formality level
   - Use writer's dialogue style
   - Follow writer's description style
   - Apply writer's human-like features
   - Use writer's anti-AI detection techniques

3. **Respect Constitution**:
   - Follow narrative point of view rules
   - Match target audience requirements
   - Maintain tone & style consistency
   - Respect worldview constraints
   - Follow character constraints
   - Adhere to plot constraints
   - Respect time & space constraints

4. **Maintain Consistency**:
   - Character behavior matches profiles
   - Location descriptions match world data
   - Plot developments align with plot plans
   - Timeline is consistent
   - Relationships are accurate

5. **Writing Quality**:
   - Natural flow and rhythm
   - Varied sentence structure
   - Appropriate pacing
   - Show, don't tell (where applicable)
   - Engaging dialogue
   - Vivid descriptions
   - Smooth transitions

**Real-time Progress**:
- Show writing progress (word count)
- Display current section being written
- Indicate constitution compliance status
- Show consistency check results

### Phase 4: Constitution Compliance Check (Automatic)

**Check All Constitution Rules**:

1. **Story Synopsis Compliance**:
   - Does content serve the core theme?
   - Does it match story type?
   - Does it align with core conflict?
   - Does it follow story direction?

2. **Point of View Compliance**:
   - Correct POV type?
   - POV character restrictions followed?
   - No forbidden information revealed?
   - POV switches properly marked?

3. **Target Audience Compliance**:
   - Content rating appropriate?
   - Language level suitable?
   - Complexity matches audience?

4. **Tone & Style Compliance**:
   - Overall tone consistent?
   - Language style matches?
   - Emotional tone appropriate?

5. **Worldview Compliance**:
   - World type respected?
   - Rules system followed?
   - Taboos avoided?

6. **Character Constraints**:
   - Character types allowed?
   - Ability limits respected?
   - Behavior rules followed?

7. **Plot Constraints**:
   - Plot types allowed?
   - Conflict types appropriate?
   - Foreshadowing rules followed?

8. **Time & Space Constraints**:
   - Within time span?
   - Within spatial range?
   - Time flow rules followed?

**Report Violations**:
- List any violations found
- Suggest corrections
- Allow user to review and decide

### Phase 5: Consistency Check (Automatic)

**Check Consistency**:

1. **Character Consistency**:
   - Behavior matches character profiles
   - Relationships are accurate
   - Abilities match established limits
   - Speech patterns consistent

2. **Location Consistency**:
   - Descriptions match location data
   - Geography is accurate
   - Rules are followed

3. **Plot Consistency**:
   - Aligns with main plot
   - Aligns with subplots
   - Foreshadowing is logical
   - Timeline is correct

4. **World Consistency**:
   - Rules are followed
   - World-building is consistent
   - History is accurate

**Report Inconsistencies**:
- List any inconsistencies
- Suggest corrections
- Allow user to review

### Phase 6: Final Review & Save

**Present Chapter Summary**:
- Word count
- Constitution compliance status
- Consistency check results
- Key content highlights

**User Confirmation**:
- Review chapter content
- Approve or request modifications
- Save to `./chapters/chapter-001.md` (user space, project root, format: `chapters/chapter-{number:03d}.md`)

## State Machine Update

After saving the chapter:

1. **Read** `.novelkit/memory/config.json`
2. **Update** `current_chapter`:
   - `id`: [chapter ID]
   - `title`: [chapter title from plan]
   - `number`: [chapter number]
   - `file_path`: `chapters/chapter-001.md` (user space, relative to project root)
   - `word_count`: [actual word count]
   - `status`: "written"
   - `created_at`: [from plan or current timestamp]
   - `last_modified`: [current timestamp]
   - `written_at`: [current timestamp]
3. **Update** `novel.total_words`: add chapter word count
4. **Update** `statistics.total_writing_sessions`: increment by 1
5. **Update** `session.last_action`: "Wrote chapter [chapter-id] ([title]), [word_count] words"
6. **Update** `session.last_action_time`: [current timestamp]
7. **Update** `session.last_action_command`: "chapter-write"
8. **Update** `session.last_modified_file`: `chapters/chapter-001.md` (user space, relative to project root)
9. **Add to** `history.recent_actions` array (keep last 20):
   ```json
   {
     "action": "wrote_chapter",
     "chapter_id": "[chapter-id]",
     "chapter_title": "[title]",
     "word_count": [count],
     "timestamp": "[ISO 8601]",
     "command": "chapter-write"
   }
   ```
10. **Update** `last_updated`: [current timestamp]
11. **Save** updated config.json

## Output Format

The chapter should be saved as Markdown with the following structure:

```markdown
# Chapter [NUMBER]: [TITLE]

**Status**: Written  
**Word Count**: [COUNT]  
**Written**: [DATE]  
**Last Modified**: [DATE]  
**Writer**: [Writer Name]

---

[Chapter content here, following the plan and writer style]

---

## Chapter Metadata

- **Plan Reference**: `.novelkit/chapters/[chapter-id]/plan.md` (meta-space)
- **Constitution Compliance**: ✅ / ⚠️ / ❌
- **Consistency Check**: ✅ / ⚠️ / ❌
- **Characters Appeared**: [list]
- **Locations**: [list]
- **Foreshadowing**: [list]
```

## Error Handling

- If plan doesn't exist: Prompt user to create plan first
- If writer not set: Prompt user to set writer first
- If constitution missing: Warn but allow writing (suggest creating constitution)
- If word count not reached: Warn user, ask if they want to continue or expand
- If constitution violations found: List violations, allow user to review and decide
- If consistency issues found: List issues, allow user to review and decide


