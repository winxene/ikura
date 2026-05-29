#!/bin/bash

path="$1"

if [ -z "$path" ] || [ ! -d "$path" ]; then
  exit 0
fi

branch=$(git -C "$path" branch --show-current 2>/dev/null)
if [ -z "$branch" ]; then
  branch=$(git -C "$path" rev-parse --short HEAD 2>/dev/null)
fi

if [ -n "$branch" ]; then
  printf ' %s' "$branch"
fi
