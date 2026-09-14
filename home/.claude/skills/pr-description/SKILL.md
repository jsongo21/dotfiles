---
name: pr-description
description: Write a PR description for the current branch. Use when the user asks for a PR description, PR summary, or pull request description.
argument-hint: [base-branch]
---

# PR Description

Write a pull request description for the current branch.

The base branch is `$ARGUMENTS` if provided, otherwise default to `master`.

## Steps

1. Run the following to understand the branch:
   - `git log <base>..HEAD --oneline` to see all commits
   - `git diff <base>...HEAD` to see the full diff

2. Analyse the changes and write a description with this structure:

```
## Summary

<1 sentence summary of what the PR does.>

### Why

<1-3 sentences on the problem or need driving this change -- the bug, the request, the constraint. Omit if the Summary sentence already fully covers it.>

### Changes

- Keep to 3-5 dot points max. One point per logical change, not per file
- Group related changes aggressively -- if 10 files got the same kind of change, that is one dot point

### Visuals

- A diagram when it clarifies a flow, architecture, or before/after shape better than prose -- e.g. Mermaid `flowchart`/`sequenceDiagram` for request flows, dispatch/registry restructures, or state transitions
- Omit this section if a diagram wouldn't add anything beyond the Changes bullets

### Notes

- Any caveats, follow-up work, known limitations, or reviewer callouts
- Omit this section if there is nothing worth noting

### Screenshots

- Omit this section if there are no UI changes
```

3. When creating or updating the PR, assign it to the authenticated GitHub user:

```bash
gh pr edit <number> --add-assignee @me
```

If the PR has just been created, capture its number or URL first, then run the
assignment command. Confirm the assignee in the final response.

4. When writing a temporary Markdown body for `gh pr create` or `gh pr edit`,
   verify that the file begins with `## Summary` before submitting it. If using
   `apply_patch` to create the file, the patch prefix is not body content: add
   exactly one patch `+` marker per line, so the file itself never starts with
   a literal `+`.

## Style rules

- No bold title -- the summary sentence is the opener, nothing before it
- Use `-` for all bullet levels, never `*`. Do not list individual files -- summarise the changes at a higher level
- No marketing language, no filler sentences
- "Why", "Visuals", "Notes" and "Screenshots" are all optional -- only include a section if it earns its place
- Use Australian English spelling
- Be direct and specific -- say what changed and why, not just what the files are called
