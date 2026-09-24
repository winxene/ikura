# Safe Dotfiles Expansion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move remaining human-edited configuration into `~/dotfiles` while preserving local identity, credentials, and runtime state outside Git.

**Architecture:** Extend existing `home/`, `config/`, and `tools/` allowlists. Reuse `bootstrap.sh` file-level backup/link behavior; sanitize copied JSON/TOML and test activation under a temporary home before touching live files. Add an interactive `setup.sh` entry point and a narrowly allowlisted `macos.sh` settings script, both with dry-run support.

**Tech Stack:** POSIX shell, Git, Python standard library, JSON, TOML

**Spec:** `docs/superpowers/specs/2026-09-23-safe-dotfiles-expansion-design.md`

## Global Constraints

- Public repository contains no personal/work Git identity or secrets.
- Never track credentials, histories, sessions, caches, databases, SDKs, package stores, generated state, or application data.
- Preserve live files in timestamped backups before linking or cleanup; rollback restores matching files from that backup.
- Keep `.gitconfig.local` and `.gitconfig-velapod` local.
- Work on `chore/dotfiles-restructure`; commit locally; do not push without explicit approval.

---

### Task 1: Create recovery snapshot

**Files:**
- Create outside Git: `~/.dotfiles-expansion-backup/<timestamp>/`

**Interfaces:**
- Produces: backup path in `/tmp/dotfiles-expansion-backup-path`

- [ ] Create backup directory, record repository status, and copy every source file selected by this plan before editing.

```bash
backup="$HOME/.dotfiles-expansion-backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup/source"
printf '%s\n' "$backup" > /tmp/dotfiles-expansion-backup-path
git -C "$HOME/dotfiles" status --short --branch > "$backup/repo-status.txt"
```

- [ ] Verify repository starts clean and backup exists.

```bash
test -z "$(git -C "$HOME/dotfiles" status --porcelain)"
test -d "$backup/source"
```

### Task 2: Add standalone and application configuration

**Files:**
- Create: `home/.bash_profile`, `home/.bashrc`, `home/.condarc`, `home/.gitconfig`, `home/.p10k.zsh`, `home/.yarnrc`, `home/.zprofile`
- Create: `config/herdr/config.toml`, `config/neofetch/config.conf`
- Create locally only: `~/.gitconfig.local`

**Interfaces:**
- Produces: portable shell/app config and local Git identity

- [ ] Copy standalone config into `home/`, replacing active `/Users/ikura` shell paths with `$HOME`.
- [ ] Build `home/.gitconfig` from current non-identity settings. Add `[include] path = ~/.gitconfig.local` and retain conditional include of `~/.gitconfig-velapod`.
- [ ] Write current `user.name` and `user.email` into mode-600 `~/.gitconfig.local`; never stage it.
- [ ] Copy Herdr and Neofetch configs; verify Herdr `key` fields are keybindings, not credentials.
- [ ] Parse shell and Git config, scan candidates, then commit.

```bash
bash -n home/.bash_profile home/.bashrc
git config --file home/.gitconfig --list >/dev/null
! rg -n '/Users/ikura' home config/herdr config/neofetch
git add home config/herdr config/neofetch
git diff --cached --check
git commit -m "feat(dotfiles): manage remaining shell and app config"
```

### Task 3: Add Claude, Gemini, and agent manifests

**Files:**
- Create: `tools/claude/{CLAUDE.md,settings.json,agents/,commands/,hooks/,plugins/config.json}`
- Create: `tools/gemini/{GEMINI.md,settings.json,commands/,hooks/,config/config.json,config/hooks.json,config/mcp_config.json}`
- Create: `tools/agents/.skill-lock.json`

**Interfaces:**
- Produces: sanitized, human-authored AI tool configuration

- [ ] Copy exact allowlists. Exclude Claude/Gemini histories, projects, sessions, state, auth files, backups, generated packages, and Gemini `config/projects/`.
- [ ] Recursively make command strings portable: replace single-quoted `/Users/ikura/...` paths with double-quoted `$HOME/...`, then replace remaining `/Users/ikura` with `$HOME`.
- [ ] Remove `mcpServers.paca.env.PACA_API_KEY` from Gemini settings. Preserve non-secret auth mode settings.
- [ ] Scan for high-confidence token/private-key patterns and forbidden filenames; parse copied JSON.
- [ ] Commit safe tool config.

```bash
! rg -n '/Users/ikura' tools/claude tools/gemini tools/agents
! rg -n '(paca_[a-f0-9]{20,}|sk-[A-Za-z0-9_-]{20,}|AIza[A-Za-z0-9_-]{20,}|gh[pousr]_[A-Za-z0-9]{20,}|-----BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY-----)' tools/claude tools/gemini tools/agents
git add tools/claude tools/gemini tools/agents
git diff --cached --check
git commit -m "feat(dotfiles): manage Claude and Gemini config"
```

### Task 4: Extend bootstrap using TDD

**Files:**
- Modify: `bootstrap.sh`
- Modify: `tests/bootstrap_test.sh`

**Interfaces:**
- Produces: mappings for new home/config/tool paths

- [ ] Extend isolated test to assert `.gitconfig`, Herdr, Claude, Gemini, and agent-manifest links; run it and confirm failure.
- [ ] Add `herdr` and `neofetch` to config mappings; link `tools/claude` to `~/.claude`, `tools/gemini` to `~/.gemini`, and `tools/agents` to `~/.agents`.
- [ ] Run shell syntax, isolated test, live dry-run, and commit.

```bash
sh -n bootstrap.sh tests/bootstrap_test.sh
sh tests/bootstrap_test.sh
./bootstrap.sh --dry-run >/tmp/dotfiles-expansion-dry-run.txt
git add bootstrap.sh tests/bootstrap_test.sh
git diff --cached --check
git commit -m "feat(dotfiles): link expanded config allowlist"
```

### Task 5: Add one-command installer and safe macOS settings

**Files:**
- Create: `setup.sh`
- Create: `macos.sh`
- Create: `tests/setup_test.sh`

**Interfaces:**
- Produces: interactive setup choices and allowlisted macOS preferences

- [ ] Write a failing test that pipes choices 1–4 into `setup.sh --dry-run` and verifies expected Brewfile, bootstrap, and macOS actions.
- [ ] Implement `macos.sh [--dry-run]`: back up current allowlisted defaults, apply audited Dock/Finder values, then restart only Dock and Finder.
- [ ] Implement `setup.sh [--dry-run]`: install Homebrew when missing, show four choices, run essential and optional Brewfiles as selected, run bootstrap, optionally run macOS settings, then validate links.
- [ ] Run shell syntax and setup tests, then commit.

```bash
sh -n setup.sh macos.sh tests/setup_test.sh
sh tests/setup_test.sh
printf '4\n' | ./setup.sh --dry-run
git add setup.sh macos.sh tests/setup_test.sh
git diff --cached --check
git commit -m "feat(dotfiles): add interactive Mac setup"
```

### Task 6: Activate, clean obsolete duplicates, and verify

**Files:**
- Replace approved live files with links
- Move to backup: `~/.config/brew/Brewfile`, `~/.gitignore`, and confirmed empty obsolete config directories
- Modify: `README.md`

**Interfaces:**
- Produces: active expanded dotfiles setup with reversible cleanup

- [ ] Update README managed-scope and local Git identity notes.
- [ ] Run bootstrap dry-run, then activation.
- [ ] Validate Bash, Zsh, Git identity/config, Herdr TOML, JSON, and every managed link.
- [ ] Move obsolete duplicate files and empty directories into expansion backup; never delete.
- [ ] Commit README and run final clean-tree verification.

```bash
bash -n "$HOME/.bash_profile" "$HOME/.bashrc"
zsh -n "$HOME/.zprofile" "$HOME/.p10k.zsh"
git config --global --list >/dev/null
test -n "$(git config --global user.name)"
test -n "$(git config --global user.email)"
sh tests/bootstrap_test.sh
test -z "$(git status --porcelain)"
```
