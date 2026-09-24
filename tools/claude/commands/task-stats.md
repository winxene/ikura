---
description: Summarize ~/.claude/logs/task-durations.jsonl — turns, cost, p50/p95, top longest
---

Run the task-stats analyzer and print its output verbatim. Do not summarize or interpret unless the user asks a follow-up question.

```bash
node $HOME/.claude/scripts/task-stats.js $ARGUMENTS
```

Flags the user may pass via `$ARGUMENTS`:
- `--since 24h|7d|2w` — restrict to recent window
- `--cwd <substring>` — restrict to a project path
- `--top N` — top-N rows (default 5)
