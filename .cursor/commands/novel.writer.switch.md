

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Parse Writer ID**: Extract writer ID or name from `$ARGUMENTS`
   - If empty: Show current writer and list available options
   - If provided: Use specified writer

2. **Run Switch Script**: Execute `.novelkit/scripts/powershell/writer-manager.ps1 -Action Switch -Json "$ARGUMENTS` to:
   - Validate writer exists
   - Update active writer configuration
   - Save current writer ID to config file
   - Return JSON with switch status

3. **Update Configuration**: 
   - Read `.novelkit/memory/config.json`
   - Update `current_writer` section:
     - `id`: [new writer ID]
     - `name`: [writer name from profile]
     - `profile_path`: `.novelkit/writers/[WRITER_ID]/writer.md`
     - `activated_at`: [current timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ]
     - `activated_by`: "writer-switch"
   - Record in `history.writer_switches` array:
     - Add entry: `{"from": [previous writer ID or null], "to": [new writer ID], "timestamp": [ISO 8601], "command": "writer-switch"}`
   - Update `statistics.writers_switched`: increment by 1
   - Update `session.last_action`: "Switched writer to [writer_id] ([Writer Name])"
   - Update `session.last_action_time`: [current timestamp]
   - Update `session.last_action_command`: "writer-switch"
   - Update `session.last_modified_file`: `.novelkit/memory/config.json`
   - Update `last_updated`: [current timestamp]
   - Save updated config.json

4. **Confirm Switch**: Display confirmation with writer details

## Output Format

Display switch confirmation:

```markdown
✅ Active writer switched successfully!

**Previous Writer**: writer-002 (Romantic Comedy Writer)
**Current Writer**: writer-001 (Mystery Thriller Writer) ★

**Profile**: .novelkit/writers/writer-001/writer.md
**State Updated**: `.novelkit/memory/config.json`

All new chapters will use this writer's style.
```

## Guidelines

- Validate writer exists before switching
- Show previous writer for context
- Update configuration file
- Support both ID and name matching
- If writer not found: Show error and suggest `/novel.writer.list`
- If no argument: Show current writer and prompt for selection

