# Safe Dotfiles Expansion Design

## Goal

Organize remaining human-edited configuration under `~/dotfiles` while leaving credentials, histories, caches, databases, SDKs, package stores, and generated state local.

## Approach

Extend the existing explicit allowlist and file-level bootstrap. Applications keep required paths under `$HOME`, but managed files there become symlinks into `~/dotfiles`. Never link whole runtime directories.

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
