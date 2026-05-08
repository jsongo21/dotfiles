@~/ai/AGENTS.md

## Tool Usage

### CLI Commands
**Use `run_silent` to wrap bash/CLI commands** unless you need stdout. It reduces token usage by returning only exit status and stderr.
- Examples: `run_silent pnpm install`, `run_silent cargo check`, `run_silent make lint`
- Always quote all paths in bash commands

### Tool Priorities
- Use `code_skim` for exploring large files/codebases without reading full implementations
- Use purpose-built tools over manual approaches (e.g. get_library_docs for documentation, calculator for maths)
- Use tools to search documentation before making assumptions - don't guess
- Delegate to sub-agents in parallel where possible, instruct them to return only key information

### Code Intelligence
- Prefer LSP over Grep/Glob/Read for code navigation:
  - `goToDefinition` / `goToImplementation` to jump to source
  - `findReferences` for all usages across the codebase
  - `workspaceSymbol` to locate a symbol; `documentSymbol` to list symbols in a file
  - `hover` for type info without reading the file
  - `prepareCallHierarchy` then `incomingCalls` / `outgoingCalls` for call graphs
  - `code_rename` to rename a symbol across files
- Before changing a function signature, run `findReferences` to see the blast radius
- Use Grep/Glob only for text/pattern searches (comments, strings, config values) where LSP doesn't help
- After editing, attend to any LSP diagnostics surfaced and fix them before moving on

## Skills & Tasks
- Use relevant skills to extend capabilities
- Use tasks/TODOs to track work in progress. When working from a dev plan, keep tasks and plan in sync
- When creating/updating CLAUDE.md files: use the `authoring-claude-md` skill first
- Do not include line numbers when referencing files in CLAUDE.md
- If stuck on a persistent problem after multiple attempts, use the `systematic-debugging` skill

## Sub-agent Coordination
- Sub-agents have their own context window - good for parallel research, inspection, or separate features
- Define clear boundaries per agent. Specify which files each agent owns
- Include "you are one of several agents" in instructions
- Set explicit success criteria. Combine small updates to prevent over-splitting
- Sub-agents can compete and erase each other's changes - ensure no overlap
- Only use agent teams when the user has explicitly requested it

@RTK.md
# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.
