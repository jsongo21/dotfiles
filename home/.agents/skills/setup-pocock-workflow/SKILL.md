---
name: setup-pocock-workflow
description: "Add the issue-first Development Workflow block to a repo's AGENTS.md/CLAUDE.md. Run after /setup-matt-pocock-skills."
disable-model-invocation: true
---

# Setup Pocock Workflow

`/setup-matt-pocock-skills` writes the tracker, label and domain pointers but no rule saying work flows through them. This skill adds that rule.

## Process

1. **Precondition.** `docs/agents/issue-tracker.md` exists. If it does not, tell the user to run `/setup-matt-pocock-skills` first, then stop.

2. **Pick the file.** The one holding the `## Agent skills` block: `CLAUDE.md` if it has one, else `AGENTS.md`. Never create the other.

3. **Draft the block.** Use the template below. Drop step 5 when `docs/agents/triage-labels.md` is absent (no `triage` skill). Say "closes it" instead of `Closes #N` when the tracker is not GitHub. Keep any existing test or review guidance from the repo's current workflow section inside step 4.

4. **Confirm.** Show the user the draft and the target section; let them edit.

5. **Write.** Update an existing `## Development Workflow` section in place (match on its opening "Every change starts as" sentence), otherwise add the section directly after `## Agent skills`. Leave every other section untouched.

## Template

```markdown
## Development Workflow

Work follows Matt Pocock's skills. Every change starts as an issue in the repo's tracker (`docs/agents/issue-tracker.md`) before any branch or code, and its PR says `Closes #N`.

1. **Sharpen:** `grilling` + `domain-modeling` for an unclear idea.
2. **Spec:** `to-spec` turns the settled conversation into a spec issue labelled `ready-for-agent`; agree the test seams with the user first.
3. **Tickets:** `to-tickets` splits the spec into tracer-bullet issues with blocking edges; check granularity with the user before publishing. A wide mechanical refactor (rename, folder move) goes expand-contract instead.
4. **Build:** `implement` runs `tdd` at the agreed seams (failing test first, then the fix), then `code-review` before telling the user it's done. `implement-spec` builds a whole spec on an integration branch but spawns subagents, so ask first.
5. **Incoming issues:** `triage`.

A small change needs only its issue; spec and tickets are for work spanning several slices.
```
