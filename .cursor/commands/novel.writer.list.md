

## Outline

1. **Run List Script**: Execute `.novelkit/scripts/powershell/writer-manager.ps1 -Action List -Json` to:
   - Scan `.novelkit/writers/` directory for all writer profiles
   - Read metadata from each writer profile
   - Read `.novelkit/memory/config.json` to get current active writer ID
   - Return JSON with writer list

2. **Parse Script Output**: Extract writer information from JSON

3. **Display Writer List**: Format and present:
   - Writer ID
   - Writer Name
   - Status (Active/Inactive)
   - Current Writer indicator (★)
   - Last Updated date
   - Brief description (first line)

4. **Format Output**: Create a readable table or list

## Output Format

Display in a clear, organized format:

```markdown
## Available Writers

| ID | Name | Status | Last Updated | Description |
|----|------|--------|--------------|-------------|
| writer-001 | Mystery Thriller Writer | Active ★ | 2025-01-15 | Fast-paced third-person mystery stories |
| writer-002 | Romantic Comedy Writer | Inactive | 2025-01-10 | Light-hearted first-person romance |
| writer-003 | Fantasy Epic Writer | Inactive | 2025-01-08 | Complex world-building fantasy epics |

**Current Writer**: writer-001 (Mystery Thriller Writer)

Use `/novel.writer.switch <ID>` to change active writer.
Use `/novel.writer.show <ID>` to view detailed profile.
```

## Guidelines

- Sort writers by: Active first, then by Last Updated (newest first)
- Highlight current writer with ★ symbol
- Show truncated descriptions (max 60 characters)
- Include total count: "Found X writers"

