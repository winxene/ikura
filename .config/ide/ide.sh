#!/bin/bash

if [ "$1" == "exit" ]; then
  # Kill the tmux session named 'ide'
  tmux kill-session -t ide
  exit 0
fi

# Start a new tmux session named 'ide'
tmux new-session -d -s ide

# Split the left pane horizontally
tmux select-pane -t 0
tmux split-window -h -p 30

# Split the window vertically
tmux split-window -v -p 60

# Open Neovim in the left pane
tmux select-pane -t 0
tmux send-keys 'nvim' C-m

# Attach to the tmux session
tmux attach-session -t ide
