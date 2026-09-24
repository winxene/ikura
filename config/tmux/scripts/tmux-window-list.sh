#!/usr/bin/env bash

current_window=$(tmux display-message -p '#W')

tmux list-windows -F "#{window_name}" | nl -n ln -w 1 -s ':' | while read -r line; do
  index=$(echo "$line" | cut -d':' -f1)
  name=$(echo "$line" | cut -d':' -f2)
  
  if [ "$name" = "$current_window" ]; then
    echo -n "[${index}]*${name} "
  else
    echo -n "[${index}]${name} "
  fi
done
