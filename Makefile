SHELL := /bin/bash
CLAUDE_SKILLS := $(HOME)/.claude/skills
CODEX_SKILLS := $(HOME)/.codex/skills

.PHONY: stow link-codex-skills install

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

install: stow link-codex-skills
