#!/usr/bin/env bash

current_session=$(tmux display-message -p '#S')

tmux list-sessions -F "#{session_name}" | nl -n ln -w 1 -s ':' | while read -r line; do
  index=$(echo "$line" | cut -d':' -f1)
  name=$(echo "$line" | cut -d':' -f2)
  
  if [ "$name" = "$current_session" ]; then
    echo -n "[${index}]*${name} "
  else
    echo -n "[${index}]${name} "
  fi
done
