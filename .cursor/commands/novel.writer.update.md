

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Interactive Update Process

This command uses an **interactive Q&A interview** approach to update a writer profile. The process is **dynamic and adaptive**, focusing only on areas that need changes.

### Process Overview

1. **Identify Writer**: Parse writer ID/name from `$ARGUMENTS` or use current writer
2. **Load Current Profile**: Read existing `.novelkit/writers/[ID]/writer.md`
3. **Display Current State**: Show key characteristics of the current writer
4. **Interactive Update Interview**: Ask targeted questions about what to change
5. **Dynamic Question Flow**: Questions adapt based on what user wants to modify
6. **Apply Changes**: Update the profile with new values
7. **Final Confirmation**: Review changes before saving
8. **Save Updated Profile**: Write back to `.novelkit/writers/[ID]/writer.md`

9. **Update State Machine**:
   - Read `.novelkit/memory/config.json`
   - Read writer profile to get writer name: `.novelkit/writers/[WRITER_ID]/writer.md`
   - If this is the active writer (check `current_writer.id`), update `current_writer.name` if name changed
   - Update `session.last_action`: "Updated writer [writer_id] ([Writer Name])"
   - Update `session.last_action_time`: [current timestamp]
   - Update `session.last_action_command`: "writer-update"
   - Update `session.last_modified_file`: `.novelkit/writers/[WRITER_ID]/writer.md`
   - Update `session.action_context`: "[Summary of changes]"
   - Add to `history.recent_actions` array (keep last 20 entries):
     - `{"action": "updated_writer", "writer_id": [writer_id], "changes": "[summary]", "timestamp": [ISO 8601], "command": "writer-update"}`
   - Update `last_updated`: [current timestamp]
   - Save updated config.json

## Interview Structure

### Phase 1: Identify What to Change

**Question 1: What would you like to update?**
Present 6+ options based on current profile:
- A) Language characteristics (vocabulary, sentences, formality)
- B) Human-like writing features (flow, imperfections, authenticity)
- C) Writing techniques (description, imagery, metaphors)
- D) Anti-AI detection features (variation, human markers)
- E) Tone and mood (emotional tone, atmosphere)
- F) Multiple areas (comprehensive update)
- Custom: [User input]

**Question 2: Specific Focus Area** (if user chose A-F above)
- Present 6+ sub-options based on the selected area
- Allow multiple selections
- Allow custom focus

### Phase 2: Language Characteristics Updates (if selected)

**Question 3: Vocabulary Level** (if current differs or user wants to change)
Present 6+ options:
- A) Keep current: [Current value]
- B) Simple everyday words
- C) Intermediate vocabulary
- D) Rich literary vocabulary
- E) Technical/specialized terms
- F) Mix of simple and complex
- Custom: [User input]

**Question 4: Sentence Structure** (if relevant)
Present 6+ options with current value highlighted:
- A) Keep current: [Current value]
- B) Short sentences (5-10 words)
- C) Medium sentences (10-20 words)
- D) Long flowing sentences (20+ words)
- E) Varied mix
- F) Mostly short with occasional long
- Custom: [User input]

**Question 5: Formality Level** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) Very casual
- C) Casual
- D) Neutral
- E) Formal
- F) Very formal
- Custom: [User input]

### Phase 3: Human-Like Features Updates (if selected)

**Question 6: Natural Flow** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) Smooth transitions, steady rhythm
- C) Varied rhythm with natural pauses
- D) Abrupt transitions for emphasis
- E) Stream-of-consciousness elements
- F) Winding flow with digressions
- Custom: [User input]

**Question 7: Imperfections & Authenticity** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) Highly polished
- C) Occasional natural variations
- D) Intentional inconsistencies
- E) Natural hesitations and pauses
- F) Rough edges preserved
- Custom: [User input]

### Phase 4: Writing Techniques Updates (if selected)

**Question 8: Description Style** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) Sparse (minimal)
- C) Moderate (balanced)
- D) Detailed (rich)
- E) Very detailed (extensive)
- F) Varied by context
- Custom: [User input]

**Question 9: Imagery & Sensory** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) Visual only
- C) Multiple senses
- D) All senses
- E) Selective emphasis
- F) Vivid and immersive
- Custom: [User input]

### Phase 5: Anti-AI Features Updates (if selected)

**Question 10: Variation & Uniqueness** (if relevant)
Present 6+ options:
- A) Keep current: [Current value]
- B) High variation
- C) Moderate variation
- D) Strong personal voice
- E) Natural inconsistencies
- F) Breaks predictable patterns
- Custom: [User input]

### Phase 6: Additional Refinements

**Question 11: Any other changes?**
- Present options based on what hasn't been covered
- Allow user to specify additional areas
- Or proceed to confirmation

### Phase 7: Review & Confirmation

**Question 12: Review Changes**
- Display side-by-side comparison:
  - **Before**: [Current value]
  - **After**: [New value]
- Show all changes made
- Ask: "Confirm these changes? (Yes/No/Modify more)"
- If Modify: Return to relevant questions
- If Yes: Save updates

## Interview Guidelines

### Dynamic Question Selection

- **Skip unchanged areas**: If user says "keep current", don't ask follow-ups
- **Focus on changes**: Only ask about areas user wants to modify
- **Adaptive depth**: If user wants "comprehensive update", ask more questions
- **Progressive refinement**: Later questions can refine earlier changes

### Question Presentation Format

Each question MUST be presented in this format:

```markdown
## Question [N]: [Question Title]

**Current value**: [Show current setting]

**What would you like to change it to?**

| Option | Choice | Description |
|--------|--------|-------------|
| A | Keep current | [Current value] |
| B | [Option B] | [What this means] |
| C | [Option C] | [What this means] |
| D | [Option D] | [What this means] |
| E | [Option E] | [What this means] |
| F | [Option F] | [What this means] |
| Custom | [Your own] | Enter your custom value |

**Your choice**: _[Wait for user response]_
```

### User Response Handling

- **Accept letter choices**: A, B, C, D, E, F (case-insensitive)
- **Accept "keep" or "current"**: Preserve existing value
- **Accept custom input**: Any text input
- **Allow "skip"**: User can skip questions (keep current)
- **Allow "back"**: User can go back to previous questions
- **Allow "done"**: User can finish early if satisfied

### Change Tracking

- Track all changes: field name, old value, new value
- Display change summary before saving
- Allow user to undo specific changes
- Preserve unchanged fields completely

## Output Format

After completing the update interview:

```markdown
✅ Writer profile updated successfully!

**Writer**: writer-001 ([Writer Name])

**Changes Made**:
- Vocabulary Level: Intermediate → Rich literary vocabulary
- Sentence Structure: Medium → Varied mix
- Formality: Neutral → Casual
- Description Style: Moderate → Detailed

**Profile**: .novelkit/writers/writer-001/writer.md
**Last Updated**: 2025-01-15

Use `/novel.writer.show writer-001` to view updated profile.
```

## Important Notes

- **Minimum 6 options**: Every question must have at least 6 options (A-F) plus Custom
- **Dynamic flow**: Questions adapt based on what user wants to change
- **Preserve unchanged**: Only modify fields user explicitly changes
- **Show current values**: Always display current setting before asking for change
- **User control**: User can skip, go back, or finish early
- **Change confirmation**: Always show summary of changes before saving
