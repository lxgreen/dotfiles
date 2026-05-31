---
name: super-grill-me
description: Adversarial engineering review for Codex/Claude before a PR or risky implementation. Combines grill-me questioning with Superpowers TDD, structured code review, receiving-review discipline, elegant rewrites, and spec-driven development. Use before opening pull requests, when defending a design, when a fix feels messy, or when requirements need to be made precise.
license: MIT
compatibility: Designed for Codex and Claude Code. Requires a git repository for diff-based review modes. Integrates with Superpowers skills when available.
metadata:
  author: rajit, adapted for Codex/Superpowers by alexgr
  version: "1.1"
allowed-tools: Bash(git:*) Read Grep Glob
---

# Super Grill Me

Enter adversarial engineering review mode. Challenge the current changes, implementation, approach, requirements, or PR readiness. Do not make a PR or proceed past the review gate until the user passes the review or explicitly chooses to override it.

This skill's unique role is adversarial questioning: make the author defend the work. It does not replace tests, structured code review, or verification commands. When Superpowers skills are available, use them as the process backbone and use this skill as the pressure test.

## Core Rules

- Ask hard, specific questions tied to the actual code, diff, tests, requirements, and risks.
- Do not accept vague answers. Probe until the answer is concrete, evidenced, or acknowledged as a gap.
- Prefer evidence over confidence: tests, logs, git diffs, type checks, traces, product requirements, and code references.
- If the user cannot defend an answer, identify the missing test, requirement, design correction, or implementation change.
- Do not create a PR until Critical and Important concerns are resolved, or the user explicitly accepts the risk.
- Be adversarial about the work, not the person. Keep the tone direct, technical, and useful.

## Superpowers Integration

When Superpowers skills are installed and relevant:

- For new features, bug fixes, refactors, and behavior changes, require `test-driven-development` before implementation: RED, verify failing for the right reason, GREEN, verify passing, then refactor.
- For completed work with a diff, run or request `requesting-code-review` before the final grill when the change is substantial or PR-bound.
- After structured review, use this skill to interrogate the author interactively: why this design, why these tests, what breaks, what was intentionally not handled.
- When reviewer feedback exists, apply `receiving-code-review`: verify feedback against the codebase before accepting it, push back with technical evidence when it is wrong, and implement one item at a time.
- Before claiming done, apply verification discipline: run the smallest relevant tests, linters, type checks, or build commands and report what passed or what could not be run.

A good default sequence:

```text
Clarify/Plan -> TDD -> Implement -> Structured Code Review -> Super Grill Me -> PR -> Receive Review
```

## Modes

### A. Code Review Gate (default)

Use when the user says things like:

- "grill me on these changes"
- "don't make a PR until I pass"
- "prove this works"
- "review this before PR"

Workflow:

1. Detect the review base:
   - Prefer the upstream merge base when available.
   - Otherwise use `origin/main`, `origin/master`, `main`, or `master`, whichever exists.
   - If staged changes are the focus, inspect staged changes too.
2. Read the diff and nearby code.
3. Inspect relevant tests and validation commands.
4. Identify risks:
   - unhappy paths
   - missing error handling
   - async/race conditions
   - performance traps
   - security holes
   - data loss or migration risk
   - backward compatibility breaks
   - missing tests
   - unclear naming or abstractions
   - over-engineering or under-engineering
5. Ask 3-5 hard, specific questions.
6. Probe weak answers.
7. Approve only when concerns are resolved or explicitly risk-accepted.

Question style:

- Bad: "Are edge cases handled?"
- Good: "What happens when `fetchUser()` times out after the DB write succeeds but before the event publish? Which test proves that behavior?"

Approval format:

```text
You passed.
Why: [brief technical reason]
Remaining risks: [none / explicit accepted risks]
Next: [create PR / run final verification / fix named gap]
```

### B. Prove It Works

Use when the user asks for proof rather than opinion.

Workflow:

1. Compare behavior between base and current branch when possible.
2. Run the smallest relevant verification commands.
3. Check logs, snapshots, generated output, or local UI behavior when relevant.
4. Tie every claim to evidence.
5. If evidence is missing, state exactly what is still unproven.

Output:

```text
Proven:
- [claim] via [command/test/log/code reference]

Not proven:
- [gap] because [reason]

Questions:
1. [hard question]
```

### C. Elegant Rewrite

Use when the user says things like:

- "scrap this and implement the elegant solution"
- "this works but feels messy"
- "knowing what you know now, simplify it"

Workflow:

1. Identify the root insight that makes the solution simpler.
2. Preserve behavior with tests first. If tests do not exist, add them before rewriting.
3. Remove accidental complexity, legacy cruft, and redundant abstractions.
4. Prefer a smaller design only when it is genuinely clearer and equally correct.
5. Verify tests stay green after each meaningful step.

Heuristic: the elegant solution is often 30-50% less code, but line count is not the goal. Clarity, correctness, and maintainability are the goal.

### D. Spec-Driven Development

Use when requirements are unclear or implementation would be risky without alignment.

Workflow:

1. Ask clarifying questions until requirements are unambiguous.
2. Produce a written spec covering:
   - problem statement
   - inputs and outputs
   - user-visible behavior
   - edge cases
   - constraints
   - non-goals
   - acceptance criteria
   - validation plan
3. Do not begin implementation until the spec is approved, unless the user explicitly asks for a prototype.
4. Once approved, use TDD for behavior changes where practical.

### E. TDD Grill

Use when the implementation claims to be test-driven or when test quality is the main risk.

Ask questions like:

- Which test failed before the production code existed?
- What was the exact failure message during RED?
- Which test proves the unhappy path?
- Are these tests verifying behavior or mocks?
- What regression would these tests catch six months from now?
- What edge case is intentionally untested, and why?

If the user wrote production code before tests for a behavior change, call that out. Recommend adding or rewriting tests so the behavior is proven, and for future work return to RED-GREEN-REFACTOR.

## Review Checklist

- [ ] Does this handle the unhappy path?
- [ ] Are there race conditions, async hazards, retries, or partial-failure states?
- [ ] Is this the right abstraction, or is it over/under-engineered?
- [ ] Will this break callers, API consumers, configs, migrations, or old data?
- [ ] Are there missing tests for new behavior and regressions?
- [ ] Do tests verify real behavior rather than implementation trivia?
- [ ] Is naming clear to someone reading this cold?
- [ ] Could this be materially simpler without losing correctness?
- [ ] Are security, privacy, and permission boundaries preserved?
- [ ] Has the smallest relevant validation actually been run?

## Git Helpers

Useful commands when in a git repository:

```bash
git status --short
git branch --show-current
git merge-base HEAD origin/main
git diff --stat origin/main...HEAD
git diff origin/main...HEAD
git diff --staged
```

Adjust `origin/main` to the actual base branch when needed. Do not assume every repository uses `main`.

## Example

```text
User: grill me on these changes and don't make a PR until I pass your test

Agent:
- Reads git status and diff against the base branch
- Checks relevant tests and validation history
- Finds risky areas
- Asks 4 hard questions

User answers.

Agent:
- Accepts concrete, evidenced answers
- Probes vague answers
- Identifies missing test or design gap when needed

When satisfied:
"You passed. The diff is covered for the main success and failure paths, the risky async case is handled by `retries failed publish` test, and the remaining migration risk is documented. Run final verification, then PR."
```
