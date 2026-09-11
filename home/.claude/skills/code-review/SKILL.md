---
name: code-review
description: Use this skill after completing multiple, complex software development tasks before informing the user that work is complete.
---

# Guidelines For Performing Code Reviews After Completing Multiple Complex Software Development Tasks

0. **Find the rule set before spawning anything.** Check, in order, for a project-specific review guide:
   - `review.md` or `code-review.md` at the repo root
   - `docs/review.md` or `docs/code-review.md`
   If none exists, fall back to the generic template at `~/.agents/code-review.md`. Either way, read whichever file you find — its rule IDs and severities are what sub-agents check the diff against, not an ad-hoc list you invent per review. If the generic fallback is used and the project has an obvious stack/conventions, consider copying it to the project root and filling in the bracketed placeholders (see the template's own instructions) as part of this review, rather than leaving every future review to fall back again.
1. Spawn parallel sub-agents with tasks to perform a critical self-review of the changes you've made, each given the review guide's content (or the relevant sections of it) as their ruleset.
2. Compile findings into a concise numbered list, citing the rule ID and severity from the guide (e.g. `DRY-1 · blocking`) rather than an invented ad-hoc severity label.
3. Verify each finding against actual code (no false positives)
4. Implement all fixes and run the appropriate lint/test/build pipeline

If you get stuck on any especially complex or recurring issue consider using the systematic debugging skill to investigate further and unblock yourself.

## Sub Agent Guidelines

- Give each sub-agent the review guide (or its relevant sections) directly in the prompt — don't make them go find it themselves, and don't let them invent their own rules in its absence.
- Instruct sub-agents to keep outputs concise, token-efficient, relevant and actionable focused on your changes and not to nitpick on minor style issues.
- Provide concise relevant context to the sub-agents to help them understand the context of the changes they are reviewing but avoid wasting lots of tokens on context they can infer from the code itself.
- Appropriately scope the review to your changes with clear boundaries.
- Follow the review guide's own "how to write findings" section for format — most guides mandate a specific structure (consequence-first, rule ID, severity, evidence, fix) rather than a free-form bullet.
