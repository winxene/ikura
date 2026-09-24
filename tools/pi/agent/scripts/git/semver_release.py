#!/usr/bin/env python3
"""Compute SemVer bump and release notes from conventional commits."""
from __future__ import annotations
import json, re, subprocess
from pathlib import Path

def git(args):
    p=subprocess.run(['git']+args,text=True,capture_output=True)
    return p.returncode,p.stdout.strip(),p.stderr.strip()

def last_tag():
    c,o,_=git(['describe','--tags','--abbrev=0'])
    return o if c==0 and o else None

def parse_version(tag):
    if not tag: return (0,0,0)
    m=re.search(r'v?(\d+)\.(\d+)\.(\d+)', tag)
    return tuple(map(int,m.groups())) if m else (0,0,0)

def bump(v, level):
    M,m,p=v
    if level=='major': return (M+1,0,0)
    if level=='minor': return (M,m+1,0)
    if level=='patch': return (M,m,p+1)
    return v

def channel():
    _,b,_=git(['branch','--show-current'])
    if b in ('main','master'): return 'stable'
    if b in ('canary','next','nightly'): return 'canary'
    if b.startswith('alpha'): return 'alpha'
    if b.startswith('beta'): return 'beta'
    if b in ('rc',) or b.startswith('release/'): return 'rc'
    return 'canary'

def main():
    tag=last_tag(); rng=[f'{tag}..HEAD'] if tag else ['HEAD']
    c,o,_=git(['log',*rng,'--pretty=%h%x09%s%x09%b'])
    commits=[]; highest='none'; cats={'Breaking Changes':[],'Features':[],'Bug Fixes':[],'Performance':[],'Reverts':[],'Internal':[]}
    order={'none':0,'patch':1,'minor':2,'major':3}
    for line in o.splitlines():
        if not line.strip(): continue
        h, subj, *body = line.split('\t')
        m=re.match(r'(\w+)(?:\(([^)]+)\))?(!)?:\s*(.+)', subj)
        typ=m.group(1) if m else ''; scope=m.group(2) if m else ''; bang=bool(m and m.group(3)); desc=m.group(4) if m else subj
        breaking=bang or 'BREAKING CHANGE' in '\t'.join(body)
        if breaking: cat,lev='Breaking Changes','major'
        elif typ=='feat': cat,lev='Features','minor'
        elif typ=='fix': cat,lev='Bug Fixes','patch'
        elif typ=='perf': cat,lev='Performance','patch'
        elif typ=='revert': cat,lev='Reverts','patch'
        else: cat,lev='Internal','none'
        if order[lev] > order[highest]: highest=lev
        item=f"- **{scope}:** {desc} ({h})" if scope else f"- {desc} ({h})"
        cats[cat].append(item); commits.append({'hash':h,'subject':subj,'category':cat,'bump':lev})
    base=parse_version(tag); proposed=bump(base, highest); ch=channel()
    count_code,count,_=git(['rev-list',*( [f'{tag}..HEAD'] if tag else ['HEAD'] ),'--count'])
    ver='.'.join(map(str,proposed))
    if ch!='stable' and highest!='none': ver=f'{ver}-{ch}.{count or len(commits)}'
    notes=[f'## {ver}','']
    for cat,items in cats.items():
        if items: notes += [f'### {cat}', *items, '']
    result={'current_tag':tag,'current_version':'.'.join(map(str,base)),'channel':ch,'bump':highest,'proposed_version':ver,'commit_count':len(commits),'release_notes':'\n'.join(notes).strip(),'commits':commits}
    print(json.dumps(result, indent=2))
if __name__=='__main__': main()
