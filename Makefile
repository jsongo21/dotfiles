SHELL := /bin/bash
CLAUDE_SKILLS := $(HOME)/.claude/skills
CODEX_SKILLS := $(HOME)/.codex/skills
SHARED_AGENTS := $(HOME)/ai/AGENTS.md
CODEX_AGENTS := $(HOME)/.codex/AGENTS.md

.PHONY: stow link-codex-skills link-codex-agents install

stow:
	stow --target=$(HOME) --dir=$(CURDIR) home

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

link-codex-agents:
	@if [ -L "$(CODEX_AGENTS)" ] && [ -e "$(CODEX_AGENTS)" ]; then \
		echo "skip AGENTS.md (already linked)"; \
	elif [ -L "$(CODEX_AGENTS)" ]; then \
		rm "$(CODEX_AGENTS)" && ln -s "$(SHARED_AGENTS)" "$(CODEX_AGENTS)" && echo "relinked AGENTS.md (was broken)"; \
	elif [ -e "$(CODEX_AGENTS)" ]; then \
		echo "skip AGENTS.md (exists, not a symlink)"; \
	else \
		ln -s "$(SHARED_AGENTS)" "$(CODEX_AGENTS)" && echo "linked AGENTS.md"; \
	fi

install: stow link-codex-skills link-codex-agents
