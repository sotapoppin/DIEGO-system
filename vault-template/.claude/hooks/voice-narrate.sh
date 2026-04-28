#!/bin/bash
# PostToolUse hook — speaks new <narrate>...</narrate> blocks emitted
# in assistant text between tool calls. Dedup'd per session.

set -uo pipefail

input=$(cat)
transcript=$(echo "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
session=$(echo "$input" | jq -r '.session_id // "default"' 2>/dev/null)

[ -n "$transcript" ] && [ -f "$transcript" ] || exit 0

STATE="/tmp/diego-narrate-${session}.last"

extract_latest_narrate() {
  jq -rs '
    (. | map(.type == "user" and (.message.content | type == "string" or (type == "array" and (.[0].type // "") == "text"))) | rindex(true)) as $last_user
    | .[($last_user // -1) + 1 :]
    | [.[] | select(.type == "assistant" and (.message.content | type) == "array") | .message.content[] | select(.type == "text") | .text]
    | join("\n---SEP---\n")
  ' "$transcript" 2>/dev/null | perl -0777 -ne 'my @m; while (/<narrate>(.*?)<\/narrate>/gs) { push @m, $1; } print $m[-1] if @m;'
}

narrate=$(extract_latest_narrate)

[ -n "$narrate" ] || exit 0

hash=$(printf '%s' "$narrate" | shasum | awk '{print $1}')
if [ -f "$STATE" ] && [ "$(cat "$STATE")" = "$hash" ]; then
  exit 0
fi
echo "$hash" > "$STATE"

pkill -x say 2>/dev/null || true
( say -r 210 -- "$narrate" 2>/dev/null ) &
disown $!

exit 0
