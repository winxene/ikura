#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
home="$tmp/home"
mkdir -p "$home/.config/fish"
printf 'old config\n' > "$home/.config/fish/config.fish"

HOME="$home" "$repo/bootstrap.sh" --dry-run >/dev/null
test ! -L "$home/.config/fish/config.fish"
test "$(cat "$home/.config/fish/config.fish")" = "old config"

HOME="$home" "$repo/bootstrap.sh" >/dev/null
test -L "$home/.config/fish/config.fish"
test "$(readlink "$home/.config/fish/config.fish")" = "$repo/config/fish/config.fish"
test "$(readlink "$home/.gitconfig")" = "$repo/home/.gitconfig"
test "$(readlink "$home/.config/herdr/config.toml")" = "$repo/config/herdr/config.toml"
test "$(readlink "$home/.config/neofetch/config.conf")" = "$repo/config/neofetch/config.conf"
test "$(readlink "$home/.claude/settings.json")" = "$repo/tools/claude/settings.json"
test "$(readlink "$home/.gemini/settings.json")" = "$repo/tools/gemini/settings.json"
test "$(readlink "$home/.agents/.skill-lock.json")" = "$repo/tools/agents/.skill-lock.json"
backup_count=$(find "$home/.dotfiles-backup" -type f -path '*/.config/fish/config.fish' | wc -l | tr -d ' ')
test "$backup_count" = 1

HOME="$home" "$repo/bootstrap.sh" >/dev/null
test "$(find "$home/.dotfiles-backup" -type f -path '*/.config/fish/config.fish' | wc -l | tr -d ' ')" = 1

broken=$(find "$home" -type l ! -exec test -e {} \; -print)
test -z "$broken"

printf 'bootstrap test passed\n'
