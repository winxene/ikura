#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

run_choice() {
  printf '%s\n' "$1" | "$repo/setup.sh" --dry-run
}

one=$(run_choice 1)
printf '%s' "$one" | grep -q 'Brewfile'
printf '%s' "$one" | grep -q 'bootstrap.sh'
! printf '%s' "$one" | grep -q 'Brewfile.optional'
! printf '%s' "$one" | grep -q 'macos.sh'

two=$(run_choice 2)
printf '%s' "$two" | grep -q 'Brewfile.optional'
! printf '%s' "$two" | grep -q 'macos.sh'

three=$(run_choice 3)
printf '%s' "$three" | grep -q 'macos.sh'
! printf '%s' "$three" | grep -q 'Brewfile.optional'

four=$(run_choice 4)
printf '%s' "$four" | grep -q 'Brewfile.optional'
printf '%s' "$four" | grep -q 'macos.sh'

printf 'setup test passed\n'
