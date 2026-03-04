---
name: pr-description
description: Write a PR description for the current branch. Use when the user asks for a PR description, PR summary, or pull request description.
disable-model-invocation: true
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
**<Short title summarising what the PR does>**

<1-2 sentence summary of what the PR does and why.>

**Changes**
- `path/to/file` -- what changed and why
- (one bullet per file or logical group of changes)

**Notes**
- Any caveats, follow-up work, known limitations, or reviewer callouts
- Omit this section if there is nothing worth noting
```

## Style rules

- Always output the description inside a markdown code block (` ```markdown `) so it can be copied directly
- Title: plain bold text, no emoji, under 70 characters, imperative mood
- No marketing language, no filler sentences
- "Notes" section is optional -- only include it if there is something meaningful to flag
- Use Australian English spelling
- Be direct and specific -- say what changed and why, not just what the files are called
