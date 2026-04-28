---
type: proposal
status: open
created: 2026-04-28
file: root CLAUDE.md (output convention), .claude/settings.json (Stop hook)
---

# Voice mode — dual output via `<speak>` block + Stop hook

## The friction

Three friction entries from 2026-04-27 cluster around the same underlying need:

- *Token-cost worry* — warmer/friendlier register may inflate response length.
- *TTS desire* — Diego should be able to speak aloud, not just type.
- *Dual-mode* — voice mode should be terse for playback; text mode should keep full structure (lists, code, tables).

Treating these separately produces three half-fixes. Treating them as one — *what the user hears vs. what the user reads, in the same turn* — produces one mechanism that resolves all three.

The use case Sota named directly: when he's at the keyboard, he wants the dense structured response *and* a short spoken summary so he can listen-and-glance instead of read-and-parse. The two channels carry different payloads, not the same payload at different lengths.

## The diagnosis

**Output-convention rule missing** plus **harness wiring missing**:

- The output convention has no designated location for "the speakable line." Without a tag, a hook can't reliably extract the spoken portion, and the assistant has no anchor for *what to say vs. what to write*.
- Claude Code already supports `Stop` hooks in `settings.json`, which fire when a turn ends. The wiring is available; nothing's pointed at TTS yet.

The fix is two-sided and both sides are required: a convention in Diego's output, and a hook that consumes it.

## Current text / state

- Root `CLAUDE.md` defines tone, identity, and behavior, but has no spoken-output convention.
- `.claude/settings.json` has no `Stop` hook.
- macOS `say` is available natively. No external TTS service is wired in.

## Proposed change

### 1. Output convention (root `CLAUDE.md`)

Add a new section, `## Voice and text output`, with this rule:

> When a response has a meaningful update worth saying aloud, lead with a `<speak>...</speak>` block — one or two short sentences, conversational, no markdown. The block is consumed by a TTS hook and removed from the rendered text before the user sees it. Everything else in the response is text-only: structured detail, file paths, draft entries, lists.
>
> Skip the block on tool-only turns, on confirmations the user just gave, or when there's nothing to summarize. Brevity over completeness — the spoken line is a *headline*, not a recap.

### 2. Stop hook (`.claude/settings.json`)

Register a `Stop` hook that:

- Reads the last assistant turn.
- Extracts the contents of the first `<speak>...</speak>` block, if any.
- Pipes the extracted text to `say` (macOS native TTS) and detaches.
- Strips the block from the visible transcript so the user doesn't see the markup.

`say` is the right starting choice: built-in, free, no API key, works offline. Quality is acceptable for a headline line. Upgrade to ElevenLabs / OpenAI tts-1 later if voice quality becomes the bottleneck — the hook is a single point of swap.

### 3. Interruption + queueing

`say` blocks until done. To prevent it from stalling the next turn or queuing audio behind a fresh response, the hook should `pkill say` before invoking a new `say` call. New turn cuts in; old utterance dies. This matches conversational expectation — when the user types again, the previous spoken line is no longer relevant.

## Rationale

- **One mechanism resolves three frictions.** Token-cost worry goes away because brevity is *only* enforced on the spoken line, not on the text response. TTS works because the hook fires on every turn. Dual-mode works because the two channels are explicitly separated by the tag.
- **Tagged block over implicit conventions.** "First line is always the spoken line" couples brevity to the entire response shape and breaks the moment the assistant needs to lead with a question or a code block. A tag is explicit, omittable, and parseable.
- **Stop hook is the right harness primitive.** Fires on turn end; doesn't need streaming; works with whatever model is running.
- **Trigger is the model's judgment, not a flag.** Diego decides when there's something worth saying. Forced TTS on every turn (including tool-only acknowledgments) would be noise.
- **Tradeoff:** the `<speak>` block adds output the model has to produce, which is a small token cost. But the cost is bounded (1-2 sentences) and offset by removing the implicit pressure to keep the *whole* response short.
- **Tradeoff:** macOS-only as written. `say` doesn't exist on Linux. Cross-platform support is deferred until Diego has a non-Mac install — at which point the hook becomes a small dispatch (`say` on darwin, `espeak` or a TTS API elsewhere).
- **Tradeoff:** if the hook silently fails (e.g., `say` is missing), the user gets text-only with no warning. The hook should log to a known path so failures are diagnosable, not invisible.

## Scope

- [ ] Affects only one space
- [x] Affects identity / root CLAUDE.md (high-care change)
- [x] Affects repo structure and install path (cross-cutting)

The output convention is a root-`CLAUDE.md` edit — every space inherits it. The hook lives in per-install `settings.json` (not symlinked from the system repo, since hooks are environment-specific). `install.sh` could optionally seed a default Stop hook on new installs.

## Open questions

- **Should the hook also speak on tool-only turns** (e.g., a one-line "done, log updated") so the user gets audio confirmation when nothing's to read? Default proposal: no — let the model decide whether to emit `<speak>`. Worth revisiting after a week of real use.
- **Voice selection.** macOS `say` defaults to a generic system voice. Sota may want a specific voice (`-v Samantha`, `-v Daniel`, etc.) or a downloaded high-quality variant. Pick during apply, not now.
- **Rate / volume.** `say -r 200` is a reasonable default but personal. Tunable in the hook.
- **Logging.** Where do hook failures land? Proposal: `~/.claude/voice-hook.log`, rotated manually. Keep small.
- **Third-party TTS upgrade path.** Worth noting in the applied changelog so future-Diego knows the swap point if quality complaints surface.

## Discussion

Surfaced 2026-04-28 morning when Sota asked: *"is there a way you could talk to me out loud in a summary format but give me more information through text."* The phrasing made the dual-channel framing explicit — not "shorten responses" and not "read everything aloud," but two channels carrying different payloads. That framing is what unlocks treating the three earlier frictions as one design problem.
