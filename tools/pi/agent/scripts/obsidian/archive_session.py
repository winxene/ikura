#!/usr/bin/env python3
"""Write Pi session archive note and entity stubs."""
from __future__ import annotations

import argparse
import os
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parent))
from pi_context import context, ensure_dir, slugify, split_csv, wikilink_list, yaml_list


def write_entity_stub(base: Path, project: str, kind: str, name: str) -> Path:
    if kind == "components" and "/" in name:
        rel = Path(kind) / name
    else:
        rel = Path(kind) / name
    path = base / rel
    if path.suffix != ".md":
        path = path.with_suffix(".md")
    if not path.exists():
        ensure_dir(path.parent)
        path.write_text(
            f"---\ntype: entity\nkind: {kind}\nproject: {project}\ntags:\n  - entity\n  - {kind}\n  - {project}\n---\n\n# {name}\n",
            encoding="utf-8",
        )
    return path


def related_section(groups: list[tuple[str, list[str]]]) -> str:
    chunks: list[str] = []
    for title, items in groups:
        if not items:
            continue
        chunks.append(f"### {title}\n" + "\n".join(f"- [[{i}]]" for i in items))
    if not chunks:
        return ""
    return "\n\n## Related\n\n" + "\n\n".join(chunks) + "\n"


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--title", required=True)
    ap.add_argument("--summary", required=True)
    ap.add_argument("--model", default="unknown")
    ap.add_argument("--agents", default="")
    ap.add_argument("--skills", default="compress-to-obsidian")
    ap.add_argument("--features", default="")
    ap.add_argument("--components", default="")
    ap.add_argument("--issues", default="")
    ap.add_argument("--bugs", default="")
    ap.add_argument("--adrs", default="")
    ap.add_argument("--extra-tags", default="")
    ap.add_argument("--cwd", default=os.getcwd())
    args = ap.parse_args()

    ctx = context(args.cwd)
    project = ctx["project"]
    title = slugify(args.title)
    archive_dir = Path(ctx["archive_dir"])
    ensure_dir(archive_dir)

    skills = split_csv(args.skills)
    if "compress-to-obsidian" not in skills:
        skills.append("compress-to-obsidian")
    agents = split_csv(args.agents)
    features = split_csv(args.features)[:6]
    components = split_csv(args.components)[:15]
    issues = split_csv(args.issues)[:6]
    bugs = split_csv(args.bugs)[:10]
    adrs = split_csv(args.adrs)[:6]
    extra_tags = split_csv(args.extra_tags)

    entities = Path(ctx["entities_dir"])
    for kind, items in [
        ("features", features), ("components", components), ("issues", issues),
        ("bugs", bugs), ("adrs", adrs),
    ]:
        for item in items:
            write_entity_stub(entities, project, kind, item)

    tags = ["ai-session", "pi", project]
    tags += [f"feature/{slugify(x)}" for x in features]
    for c in components:
        if "/" in c:
            scope, stem = c.rsplit("/", 1)
            stem = stem.rsplit(".", 1)[0]
            tags.append(f"component/{scope}/{slugify(stem)}")
        else:
            tags.append(f"component/{slugify(c.rsplit('.',1)[0])}")
    tags += [f"bug/{slugify(x)}" for x in bugs]
    tags += extra_tags

    fm = [
        "---",
        "type: pi-session",
        f"project: {project}",
        f"model: {args.model}",
        f"agents: {yaml_list(agents)}",
        f"skills: {yaml_list(skills)}",
    ]
    if features: fm.append(f"features: {wikilink_list(features)}")
    if components: fm.append(f"components: {wikilink_list(components)}")
    if issues: fm.append(f"issues: {wikilink_list(issues)}")
    if bugs: fm.append(f"bugs: {wikilink_list(bugs)}")
    if adrs: fm.append(f"adrs: {wikilink_list(adrs)}")
    fm += [f"date: {ctx['now']}", "tags:"] + [f"  - {t}" for t in dict.fromkeys(tags)] + ["---"]

    related = related_section([
        ("Features", features), ("Components", components), ("Issues", issues), ("Bugs", bugs), ("ADRs", adrs)
    ])
    body = args.summary.strip()
    path = archive_dir / f"{ctx['today']}-{title}.md"
    note = "\n".join(fm) + f"\n\n# {title}\n\n{body}\n{related}\n— pi@{args.model}\n"
    path.write_text(note, encoding="utf-8")
    print(path)


if __name__ == "__main__":
    main()
