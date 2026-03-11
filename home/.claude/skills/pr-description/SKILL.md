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

<1 sentence summary of what the PR does and why.>

### Changes

- `path/to/file`
  - detail about what changed
  - another detail if needed

### Notes

- Any caveats, follow-up work, known limitations, or reviewer callouts
- Omit this section if there is nothing worth noting

### Screenshots

- Omit this section if there are no UI changes
```

## Style rules

- Output the description inside a plain fenced code block (triple backticks with no language hint)
- No bold title -- the summary sentence is the opener, nothing before it
- File names as top-level `-` bullets, sub-details as indented `-` bullets under each file. Use `-` for all bullet levels, never `*`
- No marketing language, no filler sentences
- "Notes" section is optional -- only include it if there is something meaningful to flag
- Use Australian English spelling
- Be direct and specific -- say what changed and why, not just what the files are called
