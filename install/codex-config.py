#!/usr/bin/env python3
"""Merge the shared Codex config into ~/.codex/config.toml.

Codex writes trust and UI state into the user config, so the live file must be
a local file. Shared settings come from home/.codex/config.toml; Codex-owned
state already in the live file is kept.
"""

from __future__ import annotations

import os
from pathlib import Path

STATE_HEADERS = ("[projects.", "[hooks.state", "[tui.model_availability_nux")
STATE_KEYS = ("screen_reader_detection_done",)


def split_blocks(text: str) -> list[tuple[str, list[str]]]:
    blocks: list[tuple[str, list[str]]] = [("", [])]
    for line in text.splitlines():
        if line.startswith("["):
            blocks.append((line, []))
        else:
            blocks[-1][1].append(line)
    return blocks


def render(blocks: list[tuple[str, list[str]]]) -> str:
    lines: list[str] = []
    for header, body in blocks:
        if header:
            lines.append(header)
        lines.extend(body)
    return "\n".join(lines).rstrip("\n") + "\n"


def merge(shared: str, local: str) -> str:
    blocks = split_blocks(shared)
    state_blocks = []
    state_keys = []
    for header, body in split_blocks(local):
        if header.startswith(STATE_HEADERS):
            state_blocks.append((header, body))
        elif header == "[tui]":
            state_keys = [line for line in body if line.startswith(STATE_KEYS)]

    for index, (header, body) in enumerate(blocks):
        if header == "[tui]" and state_keys:
            tail = [line for line in body if line.strip()]
            blocks[index] = (header, tail + state_keys + [""])
    if state_blocks:
        blocks[-1] = (blocks[-1][0], blocks[-1][1] + [""])
    return render(blocks + state_blocks)


def main() -> None:
    root = Path(__file__).resolve().parent.parent
    shared_path = root / "home/.codex/config.toml"
    live_path = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex")) / "config.toml"

    local = ""
    if live_path.exists():
        local = live_path.read_text(encoding="utf-8")
    if live_path.is_symlink():
        live_path.unlink()

    merged = merge(shared_path.read_text(encoding="utf-8"), local)
    live_path.write_text(merged, encoding="utf-8")
    print(f"wrote {live_path}")


if __name__ == "__main__":
    main()
