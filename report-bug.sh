#!/usr/bin/env bash
#
# Report a bug as a GitHub issue on this repo.
#
# Usage:
#   scripts/report-bug.sh "Title of the bug"
#   scripts/report-bug.sh "Title" --body "What happened / steps to reproduce"
#   echo "long description" | scripts/report-bug.sh "Title" --body -
#
# Options:
#   -b, --body TEXT     Issue body, or "-" to read it from stdin
#                       (default: repro template)
#   -l, --label LABEL   Extra label, repeatable (the "bug" label is always added)
#   -a, --assignee USER Assign the issue (use "@me" for yourself)
#   -w, --web           Open the created issue in a browser
#   -h, --help          Show this help

set -euo pipefail

KIND_LABEL=bug
KIND_NOUN="a bug"
# read -d '' returns nonzero at EOF, hence the `|| true` under `set -e`.
IFS='' read -r -d '' KIND_TEMPLATE <<'EOF' || true
## What happened

<!-- describe the bug -->

## Steps to reproduce

1.
2.
3.

## Expected

<!-- what should have happened -->
EOF

source "$(dirname "${BASH_SOURCE[0]}")/lib/report-issue.sh"
report_issue "$@"
