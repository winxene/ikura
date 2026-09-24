#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
dry_run=false
case ${1-} in
  '') ;;
  --dry-run) dry_run=true ;;
  *) printf 'usage: %s [--dry-run]\n' "$0" >&2; exit 2 ;;
esac

cat <<'EOF'
1. Essential apps + dotfiles
2. Essential + optional apps + dotfiles
3. Essential apps + dotfiles + macOS settings
4. Everything
EOF
printf 'Choose [1-4]: '
IFS= read -r choice

optional=false
macos=false
case $choice in
  1) ;;
  2) optional=true ;;
  3) macos=true ;;
  4) optional=true; macos=true ;;
  *) printf 'invalid choice: %s\n' "$choice" >&2; exit 2 ;;
esac

show() {
  printf '+ '
  printf '%s ' "$@"
  printf '\n'
}

if ! command -v brew >/dev/null 2>&1; then
  install='/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  if [ "$dry_run" = true ]; then
    printf '+ %s\n' "$install"
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

if [ "$dry_run" = true ]; then
  show brew bundle --file="$repo/Brewfile"
  [ "$optional" = false ] || show brew bundle --file="$repo/Brewfile.optional"
  show "$repo/bootstrap.sh" --dry-run
  [ "$macos" = false ] || show "$repo/macos.sh" --dry-run
  exit 0
fi

brew bundle --file="$repo/Brewfile"
[ "$optional" = false ] || brew bundle --file="$repo/Brewfile.optional"
"$repo/bootstrap.sh"
[ "$macos" = false ] || "$repo/macos.sh"

fish -n "$HOME/.config/fish/config.fish"
broken=$(find "$HOME/.config" "$HOME/.pi/agent" "$HOME/.codex" "$HOME/.claude" "$HOME/.gemini" "$HOME/.agents" -type l -lname "$repo/*" ! -exec test -e {} \; -print 2>/dev/null)
test -z "$broken"
printf 'Setup complete. Restart terminal to load shell changes.\n'
