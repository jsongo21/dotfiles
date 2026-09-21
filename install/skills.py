#!/usr/bin/env python3
"""Install and update the skills declared in the repository manifest."""

from __future__ import annotations

import json
import os
import shlex
import subprocess
from pathlib import Path


def run(command: list[str]) -> None:
    print(f"+ {' '.join(shlex.quote(part) for part in command)}")
    subprocess.run(command, check=True)


def main() -> None:
    cli = shlex.split(os.environ.get("SKILLS_CLI", "npx --yes skills"))
    agents = shlex.split(
        os.environ.get("SKILLS_AGENTS", "claude-code codex opencode")
    )
    manifest_path = Path(os.environ.get("SKILLS_MANIFEST", "skills.json"))

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    for entry in manifest["skills"]:
        run(
            cli
            + ["add", entry["source"], "--skill", *entry["names"]]
            + ["--global", *sum((["--agent", agent] for agent in agents), [])]
            + ["--yes"]
        )

    run(cli + ["update", "--global"])


if __name__ == "__main__":
    main()
