#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
dry_run=false

case ${1-} in
  '') ;;
  --dry-run) dry_run=true ;;
  *) printf 'usage: %s [--dry-run]\n' "$0" >&2; exit 2 ;;
esac

backup_root="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link_file() {
  source=$1
  target=$2

  if [ ! -e "$source" ] && [ ! -L "$source" ]; then
    printf 'missing source: %s\n' "$source" >&2
    exit 1
  fi

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    relative=${target#"$HOME"/}
    backup="$backup_root/$relative"
    printf 'backup %s -> %s\n' "$target" "$backup"
    if [ "$dry_run" = false ]; then
      mkdir -p "$(dirname "$backup")"
      mv "$target" "$backup"
    fi
  fi

  printf 'link %s -> %s\n' "$target" "$source"
  if [ "$dry_run" = false ]; then
    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
  fi
}

link_tree() {
  source_dir=$1
  target_dir=$2

  find "$source_dir" \( -type f -o -type l \) -print | while IFS= read -r source; do
    relative=${source#"$source_dir"/}
    link_file "$source" "$target_dir/$relative"
  done
}

retire_link() {
  target=$1

  if [ -L "$target" ]; then
    source=$(readlink "$target")
    case $source in
      "$repo"/*)
        printf 'unlink retired %s\n' "$target"
        [ "$dry_run" = true ] || unlink "$target"
        ;;
    esac
  fi
}

for target in \
  "$HOME/.bash_profile" \
  "$HOME/.bashrc" \
  "$HOME/.p10k.zsh" \
  "$HOME/.yarnrc" \
  "$HOME/.config/fish/completions/bun.fish" \
  "$HOME/.config/fish/conf.d/fish_frozen_key_bindings.fish" \
  "$HOME/.config/fish/conf.d/fish_frozen_theme.fish" \
  "$HOME/.config/fish/conf.d/z.fish" \
  "$HOME/.config/fish/config-osx.fish" \
  "$HOME/.config/fish/functions/__z.fish" \
  "$HOME/.config/fish/functions/__z_add.fish" \
  "$HOME/.config/fish/functions/__z_clean.fish" \
  "$HOME/.config/fish/functions/__z_complete.fish" \
  "$HOME/.config/fish/functions/peco_kill.fish" \
  "$HOME/.config/fish/functions/peco_select_history.fish" \
  "$HOME/.config/omf/bundle" \
  "$HOME/.config/omf/channel" \
  "$HOME/.config/omf/theme"
do
  retire_link "$target"
done

link_tree "$repo/home" "$HOME"

for name in fish ghostty git herdr ide linearmouse neofetch nvim themes tmux; do
  link_tree "$repo/config/$name" "$HOME/.config/$name"
done
link_file "$repo/config/starship.toml" "$HOME/.config/starship.toml"

link_tree "$repo/tools/pi/agent" "$HOME/.pi/agent"
link_tree "$repo/tools/codex" "$HOME/.codex"
link_tree "$repo/tools/opencode" "$HOME/.config/opencode"
link_tree "$repo/tools/zed" "$HOME/.config/zed"
link_tree "$repo/tools/claude" "$HOME/.claude"
link_tree "$repo/tools/gemini" "$HOME/.gemini"
link_tree "$repo/tools/agents" "$HOME/.agents"
