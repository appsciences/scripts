#!/usr/bin/env bash
#
# dev-backup.sh — back up ~/dev and ~/.claude, skipping build artifacts.
#
# Two modes:
#
#   mirror (default)  rsync ~/dev into iCloud Drive as a loose file tree.
#   --zip             Build one portable archive of ~/dev AND ~/.claude with
#                     paths relative to $HOME, so that
#
#                         cd ~ && unzip dev-backup-<stamp>.zip
#
#                     restores every project ready to work in: source, full git
#                     history, per-project .claude/ config, Claude Code global
#                     config and accumulated memory. Dependencies and build
#                     output are excluded — run npm install / pub get / pod
#                     install to rehydrate them.
#
# Exclusions come from three places:
#
#   1. Static  — names that are NEVER source (node_modules, .dart_tool, Pods,
#                __pycache__, ...). Kept in dev-backup.excludes, which this
#                script writes on first run and which you can then edit freely.
#
#   2. Dynamic — ambiguous names (build/, dist/, out/, target/, coverage/) are
#                skipped only when git already ignores them, when a pubspec.yaml
#                marks the directory as a Flutter project, or when an hts-cache/
#                marker identifies a downloaded HTTrack website mirror.
#
#   3. ~/.claude — an ALLOW-list in claude-backup.filter, because that tree is
#                195 MB of mostly regenerable session state wrapped around
#                ~360 KB of hand-authored config and memory.
#
# The second rule exists because a hand-written list gets this wrong in both
# directions:
#   * ~/dev/deskreen/build holds git-TRACKED icons and entitlements — a blanket
#     "build/" pattern would silently drop real source from every backup.
#   * ~/dev/chys-app-flutter/ios/build holds git-TRACKED Xcode build metadata —
#     gitignore alone would never skip it, so the Flutter rule covers the
#     platform build dirs explicitly. Anything tracked stays recoverable
#     regardless, because .git itself is always backed up.
#
# .git is deliberately never excluded. An audit of the 56 repositories under
# ~/dev found 6 with no remote at all and 21 holding unpushed commits, local-only
# branches or stashes — 264 MB that exists nowhere else.
#
# Usage:  dev-backup.sh [-n] [--zip] [--prune] [-v] [--list-excludes]
#                       [--keep N] [--src DIR] [--dest DIR]
#         dev-backup.sh --help

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

SRC="${DEV_BACKUP_SRC:-$HOME/dev}"
CLAUDE_SRC="${DEV_BACKUP_CLAUDE_SRC:-$HOME/.claude}"
ICLOUD_ROOT="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
MIRROR_DEST="$ICLOUD_ROOT/backup/dev"
ARCHIVE_DEST="$ICLOUD_ROOT/backup/archives"
EXCLUDES_FILE="${DEV_BACKUP_EXCLUDES:-$SCRIPT_DIR/dev-backup.excludes}"
CLAUDE_FILTER_FILE="${DEV_BACKUP_CLAUDE_FILTER:-$SCRIPT_DIR/claude-backup.filter}"
STAGE_ROOT="${DEV_BACKUP_STAGE:-$HOME/.cache/dev-backup}"
LOG_DIR="${DEV_BACKUP_LOG_DIR:-$HOME/Library/Logs/dev-backup}"
LOCK_DIR="${TMPDIR:-/tmp}/dev-backup.lock"
KEEP_LOGS=20
KEEP_ARCHIVES="${DEV_BACKUP_KEEP:-3}"

# Ambiguous directory names: skipped only when git-ignored.
CANDIDATE_DIRS="build dist out .output target coverage .nyc_output"

# Sub-paths under a Flutter project root that are always build output.
FLUTTER_BUILD_SUBDIRS=". ios android android/app macos linux windows"

DRY_RUN=0
PRUNE=0
VERBOSE=0
LIST_ONLY=0
ZIP_MODE=0
DEST_OVERRIDE=""

die() { printf 'dev-backup: %s\n' "$*" >&2; exit 1; }
say() { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
dev-backup.sh — back up ~/dev and ~/.claude, skipping build artifacts.

  -n, --dry-run        Show what would transfer; write nothing.
      --zip            Build one portable archive of ~/dev and ~/.claude with
                       paths relative to $HOME. Unzip it in your home directory
                       and every project is ready to work in.
      --prune          Mirror mode only. Delete files in the backup that no
                       longer exist in the source, AND purge previously-copied
                       files that are now excluded. Off by default.
  -v, --verbose        Per-file rsync output.
      --list-excludes  Print the full computed exclusion set and exit.
      --keep N         Archives to retain in the destination (default: 3).
      --src DIR        Source directory        (default: ~/dev)
      --dest DIR       Destination directory
                       mirror default:  ~/Library/Mobile Documents/
                                        com~apple~CloudDocs/backup/dev
                       --zip default:   .../backup/archives
  -h, --help           This message.

Environment overrides: DEV_BACKUP_SRC, DEV_BACKUP_CLAUDE_SRC, DEV_BACKUP_DEST,
DEV_BACKUP_EXCLUDES, DEV_BACKUP_CLAUDE_FILTER, DEV_BACKUP_STAGE,
DEV_BACKUP_LOG_DIR, DEV_BACKUP_KEEP.

Static exclusions live in dev-backup.excludes next to this script; the ~/.claude
allow-list lives in claude-backup.filter. Edit either to tune them. Logs are kept
in ~/Library/Logs/dev-backup.

Restoring an archive:

    cd ~ && unzip -o dev-backup-<stamp>.zip

Then reinstall dependencies per project (npm install, flutter pub get, pod
install) and re-login to Claude Code — auth lives in the macOS Keychain and is
deliberately not in the archive.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    -n|--dry-run)     DRY_RUN=1 ;;
    --zip|--archive)  ZIP_MODE=1 ;;
    --prune)          PRUNE=1 ;;
    -v|--verbose)     VERBOSE=1 ;;
    --list-excludes)  LIST_ONLY=1 ;;
    --keep)           [ $# -ge 2 ] || die "--keep needs a number"; KEEP_ARCHIVES="$2"; shift ;;
    --src)            [ $# -ge 2 ] || die "--src needs a directory"; SRC="$2"; shift ;;
    --dest)           [ $# -ge 2 ] || die "--dest needs a directory"; DEST_OVERRIDE="$2"; shift ;;
    -h|--help)        usage; exit 0 ;;
    *)                die "unknown option: $1 (try --help)" ;;
  esac
  shift
done

case "$KEEP_ARCHIVES" in
  ''|*[!0-9]*) die "--keep needs a non-negative integer, got: $KEEP_ARCHIVES" ;;
esac

if [ "$ZIP_MODE" -eq 1 ] && [ "$PRUNE" -eq 1 ]; then
  die "--prune applies to mirror mode only; an archive is rebuilt from scratch each run"
fi

if [ "$ZIP_MODE" -eq 1 ]; then
  DEST="${DEV_BACKUP_DEST:-$ARCHIVE_DEST}"
else
  DEST="${DEV_BACKUP_DEST:-$MIRROR_DEST}"
fi
[ -n "$DEST_OVERRIDE" ] && DEST="$DEST_OVERRIDE"

# ---------------------------------------------------------------- static list

write_default_excludes() {
  cat > "$1" <<'EOF'
# dev-backup static exclusions — rsync filter patterns, one per line.
#
# ONLY put names here that are never source. Ambiguous ones (build/, dist/,
# out/, target/, coverage/) are handled dynamically by dev-backup.sh: skipped
# only when git already ignores them, or when a pubspec.yaml marks the project
# as Flutter. That is deliberate — ~/dev/deskreen/build holds tracked icons and
# entitlements that a blanket rule would throw away.
#
# A leading "/" anchors a pattern to the top of the source directory.
# A trailing "/" restricts it to directories.
# A bare name with no slash matches at any depth.

# --- node / npm / yarn / pnpm ------------------------------------------------
node_modules*/
.npm/
.pnpm-store/
.yarn/cache/
.yarn/unplugged/
.yarn/install-state.gz
npm-debug.log*
yarn-error.log*
pnpm-debug.log*

# --- JS framework + bundler output/caches (never source) ---------------------
.next/
.nuxt/
.svelte-kit/
.astro/
.angular/
.docusaurus/
.turbo/
.parcel-cache/
.vite/
.rollup.cache/
.eslintcache
*.tsbuildinfo
.cache/
storybook-static/

# --- Flutter / Dart ----------------------------------------------------------
/flutter/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.symlinks/
ephemeral/

# --- iOS / macOS / Xcode -----------------------------------------------------
Pods/
DerivedData/
xcuserdata/
*.xcuserdatad/

# --- Android / Gradle --------------------------------------------------------
.gradle/
.cxx/
captures/
local.properties

# --- Python ------------------------------------------------------------------
__pycache__/
*.pyc
*.pyo
.pytest_cache/
.mypy_cache/
.ruff_cache/
.tox/
.venv/
.venv*/
venv/
*.egg-info/

# --- Other toolchains --------------------------------------------------------
.terraform/
.serverless/
.expo/
.expo-shared/

# --- Claude Code worktrees ---------------------------------------------------
# Throwaway checkouts of branches that already live in .git.
.claude/worktrees/

# --- Not source: media library -----------------------------------------------
/fed-docs/

# --- Live database data directories ------------------------------------------
# A file-level copy of a running cluster is not a valid backup. Use pg_dump.
postgres_db/
pgdata/

# --- macOS / editor noise ----------------------------------------------------
.DS_Store
._*
.Spotlight-V100/
.Trashes/
.fseventsd/
*.swp
*~
EOF
}

write_default_claude_filter() {
  cat > "$1" <<'EOF'
# dev-backup filter for ~/.claude — rsync filter rules, first match wins.
# ALLOW-list: ~/.claude is mostly regenerable session state wrapped around a
# small amount of hand-authored config and memory. Credentials are NOT here —
# Claude Code keeps auth in the macOS login Keychain.

+ /CLAUDE.md
+ /settings.json
+ /settings.local.json
+ /keybindings.json
+ /.mcp.json
+ /mcp.json

+ /agents/
+ /agents/**
+ /commands/
+ /commands/**
+ /skills/
+ /skills/**
+ /hooks/
+ /hooks/**
+ /output-styles/
+ /output-styles/**

+ /agent-memory/
+ /agent-memory/**

+ /plugins/
+ /plugins/installed_plugins.json
+ /plugins/known_marketplaces.json
- /plugins/**

+ /projects/
+ /projects/*/
+ /projects/*/memory/
+ /projects/*/memory/**
- /projects/**

- *
EOF
}

if [ ! -f "$EXCLUDES_FILE" ]; then
  say "Creating default exclude list: $EXCLUDES_FILE"
  write_default_excludes "$EXCLUDES_FILE"
fi

if [ ! -f "$CLAUDE_FILTER_FILE" ]; then
  say "Creating default ~/.claude filter: $CLAUDE_FILTER_FILE"
  write_default_claude_filter "$CLAUDE_FILTER_FILE"
fi

# ------------------------------------------------------------------ pre-flight

[ -d "$SRC" ] || die "source directory does not exist: $SRC"
SRC="$(cd -- "$SRC" && pwd -P)"

entry_count=$(find "$SRC" -maxdepth 1 -mindepth 1 | wc -l | tr -d ' ')
[ "$entry_count" -gt 0 ] || die "source directory is empty, refusing to run: $SRC"

if [ "$ZIP_MODE" -eq 1 ]; then
  command -v zip >/dev/null 2>&1 || die "zip not found in PATH"
fi

FILTER_FILE="$(mktemp "${TMPDIR:-/tmp}/dev-backup-filter.XXXXXX")"
DYNAMIC_FILE="$(mktemp "${TMPDIR:-/tmp}/dev-backup-dynamic.XXXXXX")"
SCRATCH_A="$(mktemp "${TMPDIR:-/tmp}/dev-backup-a.XXXXXX")"
SCRATCH_B="$(mktemp "${TMPDIR:-/tmp}/dev-backup-b.XXXXXX")"
cleanup() {
  rm -f "$FILTER_FILE" "$DYNAMIC_FILE" "$SCRATCH_A" "$SCRATCH_B"
  if [ -n "${LOCK_HELD:-}" ]; then rmdir "$LOCK_DIR" 2>/dev/null || true; fi
  return 0
}
trap cleanup EXIT INT TERM

# --------------------------------------------------------------- dynamic list
#
# Emits anchored rsync patterns (e.g. "/notedude2/build/") relative to $SRC.

emit_pattern() {   # emit_pattern <absolute-dir>
  local rel="${1#$SRC}"
  rel="${rel#/}"
  [ -n "$rel" ] || return 0
  printf '/%s/\n' "$rel" >> "$DYNAMIC_FILE"
}

# (a) Ambiguous directories that git already ignores, per repository.
scan_gitignored() {
  local find_names="" name repo abs rel

  for name in $CANDIDATE_DIRS; do
    if [ -z "$find_names" ]; then find_names="-name $name"
    else find_names="$find_names -o -name $name"; fi
  done

  # "node_modules*" (not a bare "node_modules") so that renamed copies such as
  # "node_modules 11.48.10 AM" are pruned too. Without the glob the scan
  # descends into them and emits thousands of dead patterns for dependency
  # dist/ directories that node_modules*/ already covers.
  find "$SRC" -maxdepth 7 \
       \( -name 'node_modules*' -o -name Pods -o -name .dart_tool \
          -o -name .venv -o -name venv \) -prune -o \
       -type d -name .git -print -prune 2>/dev/null \
    | sed 's|/\.git$||' > "$SCRATCH_A" || true

  while IFS= read -r repo; do
    [ -n "$repo" ] || continue
    git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 || continue

    # Candidate dirs in this repo, expressed relative to the repo root.
    # shellcheck disable=SC2086
    find "$repo" \
         \( -name .git -o -name 'node_modules*' -o -name Pods -o -name .dart_tool \
            -o -name .venv -o -name venv -o -name .gradle -o -name __pycache__ \) -prune -o \
         -type d \( $find_names \) -print 2>/dev/null > "$SCRATCH_B" || true

    [ -s "$SCRATCH_B" ] || continue

    while IFS= read -r abs; do
      [ -n "$abs" ] || continue
      printf '%s\n' "${abs#$repo/}"
    done < "$SCRATCH_B" \
      | ( cd "$repo" && git -c core.quotePath=false check-ignore --stdin 2>/dev/null || true ) \
      | while IFS= read -r rel; do
          [ -n "$rel" ] || continue
          emit_pattern "$repo/$rel"
        done
  done < "$SCRATCH_A"
  return 0
}

# (b) Flutter projects: build output, tracked or not.
scan_flutter() {
  local proj sub target

  find "$SRC" -maxdepth 7 \
       \( -name 'node_modules*' -o -name .git -o -name Pods -o -name .dart_tool \) -prune -o \
       -type f -name pubspec.yaml -print 2>/dev/null > "$SCRATCH_A" || true

  while IFS= read -r proj; do
    [ -n "$proj" ] || continue
    proj="$(dirname "$proj")"
    for sub in $FLUTTER_BUILD_SUBDIRS; do
      if [ "$sub" = "." ]; then target="$proj/build"; else target="$proj/$sub/build"; fi
      if [ -d "$target" ]; then emit_pattern "$target"; fi
    done
  done < "$SCRATCH_A"
  return 0
}

# (c) Downloaded website mirrors. HTTrack drops an hts-cache/ directory at the
#     root of whatever it scraped; the sibling HTML tree is the mirror itself
#     (~/dev/clients/archive/david/pp is 149 MB of papayaglobal.com). Detected
#     by marker rather than by name so a renamed mirror is still caught, and so
#     hand-authored HTML is never touched.
scan_httrack() {
  local marker

  find "$SRC" -maxdepth 7 \
       \( -name 'node_modules*' -o -name .git -o -name Pods \) -prune -o \
       -type d -name hts-cache -print 2>/dev/null > "$SCRATCH_A" || true

  while IFS= read -r marker; do
    [ -n "$marker" ] || continue
    emit_pattern "$(dirname "$marker")"
  done < "$SCRATCH_A"
  return 0
}

: > "$DYNAMIC_FILE"
scan_gitignored
scan_flutter
scan_httrack
sort -u "$DYNAMIC_FILE" -o "$DYNAMIC_FILE"

{
  cat "$EXCLUDES_FILE"
  echo
  echo "# --- generated: git-ignored dirs, Flutter build output, website mirrors ---"
  cat "$DYNAMIC_FILE"
} > "$FILTER_FILE"

dynamic_count=$(grep -c . "$DYNAMIC_FILE" 2>/dev/null || true)
dynamic_count="${dynamic_count:-0}"

if [ "$LIST_ONLY" -eq 1 ]; then
  cat "$FILTER_FILE"
  exit 0
fi

# Destination. Fail loudly if iCloud Drive is not set up, rather than quietly
# creating a plain local folder that never syncs anywhere.
case "$DEST" in
  "$ICLOUD_ROOT"/*)
    [ -d "$ICLOUD_ROOT" ] || die "iCloud Drive not found at $ICLOUD_ROOT — enable iCloud Drive in System Settings, or pass --dest"
    ;;
esac
if [ "$DRY_RUN" -eq 0 ]; then
  mkdir -p "$DEST" || die "cannot create destination: $DEST"
elif [ ! -d "$DEST" ]; then
  say "note: destination does not exist yet; a real run would create $DEST"
fi

# Single instance.
if mkdir "$LOCK_DIR" 2>/dev/null; then
  LOCK_HELD=1
else
  die "another backup is already running (lock: $LOCK_DIR) — remove it if that is stale"
fi

mkdir -p "$LOG_DIR"
STAMP="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$LOG_DIR/$STAMP.log"

# ----------------------------------------------------------------- restore doc

write_restore_doc() {   # write_restore_doc <path> <stamp>
  cat > "$1" <<EOF
# dev backup — $2

Archive of \`~/dev\` and \`~/.claude\`, with paths relative to \$HOME.

## Restore

    cd ~
    unzip -o dev-backup-$2.zip

That puts \`dev/\` and \`.claude/\` back in place. Then, per project:

    npm install          # or pnpm install / yarn
    flutter pub get      # Flutter projects
    pod install          # iOS, from the ios/ directory

## What is here

* Full source for every project under \`~/dev\`, including \`.git\` — all
  branches, tags, stashes and unpushed commits.
* Per-project \`.claude/\` configuration.
* Claude Code global config: \`CLAUDE.md\`, \`settings.json\`, custom agents,
  commands, skills, hooks, and accumulated memory.

## What is deliberately not here

* **Dependencies and build output** — \`node_modules\`, \`Pods\`, \`.next\`,
  \`build/\`, \`.dart_tool\`, virtualenvs. Reinstall with the commands above.
* **The Flutter SDK** (\`~/dev/flutter\`) — reinstall from flutter.dev.
* **\`~/dev/fed-docs\`** — 1.4 GB media library, not code.
* **Claude Code credentials** — auth lives in the macOS login Keychain. Run
  \`claude\` and log in again.
* **Conversation transcripts and job scratch** from \`~/.claude\` — regenerable.
* **Live Postgres data directories** — a file-level copy is not a valid
  snapshot. Re-run migrations, or restore from a \`pg_dump\`.

\`.env\` files ARE included, since projects will not run without them. Treat this
archive as containing secrets.
EOF
}

# ------------------------------------------------------------------------ run

{
  say "dev-backup $STAMP"
  say "  source      : $SRC"
  if [ "$ZIP_MODE" -eq 1 ]; then
    say "  source      : $CLAUDE_SRC"
  fi
  say "  destination : $DEST"
  if [ "$ZIP_MODE" -eq 1 ]; then
    MODE="portable archive (zip)"
  else
    MODE="mirror (additive)"
    [ "$PRUNE" -eq 1 ] && MODE="mirror (--prune: deletes + purges excluded)"
  fi
  [ "$DRY_RUN" -eq 1 ] && MODE="$MODE, DRY RUN"
  say "  mode        : $MODE"
  say "  excludes    : $EXCLUDES_FILE (+ $dynamic_count generated)"
  [ "$ZIP_MODE" -eq 1 ] && say "  claude filter: $CLAUDE_FILTER_FILE"
  say ""
} | tee "$LOG_FILE"

start=$(date +%s)
status=0

if [ "$ZIP_MODE" -eq 0 ]; then
  # ---------------------------------------------------------------- mirror mode
  set -- -a --stats --exclude-from="$FILTER_FILE"
  [ "$VERBOSE" -eq 1 ] && set -- "$@" -v --progress
  [ "$DRY_RUN" -eq 1 ] && set -- "$@" -n
  [ "$PRUNE" -eq 1 ]   && set -- "$@" --delete --delete-excluded

  set +e
  rsync "$@" "$SRC/" "$DEST/" 2>&1 | tee -a "$LOG_FILE"
  status=${PIPESTATUS[0]}
  set -e
else
  # --------------------------------------------------------------- archive mode
  #
  # Staged into a persistent local directory first, then zipped. The staging dir
  # is a true mirror (--delete --delete-excluded), so repeat runs only copy what
  # changed, and a pattern added to the exclude list actually removes files that
  # an earlier run had staged.
  STAGE="$STAGE_ROOT/home"

  if [ "$DRY_RUN" -eq 0 ]; then
    mkdir -p "$STAGE/dev" "$STAGE/.claude" || die "cannot create staging dir: $STAGE"
  fi

  set -- -a --delete --delete-excluded
  [ "$VERBOSE" -eq 1 ] && set -- "$@" -v
  [ "$DRY_RUN" -eq 1 ] && set -- "$@" -n

  set +e
  {
    say "Staging ~/dev ..."
    rsync "$@" --stats --exclude-from="$FILTER_FILE" "$SRC/" "$STAGE/dev/" 2>&1
    dev_status=$?

    say ""
    say "Staging ~/.claude ..."
    # -m prunes project directories whose only allowed content (memory/) is absent.
    rsync "$@" -m --stats --filter="merge $CLAUDE_FILTER_FILE" "$CLAUDE_SRC/" "$STAGE/.claude/" 2>&1
    claude_status=$?

    [ "$dev_status" -ne 0 ] && exit "$dev_status"
    [ "$claude_status" -ne 0 ] && exit "$claude_status"
    exit 0
  } | tee -a "$LOG_FILE"
  status=${PIPESTATUS[0]}
  set -e

  if [ "$status" -eq 0 ] && [ "$DRY_RUN" -eq 0 ]; then
    write_restore_doc "$STAGE/RESTORE.md" "$STAMP"

    ARCHIVE_NAME="dev-backup-$STAMP.zip"
    ARCHIVE_TMP="$STAGE_ROOT/$ARCHIVE_NAME"

    # Assembled locally, then moved into iCloud, so the sync daemon never sees a
    # partially-written archive.
    ZIP_ARGS="-r -y"
    [ "$VERBOSE" -eq 0 ] && ZIP_ARGS="$ZIP_ARGS -q"

    say ""
    say "Compressing ..."
    rm -f "$ARCHIVE_TMP"
    set +e
    # shellcheck disable=SC2086
    ( cd "$STAGE" && zip $ZIP_ARGS "$ARCHIVE_TMP" dev .claude RESTORE.md ) 2>&1 | tee -a "$LOG_FILE"
    status=${PIPESTATUS[0]}
    set -e

    if [ "$status" -eq 0 ]; then
      say "Verifying ..."
      set +e
      zip -T "$ARCHIVE_TMP" >/dev/null 2>&1
      status=$?
      set -e
      [ "$status" -ne 0 ] && say "archive failed integrity check — not moving into place"
    fi

    if [ "$status" -eq 0 ]; then
      mv "$ARCHIVE_TMP" "$DEST/$ARCHIVE_NAME" || die "cannot move archive into $DEST"
      {
        say ""
        say "Archive: $DEST/$ARCHIVE_NAME"
        say "Size:    $(du -h "$DEST/$ARCHIVE_NAME" | cut -f1)"
        say "Staged:  $(du -sh "$STAGE" | cut -f1) in $STAGE"
      } | tee -a "$LOG_FILE"

      # Retention.
      if [ "$KEEP_ARCHIVES" -gt 0 ]; then
        ls -1t "$DEST"/dev-backup-*.zip 2>/dev/null \
          | tail -n "+$(( KEEP_ARCHIVES + 1 ))" \
          | while IFS= read -r old; do
              say "Removing old archive: $(basename "$old")" | tee -a "$LOG_FILE"
              rm -f "$old"
            done
      fi
    else
      rm -f "$ARCHIVE_TMP"
    fi
  fi
fi

end=$(date +%s)
elapsed=$(( end - start ))
say ""
say "Elapsed: $(( elapsed / 60 ))m $(( elapsed % 60 ))s"
say "Log:     $LOG_FILE"

# Trim old logs.
ls -1t "$LOG_DIR"/*.log 2>/dev/null | tail -n "+$(( KEEP_LOGS + 1 ))" | while IFS= read -r old; do
  rm -f "$old"
done

if [ "$status" -ne 0 ]; then
  say ""
  say "failed with status $status — see $LOG_FILE"
  exit "$status"
fi

if [ "$DRY_RUN" -eq 0 ]; then
  say ""
  if [ "$ZIP_MODE" -eq 1 ]; then
    say "Done. Restore with:  cd ~ && unzip -o $DEST/dev-backup-$STAMP.zip"
    say "iCloud uploads in the background — watch Finder's iCloud Drive sidebar"
    say "for the progress ring; the copy on disk is already complete."
  else
    say "Backed up. iCloud uploads in the background — watch Finder's iCloud Drive"
    say "sidebar for the progress ring; the copy on disk is already complete."
  fi
fi
