---
name: open-in-vim
description: Use when the user explicitly asks to open a file in vim/nvim, open nvim in a split, or "open in vim". Do NOT use proactively or for navigational queries — only on explicit request.
---

# Open in Vim

Open files in nvim — reusing an existing instance if one is running, otherwise creating a new Ghostty vertical split.

## When to use

- User explicitly says "open in vim", "open nvim", "open in a split", or similar
- Do NOT invoke proactively for navigational queries ("where is X", "show me X")
- Do NOT invoke unless the user explicitly asks

## Steps

1. Identify the files to open — from context, worktree, or what the user named.

2. If the task has an active git worktree, resolve the correct path:
```bash
git worktree list | grep <branch-fragment>
```
Use the worktree path, not the main repo path.

3. Find an existing nvim socket:
```bash
find /var/folders -name "nvim*" -type s 2>/dev/null; find /tmp -name "nvim*" -type s 2>/dev/null
```

4a. **If a socket is found** — open files in the existing instance:
```bash
nvim --server <socket> --remote-send ':e <absolute-file-path><CR>'
```
For multiple files, use `-O` to open them in vertical splits within nvim:
```bash
nvim --server <socket> --remote-send ":e <file1><CR>:vsplit <file2><CR>"
```

4b. **If no socket is found** — create a new Ghostty vertical split and launch nvim:
```bash
osascript <<'EOF'
tell application "Ghostty" to activate
tell application "System Events"
  tell process "Ghostty"
    keystroke "d" using {command down}
    delay 0.3
    keystroke "nvim -O /absolute/path/to/file1 /absolute/path/to/file2"
    key code 36
  end tell
end tell
EOF
```

5. Do this silently — no need to announce it unless it fails.

## Notes

- `Cmd+D` opens a vertical split in Ghostty
- `key code 36` is Return/Enter
- `nvim -O file1 file2` opens files in vertical splits within nvim
- Always use absolute paths
- If Ghostty is not the active terminal, AppleScript will still activate it first
