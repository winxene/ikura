#!/usr/bin/env python3
"""Append rolling hot-cache delta."""
from __future__ import annotations

import argparse, os, re, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent))
from pi_context import context, ensure_dir, slugify


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--title", required=True)
    ap.add_argument("--summary", required=True)
    ap.add_argument("--model", default="unknown")
    ap.add_argument("--open-items", default="None")
    ap.add_argument("--cwd", default=os.getcwd())
    args = ap.parse_args()
    ctx = context(args.cwd)
    path = Path(ctx["hot_cache"])
    ensure_dir(path.parent)
    if path.exists():
        text = path.read_text(encoding="utf-8")
    else:
        text = (
            f"---\ntype: hot-cache\nproject: {ctx['project']}\ntags:\n  - hot-cache\n  - pi\n  - {ctx['project']}\nupdated: {ctx['now']}\n---\n\n"
            f"# {ctx['project']} hot-cache\n\n## Recent Deltas\n"
        )
    text = re.sub(r"updated: .*", f"updated: {ctx['now']}", text, count=1)
    entry = (
        f"\n### {ctx['now']} — {slugify(args.title)}\n"
        f"{args.summary.strip()}\n\nOpen items:\n"
        + "\n".join(f"- {x.strip()}" for x in args.open_items.split(";") if x.strip())
        + f"\n\n— pi@{args.model}\n"
    )
    marker = "## Recent Deltas"
    if marker not in text:
        text += f"\n\n{marker}\n"
    head, tail = text.split(marker, 1)
    combined = head + marker + "\n" + entry + tail.strip() + "\n"
    parts = re.split(r"(?=^### \d{4}-\d{2}-\d{2} )", combined, flags=re.M)
    prefix = parts[0]
    entries = parts[1:]
    combined = prefix + "".join(entries[:10])
    path.write_text(combined, encoding="utf-8")
    print(path)

if __name__ == "__main__":
    main()
