#!/usr/bin/env bash

session=$(tmux display-message -p '#S')

current_name=$(tmux display-message -p '#S')
new_name="$(whoami)"

if [ "$current_name" != "$new_name" ]; then
  tmux rename-session -t "$session" "$new_name"
fi
