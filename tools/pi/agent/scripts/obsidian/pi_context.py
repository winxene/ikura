#!/usr/bin/env python3
"""Shared Pi→Obsidian context helpers."""
from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
from datetime import datetime
from pathlib import Path

DEFAULT_VAULT = Path.home() / "Documents/Pi"
PROJECT_VAULT_OVERRIDES = [
    (
        Path.home() / "Development/iglo/tauri/velapod-orchestrator",
        Path.home() / "Documents/Velapod",
    ),
]


def sh(cmd: list[str], cwd: str | None = None) -> tuple[int, str, str]:
    p = subprocess.run(cmd, cwd=cwd, text=True, capture_output=True)
    return p.returncode, p.stdout.strip(), p.stderr.strip()


def vault_root(cwd: str | None = None) -> Path:
    env = os.environ.get("OBSIDIAN_VAULT")
    if env and Path(env).expanduser().is_dir():
        return Path(env).expanduser().resolve()

    cwdp = Path(cwd or os.getcwd()).resolve()
    for code_root, vault in PROJECT_VAULT_OVERRIDES:
        try:
            cwdp.relative_to(code_root)
        except ValueError:
            continue
        if vault.is_dir():
            return vault.resolve()

    if DEFAULT_VAULT.is_dir():
        return DEFAULT_VAULT.resolve()
    raise SystemExit(f"No Obsidian vault found. Set OBSIDIAN_VAULT or create {DEFAULT_VAULT}")


def repo_root(cwd: str | None = None) -> Path:
    cwdp = Path(cwd or os.getcwd()).resolve()
    code, out, _ = sh(["git", "rev-parse", "--show-toplevel"], str(cwdp))
    if code == 0 and out:
        return Path(out).resolve()
    return cwdp


def project_name(cwd: str | None = None) -> str:
    return repo_root(cwd).name or "home"


def slugify(s: str, fallback: str = "session") -> str:
    s = s.strip().lower()
    s = re.sub(r"[^a-z0-9]+", "-", s)
    s = re.sub(r"-+", "-", s).strip("-")
    return s or fallback


def now_stamp() -> str:
    return datetime.now().strftime("%Y-%m-%d %H:%M")


def today() -> str:
    return datetime.now().strftime("%Y-%m-%d")


def split_csv(value: str | None) -> list[str]:
    if not value:
        return []
    return [x.strip() for x in value.split(",") if x.strip()]


def yaml_scalar(s: str) -> str:
    return json.dumps(s, ensure_ascii=False)


def yaml_list(items: list[str]) -> str:
    return "[" + ", ".join(yaml_scalar(i) for i in items) + "]"


def wikilink_list(items: list[str]) -> str:
    return yaml_list([f"[[{i}]]" for i in items])


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def context(cwd: str | None = None) -> dict:
    vault = vault_root(cwd)
    root = repo_root(cwd)
    project = project_name(cwd)
    return {
        "vault": str(vault),
        "repo_root": str(root),
        "project": project,
        "archive_dir": str(vault / "04_Archives" / "Sessions" / project),
        "project_dir": str(vault / "01_Projects" / project),
        "hot_cache": str(vault / "01_Projects" / project / "hot-cache.md"),
        "plans_dir": str(vault / "01_Projects" / project / "Plans"),
        "entities_dir": str(vault / "01_Projects" / project / "Entities"),
        "codebase_map_dir": str(vault / "03_Resources" / "Codebase-Maps" / project),
        "wiki_dir": str(vault / "03_Resources" / "Wikis"),
        "now": now_stamp(),
        "today": today(),
    }


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--cwd", default=os.getcwd())
    ap.add_argument("--slug", help="Print slugified string instead of context JSON")
    args = ap.parse_args()
    if args.slug is not None:
        print(slugify(args.slug))
        return
    print(json.dumps(context(args.cwd), indent=2))


if __name__ == "__main__":
    main()
