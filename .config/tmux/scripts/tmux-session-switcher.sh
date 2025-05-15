#!/usr/bin/env bash
selected_session=$(tmux list-sessions -F '#{session_name}' | \
  fzf --reverse \
      --header='Select Session' \
      --preview 'tmux capture-pane -pt {}' \
      --preview-window=right:70%)
# Switch to the selected session if one was chosen
if [[ -n "$selected_session" ]]; then
  tmux switch-client -t "$selected_session"
fi
