

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Load Constitution**: Read `.novelkit/memory/constitution.md`
   - If not found: ERROR "Constitution not found. Use `/novel.constitution.create` first."

2. **Determine Check Scope**:
   - If `$ARGUMENTS` is empty: Check all content (characters, plots, chapters, etc.)
   - If `$ARGUMENTS` contains entity type: Check specific type (e.g., "characters", "plots")
   - If `$ARGUMENTS` contains entity ID: Check specific entity

3. **Run Check Script**: Execute `.novelkit/scripts/powershell/constitution-manager.ps1 -Action Check -Json "$ARGUMENTS` to:
   - Scan relevant content files
   - Return JSON with check results

4. **Perform Compliance Checks**:
   - **Story Synopsis Compliance**: Check if content aligns with theme, genre, conflict
   - **POV Compliance**: Check if chapters follow POV rules
   - **Audience Compliance**: Check if content matches target audience rating
   - **Tone Compliance**: Check if style matches tone requirements
   - **Worldview Compliance**: Check if settings follow worldview constraints
   - **Character Compliance**: Check if characters follow character constraints
   - **Plot Compliance**: Check if plots follow plot constraints
   - **Time/Space Compliance**: Check if events are within time/space constraints

5. **Generate Report**: Create detailed compliance report with:
   - Compliant items (✓)
   - Violations (✗) with specific issues
   - Warnings (⚠) for potential issues
   - Recommendations for fixes

## Check Categories

### 1. Story Synopsis Compliance
- Content aligns with core theme
- Content matches story genre
- Conflicts match core conflict type
- Story direction is consistent
- Values are conveyed appropriately

### 2. POV Compliance
- Chapters follow POV type rules
- No POV violations (describing unknown info)
- POV switches are properly marked
- Perspective character restrictions followed

### 3. Audience Compliance
- Violence level matches rating
- Sexual content matches rating
- Language matches rating
- Theme depth matches audience level

### 4. Tone & Style Compliance
- Overall tone is consistent
- Language style matches requirements
- Realism level is appropriate
- Emotional tone is consistent

### 5. Worldview Compliance
- Settings match world type
- Rules are not violated
- Forbidden content is not present
- Power systems follow established rules

### 6. Character Compliance
- Characters match allowed types
- Character abilities within limits
- Character behavior follows rules
- Relationships are allowed types

### 7. Plot Compliance
- Plots match allowed types
- Conflicts match allowed types
- Twist frequency is appropriate
- Foreshadowing follows rules

### 8. Time & Space Compliance
- Events within time span
- Locations within space range
- Time flow rules followed
- Space rules followed

## Output Format

Display compliance report:

```markdown
# Constitution Compliance Check

**Check Date**: 2025-01-15
**Constitution Version**: 1.0
**Scope**: All content

## Summary
- ✅ Compliant: 45 items
- ✗ Violations: 3 items
- ⚠ Warnings: 2 items

## Violations

### 1. Character "char-001" - Character Type Violation
- **Issue**: Character is a dragon, but constitution allows "Only humans"
- **Location**: `./world/characters/char-001/character.md` (user space, project root)
- **Recommendation**: Change character type or update constitution

### 2. Chapter "ch-005" - POV Violation
- **Issue**: Describes character's thoughts without being in their POV
- **Location**: `chapters/ch-005.md`
- **Recommendation**: Remove internal thoughts or switch to that character's POV

### 3. Plot "plot-002" - Time Constraint Violation
- **Issue**: Event occurs outside allowed time span
- **Location**: `./plots/main/plot-002/plot.md` (user space, project root)
- **Recommendation**: Adjust event timing or update time constraints

## Warnings

### 1. Content Rating - Violence
- **Issue**: Chapter "ch-012" has heavy violence, but rating is "Mild"
- **Recommendation**: Reduce violence or update content rating

### 2. Tone Consistency
- **Issue**: Chapter "ch-008" tone is humorous, but overall tone is "Serious"
- **Recommendation**: Adjust chapter tone or consider if humor is appropriate

## Recommendations

1. Review and fix 3 violations
2. Consider addressing 2 warnings
3. Run check again after fixes
```

## Guidelines

- If constitution not found: Show error and suggest creating one
- Be specific about violations: Include file path, line number if possible
- Provide actionable recommendations
- Categorize issues by severity (violation vs warning)
- Support partial checks (specific entity types or IDs)
- Update check records in constitution file

