

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Parse Writer ID**: Extract writer ID from `$ARGUMENTS`
   - If empty: Show current active writer
   - If provided: Use specified writer ID
   - Support both ID (writer-001) and name matching

2. **Run Show Script**: Execute `.novelkit/scripts/powershell/writer-manager.ps1 -Action Show -Json "$ARGUMENTS` to:
   - Locate writer profile file
   - Read writer profile content
   - Return JSON with writer data

3. **Load Writer Profile**: Read the full `writer.md` file

4. **Format Display**: Present writer information in organized sections:
   - Basic Information (highlighted)
   - Writing Style & Voice (detailed)
   - Language Characteristics
   - Human-Like Writing Features
   - Writing Techniques
   - Anti-AI Detection Features
   - Examples (if available)

5. **Highlight Active Status**: If this is the current writer, clearly indicate

## Output Format

Display the full writer profile in a readable format:

```markdown
# Writer Profile: [WRITER_NAME]

**Status**: Active ★ | Inactive
**ID**: writer-001
**Last Updated**: 2025-01-15

## Basic Information
- **Name**: [Writer Name]
- **Description**: [Description]

## Writing Style & Voice

### Language Characteristics
- **Vocabulary Level**: Intermediate
- **Sentence Length**: Varied
- **Formality**: Neutral
- **Sentence Complexity**: Varied mix

### Human-Like Writing Features
- **Natural Flow**: Smooth transitions with natural pauses
- **Imperfections**: Occasional natural variations
- **Human Quirks**: Natural hesitations and thinking pauses

### Writing Techniques
- **Description Style**: Moderate detail with multiple senses
- **Expression Methods**: Occasional metaphors, rich imagery
...

[Continue with all sections from the template]
```

## Guidelines

- If writer not found: Show error and suggest using `/novel.writer.list`
- Support partial name matching (fuzzy search)
- Show all sections even if some are empty
- Format markdown properly for readability
- Include file path for reference

