# Dotfiles Restructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move managed dotfiles into `~/dotfiles`, preserve Git history, and activate them through safe file-level symlinks without breaking current tools.

**Architecture:** Clone the current local repository into `~/dotfiles`, then reorganize committed files there with `git mv`. A small POSIX shell bootstrap links allowlisted files into `$HOME`, backing up conflicts first; generated state and secrets remain outside Git.

**Tech Stack:** Git, POSIX shell, Homebrew Bundle, native macOS tools

**Spec:** `docs/superpowers/specs/2026-09-23-dotfiles-restructure-design.md`

## Global Constraints

- Preserve existing Git history and GitHub remote.
- Work on `chore/dotfiles-restructure`.
- Never push without explicit approval.
- Exclude credentials, sessions, histories, memories, caches, logs, backups, databases, generated state, `node_modules`, SSH keys, app data, and personal files.
- Keep timestamped migration backups until explicit cleanup approval.
- Keep README concise.
- Use file-level links where applications create generated state beside managed files.

---

### Task 1: Capture recoverable migration state

**Files:**
- Create outside Git: `~/.dotfiles-migration-backup/<timestamp>/repo.bundle`
- Create outside Git: `~/.dotfiles-migration-backup/<timestamp>/working-tree.patch`
- Create outside Git: `~/.dotfiles-migration-backup/<timestamp>/untracked-files.txt`

**Interfaces:**
- Consumes: current `$HOME/.git` repository and working tree
- Produces: complete ref bundle plus working-tree recovery records

- [ ] **Step 1: Record current state**

```bash
backup="$HOME/.dotfiles-migration-backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup"
git -C "$HOME" status --short --branch > "$backup/status.txt"
git -C "$HOME" remote -v > "$backup/remotes.txt"
git -C "$HOME" diff --binary > "$backup/working-tree.patch"
git -C "$HOME" ls-files --others --exclude-standard > "$backup/untracked-files.txt"
printf '%s\n' "$backup" > /tmp/dotfiles-migration-backup-path
```

- [ ] **Step 2: Bundle every Git ref**

```bash
backup=$(cat /tmp/dotfiles-migration-backup-path)
git -C "$HOME" bundle create "$backup/repo.bundle" --all
git bundle verify "$backup/repo.bundle"
```

Expected: bundle verification reports all refs complete.

- [ ] **Step 3: Copy modified tracked files needed by migration**

```bash
backup=$(cat /tmp/dotfiles-migration-backup-path)
mkdir -p "$backup/modified"
git -C "$HOME" diff --name-only -z | while IFS= read -r -d '' file; do
  mkdir -p "$backup/modified/$(dirname "$file")"
  cp -p "$HOME/$file" "$backup/modified/$file"
done
```

- [ ] **Step 4: Verify backup files exist**

```bash
backup=$(cat /tmp/dotfiles-migration-backup-path)
test -s "$backup/repo.bundle"
test -f "$backup/working-tree.patch"
test -f "$backup/status.txt"
```

### Task 2: Create dedicated repository and preserve current edits

**Files:**
- Create: `~/dotfiles/`
- Modify in clone: `.config/fish/completions/bun.fish`
- Modify in clone: `.config/fish/config.fish`
- Modify in clone: `.config/tmux/tmux.conf`
- Modify in clone: `.zshrc`

**Interfaces:**
- Consumes: backup path from Task 1 and current local repository
- Produces: standalone `~/dotfiles` clone on `chore/dotfiles-restructure`

- [ ] **Step 1: Clone local history without hardlinks**

```bash
remote=$(git -C "$HOME" remote get-url origin)
git clone --no-hardlinks --branch chore/dotfiles-restructure "$HOME" "$HOME/dotfiles"
git -C "$HOME/dotfiles" remote set-url origin "$remote"
test "$(git -C "$HOME/dotfiles" remote get-url origin)" = "$remote"
```

- [ ] **Step 2: Restore modified tracked files into clone**

```bash
backup=$(cat /tmp/dotfiles-migration-backup-path)
for file in \
  .config/fish/completions/bun.fish \
  .config/fish/config.fish \
  .config/tmux/tmux.conf \
  .zshrc
do
  test -f "$backup/modified/$file" || continue
  cp -p "$backup/modified/$file" "$HOME/dotfiles/$file"
done
```

- [ ] **Step 3: Verify clone independence and branch**

```bash
test "$(git -C "$HOME/dotfiles" branch --show-current)" = chore/dotfiles-restructure
test "$(git -C "$HOME/dotfiles" rev-parse --git-dir)" = .git
git -C "$HOME/dotfiles" status --short
```

Expected: only known current edits appear.

### Task 3: Reorganize core configs and remove generated artifacts

**Files:**
- Move: `.config/brew/Brewfile` → `Brewfile`
- Move: `.config/fish/` → `config/fish/`
- Move: `.config/ghostty/` → `config/ghostty/`
- Move: `.config/git/` → `config/git/`
- Move: `.config/nvim/` → `config/nvim/`
- Move: `.config/starship.toml` → `config/starship.toml`
- Move: `.config/tmux/` → `config/tmux/`
- Move: `.zshrc` → `home/.zshrc`
- Preserve under `config/`: `ide`, `iterm2`, `linearmouse`, `omf`, and `themes`
- Remove from tracking: Mole logs and machine-specific `xbuild/monodroid-config.xml`

**Interfaces:**
- Consumes: standalone clone from Task 2
- Produces: organized core configuration tree with history-preserving moves

- [ ] **Step 1: Create destination directories and move tracked content**

```bash
cd "$HOME/dotfiles"
mkdir -p config home
git mv .config/brew/Brewfile Brewfile
git mv .config/fish config/fish
git mv .config/ghostty config/ghostty
git mv .config/git config/git
git mv .config/nvim config/nvim
git mv .config/starship.toml config/starship.toml
git mv .config/tmux config/tmux
git mv .config/ide config/ide
git mv .config/iterm2 config/iterm2
git mv .config/linearmouse config/linearmouse
git mv .config/omf config/omf
git mv .config/themes config/themes
git mv .zshrc home/.zshrc
git rm -r .config/mole .config/xbuild
```

- [ ] **Step 2: Make home paths portable**

Replace active `/Users/ikura` references with `$HOME`-compatible syntax in Fish and Zsh. Remove the active Ghostty background image path because it points into Downloads. Keep `/opt/homebrew` where executable paths require the Apple Silicon Homebrew prefix.

Run:

```bash
cd "$HOME/dotfiles"
grep -RIn '/Users/ikura' config home --exclude='*.log' || true
fish -n config/fish/config.fish
```

Expected: no active machine-specific home path remains; Fish syntax succeeds.

- [ ] **Step 3: Commit core layout locally**

```bash
cd "$HOME/dotfiles"
git add Brewfile config home
git diff --cached --check
git commit -m "refactor(dotfiles): move configs into dedicated layout"
```

### Task 4: Add safe developer-tool allowlists

**Files:**
- Create: `tools/pi/agent/`
- Create: `tools/codex/`
- Create: `tools/opencode/`
- Create: `tools/zed/`

**Interfaces:**
- Consumes: safe live configuration files selected below
- Produces: versioned developer-tool config without credentials or runtime state

- [ ] **Step 1: Copy Pi allowlist**

Copy only existing safe paths from `~/.pi/agent`: `AGENTS.md`, `settings.json`, `models.json`, `prompts/`, `skills/`, and `scripts/`. Do not copy `auth.json`, MCP caches, trust state, run history, sessions, memory, package caches, or generated Git directories.

```bash
cd "$HOME/dotfiles"
mkdir -p tools/pi/agent
for path in AGENTS.md settings.json models.json prompts skills scripts; do
  test -e "$HOME/.pi/agent/$path" && cp -R "$HOME/.pi/agent/$path" tools/pi/agent/
done
```

- [ ] **Step 2: Copy Codex allowlist**

```bash
cd "$HOME/dotfiles"
mkdir -p tools/codex
for path in config.toml agents hooks.json; do
  test -e "$HOME/.codex/$path" && cp -R "$HOME/.codex/$path" tools/codex/
done
```

Exclude `auth.json`, histories, sessions, memories, caches, SQLite files, installation IDs, locks, logs, and backups.

- [ ] **Step 3: Copy OpenCode and Zed allowlists**

```bash
cd "$HOME/dotfiles"
mkdir -p tools/opencode/plugins tools/zed
for path in opencode.jsonc oh-my-opencode-slim.json tui.json package.json package-lock.json; do
  test -f "$HOME/.config/opencode/$path" && cp -p "$HOME/.config/opencode/$path" tools/opencode/
done
test -d "$HOME/.config/opencode/plugins" && cp -R "$HOME/.config/opencode/plugins/." tools/opencode/plugins/
for path in settings.json keymap.json; do
  test -f "$HOME/.config/zed/$path" && cp -p "$HOME/.config/zed/$path" tools/zed/
done
```

- [ ] **Step 4: Scan staged candidates before adding**

```bash
cd "$HOME/dotfiles"
find tools -type f \( -name 'auth.json' -o -name '*.db' -o -name '*.sqlite*' -o -name '*.jsonl' -o -name '*.log' \) -print
grep -RIlE '(api[_-]?key|access[_-]?token|client[_-]?secret|password)[[:space:]]*[=:][[:space:]]*[^$<{[:space:]]+' tools || true
```

Expected: filename scan returns nothing. Inspect and exclude every secret-pattern match before staging.

- [ ] **Step 5: Commit safe developer config locally**

```bash
cd "$HOME/dotfiles"
git add tools
git diff --cached --check
git commit -m "feat(dotfiles): manage developer tool configuration"
```

### Task 5: Curate Homebrew manifests

**Files:**
- Modify: `Brewfile`
- Create: `Brewfile.optional`

**Interfaces:**
- Consumes: existing generated Brewfile and installed-package audit
- Produces: lean default installation plus opt-in extras

- [ ] **Step 1: Keep default development essentials**

Keep these requested packages in `Brewfile`, plus required taps:

```text
ast-grep bat cmake cocoapods colima docker fd ffmpeg fish fisher fnm fzf
go imagemagick jq lazydocker lazygit llvm neovim ninja node openjdk pandoc
python@3.12 ripgrep rustup starship swiftgen swiftlint tmux tree trivy
watchman wget xcodegen yazi zoxide
```

Keep default casks:

```text
android-studio codex docker-desktop font-symbols-only-nerd-font ghostty
git-credential-manager obsidian zed
```

Keep global package entries required for Pi, Copilot, Gemini CLI, and pnpm. Remove duplicate `git-credential-manager`, stale `vnc-viewer`, and dependency-only formula entries.

- [ ] **Step 2: Move remaining explicit apps/tools to optional manifest**

Move browsers, communication apps, licensed utilities, CAD, databases, embedded tooling, security/network tools, VS Code extensions, extra Go tools, extra Cargo tools, and non-core npm CLIs into `Brewfile.optional`. Rename `vnc-viewer` to `realvnc-connect-viewer`; omit unavailable `voov-meeting`.

- [ ] **Step 3: Format and validate manifests**

```bash
cd "$HOME/dotfiles"
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file=Brewfile || true
brew bundle list --file=Brewfile >/dev/null
brew bundle list --file=Brewfile.optional >/dev/null
grep -E '^(tap|brew|cask|vscode|go|cargo|npm) ' Brewfile Brewfile.optional | sort | uniq -d
```

Expected: both manifests parse and no identical entries appear twice. Missing packages on current machine may remain reported when intentionally selected.

- [ ] **Step 4: Commit manifests locally**

```bash
cd "$HOME/dotfiles"
git add Brewfile Brewfile.optional
git diff --cached --check
git commit -m "chore(brew): split essential and optional packages"
```

### Task 6: Build and test bootstrap script

**Files:**
- Create: `bootstrap.sh`
- Create: `tests/bootstrap_test.sh`

**Interfaces:**
- Consumes: `home/`, `config/`, and `tools/` trees
- Produces: `bootstrap.sh [--dry-run]` with conflict backup and idempotent file-level links

- [ ] **Step 1: Write failing isolated test**

Test with a temporary `HOME`. It must verify dry-run changes nothing, first run backs up a conflicting Fish config and links managed files, second run succeeds without another backup, and every resulting link resolves.

```bash
HOME="$tmp/home" "$repo/bootstrap.sh" --dry-run
HOME="$tmp/home" "$repo/bootstrap.sh"
HOME="$tmp/home" "$repo/bootstrap.sh"
find "$tmp/home" -type l ! -exec test -e {} \; -print | grep -q . && exit 1
```

- [ ] **Step 2: Run test and confirm failure**

```bash
cd "$HOME/dotfiles"
sh tests/bootstrap_test.sh
```

Expected: FAIL because `bootstrap.sh` does not exist.

- [ ] **Step 3: Implement minimal bootstrap**

Implement:

- `--dry-run` as the only option
- repository root derived from script location
- timestamped backup under `${HOME}/.dotfiles-backup/`
- `link_file SOURCE TARGET` that leaves a correct link untouched, backs up conflicting targets, creates parent directories, and links source
- `link_tree SOURCE TARGET_DIR` that mirrors files recursively with file-level links
- mappings for `home`, core `config` paths, and allowlisted `tools` targets
- nonzero exit for unknown arguments or missing source files

- [ ] **Step 4: Run bootstrap checks**

```bash
cd "$HOME/dotfiles"
sh -n bootstrap.sh tests/bootstrap_test.sh
sh tests/bootstrap_test.sh
./bootstrap.sh --dry-run
```

Expected: syntax and isolated tests pass; live dry-run reports operations without changing `$HOME`.

- [ ] **Step 5: Commit bootstrap locally**

```bash
cd "$HOME/dotfiles"
git add bootstrap.sh tests/bootstrap_test.sh
git diff --cached --check
git commit -m "feat(dotfiles): add safe symlink bootstrap"
```

### Task 7: Write concise setup guide

**Files:**
- Modify: `README.md`

**Interfaces:**
- Consumes: final repository structure and bootstrap commands
- Produces: short fresh-Mac and rollback guide

- [ ] **Step 1: Update README**

Keep existing attribution/theme context, corrected Lazy.nvim link, and add only:

- prerequisites: Xcode CLI tools and Homebrew
- clone into `~/dotfiles`
- `brew bundle --file=~/dotfiles/Brewfile`
- optional `brew bundle --file=~/dotfiles/Brewfile.optional`
- `~/dotfiles/bootstrap.sh --dry-run`, then `~/dotfiles/bootstrap.sh`
- Fish shell selection
- manual sign-in/secrets note
- validation and rollback commands
- explicit exclusions

- [ ] **Step 2: Verify commands and links**

```bash
cd "$HOME/dotfiles"
grep -n 'https:/github.com' README.md && exit 1 || true
grep -nE 'bootstrap\.sh|Brewfile\.optional|rollback|secret' README.md
```

Expected: malformed link absent; required guide topics present.

- [ ] **Step 3: Commit README locally**

```bash
cd "$HOME/dotfiles"
git add README.md
git diff --cached --check
git commit -m "docs(dotfiles): add mac setup guide"
```

### Task 8: Activate links and detach `$HOME` repository

**Files:**
- Rename: `~/.git` → migration backup
- Replace managed live config files with links into `~/dotfiles`

**Interfaces:**
- Consumes: tested bootstrap and migration backup
- Produces: working live setup backed by standalone repository

- [ ] **Step 1: Run pre-cutover validation**

```bash
cd "$HOME/dotfiles"
sh tests/bootstrap_test.sh
fish -n config/fish/config.fish
nvim --headless -u "$HOME/.config/nvim/init.lua" '+qa' 2>/dev/null || true
git status --short
```

Inspect status and confirm only planned files are changed or committed.

- [ ] **Step 2: Activate managed links**

```bash
"$HOME/dotfiles/bootstrap.sh" --dry-run
"$HOME/dotfiles/bootstrap.sh"
```

- [ ] **Step 3: Validate live tools**

```bash
fish -n "$HOME/.config/fish/config.fish"
git config --global --list >/dev/null
tmux -f "$HOME/.config/tmux/tmux.conf" start-server \; kill-server
nvim --headless '+qa'
find "$HOME" -maxdepth 5 -type l ! -exec test -e {} \; -print
```

Expected: commands succeed and no managed broken links appear.

- [ ] **Step 4: Detach home repository reversibly**

```bash
backup=$(cat /tmp/dotfiles-migration-backup-path)
mv "$HOME/.git" "$backup/home.git"
test -d "$backup/home.git"
git -C "$HOME/dotfiles" status --short --branch
```

- [ ] **Step 5: Record final state without pushing**

```bash
backup=$(cat /tmp/dotfiles-migration-backup-path)
printf 'dotfiles=%s\ncommit=%s\nbranch=%s\n' \
  "$HOME/dotfiles" \
  "$(git -C "$HOME/dotfiles" rev-parse HEAD)" \
  "$(git -C "$HOME/dotfiles" branch --show-current)" \
  > "$backup/final-state.txt"
git -C "$HOME/dotfiles" status --short --branch
git -C "$HOME/dotfiles" log --oneline origin/main..HEAD
```

Expected: clean or intentionally documented status; local commits visible; no push performed.
