# Repository Agent Instructions

This is a personal, public dotfiles repository.

## Repository Layout

- Treat `home/` as the GNU Stow package and preserve its target paths.
- Prefer the existing Makefile targets over ad hoc installation commands.
- Keep platform-specific configuration in `mac/`, `linux/`, and other platform directories.
- Do not use `stow --adopt` without reviewing the resulting diff.
- `home/.codex/config.toml` is the tracked source for shared Codex settings and is not stowed. The live `~/.codex/config.toml` must remain a local file because Codex writes trust and UI state there.
- To apply shared Codex settings, run `make codex-config` (also included in `make install`). The merge starts from `home/.codex/config.toml`, so its values win for shared settings. It preserves only Codex-owned local state: `[projects.*]`, `[hooks.state*]`, `[tui.model_availability_nux]`, and `screen_reader_detection_done` under `[tui]`. Other settings found only in the live config are not retained; put settings that should be version-controlled in `home/.codex/config.toml`.
- When changing the merge behaviour, update `install/codex-config.py` and this guidance together. Do not commit Codex-written state from the live config.
- Ask before deleting or overwriting existing user configuration.

## Skills

- Keep repo-owned shared skills in `home/.agents/skills/`.
- Keep Claude-specific skills in `home/.claude/skills/`.
- Record Skills CLI-managed sources in `skills.json`.
- Use `make skills` to install configured skills and `make link-agent-skills` to link them.
- Run `./tests/link-skills.sh` after changing the skill linker.

## Git

- Committing and pushing directly to `master` is allowed in this repo. This overrides the global no-commit-to-main rule.

## Verification

- Run `git diff --check` before committing.
- Run the smallest relevant test suite after changes.
- Never commit Codex-written state: `[projects.*]` trust entries, `[hooks.state*]`, `[tui.model_availability_nux]` or `screen_reader_detection_done`.
- Do not commit secrets, machine-specific state, generated Graphify output, or downloaded skill metadata.
