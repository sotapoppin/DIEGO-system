#!/bin/bash
# Stop hook — extracts <speak>...</speak> from the latest assistant text
# and pipes the contents to macOS `say` for TTS playback.

set -uo pipefail

input=$(cat)
transcript=$(echo "$input" | jq -r '.transcript_path // empty' 2>/dev/null)

[ -n "$transcript" ] && [ -f "$transcript" ] || exit 0

extract_speak() {
  jq -rs '
    (. | map(.type == "user") | rindex(true)) as $last_user
    | .[($last_user // -1) + 1 :]
    | [.[] | select(.type == "assistant" and (.message.content | type) == "array") | .message.content[] | select(.type == "text") | .text]
    | join("\n---SEP---\n")
  ' "$transcript" 2>/dev/null | perl -0777 -ne 'my @m; while (/<speak>(.*?)<\/speak>/gs) { push @m, $1; } print $m[-1] if @m;'
}

speak=""
for _ in 1 2 3 4 5; do
  speak=$(extract_speak)
  [ -n "$speak" ] && break
  sleep 0.3
done

[ -n "$speak" ] || exit 0

pkill -x say 2>/dev/null || true
( say -r 210 -- "$speak" 2>/dev/null ) &
disown $!

exit 0
