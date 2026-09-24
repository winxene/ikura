# ikura dotfiles

Personal macOS configuration for Fish, tmux, Ghostty, Neovim, Zsh, and selected developer tools. Current theme: [Kanagawa](https://github.com/rebelot/kanagawa.nvim).

## Structure

- `config/` — XDG application config
- `home/` — files linked directly into `$HOME`
- `tools/` — safe AI/developer-tool config
- `Brewfile` — essential tools and apps
- `Brewfile.optional` — opt-in tools and apps
- `setup.sh` — interactive app/config/macOS setup
- `bootstrap.sh` — file-level symlink installer
- `macos.sh` — allowlisted Dock and Finder settings

## New Mac setup

Install Xcode Command Line Tools once:

```sh
xcode-select --install
```

Then clone and start interactive setup with one pasted command:

```sh
git clone https://github.com/winxene/ikura.git ~/dotfiles && ~/dotfiles/setup.sh
```

The menu installs essentials, optional apps, dotfiles, and safe macOS settings. Preview without changes using `~/dotfiles/setup.sh --dry-run`. Homebrew is installed automatically when missing.

Enable Fish:

```sh
grep -qxF /opt/homebrew/bin/fish /etc/shells || echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

Sign in to apps and developer tools manually. Credentials, SSH keys, API keys, sessions, histories, caches, databases, generated files, and personal data are intentionally excluded. Git identity stays in local-only `~/.gitconfig.local`.

## Check

```sh
fish -n ~/.config/fish/config.fish
tmux -f ~/.config/tmux/tmux.conf start-server \; kill-server
nvim --headless '+qa'
find ~/.config ~/.pi ~/.codex ~/.claude ~/.gemini ~/.agents -type l ! -exec test -e {} \; -print
```

No output from the final command means managed links resolve.

## Update

```sh
git -C ~/dotfiles pull --ff-only
~/dotfiles/bootstrap.sh
```

## Rollback

Conflicting files are moved to `~/.dotfiles-backup/<timestamp>/` before linking. macOS preferences are exported under `~/.dotfiles-macos-backup/`. To restore one file, remove its symlink and move the matching backup file to its original path. Migration-level Git backups live under `~/.dotfiles-migration-backup/`.

## Notes

Neovim uses [lazy.nvim](https://github.com/folke/lazy.nvim). Configuration references:

- <https://github.com/craftzdog/dotfiles-public/tree/master>
- <https://github.com/josean-dev/dev-environment-files>
