

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). Support both character ID (character-xxx) and name matching.

## Process Overview

This command retrieves and displays the full profile of a specified character, including all details from the character template. It also provides context by reading related information like relationships, faction details, and plot involvement.

### Process Steps

1. **Identify Character**: Parse ID/name from `$ARGUMENTS` or prompt user
2. **Load Character Profile**: Read the character file
3. **Load Context**: Read related information (factions, relationships, plots)
4. **Format Display**: Present profile in organized, readable format
5. **Provide Interactive Options**: Offer follow-up actions

## Detailed Process

### Phase 1: Character Identification

#### Step 1: Parse Character Identifier

**If `$ARGUMENTS` is provided**:
- Try to match as character ID (format: `character-xxx`)
- If not found, try name matching (fuzzy search)
- Support partial matches

**If `$ARGUMENTS` is empty**:
- Prompt user: "Which character would you like to view?"
- Suggest: "Enter character ID (character-xxx) or name"
- Optionally list recent characters from config.json

#### Step 2: Run Show Script

Execute the character manager script:

```bash
./scripts/bash/character-manager.sh show "$ARGUMENTS"
```

The script should:
- Locate character file in `./world/characters/[character-id]/character.md` (user space, project root)
- Return JSON with:
  - Character ID
  - Character name
  - File path
  - Last modified date
  - Status (if available)

#### Step 3: Handle Identification Errors

**If character not found**:
- List similar names (fuzzy matching)
- Suggest: "Did you mean [similar name]?"
- Offer to create new character: `/novel.character.new`
- Offer to list all characters: `/novel.character.list`

### Phase 2: Load Character Profile

#### Step 4: Read Character File

Read the full character profile from the path returned by script:
- File location: `./world/characters/[character-id]/character.md` (user space, project root)
- Parse all sections according to character template

#### Step 5: Extract Profile Information

Extract all sections from the character template:

1. **Basic Information**:
   - Name, aliases, gender, age, race
   - Identity/occupation, faction, birthplace, residence

2. **Appearance**:
   - Body type, face, hair/eyes, clothing
   - Distinguishing marks, aura

3. **Personality**:
   - Core personality, strengths, weaknesses
   - Values, fears, desires, habits, speaking style

4. **Abilities**:
   - Core ability, skills list, equipment
   - Combat style, intellect, special talents

5. **Background**:
   - Origin, upbringing, key events
   - Personality origin, secrets

6. **Relationships**:
   - Important relationships
   - Attitude to others, reputation

7. **Plot Relevance**:
   - Role type, first appearance
   - Current state, main goal, side quests, foreshadowing

8. **Notes**:
   - Additional notes and metadata

### Phase 3: Load Context Information

#### Step 6: Read Related Faction Information

**If character has faction affiliation**:
- Read `./world/factions/[faction-id]/faction.md`
- Extract: faction name, structure, goals, current status
- Show character's position in faction

#### Step 7: Read Relationship Network

**If relationship network exists**:
- Read `./world/relationships/network.md`
- Extract relationships involving this character
- Show relationship dynamics and history

#### Step 8: Read Plot Involvement

**Check plot files for character mentions**:
- Read active main plots: `./plots/main/[plot-id]/plot.md`
- Read active side plots: `./plots/side/[plot-id]/plot.md`
- Extract: character's role in each plot, current plot status
- Show plot connections and involvement

#### Step 9: Read Chapter Appearances (Optional)

**If config.json tracks chapter appearances**:
- Check `history.chapter_creations` for character mentions
- List recent chapters where character appeared
- Show character development over time

### Phase 4: Format Display

#### Step 10: Organize Display Sections

Present character profile in a structured, easy-to-read format with clear sections:

**Header Section** (highlighted):
- Character name (large, prominent)
- Character ID
- Status badge (Active/Deceased/etc.)
- Role badge (Protagonist/Antagonist/etc.)
- Last updated date

**Main Sections** (in order):
1. Basic Information
2. Appearance
3. Personality
4. Abilities
5. Background
6. Relationships
7. Plot Relevance
8. Notes

**Context Sections** (if available):
- Faction Information
- Relationship Network
- Plot Involvement
- Chapter Appearances

#### Step 11: Format Each Section

**Basic Information**:
```markdown
## 基本信息 (Basic Information)

- **姓名**: [Name]
- **别名/称号**: [Aliases] (if any)
- **性别**: [Gender]
- **年龄**: [Age]
- **种族**: [Race]
- **身份/职业**: [Identity]
- **所属阵营**: [Faction] [Link to faction]
- **出生地**: [Birthplace]
- **现居地**: [Residence]
```

**Appearance**:
```markdown
## 外貌特征 (Appearance)

- **体型**: [Body Type]
- **容貌**: [Face Description]
- **发色/瞳色**: [Hair/Eyes]
- **衣着风格**: [Clothing Style]
- **特征/标记**: [Distinguishing Marks]
- **气质/气场**: [Aura]
```

**Personality**:
```markdown
## 性格特征 (Personality)

- **核心性格**: [Core Personality]
- **优点**: [Strengths]
- **缺点**: [Weaknesses]
- **价值观**: [Values]
- **恐惧/弱点**: [Fears]
- **欲望/目标**: [Desires]
- **习惯/怪癖**: [Habits]
- **说话风格**: [Speaking Style]
```

**Abilities**:
```markdown
## 能力属性 (Abilities)

- **核心能力**: [Core Ability]
- **技能列表**:
  - [Skill 1]
  - [Skill 2]
- **武器/装备**: [Equipment]
- **战斗风格**: [Combat Style]
- **智力/谋略**: [Intellect]
- **特殊天赋**: [Talents]
```

**Background**:
```markdown
## 背景故事 (Background)

- **出身背景**: [Origin]
- **成长经历**: [Upbringing]
- **重要事件**: [Key Events]
- **性格成因**: [Personality Origin]
- **秘密**: [Secrets]
```

**Relationships**:
```markdown
## 人际关系 (Relationships)

### 重要关系
- **[Character Name]**: [Relationship Description] [Link to character]
- **[Character Name]**: [Relationship Description] [Link to character]

- **对他人态度**: [Attitude to Others]
- **他人对评价**: [Reputation]
```

**Plot Relevance**:
```markdown
## 剧情相关 (Plot Relevance)

- **角色定位**: [Role Type] (主角/配角/反派/龙套)
- **初次登场**: [First Appearance]
- **当前状态**: [Current State]
- **主线任务**: [Main Goal] [Link to main plot]
- **支线任务**: [Side Quests] [Link to side plots]
- **伏笔线索**: [Foreshadowing] [Link to foreshadowing]
```

**Context Sections** (if available):

**Faction Information**:
```markdown
## 阵营信息 (Faction Information)

**所属阵营**: [Faction Name] [Link to faction]

- **在阵营中的位置**: [Position in Faction]
- **阵营目标**: [Faction Goals]
- **阵营关系**: [Faction Relationships]
```

**Plot Involvement**:
```markdown
## 剧情参与 (Plot Involvement)

### 主线剧情
- **[Plot Name]**: [Character's Role] - [Current Status] [Link to plot]

### 支线剧情
- **[Plot Name]**: [Character's Role] - [Current Status] [Link to plot]
```

### Phase 5: Interactive Actions

#### Step 12: Provide Follow-up Options

After displaying the profile, offer interactive actions:

**Primary Actions**:
- **Update Character**: `/novel.character.update [ID]` - Modify character profile
- **View Relationships**: Show detailed relationship network
- **View in Plots**: List all plots involving this character
- **View Faction**: Show full faction information (if applicable)

**Secondary Actions**:
- **List All Characters**: `/novel.character.list` - Return to character list
- **Create Related Character**: `/novel.character.new` - Create character with relationship
- **Delete Character**: Warning with confirmation (if supported)

**Navigation**:
- **Previous Character**: Navigate to previous character in list
- **Next Character**: Navigate to next character in list
- **Related Characters**: Show characters with relationships

## Output Format

### Standard Display

```markdown
# 角色档案：[CHARACTER_NAME]

**ID**: character-001  
**状态**: Active ⭐  
**角色定位**: Protagonist  
**最后更新**: 2025-01-15

---

## 基本信息 (Basic Information)

[Full basic information section]

## 外貌特征 (Appearance)

[Full appearance section]

[... all other sections ...]

---

## 快速操作 (Quick Actions)

- [Update Character] [View Relationships] [View in Plots] [View Faction]
- [List All Characters] [Create Related Character]
```

### Compact Display (if requested)

Show only key sections:
- Basic Information
- Current Status
- Key Relationships
- Plot Involvement

## Error Handling

- **Character Not Found**: 
  - Show error: "Character '[ID/Name]' not found."
  - List similar names
  - Suggest creating new character

- **File Read Error**: 
  - Show error: "Unable to read character file: [path]"
  - Check file permissions
  - Suggest manual file check

- **Missing Sections**: 
  - Show available sections
  - Note: "Some sections are incomplete. Use `/novel.character.update` to complete."

- **Related Information Missing**: 
  - Show character profile anyway
  - Note: "Some related information (factions, plots) not available."

## Guidelines

- **Complete Display**: Show all sections even if some are empty (mark as "未设置" or "Not set")
- **Link Navigation**: Provide links to related entities (factions, plots, other characters)
- **Readability**: Use clear formatting, proper spacing, and visual hierarchy
- **Context Awareness**: Highlight character's current relevance in story
- **Interactive**: Make it easy to navigate to related information
