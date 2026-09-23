#!/usr/bin/env bash
set -euo pipefail
MODE="${1:-freetext}"
QUERY="${2:-}"
SCOPE="${3:-}"
CTX=$(python3 "$(dirname "$0")/pi_context.py")
VAULT=$(python3 -c 'import json,sys; print(json.load(sys.stdin)["vault"])' <<<"$CTX")
PROJECT=$(python3 -c 'import json,sys; print(json.load(sys.stdin)["project"])' <<<"$CTX")
if [ -z "$SCOPE" ]; then SCOPE="$VAULT/04_Archives/Sessions/$PROJECT"; fi
[ -d "$SCOPE" ] || SCOPE="$VAULT/04_Archives/Sessions"
PATTERN="$QUERY"
case "$MODE" in
  bug) PATTERN="Problems Solved|bugs:|bug/|$QUERY" ;;
  component) PATTERN="components:|component/|$QUERY" ;;
  feature) PATTERN="features:|feature/|$QUERY" ;;
  issue) PATTERN="issues:|#[0-9]+|issue-[0-9]+|$QUERY" ;;
  entity) SCOPE="$VAULT/01_Projects/$PROJECT/Entities"; PATTERN="$QUERY" ;;
  freetext|*) PATTERN="${QUERY:-$PROJECT}" ;;
esac
if command -v rg >/dev/null 2>&1; then
  rg -i -l --glob '*.md' "$PATTERN" "$SCOPE" 2>/dev/null | while read -r f; do stat -f '%m %N' "$f"; done | sort -rn | cut -d' ' -f2-
else
  grep -RIlE "$PATTERN" "$SCOPE" --include='*.md' 2>/dev/null | while read -r f; do stat -f '%m %N' "$f"; done | sort -rn | cut -d' ' -f2-
fi
