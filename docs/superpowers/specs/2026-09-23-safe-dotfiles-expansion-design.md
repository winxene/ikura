# Safe Dotfiles Expansion Design

## Goal

Organize remaining human-edited configuration under `~/dotfiles` while leaving credentials, histories, caches, databases, SDKs, package stores, and generated state local.

## Approach

Extend the existing explicit allowlist and file-level bootstrap. Applications keep required paths under `$HOME`, but managed files there become symlinks into `~/dotfiles`. Never link whole runtime directories.

Add `setup.sh` as the interactive entry point. It installs Homebrew when missing, offers essential/optional package and macOS-setting choices, runs `bootstrap.sh`, then validates the setup. `setup.sh --dry-run` prints actions without changing the machine.

## Scope

Add standalone configuration under `home/`:

- `.bash_profile`
- `.bashrc`
- `.condarc`
- `.gitconfig`
- `.p10k.zsh`
- `.yarnrc`
- `.zprofile`

Add application configuration under `config/`:

- `herdr/config.toml`, after removing generated or secret values
- `neofetch/config.conf`

Add developer-tool configuration under `tools/`:

- Claude: `CLAUDE.md`, settings, agents, commands, hooks, and safe plugin configuration
- Gemini: `GEMINI.md`, settings, commands, hooks, and safe config
- Agent package manifest: `.skill-lock.json`

## Git identity

The public repository must not contain personal or work identity. Managed `.gitconfig` contains generic settings and includes `~/.gitconfig.local`. Before activation, current name and email are written to local-only `~/.gitconfig.local`. Existing `.gitconfig-velapod` remains local and may be included conditionally.

## Exclusions

Never track:

- Credentials, auth/OAuth data, API keys, private keys, or installation IDs
- Histories, sessions, conversations, projects, memories, or backups
- Logs, caches, databases, generated state, `node_modules`, or plugin package contents
- `.ssh`, `.cargo`, `.rustup`, `.npm`, `.bun`, SDKs, or application data under `Library`

## Migration

1. Create a fresh timestamped backup.
2. Copy only approved paths into `~/dotfiles`.
3. Replace machine-specific home paths and remove secret fields.
4. Scan every candidate before staging.
5. Extend bootstrap mappings and its isolated test.
6. Create `.gitconfig.local` before replacing live Git configuration.
7. Activate links and validate each affected tool.
8. Move obsolete duplicates and empty config remnants into backup.
9. Commit locally; do not push without explicit approval.

## macOS settings

`macos.sh` manages only audited, explicit preferences:

- Dock auto-hide, 25-pixel tile size, magnification, scale minimization, hidden recent apps, bottom orientation
- Finder path bar and list view

Before applying changes, save current values to a timestamped backup. Restart Dock and Finder afterward. Do not manage Apple ID/iCloud, Keychain, privacy/TCC, network, display, audio, Touch ID, or hardware-specific preferences.

## One-command setup

Running `~/dotfiles/setup.sh` presents four choices:

1. Essential apps and dotfiles
2. Essential plus optional apps and dotfiles
3. Essential apps, dotfiles, and safe macOS settings
4. Everything

## Cleanup

Move obsolete `~/.config/brew/Brewfile`, old home-repository `~/.gitignore`, and confirmed empty obsolete config directories into the timestamped backup. Never delete them during this migration.

## Validation

- Bootstrap dry-run changes nothing
- Bootstrap runs twice without destructive changes
- Bash and Zsh parse
- Git configuration parses and identity remains available locally
- Managed JSON and TOML parse where formats permit
- Secret and forbidden-file scans pass
- Every managed symlink resolves
- Repository is clean after local commit
