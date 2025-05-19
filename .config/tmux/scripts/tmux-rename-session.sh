#!/usr/bin/env bash

session=$(tmux display-message -p '#S')

current_path=$(tmux display-message -p '#{pane_current_path}' | xargs basename)

current_command=$(tmux display-message -p '#{pane_current_command}')

case "$current_command" in
  tmux|bash|zsh|fish|sh|ksh)
    new_name="${current_path}"
    ;;
  *)
    new_name="${current_path}-${current_command}"
    ;;
esac

current_name=$(tmux display-message -p '#S')
if [ "$current_name" != "$new_name" ]; then
  tmux rename-session -t "$session" "$new_name"
fi
