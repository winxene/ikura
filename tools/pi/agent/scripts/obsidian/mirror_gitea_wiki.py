#!/usr/bin/env python3
"""Mirror one Gitea repo wiki into Obsidian PARA resources."""
from __future__ import annotations
import argparse, base64, json, os, re, subprocess, sys, urllib.request
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent))
from pi_context import context, ensure_dir, slugify

def api(url, token):
    req=urllib.request.Request(url, headers={'Authorization':f'token {token}','Accept':'application/json'})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.loads(r.read().decode())

def infer_repo():
    p=subprocess.run(['git','remote','get-url','origin'],text=True,capture_output=True)
    if p.returncode!=0: return None
    u=p.stdout.strip().removesuffix('.git')
    m=re.search(r'[:/]([^/:]+)/([^/]+)$', u)
    return f'{m.group(1)}/{m.group(2)}' if m else None

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--repo'); ap.add_argument('--owner', default=os.environ.get('GITEA_OWNER',''))
    args=ap.parse_args(); base=os.environ.get('GITEA_URL','').rstrip('/'); token=os.environ.get('GITEA_TOKEN','')
    if not base or not token: raise SystemExit('Missing GITEA_URL or GITEA_TOKEN')
    repo=args.repo or infer_repo()
    if not repo: raise SystemExit('Repo required: --repo owner/repo or --owner owner --repo repo')
    if '/' not in repo:
        if not args.owner: raise SystemExit('Owner required for bare repo name')
        owner,name=args.owner,repo
    else: owner,name=repo.split('/',1)
    ctx=context(); outdir=Path(ctx['wiki_dir'])/name; ensure_dir(outdir)
    pages_url=f'{base}/api/v1/repos/{owner}/{name}/wiki/pages'
    try: pages=api(pages_url,token)
    except Exception as e: raise SystemExit(f'Fetch failed {pages_url}: {e}')
    written=[]; current=set()
    for p in pages:
        sub=p.get('sub_url') or p.get('title') or p.get('page_name')
        title=p.get('title') or p.get('page_name') or str(sub)
        detail_url=sub if str(sub).startswith('http') else f'{base}{sub}' if str(sub).startswith('/') else f'{pages_url}/{title}'
        d=api(detail_url, token)
        b64=d.get('content_base64') or d.get('content') or ''
        try: body=base64.b64decode(b64).decode('utf-8') if b64 else ''
        except Exception: body=d.get('content','')
        fname=slugify(title)+'.md'; current.add(fname); path=outdir/fname
        src=d.get('html_url') or d.get('url') or detail_url
        sha=(d.get('commit') or {}).get('sha','') if isinstance(d.get('commit'),dict) else d.get('commit_sha','')
        note=f"---\ntype: gitea-wiki-mirror\nrepo: {owner}/{name}\nsource: {src}\nmirrored: {ctx['now']}\ntags:\n  - wiki\n  - gitea\n  - {name}\n---\n\n> [!info] Read-only mirror\n> Source: {src}  \n> Last commit: {sha}\n\n{body}\n"
        path.write_text(note,encoding='utf-8'); written.append(str(path))
    pruned=[]
    for old in outdir.glob('*.md'):
        if old.name not in current:
            old.unlink(); pruned.append(str(old))
    print(json.dumps({'repo':f'{owner}/{name}','written':written,'pruned':pruned,'count':len(written)}, indent=2))
if __name__=='__main__': main()
