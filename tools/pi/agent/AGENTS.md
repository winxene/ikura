# Global Pi Rules

## Obsidian vault
- Default vault root: `~/Documents/Pi`.
- Velapod override: when cwd is `~/Development/iglo/tauri/velapod-orchestrator` or any child, use `~/Documents/Velapod` by default.
- `OBSIDIAN_VAULT` env may override only when it points to an existing vault; otherwise use the cwd-resolved default above.
- Use PARA folders only:
  - `01_Projects/<project>/` — active project memory, hot-cache, entity hubs.
  - `02_Areas/` — ongoing responsibilities.
  - `03_Resources/` — reusable references, wikis, codebase maps.
  - `04_Archives/Sessions/<project>/` — permanent Pi chat/session archives.
- Never write chat history to `Claude Chats/`.
- Prefer direct filesystem writes (`write`, `edit`, `bash mkdir -p`) over MCP for this vault.

## Session memory workflow
- When user says `compress`, `save session`, `save to obsidian`, `archive this chat`, or asks to save full history: load skill `compress-to-obsidian`.
- When user asks to find or recall old work: load skill `search-from-obsidian`.
- When user says `save delta`, `update hot cache`, `log this commit`, or wants lightweight working memory: load skill `archive-session-hot`.
- `archive-session-hot` is working memory under `01_Projects/<project>/hot-cache.md`; `compress-to-obsidian` is permanent archive under `04_Archives/Sessions/<project>/`.

## Plan workflow
- When user asks for plan mode, planning, implementation plan, roadmap, or multi-step task plan: create/update Obsidian plan under `01_Projects/<project>/Plans/`.
- Use script: `python3 "$HOME/.pi/agent/scripts/obsidian/plan_note.py" --title "<title>" --body "<plan-body>" --model "<model>"`.
- Plan filename: `YYYY-MM-DD-<plan-slug>.md`, lowercase slug, no spaces or slashes.
- Plan notes use `type: pi-plan`, tags `pi`, `plan`, and `<project>`.
- Keep active plan in project folder; after implementation, summarize final outcome via `archive-session-hot` or `compress-to-obsidian` as requested.
- Do not store plans in `04_Archives/Sessions/` unless they are part of final session archive.

## Metadata rules
- Session notes use `type: pi-session`, tag `ai-session`, tag `pi`, and tag `<project>`.
- Project name comes from git root basename when available; otherwise current directory basename. Never ask.
- Quoted wikilinks in YAML lists create graph edges: `features: ["[[foo]]"]`.
- Keep session bodies concise: summary, key decisions, changes made, problems solved, open items, session log.
- Strip noisy tool output, long stack traces, repeated messages, and raw secrets.

## Quit/save safety
- Do not enable automatic save-on-quit behavior globally without explicit user confirmation.
- If user asks `quit and save`, ask whether to write lightweight hot-cache only or full permanent archive, then run matching skill before quitting.

## Coding Guidelines

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think Before Coding
**Don't assume. Don't hide confusion. Surface tradeoffs.**
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First
**Minimum code that solves the problem. Nothing speculative.**
- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes
**Touch only what you must. Clean up only your own mess.**
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.
- The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution
**Define success criteria. Loop until verified.**
- Transform tasks into verifiable goals (e.g., "Add validation" → "Write tests for invalid inputs, then make them pass").
- For multi-step tasks, state a brief plan: `[Step] → verify: [check]`.
- Strong success criteria let you loop independently. Weak criteria require constant clarification.

## Skill priority — mattpocock engineering ↔ local (prefer local on overlap)
- Architecture review / refactor opportunities → prefer `audit-architecture` over `improve-codebase-architecture`.
- Go bugs / debugging → prefer `golang-troubleshooting` over `diagnose` (use `diagnose` for non-Go or cross-cutting).
- UI prototype / mockups → prefer `frontend-design` over `prototype`.
- Issues / PRD / triage → use `to-issues` / `to-prd` / `triage` ONLY when explicitly named AND
  `setup-matt-pocock-skills` has been run in the repo; otherwise use the normal flow.
- `grill-with-docs` and `improve-codebase-architecture` expect `CONTEXT.md` + `docs/adr/` →
  run `setup-matt-pocock-skills` in the repo first.
