# Dotfiles Restructure Design

## Goal

Move dotfiles from a Git repository rooted at `$HOME` into `~/dotfiles` without disrupting current tools. Preserve Git history and the existing GitHub remote. Do not push until explicitly approved.

## Repository layout

```text
~/dotfiles/
├── Brewfile
├── Brewfile.optional
├── README.md
├── bootstrap.sh
├── home/
│   └── .zshrc
├── config/
│   ├── fish/
│   ├── ghostty/
│   ├── git/
│   ├── nvim/
│   ├── starship.toml
│   └── tmux/
└── tools/
    ├── pi/
    ├── codex/
    ├── opencode/
    └── zed/
```

## Scope

Manage core shell/editor configuration plus safe developer-tool configuration.

Include:

- Fish, Zsh, Git, Ghostty, tmux, Neovim, and Starship
- Essential and optional Homebrew manifests
- Pi instructions, settings, models, prompts, skills, and scripts
- Codex config, agents, and hooks
- OpenCode config, plugins, and package manifests
- Zed settings and keymap

Exclude:

- Authentication and credentials
- Sessions, conversations, histories, and memories
- Caches, logs, backups, databases, generated state, and `node_modules`
- SSH keys, app data, personal files, and secrets

## Deployment

Use a small `bootstrap.sh` built on standard macOS tools. It creates explicit file-level symlinks so applications may keep generated files beside managed configuration. Re-running it must be safe.

Replace hardcoded `/Users/ikura` paths with portable home-directory forms where supported. Keep machine-specific values local when a format cannot express them portably.

## Brewfiles

`Brewfile` contains essentials needed on each development Mac. `Brewfile.optional` contains large, licensed, specialized, or infrequently used packages and applications. Remove stale and duplicate entries rather than reproducing every installed artifact.

## Migration safety

1. Record current repository and configuration state.
2. Create a Git bundle and timestamped file backup.
3. Preserve current valid uncommitted changes before restructuring.
4. Clone the local repository into `~/dotfiles`, preserving history and remote configuration.
5. Reorganize tracked files with `git mv`.
6. Back up each live target before replacing it with a symlink.
7. Validate each tool immediately and restore its original file on failure.
8. Rename, but do not delete, the original `$HOME/.git` during cutover.
9. Keep all migration backups until explicit cleanup approval.

## Validation

- `fish -n` succeeds
- Git configuration parses
- tmux loads its configuration
- Neovim starts headlessly
- Managed symlinks resolve
- Secret-pattern scan finds no tracked credentials
- Bootstrap dry run reports expected operations
- Running bootstrap twice produces no destructive changes

## README

Keep README concise. Document repository purpose, structure, fresh-Mac prerequisites, essential and optional installation, managed files, manual sign-ins, validation, updates, exclusions, and rollback.

## Git workflow

Perform work on `chore/dotfiles-restructure`. Keep unrelated working-tree changes intact. Use focused local commits only after review. Never push without explicit approval.
