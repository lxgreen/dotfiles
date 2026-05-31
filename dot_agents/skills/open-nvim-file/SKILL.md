---
name: open-nvim-file
description: Opens the most relevant file in the active nvim instance. Use when the user says "show me the code", "show me the file", "show me the logic", "open X in nvim", or any navigational request.
version: 1.0.0
disable-model-invocation: false
---

# Open Nvim File

Open the single most relevant file in the active nvim instance based on the user's request.

## When to use

- User says "show me the code for X", "show me the file", "show me the logic", "open X in nvim", or similar navigational phrasing

## Steps

1. Check if running inside VSCode — if so, stop silently:
```bash
[ "$TERM_PROGRAM" = "vscode" ] && exit 0
```

2. Identify the single most relevant file from context (already-known nvim buffers, search results, or file mentioned by the user). Open only ONE file — the most directly relevant one.

3. Find the active nvim socket:
```bash
ls /var/folders/**/*nvim* 2>/dev/null
```

4. Open the file in nvim using the first socket found:
```bash
nvim --server <socket> --remote-send ':e <absolute-file-path><CR>'
```

4. Do this silently — no need to announce "I'm opening this in nvim" unless it fails. If no socket is found, skip silently.
