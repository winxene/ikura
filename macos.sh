#!/bin/sh
set -eu

dry_run=false
case ${1-} in
  '') ;;
  --dry-run) dry_run=true ;;
  *) printf 'usage: %s [--dry-run]\n' "$0" >&2; exit 2 ;;
esac

run() {
  printf '+ '
  printf '%s ' "$@"
  printf '\n'
  if [ "$dry_run" = false ]; then "$@"; fi
}

backup="$HOME/.dotfiles-macos-backup/$(date +%Y%m%d-%H%M%S)"
if [ "$dry_run" = false ]; then
  mkdir -p "$backup"
  defaults export com.apple.dock "$backup/com.apple.dock.plist"
  defaults export com.apple.finder "$backup/com.apple.finder.plist"
else
  printf '+ backup Dock and Finder defaults to %s\n' "$backup"
fi

run defaults write com.apple.dock autohide -bool true
run defaults write com.apple.dock tilesize -int 25
run defaults write com.apple.dock magnification -bool true
run defaults write com.apple.dock mineffect -string scale
run defaults write com.apple.dock show-recents -bool false
run defaults write com.apple.dock orientation -string bottom
run defaults write com.apple.finder ShowPathbar -bool true
run defaults write com.apple.finder FXPreferredViewStyle -string Nlsv

if [ "$dry_run" = false ]; then
  killall Dock 2>/dev/null || true
  killall Finder 2>/dev/null || true
else
  printf '+ restart Dock and Finder\n'
fi
