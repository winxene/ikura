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
backup_count=$(find "$home/.dotfiles-backup" -type f -path '*/.config/fish/config.fish' | wc -l | tr -d ' ')
test "$backup_count" = 1

HOME="$home" "$repo/bootstrap.sh" >/dev/null
test "$(find "$home/.dotfiles-backup" -type f -path '*/.config/fish/config.fish' | wc -l | tr -d ' ')" = 1

broken=$(find "$home" -type l ! -exec test -e {} \; -print)
test -z "$broken"

printf 'bootstrap test passed\n'
