# ~/.opencode/OpenCode.md

## Behavior
- Use a todo list for tasks with 3+ distinct steps, and keep it updated.
- When blocked, ask a structured question with 3-5 options; put the recommended option first.
- Always include a short code snippet that demonstrates the proposed approach.
- Even in plan mode, read relevant files for context when it helps answer accurately.

## Output style
- Keep responses concise and practical.
- Use code examples even for explanations.

## Built-in tools

## Permissions
- Control tool usage with the `permission` field in `opencode.json`.
- `edit` permission covers `edit`, `write`, and `patch`.

Example
```
{ "permission": { "read": "allow", "bash": "ask" } }
```

### bash
- Purpose: Run shell commands in the project environment.
- When: Use for git, installs, tests, and scripts.
- Example
```
{ "permission": { "bash": "allow" } }
```

### edit
- Purpose: Modify existing files via exact string replacements.
- When: Use for precise edits to existing files.
- Example
```
{ "permission": { "edit": "allow" } }
```

### write
- Purpose: Create new files or overwrite existing files.
- When: Use to add new files or replace file contents.
- Example
```
{ "permission": { "edit": "allow" } }
```

### read
- Purpose: Read file contents (optionally with line ranges).
- When: Use to gather context from files.
- Example
```
{ "permission": { "read": "allow" } }
```

### grep
- Purpose: Search file contents with regular expressions.
- When: Use to locate patterns across the codebase.
- Example
```
{ "permission": { "grep": "allow" } }
```

### glob
- Purpose: Find files via glob patterns.
- When: Use to locate files by name or extension.
- Example
```
{ "permission": { "glob": "allow" } }
```

### list
- Purpose: List directory contents.
- When: Use to inspect folders or filter with glob patterns.
- Example
```
{ "permission": { "list": "allow" } }
```

### lsp (experimental)
- Purpose: Code intelligence via LSP (definitions, references, hover, symbols).
- When: Use for navigation and static analysis.
- Note: Requires `OPENCODE_EXPERIMENTAL_LSP_TOOL=true` (or `OPENCODE_EXPERIMENTAL=true`).
- Example
```
{ "permission": { "lsp": "allow" } }
```

### patch
- Purpose: Apply patch diffs to files.
- When: Use for diff-based edits or large changes.
- Example
```
{ "permission": { "edit": "allow" } }
```

### skill
- Purpose: Load a skill file into the conversation.
- When: Use when a task matches an available skill.
- Example
```
{ "permission": { "skill": "allow" } }
```

### todowrite
- Purpose: Create and update todo lists during a session.
- When: Use for tasks with 3+ distinct steps.
- Example
```
{ "permission": { "todowrite": "allow" } }
```

### todoread
- Purpose: Read the current todo list state.
- When: Use to check task progress or pending items.
- Example
```
{ "permission": { "todoread": "allow" } }
```

### webfetch
- Purpose: Fetch web content.
- When: Use to read online documentation or pages.
- Example
```
{ "permission": { "webfetch": "allow" } }
```

### question
- Purpose: Ask the user questions during execution.
- When: Use to clarify ambiguity, gather preferences, or pick a direction.
- Example
```
{ "permission": { "question": "allow" } }
```
