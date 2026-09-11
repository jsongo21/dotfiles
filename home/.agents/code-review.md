# Code Review Guidelines (generic template)

A reviewer (human or agent) checks a change against the rules below. Every
rule has a stable ID and a severity: **blocking** (must be fixed before
merge) or **advisory** (should fix; author may defer with a stated reason).
Findings cite `file_path:line` and the rule ID (e.g. `DRY-1`), and carry the
rule's severity.

This is a generic, language-agnostic starting point — copy it into a
project, then fill in the bracketed placeholders with that project's real
tools, conventions, and past incidents. A review guide grounded in a real
repo's actual stack and scars is far more useful than this generic version
left as-is; treat this as a skeleton to adapt, not a finished checklist.

## Always check first

The checks that pay for the whole review — run them on every PR before
anything else. Fill these in per-project; keep it to 4-6 items, the highest-
signal checks for that codebase specifically.

1. **DRY-1** — does anything added already exist? (`[where to search — a
   symbol index, a shared utils module, grep the obvious place first]`)
2. **[PROJECT-SPECIFIC]** — the one class of bug this codebase has shipped
   more than once (e.g. an error-handling pattern that crashes a shared
   process, an unbounded query, a missing auth check).
3. **TEST-1** — is new non-trivial logic covered by a test, not just the
   happy path?
4. **CI-1** — does a new dependency get declared everywhere it needs to be
   (lockfile, CI config, deploy manifest)?
5. **SAFE-3** — no secrets, credentials, or config committed in code or test
   fixtures?
6. **KISS-1** — does the diff reach for a new dependency or abstraction
   where an existing one, or a few more lines, would do?

## How to write findings — reviews are for HUMANS

Review output is read by a **human being**, not another agent. Write
findings the way you'd explain them to someone at their desk:

- **Lead with why it matters.** Open every finding with the consequence
  ("This crashes the whole process on the next transient error, not just
  the one request…", "Running this twice silently duplicates every row…"),
  *then* the code detail and the fix. A finding whose impact isn't stated in
  its first sentence isn't finished.
- **Easy to read beats dense.** Plain sentences, one finding per bullet, no
  jargon chains. If the author has to re-read a finding to understand it,
  rewrite the finding.
- **MANDATORY finding format (violating this is itself a review defect):**
  1. First line: **bold one-sentence takeaway** stating the consequence,
     plus `RULE-ID · severity`.
  2. Then 2-4 short bullets, one idea each: the mechanism, the evidence
     (file:line), the fix direction.
  3. A ```suggestion block when the fix is a small patch.
  4. Hard cap ~100 words of prose per finding.
  No paragraphs over 2 sentences. No em dashes.
- **Skimmable overall.** Order findings by severity — blocking first, then
  advisory — and verify each against the actual code before reporting. No
  speculative findings.

## 0. Scope & Altitude
- **SCOPE-1 · advisory** — Review only the diff and code it directly
  affects. Don't propose repo-wide refactors in a review.
- **SCOPE-2 · advisory** — Match the conventions of the surrounding file
  over personal preference.
- **SCOPE-3 · blocking** — **One concern per PR.** An unrelated change mixed
  into a feature diff belongs in its own PR/commit.

## 1. DRY / Reuse
- **DRY-1 · blocking** — **Do not duplicate existing functionality.** Before
  adding a new helper/service/util, confirm an equivalent doesn't already
  exist. `[name the project's actual reuse index / shared-utils location]`
- **DRY-2 · blocking** — **A change to shared logic lands everywhere it's
  owed.** If a function has multiple callers, a fix to one caller's handling
  that isn't reflected in the shared function itself is a finding.
- **DRY-3 · advisory** — New instances of an existing pattern (a new
  provider, a new route, a new handler) mirror the established shape rather
  than inventing a bespoke one — ask why the existing pattern doesn't fit
  before accepting a one-off.
- **DRY-4 · advisory** — Code lives with its domain — a helper used by one
  module lives near that module, not in a generic catch-all file.

## 2. Project Structure
- **STRUCT-1 · advisory** — New code goes where the project's existing
  layout expects it (`[name the project's actual directory conventions]`).
- **STRUCT-2 · advisory** — Tests live alongside/adjacent to the code under
  test, following the project's existing test-file naming convention.
- **STRUCT-3 · blocking** — Generated/vendored files are never hand-edited
  — `[name the project's actual generated-file locations and regen command,
  if any]`.

## 3. Interfaces / Handlers
- **HANDLER-1 · advisory** — An entry point (route handler, CLI command,
  event handler) stays **thin**: parse input, delegate to business logic,
  return/emit the result. Business logic doesn't live inline in the
  entry point.
- **HANDLER-2 · blocking** — **Every entry point that touches sensitive data
  or has side effects is gated** by the project's actual auth/permission
  mechanism, declared at the entry-point boundary (a decorator, a
  dependency, a middleware) — not a manual check buried in the function body
  that's easy to forget on the next one.
- **HANDLER-3 · advisory** — A bulk/multi-item action reports partial
  success/failure per item rather than aborting the whole batch on the
  first error.

## 4. Language Quality
- **LANG-1 · advisory** — No unused imports, variables, or parameters.
- **LANG-2 · blocking** — **No swallowed exceptions/errors.** Catching an
  error and silently continuing hides real failures — handle it
  meaningfully or let it propagate.
- **LANG-3 · blocking** — **Errors in code reachable from a long-running
  process (a server, a worker) never crash the whole process on one bad
  request.** Raise/return an error the caller can handle; reserve
  process-exiting calls for actual CLI entry points, never for a shared
  library function.
- **LANG-4 · advisory** — Honest signatures/types — a function's declared
  return type/nullability matches what it actually does.
- **LANG-5 · advisory** — No dead or speculative code — unused fields,
  helpers, or config keys get removed, not left "for later."

## 4b. Comment Hygiene
- **COMMENT-1 · advisory** — A comment explains the code in its own file,
  not another file's behaviour or a feature's history.
- **COMMENT-2 · advisory** — Docstrings/comments state the contract and
  non-obvious constraints briefly; longer belongs in a doc, not the code.
- **COMMENT-3 · advisory** — No narration comments restating what the code
  obviously does — a comment earns its place by explaining *why*.

## 4c. KISS — over-engineering and risk surface
- **KISS-1 · blocking** — **New dependencies need a real justification** —
  state why the standard library or an existing dependency can't do it.
- **KISS-2 · advisory** — **Flag speculative abstractions.** An
  interface/base class/config knob with exactly one implementation/consumer
  and no concrete second use is a finding.
- **KISS-3 · advisory** — **Flag risky high-surface-area diffs.** A change
  touching many unrelated files when a narrower one would do is itself a
  finding.
- **KISS-4 · blocking** — **Bulk/destructive actions default to
  preview/dry-run**, requiring an explicit opt-in flag to actually write or
  delete.

## 5. Correctness & Safety
- **SAFE-1 · blocking** — External input is validated before use.
- **SAFE-2 · blocking** — Calls to external services/APIs handle non-2xx/
  error responses explicitly — no assuming success.
- **SAFE-3 · blocking** — No secrets, API keys, or credentials committed in
  code, tests, or fixtures — environment variables or a secrets manager
  only.
- **SAFE-4 · blocking** — Secret/password/token equality checks use a
  constant-time comparison, not `==`.
- **SAFE-5 · advisory** — A data store used for anything write-more-than-once
  to the same logical key has a real uniqueness constraint, and the write
  path uses an actual upsert — a plain insert on a re-runnable script
  duplicates rows.

## 6. Observability
- **OBS-1 · advisory** — A script/job prints a clear success/failure summary
  — silent success is as bad as silent failure in a log stream.
- **OBS-2 · advisory** — A step that can fail transiently either fails
  loudly or explicitly marks itself non-blocking with a stated reason — no
  silent swallow that leaves the next person guessing.

## 7. Tests & PR Hygiene
- **TEST-1 · blocking** — New non-trivial logic ships with a test in the
  same PR, not as a follow-up.
- **TEST-2 · blocking** — Tests exercise the logic itself, not live
  third-party calls — mock/stub external dependencies; a test that needs
  real credentials to pass doesn't belong in the test suite.
- **TEST-3 · blocking** — A refactor that extracts shared logic out of an
  existing caller is re-verified against that caller's original real output
  before/after — "the new caller works" doesn't prove the old one still
  does.
- **TEST-4 · advisory** — Every test gets a fresh instance of any stateful
  test double/fixture rather than a shared one — shared mutable test state
  can silently leak between test cases.
- **TEST-5 · advisory** — No throwaway/prototype scripts committed without a
  real docstring/README entry explaining what they're for.

## 8. Data Modeling
- **DATA-1 · blocking** — A table/collection that the app upserts into has a
  real uniqueness constraint matching the conflict-resolution key used in
  code.
- **DATA-2 · advisory** — A new query pattern gets an index if the
  table/collection can grow past a trivial size.
- **DATA-3 · advisory** — Data meant to be user-editable lives in the actual
  writable store, not a file the app reads once and never writes back to —
  mixing "editable at runtime" and "source of truth is a static file" for
  the same entity is a bug waiting to happen.

## 9. CI & Automation
- **CI-1 · blocking** — A new dependency added while developing locally is
  also declared wherever CI/deploy actually installs dependencies from — a
  change that works locally but fails in CI because a dependency was never
  declared is one of the most common self-inflicted CI failures.
- **CI-2 · advisory** — A scheduled job that calls an external service on
  every run is justified against its actual freshness need — not everything
  needs to run as often as it currently does.
- **CI-3 · blocking** — Changes to CI/workflow config files are validated
  (parsed, linted) before being considered done — a broken config file often
  fails silently until the next scheduled run.
