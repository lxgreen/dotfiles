---
name: new-task-flow
description: Use when the user's message begins with `# NEW TASK`, or when they explicitly want a fresh task started from the latest `master` in its own branch and worktree before coding. This skill scopes the work, syncs trunk, creates an isolated task worktree with `wt switch --create`, and requires a user-approved implementation plan before any code changes.
version: 1.0.0
disable-model-invocation: false
---

# New Task Flow

Follow this workflow before writing code. Treat task setup as mandatory and implementation as a later phase.

## Trigger

- Use this skill when the user starts their message with `# NEW TASK`.
- Also use it when the user clearly asks to begin a fresh isolated task from trunk using a new branch and worktree, even if they omit the marker.

## Workflow

1. Read the full request.
- Identify the primary task type.
- Infer the likely package, app, or scope.
- Decide whether the work is small enough for one focused PR.
- Infer the likely validation commands.
- If the task is too broad, reduce it to the smallest useful first slice and plan that slice.

2. Sync trunk.
- Start new tasks from the latest `master`.
- Run:

```bash
git checkout master
git pull origin master
```

- If local changes block the switch, stop and explain exactly what is blocking the flow.
- Do not stash, discard, or rewrite user changes unless the user explicitly asks.

3. Choose the branch prefix.
- Use `fix/` for bug fixes.
- Use `feat/` for features or enhancements.
- Use `chore/` for dependency changes or maintenance.
- Use `test/` for test-only work.
- If the task spans categories, choose the prefix that best matches the main deliverable.

4. Derive the branch name.
- Use short, specific `kebab-case`.
- Format the name as `<prefix><task-name>`.
- Prefer names that describe the main user-facing or technical goal.
- Examples:

```bash
fix/null-pointer-in-asset-search
feat/data-binding
chore/bump-react-to-18
test/add-quick-view-panel-specs
```

5. Create the dedicated worktree.
- Run:

```bash
wt switch --create <prefix><kebab-case-task-name>
```

- Confirm the branch exists.
- Confirm the current directory is the new worktree.
- Confirm the task is isolated from other active work.
- If the current session is not already in the new worktree, switch into it before continuing.
- If `wt` is unavailable, stop and explain the blocker instead of silently falling back.

6. Plan before coding.
- Do not make code changes yet.
- Share a concise plan that includes:
  - a short restatement of the task
  - the proposed implementation approach
  - the likely files or packages to touch
  - assumptions or risks
  - exact validation commands
- Wait for explicit user approval before making code changes.

## Worktree Rules

- Keep exactly one active task per worktree.
- Do not mix unrelated requests in the same worktree.
- Do not piggyback opportunistic fixes into the same diff.
- Treat `master` as the stable base for syncing and starting new work.
- Prefer creating a fresh worktree over reusing a stale one.

## After Plan Approval

- Read surrounding code before editing.
- Keep diffs minimal and focused.
- Follow existing naming, architecture, and test patterns.
- Preserve backward compatibility unless the task explicitly changes behavior.
- In TypeScript, prefer meaningful type aliases over generic catch-all types.
- Use `===` instead of `==`.
- Avoid nested `await` expressions; split sequential async work into separate statements.
- Avoid unrelated renames, moves, or folder restructuring.

## Safety Rules

- Do not discard user changes unless explicitly asked.
- Do not create extra branches beyond the task branch unless explicitly asked.
- Do not force-push, rewrite history, or merge on the user's behalf unless explicitly asked.
- Do not start long-lived dev servers unless the task requires them.
- If sandboxing or permissions block required git or worktree commands, retry with the proper approval flow instead of skipping the step.

## Handoff

When returning work to the user, summarize:

- what changed
- why it changed
- which packages, apps, or files were touched
- which commands were run
- what passed
- what failed
- any assumptions, risks, or follow-ups
