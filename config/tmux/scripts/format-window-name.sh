#!/bin/bash

# Format tmux window name as "command:folder" with max 15 characters
# Gets pane info directly from tmux instead of relying on variable expansion

# Get the current pane ID (passed by tmux)
PANE="${1:-.}"

# Get command and folder from tmux
COMMAND=$(tmux display-message -p -t "$PANE" '#{pane_current_command}')
FOLDER=$(tmux display-message -p -t "$PANE" '#{b:pane_current_path}')

# Combine command and folder
WINDOW_NAME="${COMMAND}:${FOLDER}"

# Truncate to 15 characters with "..." if longer
MAX_LENGTH=15
if [ ${#WINDOW_NAME} -gt $MAX_LENGTH ]; then
  # Truncate to 12 chars and add "..."
  WINDOW_NAME="${WINDOW_NAME:0:12}..."
fi

echo "$WINDOW_NAME"
