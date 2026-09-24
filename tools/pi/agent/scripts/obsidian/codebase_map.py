#!/usr/bin/env python3
"""Generate compact codebase map note."""
from __future__ import annotations

import argparse, os, subprocess, sys
from collections import defaultdict
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent))
from pi_context import context, ensure_dir

SKIP = {'.git','node_modules','dist','build','target','.next','.turbo','vendor'}
ENTRY_NAMES = {'package.json','Cargo.toml','go.mod','pyproject.toml','main.go','main.rs','App.tsx','app.tsx','index.ts','main.ts','vite.config.ts','next.config.js','tauri.conf.json'}

def git_files(root: Path) -> list[str]:
    p = subprocess.run(['git','ls-files'], cwd=root, text=True, capture_output=True)
    if p.returncode == 0 and p.stdout.strip():
        return [x for x in p.stdout.splitlines() if x]
    out=[]
    for f in root.rglob('*'):
        if not f.is_file(): continue
        rel=f.relative_to(root)
        if any(part in SKIP for part in rel.parts): continue
        out.append(str(rel))
    return out

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--model', default='unknown')
    ap.add_argument('--cwd', default=os.getcwd())
    args=ap.parse_args()
    ctx=context(args.cwd); root=Path(ctx['repo_root']); project=ctx['project']
    files=git_files(root)
    top=defaultdict(int)
    exts=defaultdict(int)
    entries=[]; tests=[]; configs=[]
    for f in files:
        parts=Path(f).parts
        top[parts[0] if len(parts)>1 else '.'] += 1
        ext=Path(f).suffix or '<none>'; exts[ext]+=1
        name=Path(f).name
        if name in ENTRY_NAMES or f.startswith(('src/main','cmd/','app/','pages/')): entries.append(f)
        if any(p in {'test','tests','__tests__'} for p in parts) or name.endswith(('_test.go','.test.ts','.spec.ts','.test.tsx','.spec.tsx')): tests.append(f)
        if name in {'package.json','Cargo.toml','go.mod','pyproject.toml','Makefile','Dockerfile','docker-compose.yml','vite.config.ts','tsconfig.json'} or f.startswith(('.github/','.pi/')): configs.append(f)
    outdir=Path(ctx['codebase_map_dir']); ensure_dir(outdir); path=outdir/f'{project}-map.md'
    note=[]
    note += ['---', 'type: codebase-map', f'project: {project}', f'updated: {ctx["now"]}', 'tags:', '  - codebase-map', '  - pi', f'  - {project}', '---', '']
    note += [f'# {project} codebase map', '', '## Overview', f'- Repo root: `{root}`', f'- Tracked files: {len(files)}', '']
    note += ['## Top-Level Structure'] + [f'- `{k}/` — {v} files' for k,v in sorted(top.items())[:40]] + ['']
    note += ['## Main File Types'] + [f'- `{k}` — {v}' for k,v in sorted(exts.items(), key=lambda x:x[1], reverse=True)[:20]] + ['']
    note += ['## Entry Points'] + [f'- `{x}`' for x in entries[:30]] + ['']
    note += ['## Tests'] + ([f'- `{x}`' for x in tests[:30]] or ['- None detected']) + ['']
    note += ['## Build / Config'] + [f'- `{x}`' for x in configs[:40]] + ['']
    note += ['## Notes for Future Agents', '- Prefer `git ls-files` over broad recursive scans.', '- Ignore generated/vendor/build output unless task needs it.', '', f'— pi@{args.model}', '']
    path.write_text('\n'.join(note), encoding='utf-8')
    print(path)
if __name__ == '__main__': main()
