#!/usr/bin/env bash
# The two runs shown in docs/demo.gif, with dbt's log trimmed to the lines that matter.
set -u
dbt() { uv run dbt --no-use-colors "$@" --profiles-dir . 2>&1; }
title() { printf '\n\033[1;36m%s\033[0m\n' "$1"; }

title "1. dbt build: 8 models, 1 seed, 26 tests"
dbt build | grep -E "OK (created|loaded)|Done\." | sed -E 's/^[0-9:]+ +//; s/ \.+ / /'

title "2. Same build, with a bug injected into order line quantities"
dbt build --vars '{inject_bug: true}' | grep -E "FAIL|Done\." | sed -E 's/^[0-9:]+ +//; s/ \.+ / /'

printf '\n\033[1;32m%s\033[0m\n' "Every key is still unique and not null. The reconciliation test catches all 38 orders."
