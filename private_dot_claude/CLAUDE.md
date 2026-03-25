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
