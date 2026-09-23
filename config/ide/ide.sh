#!/bin/bash

current_folder=$(basename $PWD)
session_name=${current_folder#.}

if [ "$1" == "exit" ]; then
  tmux kill-session -t "$session_name"
  exit 0
fi

if [ "$1" == "--alt" ]; then
  if tmux has-session -t "$session_name" 2>/dev/null; then
    tmux attach-session -t "$session_name"
    exit 0
  fi

  tmux new-session -d -s "$session_name"
  tmux select-pane -t 0
  tmux split-window -h -p 30
  tmux split-window -v -p 60
  tmux select-pane -t 0
  tmux send-keys 'nvim' C-m
  tmux attach-session -t "$session_name"
  exit 0
fi

if tmux has-session -t "$session_name" 2>/dev/null; then
  tmux attach-session -t "$session_name"
  exit 0
fi

tmux new-session -d -s "$session_name"
tmux split-window -v -p 15

tmux select-pane -t 1

tmux split-window -h -p 66
tmux select-pane -t 2
tmux split-window -h -p 50

tmux select-pane -t 0
tmux send-keys 'nvim' C-m
tmux attach-session -t "$session_name"
