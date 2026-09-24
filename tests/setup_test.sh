#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

run_choice() {
  printf '%s\n' "$1" | "$repo/setup.sh" --dry-run
}

assert_not_contains() {
  if printf '%s' "$1" | grep -q "$2"; then
    printf 'unexpected output: %s\n' "$2" >&2
    exit 1
  fi
}

one=$(run_choice 1)
printf '%s' "$one" | grep -q 'Brewfile'
printf '%s' "$one" | grep -q 'bootstrap.sh'
assert_not_contains "$one" 'Brewfile.optional'
assert_not_contains "$one" 'macos.sh'

two=$(run_choice 2)
printf '%s' "$two" | grep -q 'Brewfile.optional'
assert_not_contains "$two" 'macos.sh'

three=$(run_choice 3)
printf '%s' "$three" | grep -q 'macos.sh'
assert_not_contains "$three" 'Brewfile.optional'

four=$(run_choice 4)
printf '%s' "$four" | grep -q 'Brewfile.optional'
printf '%s' "$four" | grep -q 'macos.sh'

grep -qx 'tap "mobile-dev-inc/tap"' "$repo/Brewfile"
grep -qx 'brew "bun"' "$repo/Brewfile"
grep -qx 'brew "firebase-cli"' "$repo/Brewfile"
grep -qx 'brew "mobile-dev-inc/tap/maestro"' "$repo/Brewfile"
grep -qx 'brew "starship"' "$repo/Brewfile"
grep -qx 'brew "zsh-autosuggestions"' "$repo/Brewfile"
grep -qx 'brew "zsh-syntax-highlighting"' "$repo/Brewfile"
grep -qx 'cask "flutter"' "$repo/Brewfile"
if grep -q '/Library/flutter\|\.bun/bin\|\.maestro/bin' \
  "$repo/config/fish/config.fish" "$repo/home/.zshrc"; then
  printf 'legacy mobile tool path remains\n' >&2
  exit 1
fi

zsh -n "$repo/home/.zshrc"
grep -q 'starship init zsh' "$repo/home/.zshrc"
grep -q 'zoxide init zsh' "$repo/home/.zshrc"
if grep -q 'powerlevel10k\|p10k.zsh' "$repo/home/.zshrc"; then
  printf 'legacy Zsh prompt configuration remains\n' >&2
  exit 1
fi

fish -n "$repo/config/fish/config.fish"
grep -q 'zoxide init fish' "$repo/config/fish/config.fish"
if grep -q 'config-linux\|config-windows\|anaconda3\|Python/3.9\|jdk-16\|fzf-file-widget\|toggle-vi-mode' \
  "$repo/config/fish/config.fish"; then
  printf 'stale Fish configuration remains\n' >&2
  exit 1
fi

test ! -e "$repo/home/.p10k.zsh"
test ! -e "$repo/config/omf/theme"

printf 'setup test passed\n'
