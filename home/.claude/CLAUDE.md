# Important Guidelines and Rules
## Language & Communication
<WRITING_STYLE note="IMPORTANT">
    <AVOID_AI_CLICHES>
    - **You must NEVER use overused AI phrases especially those that are not quantifiable or measurable such as: comprehensive , robust , best-in-class , feature-rich , production-ready , enterprise-grade**
    - NEVER write with smart quotes or em dashes
    - Avoid excessive bullet points with bolded headers
    - No unnecessary summary paragraphs and other fluff
    - Do engage in sycophantic or obsequious communication
    - Do not write content that could be interpreted as marketing or hype and do not use overly enthusiastic or self-congratulatory language
    </AVOID_AI_CLICHES>
    <WRITE_NATURALLY>
    - Write as if you're a knowledgeable engineer explaining to a colleague, do not write someone selling a product
    - Be direct, concise and specific, not vague and grandiose
    - Use active voice and concrete examples
    - If a sentence adds no value, delete it!
    </WRITE_NATURALLY>
</WRITING_STYLE>
<SPELLING_AND_LOCALISATION note="IMPORTANT">
  <IMPORTANT note="This is VERY important">**CRITICAL: YOU MUST ALWAYS USE INTERNATIONAL / AUSTRALIAN ENGLISH SPELLING FOR ALL RESPONSES, DOCUMENTATION, COMMENTS, DEFINITIONS AND FUNCTION NAMES. DO NOT USE AMERICAN SPELLING.**</IMPORTANT>
  <AUSTRALIAN_ENGLISH_RULES>
    - ALWAYS ensure consistent use of Australian English in all your interactions, ***AUSTRALIAN ENGLISH SPELLING MUST BE USED IN ALL WRITING!***
    - Look out for Z's when there should be S's
    - Using American spelling makes users sad, confused, frustrated and disappointed in your performance
    <KEY_PATTERNS>
        You must follow these Australian English spelling and usage rules during all your task, e.g:
        1. Use -our instead of -or (colour, favour, behaviour)
        2. Use -ise/-yse instead of -ize/-yze (organise, analyse, optimise)
        3. Use -re instead of -er (centre, metre, theatre)
        4. Use -ogue instead of -og (catalogue, dialogue, analogue)
        5. Use -ae/-oe instead of -e (anaemia, oesophagus)
        6. Use -ll- instead of -l- (travelled, cancelled, modelling)
        7. Use -t instead of -ed for certain past tense (learnt, dreamt, spelt)
        8. Use -ence instead of -ense for nouns (defence, licence, offence)
        9. Use British vocabulary (mum, aeroplane, autumn, lift, boot)
    </KEY_PATTERNS>
  </AUSTRALIAN_ENGLISH_RULES>
  <FINAL_CHECK>
    Before completing a task, verify: Did I use Australian English spellings?
  </FINAL_CHECK>
</SPELLING_AND_LOCALISATION>
<DOCUMENTATION_STANDARDS>
    - IMPORTANT: When writing any form of documentation one of your primary goals is to avoid signal dilution, context collapse, quality degradation and degraded reasoning for future understanding of the project by ensuring you keep the signal to noise ratio high and that domain insights are preserved while not introducing unnecessary filler or fluff in documentation.
  <TECHNICAL_DOCS>
    - Start with what it does, not why it's amazing
    - Configuration and examples over feature lists
    - "Setup" not "🚀 Getting Started"
    - "Exports to PDF" not "Seamlessly transforms content"
    - Include concrete examples for major features
    - Document the "why" only for non-obvious decisions
    - Aim to keep README files under 500 lines
    - **You must **NOT** create new markdown documentation files (implementation notes, usage guides, troubleshooting docs, changelogs, etc. other than a development plan document if you're working from one) unless explicitly requested - update existing README.md instead (if you need to) or keep notes in conversation.**
  </TECHNICAL_DOCS>

  <CODE_COMMENTS>
    - Only comment complex logic that cannot be inferred
    - Never add process comments ("improved", "fixed", "enhanced")
    - Explain "why" not "what" for business logic
    - Use function/variable names that eliminate need for comments
  </CODE_COMMENTS>
</DOCUMENTATION_STANDARDS>

## ARCHITECTURE & DESIGN

<CORE_DESIGN_PRINCIPLES>
  <SIMPLICITY_FIRST>
    - **CRITICAL**: Favour elegance through simplicity - "less is more"
    - Start with working MVP, iterate improvements
    - Avoid premature optimisation and over-engineering
    - Use abstraction only when pattern repeats 3+ times
    - Each iteration should be functional and tested
  </SIMPLICITY_FIRST>

  <SOLID_PRINCIPLES>
    - Single Responsibility: One reason to change
    - Open/Closed: Extend without modifying
    - Liskov Substitution: Subtypes must be substitutable
    - Interface Segregation: Many specific interfaces
    - Dependency Inversion: Depend on abstractions
  </SOLID_PRINCIPLES>

  <DESIGN_PATTERNS>
    - Repository pattern for data access
    - Dependency injection for testability
    - Circuit breaker for external services
    - Strategy pattern for swappable algorithms
    - Observer pattern for event systems
    - Factory pattern for complex object creation
    - When creating a project greenfields provide a single Makefile entrypoint to lint, test, version, build and run the application
  </DESIGN_PATTERNS>
</CORE_DESIGN_PRINCIPLES>

<CODE_QUALITY_METRICS>
- Functions: Max 50 lines (split if larger)
- Files: Max 700 lines (split if larger)
- Cyclomatic complexity: Under 10
- Test execution: Test run quickly (a few seconds ideally) and do not rely on external services
- Build time: Optimise if over 1 minute
- Code coverage: 80% minimum for new code
</CODE_QUALITY_METRICS>

<CONFIGURATION_MANAGEMENT>
- ALWAYS use .env or config files as single source of truth and ensure .env files are gitignored
- Provide .env.example with all required variables
- Validate environment variables on startup
- Group related configuration together
</CONFIGURATION_MANAGEMENT>

## TESTING & QUALITY ASSURANCE

<SOFTWARE_TESTING_PRACTICES>
  <TESTING_WORKFLOW>
    1. Write failing test for bugs (test-first)
    2. Fix the bug
    3. Verify test passes
    4. Check no other tests broken
    5. Only then declare fixed
  </TESTING_WORKFLOW>

  <TEST_STANDARDS>
    - Descriptive test names explaining what and why
    - Arrange-Act-Assert pattern
    - One assertion per test where practical
    - Use table-driven tests for multiple cases
    - Mock external dependencies where appropriate
    - Test edge cases and error paths
    - Group all tests in a common location (e.g. `test/` or `tests/`)
  </TEST_STANDARDS>
</SOFTWARE_TESTING_PRACTICES>

<VERIFICATION_CHECKLIST>
Before declaring any task complete:
- [ ] Linting passes with no warnings or errors
- [ ] Code builds without warnings
- [ ] All tests pass (new and existing)
- [ ] No debug statements or console.log remain
- [ ] Error cases and logging handled appropriately
- [ ] Documentation updated if needed
- [ ] Performance impact considered
- [ ] Security implications reviewed
</VERIFICATION_CHECKLIST>

## SECURITY & ERROR HANDLING

<SECURITY_STANDARDS>
  <CRITICAL_SECURITY>
    - NEVER hardcode credentials, tokens, or secrets
    - NEVER commit sensitive data
    - NEVER trust user input - always validate
    - NEVER use string concatenation for SQL
    - NEVER expose internal errors to users
  </CRITICAL_SECURITY>

  <SECURITY_PRACTICES>
    - Validate and sanitise all inputs
    - Use parameterised queries/prepared statements
    - Implement rate limiting for APIs
    - Follow principle of least privilege
    - Hash passwords appropriately
    - Keep dependencies updated
    - Scan for vulnerabilities
  </SECURITY_PRACTICES>
</SECURITY_STANDARDS>

<ERROR_HANDLING>
  <ERROR_STRATEGY>
    - Return meaningful errors for developers, safe errors to end users
    - Log errors with context
    - Make use of error boundaries where applicable
    - Implement retry logic with exponential backoff
    - Graceful degradation over complete failure
    - Never expose system internals in errors
  </ERROR_STRATEGY>

  <LOGGING_STANDARDS>
    - Use structured logging (JSON)
    - Include correlation IDs for tracing
    - Log levels: ERROR, WARN, INFO, DEBUG
    - Never log sensitive data
    - Include timestamp, service, and context
    - Avoid excessive logging in production
  </LOGGING_STANDARDS>
</ERROR_HANDLING>

## LANGUAGE SPECIFIC RULES
<JAVASCRIPT_TYPESCRIPT>
  <TS_STANDARDS>
    - Prefer TypeScript over JavaScript
    - Use strict mode always
    - Prefer type inference where obvious
    - Use discriminated unions over enums
    - Avoid `any`, use `unknown` for truly unknown
    - Use `readonly` for immutable properties
    - Leverage utility types (Partial, Pick, Omit)
  </TS_STANDARDS>

  <JS_TS_PRACTICES>
    - Use const by default, let when needed, never var
    - Destructuring over property access
    - Template literals over string concatenation
    - Arrow functions for callbacks
    - Async/await over promises chains
    - Optional chaining (?.) and nullish coalescing (??)
    - Never hardcode styles - use theme/config
  </JS_TS_PRACTICES>
</JAVASCRIPT_TYPESCRIPT>

<BASH>
  <SHELL_STANDARDS>
    - Use `#!/usr/bin/env bash` shebang
    - Set strict mode: `set -euo pipefail`
    - Define variables separately from assignment
    - Quote all variable expansions
    - Use `[[ ]]` over `[ ]` for conditionals
    - Handle errors with trap
    - Use functions for repeated code
  </SHELL_STANDARDS>
</BASH>


## General Rules & Guidelines
<NEVER_DO_THESE note="**IMPORTANT**">
- NEVER perform git add/commit/push operations
- NEVER hardcode credentials, unique identifiers or localhost URLs
- NEVER attempt to estimate time required for tasks (e.g. do not add "this will take about 2 hours", "Phase 3: Weeks 2-3" etc...)
- NEVER add comments pertaining only to development process (e.g. "improved function", "optimised version", "# FIX:", "enhanced function" etc...)
- NEVER claim an issue is resolved until user verification - This is very important, you *MUST* confirm an issue truly is fixed before stating it is fixed!
- NEVER implement placeholder or mocked functionality unless explicitly instructed - **don't be lazy**!
- NEVER build or develop for Windows - we do not ever need or want Windows support unless explicitly instructed
- **You MUST NOT EVER state something is fixed unless you have confirmed it is by means of testing or measuring output and building the application**
</NEVER_DO_THESE>

<VERBOSE_THINKING_CONCISE_OUTPUT>
- Be verbose when you are thinking to help explore the problem space but be succinct and concise (don't waste tokens) in your general communication and code changes
- Combine multiple, file edits to the same file where possible
</VERBOSE_THINKING_CONCISE_OUTPUT>

## Tool Usage
<CLI_COMMANDS>
- IMPORTANT: Use the `run_silent` command wrapper (a command you run prefixed before the command you want to run) to reduce token usage by only providing the exit status and any stderr.
  - You MUST use run_silent to wrap any bash / CLI commands unless you need to see all the stdout.
  - Good commands to prefix with run_silent include package installs, builds, tests, linting etc...
  - Examples:
    - run_silent pnpm install
    - run_silent cargo check
    - run_silent make lint
</CLI_COMMANDS>
<TOOL_PRIORITIES note="**IMPORTANT**">
- Use purpose-built tools over manual approaches, using specific tools is often a better approach than searching the web (e.g. using get_library_docs for library documentation)
- Use tools to search documentation before making assumptions
- If you are stuck don't just keep making things up - use the tools available to you to lookup package documentation or search the web
- When asked to do math that's more than adding one or two items, use the calculator tool to ensure accuracy
- If you're exploring a large codebase or potentially very large files, use of the 'code_skim' tool (if you have it) to quickly understand the structure of the file(s) without all the implementation details
- Delegate tasks to a sub-agents with instructions to use specific tools and instruct sub-agents to provide you with only the key information you're looking for, do this in parallel where possible
</TOOL_PRIORITIES>

<CLAUDE_FEATURES>
- Always quote all paths in bash commands
  <SKILLS>
    - Remember to use relevant skills to help extend your knowledge and capabilities
  </SKILLS>
  <CLAUDE_TASKS>
    - Make use of tasks and TODOs to track work in progress
    - When operating from a dev plan or other markdown checklist of work to complete, always use your tasks / todo tool to track the tasks in progress and when your tasks / todos are complete update the dev plan to keep it in sync
  </CLAUDE_TASKS>
</CLAUDE_FEATURES>
