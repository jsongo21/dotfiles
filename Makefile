SHELL := /bin/bash
SHARED_AGENTS := $(HOME)/ai/AGENTS.md
CODEX_AGENTS := $(HOME)/.codex/AGENTS.md
OPENCODE_AGENTS := $(HOME)/.config/opencode/AGENTS.md
SKILLS_CLI := npx --yes skills
SKILLS_MANIFEST := skills.json
SKILLS_AGENTS ?= claude-code codex opencode

.PHONY: stow link-agent-skills link-codex-skills link-agents skills test-skills firefox install

stow:
	stow --target=$(HOME) --dir=$(CURDIR) --ignore='.DS_Store' --ignore='skills$$' --ignore='\.skill-lock\.json$$' home

link-agent-skills:
	@AGENT_SKILLS_DIR="$(HOME)/.agents/skills" SKILL_HARNESS_DIRS="$(SKILL_HARNESS_DIRS)" ./install/link-skills.sh --apply

link-codex-skills: link-agent-skills

test-skills:
	@./tests/link-skills.sh

link-agents:
	@for target in $(CODEX_AGENTS) $(OPENCODE_AGENTS); do \
		mkdir -p "$$(dirname "$$target")"; \
		if [ -L "$$target" ] && [ -e "$$target" ]; then \
			echo "skip $$target (already linked)"; \
		elif [ -L "$$target" ]; then \
			rm "$$target" && ln -s "$(SHARED_AGENTS)" "$$target" && echo "relinked $$target (was broken)"; \
		elif [ -e "$$target" ]; then \
			echo "skip $$target (exists, not a symlink)"; \
		else \
			ln -s "$(SHARED_AGENTS)" "$$target" && echo "linked $$target"; \
		fi \
	done

skills:
	@python3 -c 'import json, shlex, subprocess; cli = shlex.split("$(SKILLS_CLI)"); agents = sum((["--agent", agent] for agent in shlex.split("$(SKILLS_AGENTS)")), []); manifest = json.load(open("$(SKILLS_MANIFEST)")); [subprocess.run(cli + ["add", entry["source"], "--skill", *entry["names"], "--global", *agents, "--yes"], check=True) for entry in manifest["skills"]]; subprocess.run(cli + ["update", "--global"], check=True)'

firefox:
	@./install/firefox.sh

install: stow link-agent-skills link-agents
