---
name: "novel-chapter-polish"
description: "$ARGUMENTS Invoke when user wants to use novel.chapter.polish command."
---

# Novel Chapter Polish



## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). If chapter ID is provided, use it; otherwise, use the current chapter from config.json.

## Interactive Interview Process

This command polishes and refines a completed chapter through an interactive Q&A process. It supports both local modifications and overall optimization.

### Process Overview

1. **Read Chapter** (Automatic):
   - Read chapter content from `./chapters/chapter-001.md` (user space, project root, same level as `.novelkit/`)
   - Analyze chapter structure, word count, style, etc.
   - Load writer profile for style consistency check
   - Load constitution for compliance check

2. **Interactive Configuration**: Ask user about polishing direction and scope
3. **Polishing Process**: Apply improvements based on user preferences
4. **Show Comparison**: Display before/after comparison
5. **User Approval**: Allow user to approve or request further changes
6. **Save Polished Version**: Update chapter file and record history

## Interview Structure

### Phase 1: Chapter Analysis (Automatic)

**Automatic Analysis**:
- Read chapter content
- Analyze structure (paragraphs, scenes, transitions)
- Count word count
- Analyze style consistency
- Check pacing
- Identify potential improvement areas
- Check constitution compliance
- Check consistency with previous chapters

**Present Analysis to User**:
- Chapter summary
- Word count
- Style analysis
- Potential issues detected
- Improvement suggestions

### Phase 2: Polishing Direction (4-6 questions)

**Question 1: How would you like to polish this chapter?**
Present 6+ options:
- A) Language expression optimization (improve writing quality)
- B) Plot pacing adjustment (speed up/slow down)
- C) Character dialogue optimization (more natural/character-appropriate)
- D) Scene description enhancement (more vivid/detailed)
- E) Foreshadowing clue reinforcement (more obvious/subtle)
- F) Overall comprehensive optimization
- G) Custom polishing needs
- Custom: [User input]

**Question 2: What specific content needs modification?**
Present 6+ options:
- A) Opening section (hook readers)
- B) Middle section (plot progression)
- C) Ending section (create suspense)
- D) Specific paragraph(s) (user specifies)
- E) Entire chapter
- F) Let system automatically identify areas needing improvement
- Custom: [User input paragraph numbers or content]

**Question 3: What is the polishing intensity?**
Present 6+ options:
- A) Light adjustment (maintain original style, optimize expression only)
- B) Moderate optimization (noticeable improvements, maintain structure)
- C) Deep refactoring (significant improvements, may adjust structure)
- D) Complete rewrite (keep core plot, rewrite expression)
- E) Let system decide based on content
- F) Custom
- Custom: [User input]

**Question 4: What aspects should be improved?**
Present 6+ options:
- A) Sentence structure (variety, flow)
- B) Word choice (precision, vividness)
- C) Dialogue naturalness (character voice)
- D) Description vividness (imagery, details)
- E) Pacing rhythm (fast/slow balance)
- F) Transition smoothness (scene changes)
- G) All aspects (comprehensive)
- Custom: [User input]

### Phase 3: Style Consistency Check (2-4 questions)

**Question 5: Should style consistency be checked?**
Present 6+ options:
- A) Check consistency with Writer style
- B) Check consistency with previous chapters
- C) Check consistency with constitution requirements
- D) Check all consistency aspects
- E) No consistency check needed
- F) Let system automatically check
- Custom: [User input]

**Question 6: If inconsistencies found, how to handle?**
Present 6+ options:
- A) Automatically adjust to match style
- B) Show inconsistencies for user decision
- C) Adjust major issues, show minor ones
- D) Only report, don't modify
- E) Let system decide
- F) Custom handling
- Custom: [User input]

### Phase 4: Polishing Process (Automatic)

**Apply Polishing Based on User Choices**:

1. **Language Expression Optimization**:
   - Improve sentence variety
   - Enhance word precision
   - Strengthen imagery
   - Improve flow and rhythm
   - Maintain writer's style

2. **Pacing Adjustment**:
   - Speed up: Condense descriptions, quicken dialogue
   - Slow down: Add details, expand scenes
   - Balance: Adjust based on content needs

3. **Dialogue Optimization**:
   - Make dialogue more natural
   - Match character voices
   - Improve dialogue tags
   - Enhance subtext

4. **Description Enhancement**:
   - Add sensory details
   - Strengthen imagery
   - Improve atmosphere
   - Balance show vs tell

5. **Foreshadowing Reinforcement**:
   - Make clues more obvious (if needed)
   - Make clues more subtle (if needed)
   - Add new foreshadowing
   - Develop existing foreshadowing

6. **Overall Optimization**:
   - Comprehensive improvements
   - Maintain original intent
   - Enhance readability
   - Improve engagement

**Real-time Feedback**:
- Show polishing progress
- Display changes being made
- Indicate improvement areas

### Phase 5: Comparison & Review

**Show Before/After Comparison**:

1. **Side-by-Side Comparison**:
   - Original version (left)
   - Polished version (right)
   - Highlight changes

2. **Change Summary**:
   - List of modifications
   - Improvement areas
   - Style adjustments
   - Consistency fixes

3. **Statistics**:
   - Word count change
   - Sentence count change
   - Paragraph count change
   - Style consistency score

**User Review Options**:
- Approve all changes
- Approve specific changes
- Request further modifications
- Reject and start over
- Keep original

### Phase 6: Save & Record History

**Save Polished Chapter**:
- Update `./chapters/chapter-001.md` (user space, project root)
- Record polishing history to `.novelkit/chapters/[chapter-id]/polish-history.md`

**Polishing History Format**:
```markdown
# Polishing History

## [DATE] - Polish Session [N]

**Polishing Direction**: [direction]
**Intensity**: [intensity]
**Scope**: [scope]

### Changes Made
- [Change 1]
- [Change 2]
- [Change 3]
...

### Statistics
- Word count: [before] → [after] ([change])
- Sentences: [before] → [after] ([change])
- Style consistency: [before] → [after]

### Notes
[Any additional notes]
```

## State Machine Update

After saving polished chapter:

1. **Read** `.novelkit/memory/config.json`
2. **Update** `current_chapter`:
   - `word_count`: [updated word count]
   - `last_modified`: [current timestamp]
   - `status`: "polished" (if was "written")
3. **Update** `novel.total_words`: update with new word count
4. **Update** `session.last_action`: "Polished chapter [chapter-id] ([title])"
5. **Update** `session.last_action_time`: [current timestamp]
6. **Update** `session.last_action_command`: "chapter-polish"
7. **Update** `session.last_modified_file`: `chapters/chapter-001.md` (user space, relative to project root)
8. **Add to** `history.recent_actions` array (keep last 20):
   ```json
   {
     "action": "polished_chapter",
     "chapter_id": "[chapter-id]",
     "chapter_title": "[title]",
     "word_count_before": [before],
     "word_count_after": [after],
     "timestamp": "[ISO 8601]",
     "command": "chapter-polish"
   }
   ```
9. **Update** `last_updated`: [current timestamp]
10. **Save** updated config.json

## Error Handling

- If chapter doesn't exist: Error, prompt user to write chapter first
- If chapter is not in "written" or "polished" status: Warn user
- If polishing makes chapter worse: Allow user to revert
- If word count changes significantly: Confirm with user
- If style consistency degrades: Warn user


