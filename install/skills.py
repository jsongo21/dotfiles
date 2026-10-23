#!/usr/bin/env python3
"""Install and update the skills declared in the repository manifest."""

from __future__ import annotations

import importlib.metadata
import importlib.util
import json
import os
import shlex
import shutil
import subprocess
from pathlib import Path


def run(command: list[str]) -> None:
    print(f"+ {' '.join(shlex.quote(part) for part in command)}")
    subprocess.run(command, check=True)


def restore_graphify_references(skills_dir: Path) -> None:
    """Restore the references/ sidecar that `skills add` drops for graphify.

    graphify's SKILL.md links to references/, which upstream ships inside the
    Python package rather than beside the skill, so the Skills CLI never copies it.
    """
    skill_dir = skills_dir / "graphify"
    spec = importlib.util.find_spec("graphify")
    if not skill_dir.is_dir() or spec is None or not spec.submodule_search_locations:
        print("skip graphify references (skill or graphifyy package not installed)")
        return

    source = Path(spec.submodule_search_locations[0]) / "skills" / "claude" / "references"
    target = skill_dir / "references"
    shutil.rmtree(target, ignore_errors=True)
    shutil.copytree(source, target)
    (skill_dir / ".graphify_version").write_text(
        importlib.metadata.version("graphifyy"), encoding="utf-8"
    )
    print(f"restored graphify references -> {target}")


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

    if any("graphify" in entry["names"] for entry in manifest["skills"]):
        restore_graphify_references(
            Path(os.environ.get("AGENT_SKILLS_DIR", Path.home() / ".agents" / "skills"))
        )

if __name__ == "__main__":
    main()
