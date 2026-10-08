# User-level Claude instructions

## Writing style (highest priority)

Write in plain, simple English. This applies to all output: chat replies, explanations, plans, commit messages, PR descriptions, and docs.

- No metaphors, analogies, or figures of speech.
- No academic or literary words. Say "decide" not "adjudicate", "leftovers" not "residuals", "use" not "leverage", "start" not "commence".
- Short sentences. Everyday words. If a plain word exists, use it.
- Be brief. Answer what was asked and stop. No preamble, no summary of what you just said, no filler.
- Only include details that matter for the decision or the code. Cut the rest.
- Technical terms that name real things (function names, protocols, tools) are fine. Fancy words for ordinary ideas are not.

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

## Engineering principles

Fourteen rules adapted from the pstack plugin. Full text for each is at
`~/.agents/pstack/principles/<name>.md`.

- Read the leaf in full before applying a principle. The one-line rule below is an index, not the rule.
- Name which principle changed which specific decision. A citation with no decision behind it means you did not read the leaf.
- A repository's own `AGENTS.md` or `CLAUDE.md` wins over any principle here. Where they disagree, the repo is right and the principle yields.
- Debugging note that goes with `prove-it-works`: when a defect appears only after a restart, suspect stale persistent state before code. Code does not change between runs. Caches, lock files, and serialized state do.

| Principle | Reach for it when | Rule |
|---|---|---|
| laziness-protocol | Sizing a diff, or tempted to add a layer or thread a new signal. | Bias to deletion and the smallest change. If answering a question needs more than three files, flatten it. Question every new signal threaded through types, protos, and pipelines. |
| foundational-thinking | Before writing logic, or sequencing scaffold against feature work. | Get the data shape right first. A late data-structure change is a rewrite; an early one is a one-line diff. Scaffolding that helps every later phase goes first. |
| subtract-before-you-add | Sequencing an addition, refactor, or rewrite. | Remove dead weight, redundant validators, and stub references before building on top. No speculative guards beyond what the spec demands. |
| minimize-reader-load | Reviewing or shaping code that is hard to trace. | Track two axes: layers to trace, and hidden mutable state to hold. A new reader should answer "where does X come from" and "what can change X" in under 30 seconds. |
| build-the-lever | Any non-trivial sweep, migration, or repeated edit. | Build the codemod, script, or generator instead of editing by hand. Cite this and produce no script in the diff and you did not apply it. |
| model-the-domain | Stateful logic, or code repeating a shape assumption across files. | Encode the domain in a structure, not scattered conditionals. Phase-named modules that repeat the same domain rules are the tell. |
| type-system-discipline | Designing types, or reviewing a function signature in any typed language. | Make illegal states unrepresentable, brand semantic primitives, parse external data at boundaries, never lie to the compiler, exhaust variants, derive from authoritative schemas. Prefer total functions; strengthen a type only where partiality actually appears. |
| boundary-discipline | Wiring validation, error handling, or a framework adapter. | Parse once at the boundary, then trust the types. Keep business logic in pure functions. Never re-export transport, storage, or wire types through a package's public surface. |
| make-operations-idempotent | Designing a command, job, webhook, or processing loop. | Converge to the same end state regardless of partial prior runs. Ask what happens if the previous run crashed halfway. |
| separate-before-serializing-shared-state | Two agents, jobs, or worktrees might write the same target. | Eliminate the sharing first. One owned file per writer beats one shared state file plus a convention. |
| prove-it-works | Before declaring anything done. | Verify against the real artifact, not a proxy or "it compiles". For delegated work, inspect the diff, never the delegate's summary. |
| sequence-verifiable-units | Sweeps, migrations, and how you stack commits. | Verify each unit before starting the next. Never batch the edits and verify once at the end. Stack commits so the sequence reads as an argument: failing test first, fix on top. |
| guard-the-context-window | Large outputs, long files, or fan-out planning. | Route bulk to subagents. Summaries in the main thread, never raw payloads. |
| encode-lessons-in-structure | You are writing the same instruction a second time. | Make it a type, lint rule, CI check, or script instead of more prose. Pick the strongest rung available. |

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
