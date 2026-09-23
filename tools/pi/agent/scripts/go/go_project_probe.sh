#!/usr/bin/env bash
set -euo pipefail
printf '## go environment\n'
go version 2>/dev/null || true
[ -f go.mod ] && { printf '\n## module\n'; head -20 go.mod; }
[ -f go.work ] && { printf '\n## workspace\n'; head -80 go.work; }
printf '\n## packages\n'
go list ./... 2>/dev/null | head -200 || true
printf '\n## tests\n'
find . -name '*_test.go' -not -path '*/vendor/*' | wc -l | awk '{print $1" test files"}'
printf '\n## risky patterns\n'
rg -n 'context\.TODO\(|panic\(|log\.Fatal|time\.Sleep\(|interface\{\}|TODO|FIXME' --glob '*.go' . 2>/dev/null | head -200 || true
printf '\n## deps outdated/vuln commands\n'
printf 'Run if needed: go list -m -u all\nRun if available: govulncheck ./...\n'
