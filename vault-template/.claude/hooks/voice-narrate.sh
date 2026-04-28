#!/bin/bash
# PostToolUse hook — speaks new <narrate>...</narrate> blocks emitted in
# assistant text since the last user prompt. Tracks all spoken hashes
# in a per-session state file so multi-narration turns work end-to-end.

set -uo pipefail

input=$(cat)
transcript=$(echo "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
session=$(echo "$input" | jq -r '.session_id // "default"' 2>/dev/null)

[ -n "$transcript" ] && [ -f "$transcript" ] || exit 0

STATE="/tmp/diego-narrate-${session}.spoken"
touch "$STATE"

# Emit each narrate block NUL-terminated. NUL is the only byte guaranteed
# absent from the content, so no separator-collision bugs.
extract_narrations() {
  jq -rs '
    (. | map(.type == "user" and (.message.content | type == "string" or (type == "array" and (.[0].type // "") == "text"))) | rindex(true)) as $last_user
    | .[($last_user // -1) + 1 :]
    | [.[] | select(.type == "assistant" and (.message.content | type) == "array") | .message.content[] | select(.type == "text") | .text]
    | join("\n---SEP---\n")
  ' "$transcript" 2>/dev/null \
    | perl -0777 -ne 'while (/<narrate>(.*?)<\/narrate>/gs) { print "$1\0"; }'
}

speak_text=""
while IFS= read -r -d '' block; do
  [ -z "$block" ] && continue
  hash=$(printf '%s' "$block" | shasum | awk '{print $1}')
  if ! grep -qxF "$hash" "$STATE"; then
    echo "$hash" >> "$STATE"
    speak_text+="$block. "
  fi
done < <(extract_narrations)

[ -n "$speak_text" ] || exit 0

pkill -x say 2>/dev/null || true
( say -r 180 -- "$speak_text" 2>/dev/null ) &
disown $!

exit 0
