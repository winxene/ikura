#!/bin/bash
THEME_FILE="$HOME/.config/themes/theme"

mkdir -p "$(dirname "$THEME_FILE")"

if [ ! -f "$THEME_FILE" ] || [ "$(cat "$THEME_FILE")" = "dark" ]; then
  echo "light" > "$THEME_FILE"
  NEW_THEME="light"
else
  echo "dark" > "$THEME_FILE"
  NEW_THEME="dark"
fi

echo "Switched to $NEW_THEME mode."

# Change Ghostty theme
if command -v ghostty &> /dev/null; then
  ghostty +set-theme="$NEW_THEME"
fi

# Reload tmux if running
if [ -n "$TMUX" ]; then
  tmux source-file "$HOME/.config/tmux/tmux.conf"
fi

# Reload Neovim in all tmux panes
if [ -n "$TMUX" ]; then
  tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}' | \
  while read -r pane cmd; do
    if [ "$cmd" = "nvim" ]; then
      tmux send-keys -t "$pane" Escape
      sleep 0.1
      tmux send-keys -t "$pane" ":ThemeReload" Enter
    fi
  done
fi
