---
name: get-nvim-files
description: Lists all files currently open in any running nvim instance by querying nvim's RPC sockets. Use when the user asks what's open in nvim, what file nvim has, or wants to know their nvim buffer list. Also use when the user refers to nvim (e.g. "in nvim", "my nvim") or mentions opened/open files without specifying a path.
version: 1.0.0
disable-model-invocation: false
---

# Get Nvim Files

List all files open across all running nvim instances by querying their RPC sockets.

## Steps

1. Check if running inside VSCode — if so, stop silently:
```bash
[ "$TERM_PROGRAM" = "vscode" ] && exit 0
```

2. Find all nvim RPC sockets:
```bash
ls /var/folders/**/*nvim* 2>/dev/null
```

3. For each socket path found, query all listed buffers:
```bash
nvim --server <socket> --remote-expr 'join(map(getbufinfo({"buflisted":1}), "v:val.name"), "\n")' 2>/dev/null
```

4. Also query the active buffer in each instance:
```bash
nvim --server <socket> --remote-expr 'expand("%:p")' 2>/dev/null
```

5. Display results grouped by nvim instance (use the socket path as the instance identifier). For each instance, show:
   - The active (current) buffer
   - All other open buffers

If a buffer name is empty, skip it. If a socket returns no output or errors, skip that instance.
