#!/usr/bin/env bash
# Publish each Claude agent's live context size to herdr as pane metadata.
#
# herdr tracks agent lifecycle state but has no notion of context usage:
# nothing in `herdr api schema` reports tokens, and the sidebar's built-in row
# tokens stop at state and title. The two halves needed to build it do exist
# though -- `herdr agent list` names the Claude session UUID behind each pane,
# and Claude Code's transcript records `usage` on every assistant turn. This
# joins them and pushes the result back as display-only pane metadata, which
# [ui.sidebar.agents] in herdr/config.shared.toml renders as $ctx and $ctx_pct.
set -euo pipefail

# Metadata is namespaced by source, so this only ever overwrites or clears its
# own tokens and cannot stomp on anything else reporting to the same pane.
SOURCE_ID="claude-context"
PROJECTS_DIR="${CLAUDE_PROJECTS_DIR:-$HOME/.claude/projects}"
INTERVAL=15
WINDOWS="200000,1000000"
MODE=loop

usage() {
  cat <<'USAGE'
Usage: herdr-context-tokens.sh [--once|--clear] [--interval N] [--windows LIST]

  --once         Publish one round of values and exit
  --clear        Remove this script's tokens from every Claude pane and exit
  --interval N   Seconds between rounds in loop mode (default: 15)
  --windows LIST Comma-separated candidate context windows, smallest first
                 (default: 200000,1000000)
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --once) MODE=once ;;
    --clear) MODE=clear ;;
    --interval) INTERVAL="${2:?--interval needs a value}"; shift ;;
    --windows) WINDOWS="${2:?--windows needs a value}"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

for tool in herdr jq; do
  command -v "$tool" >/dev/null 2>&1 || { echo "missing dependency: $tool" >&2; exit 1; }
done

# Outlive a slow round but not a dead poller: if this script stops, the
# numbers expire on their own rather than freezing a stale figure in the
# sidebar forever. Floor of 5s keeps a tiny --interval from self-expiring.
TTL_MS=$(( INTERVAL * 3000 ))
[ "$TTL_MS" -lt 5000 ] && TTL_MS=5000

# Panes running a Claude that has reported a session identity. Anything else
# -- another agent, or a Claude still starting up -- has no transcript to read.
claude_panes() {
  herdr agent list 2>/dev/null | jq -r '
    .result.agents[]
    | select(.agent == "claude" and .agent_session.kind == "id")
    | [.pane_id, .agent_session.value] | @tsv' 2>/dev/null || true
}

transcript_for() {
  # Sessions are filed under the directory Claude was started in, which is not
  # always the pane's current cwd, so match the UUID across every project.
  ls -t "$PROJECTS_DIR"/*/"$1".jsonl 2>/dev/null | head -1 || true
}

context_tokens() {
  # The newest assistant turn's usage is the whole prompt that was just sent:
  # fresh input plus both halves of the cache. Reading backwards also picks up
  # compaction for free -- the first turn after one reports the smaller
  # context. Sidechain turns belong to subagents and carry their own context
  # rather than this session's, so they are skipped.
  #
  # jq stops at the first match and tac dies of SIGPIPE, which pipefail would
  # otherwise report as failure; the `|| true` is for that, not for the parse.
  { tac "$1" | jq -rn 'first(
        inputs
        | select(.isSidechain != true)
        | select(.message.usage != null)
        | .message.usage
        | (.input_tokens // 0)
          + (.cache_creation_input_tokens // 0)
          + (.cache_read_input_tokens // 0)
      )'
  } 2>/dev/null || true
}

window_for() {
  # Nothing in the transcript records the session's context window -- the
  # "[1m]" marker that turns up in some of them is incidental tool output, not
  # structure -- so infer it: take the smallest candidate the current context
  # actually fits inside. A session past 200k is provably on the 1M beta. The
  # blind spot is a 1M session still under 200k, which reads as a fraction of
  # 200k until it grows past it; the absolute figure in $ctx stays right either
  # way.
  local total="$1" w
  local -a candidates
  IFS=, read -ra candidates <<< "$WINDOWS"
  for w in "${candidates[@]}"; do
    [ "$total" -le "$w" ] && { echo "$w"; return; }
  done
  echo "${candidates[${#candidates[@]}-1]}"
}

report() {
  local pane="$1" total="$2"
  local window
  window="$(window_for "$total")"
  # The pane id has to lead: herdr's parser stops treating flags as flags once
  # it has taken the positional, so options after it are the only ones seen.
  herdr pane report-metadata "$pane" \
    --source "$SOURCE_ID" \
    --token "ctx=$(( (total + 500) / 1000 ))k" \
    --token "ctx_pct=$(( total * 100 / window ))%" \
    --ttl-ms "$TTL_MS" >/dev/null 2>&1 || true
}

clear_pane() {
  herdr pane report-metadata "$1" \
    --source "$SOURCE_ID" \
    --clear-token ctx \
    --clear-token ctx_pct >/dev/null 2>&1 || true
}

tick() {
  local pane session file total
  while IFS=$'\t' read -r pane session; do
    [ -n "$pane" ] || continue
    file="$(transcript_for "$session")"
    total=""
    [ -n "$file" ] && total="$(context_tokens "$file")"
    # A session with no transcript yet, or one whose first turn has not landed,
    # gets its tokens cleared rather than keeping the previous pane's figure.
    if [ -n "$total" ] && [ "$total" -gt 0 ] 2>/dev/null; then
      report "$pane" "$total"
    else
      clear_pane "$pane"
    fi
  done < <(claude_panes)
}

case "$MODE" in
  once)
    tick
    ;;
  clear)
    while IFS=$'\t' read -r pane _; do
      [ -n "$pane" ] && clear_pane "$pane"
    done < <(claude_panes)
    ;;
  loop)
    while :; do
      tick
      sleep "$INTERVAL"
    done
    ;;
esac
