SHELL := /bin/bash
CLAUDE_SKILLS := $(HOME)/.claude/skills
CODEX_SKILLS := $(HOME)/.codex/skills
SHARED_AGENTS := $(HOME)/ai/AGENTS.md
CODEX_AGENTS := $(HOME)/.codex/AGENTS.md
OPENCODE_AGENTS := $(HOME)/.config/opencode/AGENTS.md

.PHONY: stow link-codex-skills link-agents install

stow:
	stow --target=$(HOME) --dir=$(CURDIR) --ignore='.DS_Store' home

link-codex-skills:
	@mkdir -p $(CODEX_SKILLS)
	@for skill in $(CLAUDE_SKILLS)/*/; do \
		name=$$(basename "$$skill"); \
		target=$(CODEX_SKILLS)/$$name; \
		if [ -L "$$target" ]; then \
			echo "skip $$name (already linked)"; \
		elif [ -e "$$target" ]; then \
			echo "skip $$name (exists, not a symlink)"; \
		else \
			ln -s "$$skill" "$$target" && echo "linked $$name"; \
		fi \
	done

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

install: stow link-codex-skills link-agents
