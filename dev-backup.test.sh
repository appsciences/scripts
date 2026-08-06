#!/usr/bin/env bash
#
# dev-backup.test.sh — integration test for dev-backup.sh --zip.
#
# Builds a synthetic ~/dev and ~/.claude containing one example of every case
# the filters are supposed to handle, runs a real archive build against them,
# then asserts on the contents of the resulting zip.
#
# Self-contained: touches nothing outside its own temp directory.
#
# Usage:  ./dev-backup.test.sh

set -uo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
TARGET="$SCRIPT_DIR/dev-backup.sh"

[ -x "$TARGET" ] || { echo "not executable: $TARGET" >&2; exit 1; }

WORK="$(mktemp -d "${TMPDIR:-/tmp}/dev-backup-test.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT INT TERM

PASS=0
FAIL=0

ok()   { printf '  ok    %s\n' "$1"; PASS=$(( PASS + 1 )); }
bad()  { printf '  FAIL  %s\n' "$1"; FAIL=$(( FAIL + 1 )); }

present() { grep -qxF "$1" "$WORK/listing" && ok "present: $1" || bad "MISSING: $1"; }
absent()  { grep -qxF "$1" "$WORK/listing" && bad "SHOULD BE EXCLUDED: $1" || ok "absent:  $1"; }

# ------------------------------------------------------------------- fixtures

SRC="$WORK/dev"
CLAUDE="$WORK/claude"

mkdir -p "$SRC/app/src"
echo 'export const x = 1' > "$SRC/app/src/index.ts"
echo 'SECRET=abc'         > "$SRC/app/.env"

# A real repo whose build/ is git-ignored AND untracked, so the dynamic scan has
# something to find. Note the deliberate absence of "add -f": force-adding would
# make build/ tracked, and git check-ignore does not report tracked paths — which
# is the whole mechanism the next fixture depends on.
mkdir -p "$SRC/app/build" "$SRC/app/.claude/worktrees/wt-1"
echo 'build/'            > "$SRC/app/.gitignore"
echo 'artifact'          > "$SRC/app/build/out.js"
echo '{}'                > "$SRC/app/.claude/settings.json"
echo 'throwaway'         > "$SRC/app/.claude/worktrees/wt-1/file.ts"
git -c init.defaultBranch=main init -q "$SRC/app"
git -C "$SRC/app" -c user.email=t@t -c user.name=t add -A >/dev/null 2>&1
git -C "$SRC/app" -c user.email=t@t -c user.name=t commit -qm init >/dev/null 2>&1

# The deskreen case: a repo where build/ holds TRACKED source (icons,
# entitlements) and is not git-ignored. A blanket "build/" exclusion would
# silently drop real source here, which is why the scan is gitignore-driven.
mkdir -p "$SRC/electron-app/build"
echo 'icon bytes'  > "$SRC/electron-app/build/icon.png"
echo 'entitlement' > "$SRC/electron-app/build/entitlements.plist"
git -c init.defaultBranch=main init -q "$SRC/electron-app"
git -C "$SRC/electron-app" -c user.email=t@t -c user.name=t add -A >/dev/null 2>&1
git -C "$SRC/electron-app" -c user.email=t@t -c user.name=t commit -qm init >/dev/null 2>&1

# Dependencies, including the renamed-copy case that used to break the scan.
mkdir -p "$SRC/app/node_modules/left-pad" "$SRC/app/node_modules 11.48.10 AM/dep/dist"
echo 'dep'  > "$SRC/app/node_modules/left-pad/index.js"
echo 'dep'  > "$SRC/app/node_modules 11.48.10 AM/dep/dist/bundle.js"

# Framework build output.
mkdir -p "$SRC/app/.next/static"
echo 'compiled' > "$SRC/app/.next/static/chunk.js"

# Media library.
mkdir -p "$SRC/fed-docs"
echo 'video bytes' > "$SRC/fed-docs/clip.mp4"

# Downloaded HTTrack website mirror, identified by its hts-cache/ marker.
mkdir -p "$SRC/scrape/hts-cache" "$SRC/scrape/www.example.com"
echo 'cache'          > "$SRC/scrape/hts-cache/new.txt"
echo '<html></html>'  > "$SRC/scrape/www.example.com/index.html"

# Live database data directory.
mkdir -p "$SRC/api/postgres_db/pg_wal"
echo 'wal' > "$SRC/api/postgres_db/pg_wal/000000010000000000000001"

# Synthetic ~/.claude.
mkdir -p "$CLAUDE/agents" "$CLAUDE/agent-memory" \
         "$CLAUDE/projects/proj-a/memory" "$CLAUDE/jobs/j1" \
         "$CLAUDE/plugins/marketplaces/official" "$CLAUDE/file-history"
echo '# rules'   > "$CLAUDE/CLAUDE.md"
echo '{}'        > "$CLAUDE/settings.json"
echo 'agent'     > "$CLAUDE/agents/reviewer.md"
echo 'mem'       > "$CLAUDE/agent-memory/notes.md"
echo 'project'   > "$CLAUDE/projects/proj-a/memory/MEMORY.md"
echo 'transcript'> "$CLAUDE/projects/proj-a/session.jsonl"
echo 'scratch'   > "$CLAUDE/jobs/j1/tmp.txt"
echo 'clone'     > "$CLAUDE/plugins/marketplaces/official/plugin.json"
echo '{}'        > "$CLAUDE/plugins/installed_plugins.json"
echo 'checkpoint'> "$CLAUDE/file-history/edit.json"

# ------------------------------------------------------------------------ run

echo "Building archive from fixtures ..."
DEV_BACKUP_CLAUDE_SRC="$CLAUDE" \
DEV_BACKUP_STAGE="$WORK/stage" \
DEV_BACKUP_LOG_DIR="$WORK/logs" \
TMPDIR="$WORK" \
"$TARGET" --zip --src "$SRC" --dest "$WORK/out" > "$WORK/run.log" 2>&1

rc=$?
if [ "$rc" -ne 0 ]; then
  echo "dev-backup.sh exited $rc" >&2
  cat "$WORK/run.log" >&2
  exit 1
fi

ARCHIVE="$(ls -1 "$WORK/out"/dev-backup-*.zip 2>/dev/null | head -1)"
[ -n "$ARCHIVE" ] || { echo "no archive produced" >&2; cat "$WORK/run.log" >&2; exit 1; }

unzip -Z1 "$ARCHIVE" > "$WORK/listing"

# -------------------------------------------------------------------- asserts

echo
echo "Included — a restore must be able to work:"
present "dev/app/src/index.ts"
present "dev/app/.env"
present "dev/app/.git/HEAD"
present "dev/app/.claude/settings.json"
present "dev/electron-app/build/icon.png"          # tracked build/ => kept
present "dev/electron-app/build/entitlements.plist"
present ".claude/CLAUDE.md"
present ".claude/settings.json"
present ".claude/agents/reviewer.md"
present ".claude/agent-memory/notes.md"
present ".claude/projects/proj-a/memory/MEMORY.md"
present ".claude/plugins/installed_plugins.json"
present "RESTORE.md"

echo
echo "Excluded — dependencies, build output, media, regenerable state:"
absent "dev/app/node_modules/left-pad/index.js"
absent "dev/app/node_modules 11.48.10 AM/dep/dist/bundle.js"
absent "dev/app/.next/static/chunk.js"
absent "dev/app/build/out.js"
absent "dev/app/.claude/worktrees/wt-1/file.ts"
absent "dev/fed-docs/clip.mp4"
absent "dev/api/postgres_db/pg_wal/000000010000000000000001"
absent ".claude/projects/proj-a/session.jsonl"
absent ".claude/jobs/j1/tmp.txt"
absent ".claude/file-history/edit.json"
absent ".claude/plugins/marketplaces/official/plugin.json"

# An hts-cache/ marker condemns the entire mirror root, not just the cache dir —
# the downloaded HTML tree beside it is the bulk of the weight.
echo
echo "HTTrack mirror detected by marker, whole root excluded:"
absent "dev/scrape/hts-cache/new.txt"
absent "dev/scrape/www.example.com/index.html"

# A restored repo must actually be usable, not just present.
echo
echo "Restored repository is functional:"
unzip -q "$ARCHIVE" 'dev/app/*' -d "$WORK/restore"
if git -C "$WORK/restore/dev/app" fsck --no-progress >/dev/null 2>&1 \
   && [ -n "$(git -C "$WORK/restore/dev/app" rev-parse HEAD 2>/dev/null)" ]; then
  ok "git fsck clean and HEAD resolves"
else
  bad "restored repository is broken"
fi

echo
echo "-------------------------------------"
printf 'passed: %d   failed: %d\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
