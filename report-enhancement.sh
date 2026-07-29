#!/usr/bin/env bash
#
# Request an enhancement as a GitHub issue on this repo.
#
# Usage:
#   scripts/report-enhancement.sh "Title of the enhancement"
#   scripts/report-enhancement.sh "Title" --body "What you want and why"
#   echo "long description" | scripts/report-enhancement.sh "Title" --body -
#
# Options:
#   -b, --body TEXT     Issue body, or "-" to read it from stdin
#                       (default: problem / proposal template)
#   -l, --label LABEL   Extra label, repeatable (the "enhancement" label is always added)
#   -a, --assignee USER Assign the issue (use "@me" for yourself)
#   -w, --web           Open the created issue in a browser
#   -h, --help          Show this help

set -euo pipefail

KIND_LABEL=enhancement
KIND_NOUN="an enhancement"
# read -d '' returns nonzero at EOF, hence the `|| true` under `set -e`.
IFS='' read -r -d '' KIND_TEMPLATE <<'EOF' || true
## Problem

<!-- what's awkward or missing today -->

## Proposed change

<!-- what should happen instead -->

## Alternatives considered

<!-- other approaches, or "none" -->

## Out of scope

<!-- what this deliberately does not cover -->
EOF

source "$(dirname "${BASH_SOURCE[0]}")/lib/report-issue.sh"
report_issue "$@"
