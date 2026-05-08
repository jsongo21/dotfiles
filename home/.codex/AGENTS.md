# Global Rules

## Writing & Communication Style
- Never use overused AI phrases: comprehensive, robust, best-in-class, feature-rich, production-ready, enterprise-grade, seamlessly, smoking gun
- No smart quotes, em dashes, double dashes or emojis unless requested
- No sycophancy, marketing speak, or unnecessary summary paragraphs
- Write as an engineer explaining to a colleague, not someone selling a product
- Be direct, concise and specific. If a sentence adds no value, delete it
- Active voice, concrete examples
- Final check: does it sound like a person or Wikipedia crossed with a press release?

## Spelling
**Always use Australian English spelling in all responses, documentation, comments, and code identifiers.**

## Documentation
- Keep signal-to-noise ratio high - preserve domain insights, omit filler and fluff
- Start with what it does, not why it's amazing
- Configuration and examples over feature lists
- "Setup" not "Getting Started with emojis". "Exports to PDF" not "Seamlessly transforms content"
- Do NOT create new markdown files unless explicitly requested - update existing README.md or keep notes in conversation
- Code comments: explain "why" not "what", only for complex logic. No process comments ("improved", "fixed", "enhanced")

## ARCHITECTURE & DESIGN

### Design Principles
- Favour simplicity - start with working MVP, iterate. Avoid unnecessary abstractions and only when a pattern repeats 3+ times
- Follow SOLID principles - small interfaces, composition, depend on abstractions
- Reuse and align with existing components, utilities, and logic where possible
- Use appropriate design patterns (repository, DI, circuit breaker, strategy, observer, factory) based on context
- For greenfield projects: provide a single Makefile entrypoint to lint, test, version, build and run

### Code Quality
- Functions: max 50 lines (split if larger)
- Files: max 700 lines (split if larger)
- Cyclomatic complexity: under 10
- Tests run quickly (seconds), no external service dependencies
- Tests should have assertions and must verify behaviour
- Build time: optimise if over 1 minute
- Coverage: 80% minimum for new code

### Configuration
- Use .env or config files as single source of truth, ensure .env is gitignored
- Provide .env.example with all required variables
- Validate environment variables on startup

## Security
- Never hardcode credentials, tokens, or secrets. Never commit sensitive data
- Never trust user input - validate and sanitise all inputs
- Parameterised queries only - never string concatenation for SQL
- Never expose internal errors or system details to end users
- Follow principle of least privilege. Rate-limit APIs. Keep dependencies updated

## TESTING & QUALITY ASSURANCE

## Error Handling
- Structured logging (JSON) with correlation IDs. Log levels: ERROR, WARN, INFO, DEBUG
- Meaningful errors for developers, safe errors for end users. Never log sensitive data
- Graceful degradation over complete failure. Retry with exponential backoff for transient failures

## Testing
- Test-first for bugs: write failing test, fix, verify, check no regressions
- Descriptive test names. Arrange-Act-Assert pattern. Table-driven tests for multiple cases
- One assertion per test where practical. Test edge cases and error paths
- Mock external dependencies. Group tests in `test/` or `tests/`

## LANGUAGE SPECIFIC RULES

### TypeScript
- Prefer TypeScript over JavaScript. Strict mode always
- Avoid `any` (use `unknown`), prefer discriminated unions over enums, `readonly` for immutables
- Const by default, async/await over promise chains, optional chaining and nullish coalescing
- Never hardcode styles - use theme/config

### Bash
- `#!/usr/bin/env bash` with `set -euo pipefail`
- Quote all variable expansions. Use `[[ ]]` for conditionals. Trap for error handling

## Tool Usage

### CLI Commands
- Always quote all paths in bash commands
- Prefer tools with minimal output unless stdout is needed

### Tool Priorities
- Use purpose-built tools over manual approaches
- Search documentation before making assumptions - don't guess
- Delegate to sub-agents in parallel where possible, instruct them to return only key information

### Code Intelligence
- Use available navigation tools to jump to definitions and find references before editing
- Before changing a function signature, find all usages to understand the blast radius
- Use search only for text/pattern searches (comments, strings, config values) where navigation tools don't help

### Sub-agent Coordination
- Sub-agents have their own context window - good for parallel research, inspection, or separate features
- Define clear boundaries per agent. Specify which files each agent owns
- Include "you are one of several agents" in instructions
- Set explicit success criteria. Combine small updates to prevent over-splitting
- Sub-agents can compete and erase each other's changes - ensure no overlap
- Only use agent teams when the user has explicitly requested it

## Self-Review Protocol
After implementing a list of changes, perform a critical self-review pass before reporting completion, fixing any issues you find.

## Rules

**Before declaring any task complete, verify**: linting passes, code builds, all tests pass (new + existing), no debug statements remain, error handling in place.

- Never perform git add/commit/push operations
- Never hardcode credentials, unique identifiers, or localhost URLs
- Never give time estimates for tasks
- Never add process comments ("improved function", "optimised version", "# FIX:")
- Never implement placeholder or mocked functionality unless explicitly instructed
- Never build or develop for Windows unless explicitly instructed
- Edit only what's necessary - make precise, minimal changes unless instructed otherwise
- Implement requirements in full or discuss with the user why you can't - don't defer work
- If stuck on a persistent problem after multiple attempts, perform a systematic Fagan inspection before trying another fix
- When contributing to open source: match existing code style, read CONTRIBUTING.md first, no placeholder comments
- **You must not state something is fixed unless you have confirmed it by testing, measuring output, or building the application**
