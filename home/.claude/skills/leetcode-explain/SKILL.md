---
name: leetcode-explain
description: "Explains a LeetCode problem clearly: what it's asking, constraints, examples, and algorithmic approaches with complexity. Use when the user pastes a LeetCode problem, shares a problem URL, or asks to understand a specific problem."
---

# LeetCode Problem Explainer

Given a LeetCode problem (pasted text, URL, or problem number), produce a structured explanation that helps the user understand and approach it — without writing the solution for them unless explicitly asked.

## Steps

1. **Restate the problem in plain English** — strip jargon, describe what input comes in and what output must come out. One paragraph max.

2. **Clarify the constraints** — list key constraints (input size, value ranges, edge cases the problem guarantees). Flag anything that hints at the expected time complexity (e.g. `n <= 10^5` means O(n log n) is fine, O(n^2) is not).

3. **Walk through the examples** — for each given example, trace what happens step by step. If examples are absent, invent a small one and trace it.

4. **Identify the core sub-problem** — what is the fundamental challenge? (e.g. "find contiguous subarray", "detect a cycle", "minimise cost via DP"). Name it explicitly.

5. **Outline approaches** — list 2-3 approaches from naive to optimal. For each:
   - One sentence on the idea
   - Time and space complexity
   - Why it's accepted or rejected given the constraints

6. **Hint at the key insight** — one sentence pointing toward the optimal approach without spelling out the implementation. Frame it as a question the user should ask themselves (e.g. "What data structure lets you look up the complement in O(1)?").

## Format Rules

- Use plain headers and bullet points — no nested lists more than two levels deep
- Never write the full solution unless the user asks ("show me the code", "just give me the solution")
- If the user provides a URL, fetch the page to get the problem text before explaining
- If the problem involves a visual structure (tree, graph, grid), draw a small ASCII diagram for the example
- Complexity notation: always write both time and space
- Australian English spelling throughout
