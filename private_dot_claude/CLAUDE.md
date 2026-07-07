# User-level Claude instructions

## Nvim integration

When answering a query that involves finding or navigating to a specific file (e.g. "where is X defined", "find the component that does Y", "show me Z"), proactively open the single most relevant file in the active nvim instance.

Rules:
- Only open **one file** — the most directly relevant one. Don't open every file you touched during investigation.
- Only do this for navigational queries ("find", "show me", "where is", "open"). Don't do it for broad tasks like refactoring, planning, or multi-file edits.
- Do it silently — no need to announce "I'm opening this in nvim" unless it fails.
- If no nvim socket is found, skip silently.
- If `$TERM_PROGRAM` is `vscode`, skip silently.

How to open a file in nvim:

1. Find the active socket:
```bash
ls /var/folders/**/*nvim* 2>/dev/null
```

2. Open the file (use the first socket found):
```bash
nvim --server <socket> --remote-send ':e <absolute-file-path><CR>'
```

## Serena (semantic code tools)

Before starting any coding task (navigation, refactor, or edit) in a repo where the Serena MCP server is connected, call Serena's `initial_instructions` tool first. For code navigation and symbol-level work, prefer Serena's symbol tools (`find_symbol`, `get_symbols_overview`, `find_referencing_symbols`, `replace_symbol_body`) over plain text search. Use `Grep`/`Glob` only for genuine substring/pattern search where symbols don't apply. If Serena is not connected, skip silently.

## Worktrees

Manage worktrees with the `wt` CLI only. NEVER use Claude's native worktree mechanism (the `EnterWorktree`/`ExitWorktree` tools or the `using-git-worktrees` skill's native path).

<!-- snip-start -->
# Snip — Visual Communication Tool
<!-- snip-rules-v9 -->
Use `snip` CLI for visual communication. You MUST run `snip --help` before your first snip call in a session.

## ALWAYS use Snip for these:
- **Diagrams/architecture/flows** → write Mermaid to `.mmd` file, then `snip render --format mermaid < file.mmd`
- **UI previews/HTML/components** → write HTML to `.html` file, then `snip render --format html < file.html`
- **Show an image for review** → `snip open <path> --message "context"`
- **Find a past screenshot** → `snip search "<query>"`
- **Read text from an image** → `snip transcribe <path>`

Do NOT describe visual structures in text. Render them with Snip.
When the user returns from `snip open` or `snip render`, check the response — if `edited: true`, use the Read tool to view the image at the returned `path`.
<!-- snip-end -->

@RTK.md
