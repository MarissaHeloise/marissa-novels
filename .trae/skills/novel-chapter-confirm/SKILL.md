---
name: "novel-chapter-confirm"
description: "$ARGUMENTS Invoke when user wants to use novel.chapter.confirm command."
---

# Novel Chapter Confirm



## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). If chapter ID is provided, use it; otherwise, use the current chapter from config.json.

## Process Overview

**CRITICAL: This is the most important operation for building a rich, consistent world. Extract ALL useful information and update ALL world-building elements.**

**Path Note**: All paths are relative to project root (`.`), which is the same directory level as `.novelkit/` and `.cursor/`. The project root is where commands are executed and where user space directories (`chapters/`, `world/`, `plots/`) are located.

1. **Intelligent Context Loading**: Read chapter + all relevant context (same as chapter-write Phase 1)
2. **Comprehensive Extraction**: Extract 8 categories of information with maximum detail
3. **Interactive Confirmation**: 9 question sets to confirm all extracted information
4. **World-Building Updates**: Update 12 types of world elements comprehensively (in user space: `./world/`, `./plots/`)
5. **Consistency Check**: Verify all updates are consistent
6. **Final Report**: Generate detailed completion report

## Phase 1: Comprehensive Information Extraction (Automatic)

### Step 1: Read All Context

**Read** (same as chapter-write, all paths relative to project root):
- Chapter content: `./chapters/chapter-001.md` (user space)
- Chapter plan: `.novelkit/chapters/[chapter-id]/plan.md` (meta-space)
- Novel constitution: `.novelkit/memory/constitution.md` (meta-space)
- Current writer profile: `.novelkit/writers/[writer-id]/writer.md` (meta-space)
- All character/location/item/plot files mentioned: `./world/...`, `./plots/...` (user space)
- Relationship network: `./world/relationships/network.md` (user space)
- Worldview: `./world/worldview.md` (user space)
- Timeline: `./world/timeline.md` (user space)
- Previous chapters: `./chapters/chapter-*.md` (user space)

### Step 2: Extract 8 Categories of Information

#### 1. Characters
- **New**: Name, gender, age, race, appearance, personality, abilities, background, relationships, plot involvement, writing features
- **Changes**: Physical state (location, health), abilities (skills, power, equipment), emotional/psychological state, relationships, development, status

#### 2. Items
- **New**: Name, type, rarity, appearance, properties/abilities, origin/history, current status (owner, location), plot significance
- **Changes**: Ownership, location, state, abilities, significance

#### 3. Locations
- **New**: Name, type, geography, size, population, environment, structures, rules/properties, factions/control, plot significance
- **Changes**: Control, physical state, rules, population, significance

#### 4. Factions
- **New**: Name, type, founding time, history, structure, ideology/goals, resources/power, relationships, plot significance
- **Changes**: Members, power, territory, relationships, goals, status

#### 5. Relationships
- **New**: Type, strength (1-10), status, start time, description, related characters
- **Changes**: Strength, status, dynamics, reason, context

#### 6. Plots
- **Main Plot Progress**: Events, milestones, twists, character involvement, timeline
- **Subplots**: New subplots (type, goals, characters, events, related main plot), existing subplot progress

#### 7. Foreshadowing
- **New**: Type, content, hinting method, related plots/entities, expected reveal time
- **Developments/Reveals**: Development type, how, impact, character reactions

#### 8. World-Building
- **New Rules**: Type, description, scope, exceptions, consequences, source
- **Worldview Updates**: World info, state changes, historical events, cultural/social/economic/power system info
- **Timeline Events**: Time, description, involved entities, significance, consequences

**Present to User**: Summary statistics + detailed lists + confidence levels (High/Medium/Low) + extraction quality

## Phase 2: Interactive Confirmation (9 Question Sets)

**Each question set provides 6+ options (A-F) + Custom input, similar to writer-new command.**

### Q1: New Characters
- List all detected new characters with details + confidence levels
- Options: Confirm all / Partial / Add missing / Remove false / Review individually / Auto-create
- For each confirmed: Verify basic info, abilities, background, relationships, plot involvement, writing features, importance level

### Q2: Character State Changes
- List all detected changes per character (physical/ability/emotional/relationship/development/status)
- Options: Confirm all / By character / By type / Partial / Add / Correct / Auto-update
- For each: Verify change details, assess development significance

### Q3: Plot Information
- **Q3.1**: Main plot progress (significant/moderate/minor/twist) - verify details
- **Q3.2**: New subplots detected - verify and create profiles
- **Q3.3**: Existing subplot progress - verify and update

### Q4: Foreshadowing
- **Q4.1**: New foreshadowing detected - verify and create records
- **Q4.2**: Existing foreshadowing developments/reveals - verify and update

### Q5: Items
- **Q5.1**: New items detected - verify and create profiles
- **Q5.2**: Item state changes - verify and update

### Q6: Locations
- **Q6.1**: New locations detected - verify and create profiles
- **Q6.2**: Location state changes - verify and update

### Q7: Factions
- **Q7.1**: New factions detected - verify and create profiles
- **Q7.2**: Faction state changes - verify and update

### Q8: Relationships
- **Q8.1**: New relationships detected - verify details
- **Q8.2**: Relationship changes - verify details

### Q9: Timeline & World-Building
- **Q9.1**: Timeline events - verify and add to timeline
- **Q9.2**: New world rules/info - verify and update worldview/create rule files

## Phase 3: Comprehensive World-Building Updates (Automatic)

**Update ALL elements systematically based on confirmations:**

### 1. Character Management
- **Create**: `./world/characters/character-001.md` (user space, project root) with all extracted info, link to chapter, add to index
- **Update**: All changed fields, record change history, update relationships, add chapter reference

### 2. Item Management
- **Create**: `./world/items/item-001.md` (user space, project root) with all info, link to chapter/owner, add to index
- **Update**: Ownership history, update owner's profile, add chapter reference

### 3. Location Management
- **Create**: `./world/locations/location-001.md` (user space, project root) with all info, link to chapter/faction, add to index
- **Update**: Change history, update controlling faction, add chapter reference

### 4. Faction Management
- **Create**: `./world/factions/faction-001.md` (user space, project root) with all info, link members, update relationship network, add to index
- **Update**: Member characters, relationship network, change history, add chapter reference

### 5. Relationship Network
- **Update**: `./world/relationships/network.md` (user space, project root) - add new relationships, update existing, record history, ensure consistency in character profiles

### 6. Plot Management
- **Update Main Plot**: `./plots/main/plot-001.md` (user space, project root) - add progress entry, record events/milestones, update character involvement, link chapter
- **Create Subplot**: `./plots/side/plot-001.md` (user space, project root) - fill all info, link to main plot/chapter/characters, add to index
- **Update Subplot**: Add progress entry, update status, link chapter

### 7. Foreshadowing Management
- **Create**: `./plots/foreshadowing/foreshadow-001.md` (user space, project root) - fill all info, link to plots/entities/chapter, add to index
- **Update**: Add development/reveal entry, update related plots, link chapter

### 8. Timeline Management
- **Update**: `./world/timeline.md` (user space, project root) - add events with time markers, link to all entities, maintain chronological order

### 9. Worldview Management
- **Update**: `./world/worldview.md` (user space, project root) - add new world info, update existing info, link chapter

### 10. Rules Management
- **Create**: `./world/rules/rule-001.md` (user space, project root) - fill all info, link to chapter/worldview, add to index
- **Update**: Change history, link chapter

### 11. Cross-Reference Updates (Critical)
**Ensure ALL cross-references updated**:
- Character ↔ Character, Character ↔ Item, Character ↔ Location, Character ↔ Faction, Character ↔ Plot
- Item ↔ Location, Location ↔ Faction, Plot ↔ Plot, Foreshadowing ↔ All

### 12. Index & Metadata Updates
- Update all indexes (characters, items, locations, factions, plots, foreshadowing, rules)
- Update metadata files tracking world-building elements

## Phase 4: Consistency Check (Automatic)

**Check**:
1. **Constitution Compliance**: Verify new content complies with constitution
2. **Internal Consistency**: Verify character/location/plot/timeline consistency
3. **Cross-Reference Consistency**: Verify relationships/plot connections/foreshadowing logic
4. **Timeline Consistency**: Verify chronological accuracy

**Report**: List all issues with severity levels, suggest corrections, allow user review

## Phase 5: State Machine Update (Automatic)

**Update** `.novelkit/memory/config.json`:

```json
{
  "current_chapter": {
    "id": "[chapter-id]",
    "title": "[title]",
    "number": [number],
    "file_path": "chapters/chapter-001.md",  # Relative to project root (same level as .novelkit/)
    "word_count": [count],
    "status": "completed",
    "completed_at": "[timestamp]",
    "last_modified": "[timestamp]"
  },
  "novel": {
    "total_chapters": [increment],
    "total_words": [add chapter words],
    "last_modified": "[timestamp]"
  },
  "statistics": {
    "chapters_completed": [increment]
  },
  "history": {
    "chapter_creations": [{
      "chapter_id": "[chapter-id]",
      "title": "[title]",
      "number": [number],
      "word_count": [count],
      "completed_at": "[timestamp]",
      "new_characters": [list],
      "new_items": [list],
      "new_locations": [list],
      "new_subplots": [list],
      "new_foreshadowing": [list]
    }],
    "recent_actions": [{
      "action": "confirmed_chapter",
      "chapter_id": "[chapter-id]",
      "new_content": {
        "characters": [count],
        "items": [count],
        "locations": [count],
        "subplots": [count],
        "foreshadowing": [count]
      },
      "timestamp": "[ISO 8601]",
      "command": "chapter-confirm"
    }]
  },
  "world": {
    "total_characters": [increment if new],
    "total_items": [increment if new],
    "total_locations": [increment if new],
    "total_side_plots": [increment if new],
    "total_foreshadowing": [increment if new]
  },
  "session": {
    "last_action": "Confirmed chapter [chapter-id] ([title])",
    "last_action_time": "[timestamp]",
    "last_action_command": "chapter-confirm",
    "last_modified_file": "chapters/chapter-001.md"  # Relative to project root
  },
  "last_updated": "[timestamp]"
}
```

## Phase 6: Final Report

**Generate** `.novelkit/chapters/[chapter-id]/completion-report.md`:

```markdown
# Chapter Completion Report: [Chapter ID]

**Chapter**: [Number] - [Title]  
**Word Count**: [Count]  
**Completed**: [Date]

## Executive Summary
- Total Elements Extracted: [Count]
- New Elements Created: [Count]
- Existing Elements Updated: [Count]

## Detailed Content
- New Characters: [List with IDs]
- Character Updates: [List]
- New Items: [List with IDs]
- Item Updates: [List]
- New Locations: [List with IDs]
- Location Updates: [List]
- New Factions: [List with IDs]
- Faction Updates: [List]
- New Relationships: [List]
- Relationship Updates: [List]
- New Subplots: [List with IDs]
- Subplot Progress: [List]
- New Foreshadowing: [List with IDs]
- Foreshadowing Developments: [List]
- Main Plot Progress: [Description]
- Timeline Events: [Count]

## World-Building Updates
- Files Created: [Count] (characters/items/locations/factions/subplots/foreshadowing/rules)
- Files Updated: [Count]
- Cross-References Updated: [Count]
- Indexes Updated: ✅

## Consistency Check
- Constitution Compliance: ✅/⚠️/❌
- Internal Consistency: ✅/⚠️/❌
- Cross-Reference Consistency: ✅/⚠️/❌
- Timeline Consistency: ✅/⚠️/❌

## Impact Assessment
- World-Building Impact: [Assessment]
- Plot Impact: [Assessment]
- Character Impact: [Assessment]

## Next Steps
- Ready for next chapter: `/novel.chapter.plan`
```

## Error Handling

- Chapter doesn't exist: Error, prompt user
- Chapter not in "written"/"polished" status: Warn, allow confirmation
- Extraction fails: Allow manual input
- Consistency check fails: List issues, allow review/fix
- World-building update fails: Rollback, report error

## Key Principles

1. **Extract ALL useful information** - Don't miss anything, even minor details
2. **Extract with maximum detail** - Not just names, but all attributes
3. **Update comprehensively** - Create new + update existing + cross-references
4. **Maintain consistency** - Ensure all updates align with existing world
5. **Build world progressively** - Each chapter adds to the rich world

