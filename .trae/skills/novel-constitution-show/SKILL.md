---
name: "novel-constitution-show"
description: "1. **Check Constitution Exists**: Invoke when user wants to use novel.constitution.show command."
---

# Novel Constitution Show



## Outline

1. **Check Constitution Exists**: 
   - Read `.novelkit/memory/constitution.md`
   - If not found: Show error and suggest using `/novel.constitution.create`

2. **Load Constitution**: Read the full constitution file

3. **Format Display**: Present constitution in organized sections:
   - Header (version, dates, status)
   - Section 1: Story Synopsis
   - Section 2: Narrative Perspective
   - Section 3: Target Audience
   - Section 4: Tone & Style
   - Section 5: Worldview Constraints
   - Section 6: Character Constraints
   - Section 7: Plot Constraints
   - Section 8: Time & Space Constraints
   - Modification History
   - Check Records

4. **Highlight Active Status**: If constitution is active, clearly indicate

## Output Format

Display the full constitution in a readable format:

```markdown
# Novel Constitution

**Version**: 1.0
**Created**: 2025-01-15
**Last Updated**: 2025-01-15
**Status**: Active ✓

## 1. Story Synopsis

### Core Theme
[Theme]

### Story Type
[Genre]

### Core Conflict
[Conflict]

### Story Direction
[Direction]

### Core Values
[Values]

[Continue with all 8 sections...]

## Modification History
[History table]

## Check Records
[Check records table]
```

## Guidelines

- If constitution not found: Show error and suggest creating one
- Format markdown properly for readability
- Include file path for reference
- Show status clearly (Active/Draft)
- Display all sections even if some are empty


