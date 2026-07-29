# Shared implementation for scripts/report-bug.sh and scripts/report-enhancement.sh.
# Not executable on its own — source it, then call: report_issue "$@"
#
# The caller must set before sourcing:
#   KIND_LABEL     label always applied to the issue (e.g. "bug")
#   KIND_NOUN      word used in error messages, with its article (e.g. "a bug")
#   KIND_TEMPLATE  default issue body when none is supplied

# Help text = the caller's leading comment block, minus the shebang.
usage() {
  awk 'NR==1 && /^#!/ {next}
       /^#/ {sub(/^# ?/, ""); if (!seen && $0 == "") next; seen = 1; print; next}
       {exit}' "$0"
}

report_issue() {
  local title="" body="" assignee="" open_web=false
  local labels=("$KIND_LABEL")

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -b|--body)
        [[ $# -ge 2 ]] || { echo "error: $1 requires a value" >&2; return 1; }
        body="$2"; shift 2 ;;
      -l|--label)
        [[ $# -ge 2 ]] || { echo "error: $1 requires a value" >&2; return 1; }
        labels+=("$2"); shift 2 ;;
      -a|--assignee)
        [[ $# -ge 2 ]] || { echo "error: $1 requires a value" >&2; return 1; }
        assignee="$2"; shift 2 ;;
      -w|--web) open_web=true; shift ;;
      -h|--help) usage; return 0 ;;
      -*) echo "error: unknown option: $1" >&2; usage >&2; return 1 ;;
      *)
        if [[ -z "$title" ]]; then title="$1"; else
          echo "error: unexpected argument: $1 (quote the title if it has spaces)" >&2
          return 1
        fi
        shift ;;
    esac
  done

  if [[ -z "$title" ]]; then
    echo "error: $KIND_NOUN title is required" >&2
    usage >&2
    return 1
  fi

  command -v gh >/dev/null 2>&1 || { echo "error: gh CLI not found — https://cli.github.com" >&2; return 1; }
  gh auth status >/dev/null 2>&1 || { echo "error: not logged in to GitHub — run: gh auth login" >&2; return 1; }

  # `--body -` reads the body from stdin. Auto-detecting a non-tty stdin instead
  # would hang forever whenever this runs without a terminal (CI, nested scripts).
  if [[ "$body" == "-" ]]; then
    body="$(cat)"
  fi
  [[ -n "$body" ]] || body="$KIND_TEMPLATE"

  local branch commit script
  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)"
  commit="$(git rev-parse --short HEAD 2>/dev/null || echo unknown)"
  script="scripts/$(basename "$0")"

  body="${body}

---
Reported via \`${script}\` — branch \`${branch}\` @ \`${commit}\`"

  local args=(issue create --title "$title" --body "$body")
  local label
  for label in "${labels[@]}"; do
    args+=(--label "$label")
  done
  [[ -n "$assignee" ]] && args+=(--assignee "$assignee")
  $open_web && args+=(--web)

  gh "${args[@]}"
}
