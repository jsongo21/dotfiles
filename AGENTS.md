# Repository Agent Instructions

This is a personal, public dotfiles repository.

## Repository Layout

- Treat `home/` as the GNU Stow package and preserve its target paths.
- Prefer the existing Makefile targets over ad hoc installation commands.
- Keep platform-specific configuration in `mac/`, `linux/`, and other platform directories.
- Do not use `stow --adopt` without reviewing the resulting diff.
- Ask before deleting or overwriting existing user configuration.

## Skills

- Keep repo-owned shared skills in `home/.agents/skills/`.
- Keep Claude-specific skills in `home/.claude/skills/`.
- Record Skills CLI-managed sources in `skills.json`.
- Use `make skills` to install configured skills and `make link-agent-skills` to link them.
- Run `./tests/link-skills.sh` after changing the skill linker.

## Verification

- Run `git diff --check` before committing.
- Run the smallest relevant test suite after changes.
- Do not commit secrets, machine-specific state, generated Graphify output, or downloaded skill metadata.
