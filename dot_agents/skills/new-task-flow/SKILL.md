---
name: new-task-flow
description: Use when the user's message begins with `# NEW TASK`, when they want a fresh isolated task from trunk, or when starting a dev task from Jira/docs/Slack/GitHub context that must remain resumable across context switches.
version: 1.1.0
disable-model-invocation: false
---

# New Task Flow

Follow this workflow before writing code. Treat task setup, external-context enrollment, execution logging, and work-unit planning as mandatory. Implementation is a later phase.

## Trigger

- Use this skill when the user starts their message with `# NEW TASK`.
- Also use it when the user clearly asks to begin a fresh isolated task from trunk using a new branch and worktree, even if they omit the marker.

## Workflow

1. Read the full request.
- Identify the primary task type.
- Infer the likely package, app, or scope.
- Derive the task title from fetched Jira context when available; otherwise derive it from the `# NEW TASK` request.
- Decide whether the work is small enough for one focused PR.
- Infer the likely validation commands.
- If the task is too broad, reduce it to the smallest useful first slice and plan that slice.
- If the `agent-task` command is available, use it for deterministic task state, execution logging, work-unit state, status/resume output, and gate checks.

2. Enroll external task context.
- Detect Jira keys, GitHub issues/PRs, Slack links, docs links, design/spec links, and repo paths.
- For human-started tasks, prefer an interactive task init that asks only:
  - `Jira ticket URL or key (leave empty to skip):`
  - `Docs query or URL (leave empty to skip):`
  - `Slack query or URL (leave empty to skip):`
- When `agent-task` exists, run `agent-task init --prompt "<original # NEW TASK request>"` and answer those prompts rather than recreating task-state files manually.
- Do not prompt for task title, GitHub issue/PR, repo path, base branch, worktree creation, or branch override during init:
  - task title is derived from Jira or the `# NEW TASK` request
  - GitHub PR review is handled later after a PR exists
  - repo path is the current directory
  - base branch is always `master`
  - worktree creation is always required
  - branch name is derived automatically
- If external systems are referenced, use the `mcp-s-cli` skill to investigate them before planning:
  - run `mcp-s-cli check-auth` before first use;
  - use `mcp-s-cli grep <domain>` to discover Jira, docs, Slack, or GitHub tools;
  - inspect tool schemas with `mcp-s-cli info <tool>`;
  - fetch only the fields/messages/pages needed for the task.
- Summarize fetched context into the execution log. Do not paste huge raw payloads into chat.
- If MCP auth or tool access is missing, record the blocker in the execution log and ask the user only if there is no safe way to proceed without that context.

3. Create task state and execution log.
- Create or update a task-local execution log under `.agent/tasks/<task-name>/execution-log.md` when the repo allows it. If the repo does not allow local task files, keep an equivalent note in the safest available local scratch location and mention the path.
- The log must track:
  - task summary and source links
  - current phase
  - work units and statuses
  - commands run and outcomes
  - decisions made
  - blockers and permission/auth issues
  - validation state
  - self-review and external review state
  - commits created
  - next action and safe resume point
- Do not rely on chat history as the only task state.

4. Sync trunk.
- Start new tasks from the latest `master`.
- Treat `master` as fixed; do not prompt for a different base branch unless the user explicitly asks.
- Run:

```bash
git checkout master
git pull origin master
```

- If local changes block the switch, stop and explain exactly what is blocking the flow.
- Do not stash, discard, or rewrite user changes unless the user explicitly asks.

5. Choose the branch prefix.
- Use `fix/` for bug fixes.
- Use `feat/` for features or enhancements.
- Use `chore/` for dependency changes or maintenance.
- Use `test/` for test-only work.
- If the task spans categories, choose the prefix that best matches the main deliverable.

6. Derive the branch name.
- Use short, specific `kebab-case`.
- Format the name as `<prefix><task-name>`.
- Include the Jira key in the branch name when available.
- Prefer names that describe the main user-facing or technical goal.
- Do not prompt for a branch override unless the derived name conflicts with an existing branch/worktree.
- Examples:

```bash
fix/null-pointer-in-asset-search
feat/data-binding
chore/bump-react-to-18
test/add-quick-view-panel-specs
```

7. Create the dedicated worktree.
- Run:

```bash
wt switch --create <prefix><kebab-case-task-name>
```

- Confirm the branch exists.
- Confirm the current directory is the new worktree.
- Confirm the task is isolated from other active work.
- If the current session is not already in the new worktree, switch into it before continuing.
- If `wt` is unavailable, stop and explain the blocker instead of silently falling back.
- Record the worktree path and branch in the execution log.

8. Plan before coding.
- Do not make code changes yet.
- Share a concise plan that includes:
  - a short restatement of the task
  - the proposed implementation approach
  - the likely files or packages to touch
  - assumptions or risks
  - exact validation commands
  - separate testable work units
- Wait for explicit user approval before making code changes.

## Work Units

Split implementation into separate, testable work units before coding. Each work unit must be small enough to understand, validate, summarize, and commit independently.

Each work unit must include:

- name
- goal
- scope
- likely files, packages, or repos
- validation command(s)
- done criteria
- dependencies on previous units

Work one unit at a time:

1. Mark the work unit active in the execution log.
2. Implement only that unit.
3. Run its validation.
4. Self-review the diff.
5. Summarize what changed and why.
6. Commit that work unit separately.
7. Record validation results, risks, and commit hash in the execution log.
8. Move to the next unit.

Do not combine unrelated units in one diff. If a unit cannot be committed cleanly, log the reason, current diff state, and next action.

## Execution Log

Update the execution log at each meaningful state change:

- task enrollment
- external context fetched or unavailable
- plan approval
- work unit start
- command run
- validation pass/fail
- self-review complete
- external PR/review-agent comments fetched, unavailable, or handled
- blocker found
- decision made
- work unit complete
- commit created
- handoff or resume requested

Preferred work-unit log shape:

```md
## Work Unit: <name>

Status: pending | active | blocked | validated | committed
Goal:
Scope:
Started:
Completed:
Commands:
Validation:
Self-review:
External review:
Diff summary:
Commit:
Risks:
Next:
```

If blocked on permission, missing MCP authentication, unavailable tooling, or ambiguous requirements, record the blocker before asking the user.

## Current State And Resume

When the user asks for status, current state, resume note, handoff, "where are we", or similar, answer from the execution log rather than from memory. If a deterministic task-state command exists in the environment, use it; otherwise read the execution log directly.

Status output should include:

- task and phase
- current work unit
- completed work units and commits
- latest validation state
- blockers
- next action

Resume output should include:

- goal
- important decisions
- current focus
- where to continue
- what not to change
- next command or file to inspect

## Worktree Rules

- Keep exactly one active task per worktree.
- Do not mix unrelated requests in the same worktree.
- Do not piggyback opportunistic fixes into the same diff.
- Treat `master` as the stable base for syncing and starting new work.
- Prefer creating a fresh worktree over reusing a stale one.

## After Plan Approval

- Read surrounding code before editing.
- Keep diffs minimal and focused.
- Execute the approved work units sequentially.
- Follow existing naming, architecture, and test patterns.
- Preserve backward compatibility unless the task explicitly changes behavior.
- In TypeScript, prefer meaningful type aliases over generic catch-all types.
- Use `===` instead of `==`.
- Avoid nested `await` expressions; split sequential async work into separate statements.
- Avoid unrelated renames, moves, or folder restructuring.
- Run the focused validation for each work unit before moving on.
- Self-review each work unit diff before committing it.
- Commit each validated work unit separately with a concise message matching the unit's purpose.
- Keep the execution log current before and after each commit.

## Review Gates

Before asking the user for final review or handoff:

- Run self-review over the complete task diff.
- If a PR exists, fetch external PR comments and review-agent comments through the available GitHub tooling, preferring `mcp-s-cli` when available and `gh` only as a fallback.
- Classify every external review comment as:
  - accepted and fixed
  - already handled
  - rejected with rationale
  - needs user decision
- Apply accepted fixes.
- Re-run validation affected by the fixes.
- Record fetched comments, classifications, fixes, validation, and any remaining user decisions in the execution log.

Do not ask the user for final review while external PR/review-agent comments are pending. Ask only when all comments are handled or when a comment needs a product, ownership, or policy decision that the agent cannot safely make.

## Safety Rules

- Do not discard user changes unless explicitly asked.
- Do not create extra branches beyond the task branch unless explicitly asked.
- Do not force-push, rewrite history, or merge on the user's behalf unless explicitly asked.
- Do not start long-lived dev servers unless the task requires them.
- If sandboxing or permissions block required git or worktree commands, retry with the proper approval flow instead of skipping the step.
- Do not ask the user for review mid-state. First complete the active work unit, run validation, self-review, commit or log why committing is unsafe, handle available external review comments, and update the execution log. Ask earlier only for true blockers that cannot be safely resolved.

## Handoff

When returning work to the user, summarize:

- what changed
- why it changed
- which packages, apps, or files were touched
- which commands were run
- what passed
- what failed
- current work-unit state
- self-review and external review state
- commits created
- any assumptions, risks, or follow-ups
