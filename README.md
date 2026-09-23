# ikura dotfiles

Personal macOS configuration for Fish, tmux, Ghostty, Neovim, Zsh, and selected developer tools. Current theme: [Kanagawa](https://github.com/rebelot/kanagawa.nvim).

## Structure

- `config/` — XDG application config
- `home/` — files linked directly into `$HOME`
- `tools/` — safe Pi, Codex, OpenCode, and Zed config
- `Brewfile` — essential tools and apps
- `Brewfile.optional` — opt-in tools and apps
- `bootstrap.sh` — file-level symlink installer

## New Mac setup

Install Xcode Command Line Tools and Homebrew:

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Clone and install essentials:

```sh
git clone https://github.com/winxene/ikura.git ~/dotfiles
brew bundle --file=~/dotfiles/Brewfile
~/dotfiles/bootstrap.sh --dry-run
~/dotfiles/bootstrap.sh
```

Install optional apps and tools when needed:

```sh
brew bundle --file=~/dotfiles/Brewfile.optional
```

Enable Fish:

```sh
grep -qxF /opt/homebrew/bin/fish /etc/shells || echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

Sign in to apps and developer tools manually. Credentials, SSH keys, API keys, sessions, histories, caches, databases, generated files, and personal data are intentionally excluded.

## Check

```sh
fish -n ~/.config/fish/config.fish
tmux -f ~/.config/tmux/tmux.conf start-server \; kill-server
nvim --headless '+qa'
find ~/.config ~/.pi ~/.codex -type l ! -exec test -e {} \; -print
```

No output from the final command means managed links resolve.

## Update

```sh
git -C ~/dotfiles pull --ff-only
~/dotfiles/bootstrap.sh
```

## Rollback

Conflicting files are moved to `~/.dotfiles-backup/<timestamp>/` before linking. To restore one, remove its symlink and move the matching backup file to its original path. Migration-level Git backups live under `~/.dotfiles-migration-backup/`.

## Notes

Neovim uses [lazy.nvim](https://github.com/folke/lazy.nvim). Configuration references:

- <https://github.com/craftzdog/dotfiles-public/tree/master>
- <https://github.com/josean-dev/dev-environment-files>
