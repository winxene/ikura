- always use context7
- Automatically use context7 for code generation and library documentation.

@RTK.md
# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.

# GSD — default OFF
Do NOT use GSD by default. Skip `gsd-*` skills and `/gsd:*` commands UNLESS the user
explicitly asks for GSD, names a `gsd-` skill, or types `/gsd`. Default to mattpocock
engineering skills + other always-on skills. Re-enable a cluster with `/gsd-surface enable <cluster>`.

# Skill priority — mattpocock engineering ↔ local (prefer local on overlap)
- UI prototype / mockups → prefer `frontend-design` over `prototype`.
- Issues / spec / triage → use mattpocock `to-tickets` / `to-spec` / `triage` ONLY when explicitly
  named AND `setup-matt-pocock-skills` has been run in the repo; otherwise use the normal flow.
  (Upstream renamed these 2026-08: `to-issues`→`to-tickets`, `to-prd`→`to-spec`,
  `diagnose`→`diagnosing-bugs`; `zoom-out` was deleted. Old names are dead.)
- If a GSD cluster IS explicitly enabled, prefer the GSD skill over the mattpocock equivalent
  (`gsd-debug` > `diagnosing-bugs`, `gsd-spec-phase` > `to-spec`, etc.).
- `grill-with-docs` and `improve-codebase-architecture` expect `CONTEXT.md` + `docs/adr/` →
  run `setup-matt-pocock-skills` in the repo first.
