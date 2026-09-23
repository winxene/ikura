#!/usr/bin/env python3
"""Create/update PARA project plan note."""
from __future__ import annotations
import argparse, os, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent))
from pi_context import context, ensure_dir, slugify

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--title', required=True)
    ap.add_argument('--body', required=True)
    ap.add_argument('--model', default='unknown')
    ap.add_argument('--cwd', default=os.getcwd())
    args=ap.parse_args(); ctx=context(args.cwd); title=slugify(args.title,'plan')
    outdir=Path(ctx['plans_dir']); ensure_dir(outdir); path=outdir/f"{ctx['today']}-{title}.md"
    note=f"---\ntype: pi-plan\nproject: {ctx['project']}\ndate: {ctx['now']}\ntags:\n  - pi\n  - plan\n  - {ctx['project']}\n---\n\n# {title}\n\n{args.body.strip()}\n\n— pi@{args.model}\n"
    path.write_text(note,encoding='utf-8')
    print(path)
if __name__=='__main__': main()
