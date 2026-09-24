#!/usr/bin/env node
// Stop hook — appends a per-turn record to ~/.claude/logs/task-durations.jsonl.
//
// Reads the session-state bridge written by gsd-statusline.js on every render,
// compares against a per-session tally marker, and appends only the delta. The
// marker prevents double-counting across multiple Stop events in one session.
//
// Schema written to task-durations.jsonl (one JSON object per line):
//   { ts, session, task, cwd, duration_ms, cost_usd }
//
// All errors are swallowed — Stop hooks must never block the assistant.

const fs = require('fs');
const path = require('path');
const os = require('os');

function safeReadJson(p) {
  try { return JSON.parse(fs.readFileSync(p, 'utf8')); } catch (e) { return null; }
}

function main() {
  let input = '';
  const timeout = setTimeout(() => process.exit(0), 3000);
  process.stdin.setEncoding('utf8');
  process.stdin.on('data', chunk => { input += chunk; });
  process.stdin.on('end', () => {
    clearTimeout(timeout);
    try {
      const data = JSON.parse(input || '{}');
      const session = data.session_id;
      if (!session || /[/\\]|\.\./.test(session)) return;

      const claudeDir = process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), '.claude');
      const logsDir = path.join(claudeDir, 'logs');
      if (!fs.existsSync(logsDir)) return;

      const bridgePath = path.join(logsDir, `session-state-${session}.json`);
      const state = safeReadJson(bridgePath);
      if (!state) return;

      const markerPath = path.join(logsDir, `session-tally-${session}.json`);
      const prev = safeReadJson(markerPath) || { cost_usd: 0, api_duration_ms: 0 };

      const curCost = Number(state.cost_usd) || 0;
      const curMs = Number(state.api_duration_ms) || 0;
      const deltaCost = Math.max(0, curCost - (Number(prev.cost_usd) || 0));
      const deltaMs = Math.max(0, curMs - (Number(prev.api_duration_ms) || 0));

      // Skip trivial deltas (e.g. statusline re-rendered without any real turn).
      if (deltaMs < 1000 && deltaCost < 0.001) return;

      const record = {
        ts: new Date().toISOString(),
        session,
        task: state.last_task || null,
        cwd: state.cwd || null,
        duration_ms: deltaMs,
        cost_usd: Number(deltaCost.toFixed(4)),
      };

      const logPath = path.join(logsDir, 'task-durations.jsonl');
      fs.appendFileSync(logPath, JSON.stringify(record) + '\n');

      fs.writeFileSync(markerPath, JSON.stringify({
        cost_usd: curCost,
        api_duration_ms: curMs,
        last_log_ts: record.ts,
      }));
    } catch (e) {
      // silent
    }
  });
}

if (require.main === module) main();

module.exports = { safeReadJson };
