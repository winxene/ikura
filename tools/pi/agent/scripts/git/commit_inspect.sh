#!/usr/bin/env bash
set -euo pipefail
printf '## git status\n'
git status --short || exit 0
printf '\n## changed files\n'
git diff --name-status || true
git diff --cached --name-status || true
printf '\n## diff stat\n'
git diff --stat || true
printf '\n## staged diff stat\n'
git diff --cached --stat || true
printf '\n## staged sanity\n'
git diff --cached --check || true
printf '\n## possible secrets/debug markers\n'
PAT='(sk-[A-Za-z0-9]|Bearer [A-Za-z0-9._-]+|api[_-]?key|secret|password=|console\.log|debugger|dbg!|println!)'
FILES=$(git diff --cached --name-only --diff-filter=ACM || true)
if [ -n "$FILES" ]; then
  printf '%s\n' "$FILES" | xargs grep -nEI "$PAT" 2>/dev/null || true
fi
printf '\n## suggested scopes\n'
(git diff --name-only; git diff --cached --name-only) | awk -F/ 'NF==1{print $1" -> root"} NF>1{print $0" -> "$1}' | sort -u
