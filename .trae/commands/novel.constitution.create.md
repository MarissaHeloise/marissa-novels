

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Interactive Interview Process

This command uses an **interactive Q&A interview** approach to create the novel constitution. Each step provides **at least 6 options** for the user to choose from, plus the ability to enter custom input.

### Process Overview

1. **Initial Setup**: Run `.novelkit/scripts/powershell/constitution-manager.ps1 -Action Create -Json "$ARGUMENTS` to check if constitution already exists
2. **Interactive Interview**: Conduct a series of questions about the novel's foundational rules
3. **Dynamic Question Flow**: Questions adapt based on previous answers and complexity
4. **Final Confirmation**: Review and confirm before saving
5. **Save Constitution**: Write to `.novelkit/memory/constitution.md`

## Interview Structure

### Phase 1: Story Foundation (5-8 questions)

**Question 1: What is the core theme of your novel?**
Present 6+ options:
- A) Growth and self-discovery (personal journey)
- B) Love and relationships (emotional focus)
- C) Power and ambition (political/social)
- D) Good vs Evil (moral conflict)
- E) Survival and struggle (overcoming adversity)
- F) Mystery and discovery (uncovering secrets)
- Custom: [User input]

**Question 2: What is the story genre?**
Present 6+ options:
- A) Fantasy (magic, mythical creatures)
- B) Science Fiction (future, technology)
- C) Historical (past events, real or fictional)
- D) Modern/Contemporary (current era)
- E) Urban Fantasy (modern + supernatural)
- F) Hybrid/Unique (combine genres)
- Custom: [User input]

**Question 3: What is the core conflict?**
Present 6+ options:
- A) Internal conflict (character vs self)
- B) Interpersonal conflict (character vs character)
- C) Social conflict (character vs society)
- D) Natural conflict (character vs nature/environment)
- E) Supernatural conflict (character vs supernatural forces)
- F) Multiple conflicts (complex layered)
- Custom: [User input]

**Question 4: What is the story direction?**
Present 6+ options:
- A) Hero's journey (rise to power/glory)
- B) Tragedy (downfall or loss)
- C) Redemption arc (fall and rise)
- D) Mystery resolution (uncover truth)
- E) Open-ended (ambiguous conclusion)
- F) Mixed/Complex (multiple arcs)
- Custom: [User input]

**Question 5: What core values should the story convey?**
Present 6+ options:
- A) Perseverance and determination
- B) Love and compassion
- C) Justice and righteousness
- D) Freedom and independence
- E) Wisdom and knowledge
- F) Multiple values (complex message)
- Custom: [User input]

### Phase 2: Narrative Perspective (3-5 questions)

**Question 6: What point of view will you use?**
Present 6+ options:
- A) First Person (I) - intimate, personal
- B) Third Person Limited (he/she) - focused on one character
- C) Third Person Omniscient (God's eye) - all-knowing narrator
- D) Second Person (you) - direct address
- E) Multiple POV switching - different characters
- F) Mixed approach - varies by chapter
- Custom: [User input]

**Question 7: If using limited or multiple POV, who is the main perspective character?**
- Present list of characters if any exist, or ask for description
- Allow "Not decided yet" option
- If multiple POV: Ask about switching rules

**Question 8: What are the POV restrictions?**
Present 6+ options:
- A) Strict: Only what POV character knows/sees
- B) Moderate: Can describe external events POV character witnesses
- C) Flexible: Can include some omniscient elements
- D) No restrictions (if omniscient)
- E) Varies by chapter/section
- F) Custom rules: [User input]

### Phase 3: Target Audience (4-6 questions)

**Question 9: What is the target age group?**
Present 6+ options:
- A) Children (8-12 years)
- B) Young Adult (13-18 years)
- C) Adult (18+ years)
- D) All ages (family-friendly)
- E) Mature (25+ years)
- F) Specific niche: [User input]

**Question 10: What is the reading level?**
Present 6+ options:
- A) Beginner (simple vocabulary, short sentences)
- B) Intermediate (moderate complexity)
- C) Advanced (rich vocabulary, complex sentences)
- D) Literary (sophisticated, nuanced)
- E) Varied (adapts to content)
- F) Custom: [User input]

**Question 11: What content rating for violence?**
Present 6+ options:
- A) None (no violence)
- B) Mild (implied, off-screen)
- C) Moderate (some action, not graphic)
- D) Heavy (detailed combat, consequences)
- E) Extreme (graphic, realistic)
- F) Context-dependent (varies by scene)
- Custom: [User input]

**Question 12: What content rating for romantic/sexual content?**
Present 6+ options:
- A) None (no romance/sex)
- B) Implied (suggested, not shown)
- C) Moderate (some romance, fade to black)
- D) Detailed (explicit scenes)
- E) Focus (central to story)
- F) Context-dependent
- Custom: [User input]

### Phase 4: Tone & Style (4-6 questions)

**Question 13: What is the overall tone?**
Present 6+ options:
- A) Serious and dramatic
- B) Light and humorous
- C) Dark and gritty
- D) Warm and optimistic
- E) Complex and nuanced
- F) Shifts by chapter/arc
- Custom: [User input]

**Question 14: What is the realism level?**
Present 6+ options:
- A) Completely realistic (no fantasy elements)
- B) Light fantasy (minimal supernatural)
- C) Moderate fantasy (magic/supernatural present)
- D) Heavy fantasy (magic central to world)
- E) Science fiction (technology-based)
- F) Mixed/Unique
- Custom: [User input]

**Question 15: What is the language style?**
Present 6+ options:
- A) Formal and polished
- B) Casual and conversational
- C) Poetic and literary
- D) Terse and direct
- E) Varied (adapts to character/scene)
- F) Experimental/Unique
- Custom: [User input]

### Phase 5: Worldview Constraints (5-8 questions, dynamic based on genre)

**Question 16: What type of world setting?**
Present 6+ options (adapt based on genre from Q2):
- A) Ancient/Historical
- B) Modern/Contemporary
- C) Future/Sci-Fi
- D) Alternate/Parallel world
- E) Mixed (time periods blend)
- F) Unique/Other
- Custom: [User input]

**Question 17: What power/magic system exists?** (if fantasy/sci-fi)
Present 6+ options:
- A) No special powers (realistic)
- B) Magic system (defined rules)
- C) Supernatural abilities (vague rules)
- D) Technology-based (sci-fi)
- E) Multiple systems (complex)
- F) Not applicable
- Custom: [User input]

**Question 18: What are the world rules/constraints?**
- Ask about physical laws
- Ask about social rules
- Ask about magic/tech limitations
- Present 6+ options for each aspect

**Question 19: What content is forbidden/not allowed?**
Present 6+ options:
- A) No restrictions
- B) No explicit sexual content
- C) No graphic violence
- D) No controversial topics
- E) No modern references (if historical)
- F) Custom restrictions: [User input]

### Phase 6: Character Constraints (3-5 questions)

**Question 20: What character types are allowed?**
Present 6+ options (adapt based on genre):
- A) Only humans
- B) Humans + fantasy races
- C) Humans + aliens
- D) Any sentient beings
- E) Specific types only: [list]
- F) No restrictions
- Custom: [User input]

**Question 21: What are character power/ability limits?**
Present 6+ options:
- A) Realistic human limits
- B) Enhanced but bounded
- C) Superhuman but not godlike
- D) Near-omnipotent allowed
- E) No limits
- F) Context-dependent
- Custom: [User input]

**Question 22: What relationship types are allowed?**
Present 6+ options:
- A) All relationship types
- B) No romantic relationships
- C) No family relationships
- D) Only positive relationships
- E) Specific types only: [list]
- F) Custom restrictions
- Custom: [User input]

### Phase 7: Plot Constraints (3-5 questions)

**Question 23: What plot types are allowed?**
Present 6+ options:
- A) All plot types
- B) Adventure/action focused
- C) Character-driven only
- D) Mystery/investigation
- E) Romance-focused
- F) Specific types: [list]
- Custom: [User input]

**Question 24: How frequent should major plot twists be?**
Present 6+ options:
- A) Very frequent (every few chapters)
- B) Moderate (every 10-15 chapters)
- C) Occasional (every 20+ chapters)
- D) Rare (only major arcs)
- E) No specific requirement
- F) Context-dependent
- Custom: [User input]

**Question 25: What are the foreshadowing rules?**
Present 6+ options:
- A) All foreshadowing must be revealed within 20 chapters
- B) Foreshadowing can span 50+ chapters
- C) Some foreshadowing can remain unresolved
- D) All major foreshadowing must be resolved
- E) No specific rules
- F) Custom rules: [User input]

### Phase 8: Time & Space Constraints (3-5 questions)

**Question 26: What is the time span of the story?**
Present 6+ options:
- A) Days/weeks (short period)
- B) Months (medium period)
- C) Years (long period)
- D) Decades (very long)
- E) Multiple time periods (non-linear)
- F) Not specified yet
- Custom: [User input]

**Question 27: What is the geographical scope?**
Present 6+ options:
- A) Single location (one city/building)
- B) Regional (one country/region)
- C) Continental (multiple regions)
- D) Global (entire world)
- E) Multiple worlds/realms
- F) Not specified yet
- Custom: [User input]

**Question 28: How does time flow in the story?**
Present 6+ options:
- A) Linear (chronological order)
- B) Non-linear (flashbacks, time jumps)
- C) Mixed (mostly linear with jumps)
- D) Time manipulation (characters can affect time)
- E) Multiple timelines
- F) Not applicable
- Custom: [User input]

### Phase 9: Final Review & Confirmation

**Question 29: Review Complete Constitution**
- Display the complete constitution based on all answers
- Show all 8 sections with filled values
- Ask: "Does this accurately represent your novel's constitution? (Yes/No/Modify)"
- If Modify: Return to specific sections
- If Yes: Proceed to save

## Interview Guidelines

### Dynamic Question Flow

- **Skip irrelevant questions**: If user chooses "No magic" in Q17, skip magic system questions
- **Adapt based on genre**: Fantasy questions differ from sci-fi questions
- **Progressive refinement**: Later questions can refine earlier choices
- **Complexity-based depth**: Simple stories need fewer questions, complex stories need more

### Question Presentation Format

Each question MUST be presented in this format:

```markdown
## Question [N]: [Question Title]

[Brief explanation of what this affects and why it matters]

**Options:**

| Option | Choice | Description |
|--------|--------|-------------|
| A | [Choice A] | [What this means for your novel] |
| B | [Choice B] | [What this means for your novel] |
| C | [Choice C] | [What this means for your novel] |
| D | [Choice D] | [What this means for your novel] |
| E | [Choice E] | [What this means for your novel] |
| F | [Choice F] | [What this means for your novel] |
| Custom | [Your own] | Enter your custom description |

**Your choice**: _[Wait for user response]_
```

### User Response Handling

- **Accept letter choices**: A, B, C, D, E, F (case-insensitive)
- **Accept custom input**: Any text input
- **Allow "skip"**: User can skip questions (use intelligent defaults)
- **Allow "back"**: User can go back to previous questions
- **Allow "review"**: User can review current progress anytime
- **Allow "not decided"**: For questions that need more thought

### Mapping Answers to Template

After each answer:
1. Map the choice to specific template sections
2. Update the in-progress constitution
3. Determine next question based on:
   - Current answers
   - Story complexity
   - Genre requirements
4. Continue until all critical sections are covered

### Question Count Management

- **Minimum**: 5 questions (for very simple stories)
- **Typical**: 15-25 questions (for most novels)
- **Maximum**: 30+ questions (for complex epics)
- **Dynamic adjustment**: 
  - If user chooses "simple" options → fewer questions
  - If user chooses "complex" options → more detailed questions
  - If user provides detailed custom answers → can skip follow-ups

## Output Format

After completing the interview:

```markdown
✅ Novel constitution created successfully!

**Constitution Version**: 1.0
**Created**: 2025-01-15
**File**: .novelkit/memory/constitution.md

**Summary**:
- Story Type: [Genre]
- POV: [Perspective]
- Target Audience: [Audience]
- Tone: [Tone]
- World Type: [World]

**Next Steps**:
1. Use `/novel.constitution.show` to view full constitution
2. Use `/novel.writer.new` to create a writer that follows this constitution
3. Use `/novel.constitution.check` to verify content compliance
```

## Important Notes

- **Minimum 6 options**: Every question must have at least 6 options (A-F) plus Custom
- **Dynamic flow**: Questions adapt based on answers, not fixed sequence
- **User control**: User can skip, go back, or review at any time
- **Progressive building**: Constitution is built incrementally through conversation
- **Final confirmation**: Always show complete constitution before saving
- **Template-based**: Constitution is generated from `.novelkit/templates/constitution.md`
- **One constitution only**: If constitution already exists, warn user before overwriting

