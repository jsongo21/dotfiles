---
name: setup-pocock-workflow
description: "Add the issue-first Development Workflow block to a repo's AGENTS.md/CLAUDE.md. Run after /setup-matt-pocock-skills."
disable-model-invocation: true
---

# Setup Pocock Workflow

`/setup-matt-pocock-skills` writes the tracker, label and domain pointers but no rule saying work flows through them. This skill adds that rule, following the main flow (idea to ship) from Matt Pocock's `ask-matt` skill.

## Process

1. **Precondition.** `docs/agents/issue-tracker.md` exists. If it does not, tell the user to run `/setup-matt-pocock-skills` first, then stop.

2. **Pick the file.** The one holding the `## Agent skills` block: `CLAUDE.md` if it has one, else `AGENTS.md`. Never create the other.

3. **Draft the block.** Use the template below. Drop the `triage` line in step 6 when `docs/agents/triage-labels.md` is absent (no `triage` skill). Say "closes it" instead of `Closes #N` when the tracker is not GitHub. Keep any existing test or review guidance from the repo's current workflow section inside step 4.

4. **Confirm.** Show the user the draft and the target section; let them edit.

5. **Write.** Update an existing `## Development Workflow` section in place (match on its opening "Every change starts as" sentence), otherwise add the section directly after `## Agent skills`. Leave every other section untouched.

## Template

```markdown
## Development Workflow

Work follows Matt Pocock's skills (`/ask-matt` routes between them). Every change starts as an issue in the repo's tracker (`docs/agents/issue-tracker.md`) before any branch or code, and its PR says `Closes #N`.

1. **Sharpen:** `grill-with-docs` interviews the user and keeps `GLOSSARY.md` and ADRs current. Use `grill-me` only when there is no repo to write to.
2. **Prototype (if needed):** a question that needs a runnable answer (state, business logic, a UI to see) goes through `handoff` out, `prototype`, then `handoff` back with what was learned.
3. **Spec and tickets (multi-session work):** `to-spec` turns the settled conversation into a spec issue; agree the test seams with the user first. `to-tickets` splits it into tracer-bullet issues with blocking edges; check granularity with the user before publishing. A wide mechanical refactor (rename, folder move) goes expand-contract instead. A greenfield effort too big for one session starts at `wayfinder`, which hands off to `to-spec`.
4. **Build:** `implement` runs `tdd` at the agreed seams (failing test first, then the fix), then `code-review` before telling the user it's done. Run `implement` per ticket and `/clear` between tickets. `implement-spec` builds a whole spec on an integration branch but spawns subagents, so ask first. Single-session work skips step 3 and runs `implement` in the same context.
5. **PR:** `pr` shapes the body: the smallest visual that shows the change, before/after evidence, and a one-way or two-way door call.
6. **Close the loop:** `retro` suggests improvements to the agent's environment. Other entry points: `triage` for issues the user did not create (never for `to-tickets` output), `diagnosing-bugs` for a hard or intermittent bug.

Keep steps 1-3 in one unbroken context window; do not clear or compact until after `to-tickets`. A small change needs only its issue; spec and tickets are for work spanning several slices.
```
