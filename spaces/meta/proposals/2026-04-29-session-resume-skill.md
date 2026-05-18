---
type: proposal
status: open
created: 2026-04-29
applied: null
file: skills/resume/ (new), spaces/life/CLAUDE.md (Sessions block reference)
---

# `/resume` skill — session-start context load

## The friction

`/wrap` synthesizes the session at end-of-session into a structured `## Sessions` block. The consumption side is missing. Today, when a session starts, Diego has no canonical "load the last session's context" move. The user ends up either describing what they were doing last time, or Diego improvises a re-read by guessing which files matter.

Logged 2026-04-27 alongside a write-up reference to `/resume` + `/compress` skills with a scannable Quick Reference at the top of session logs.

The Diego-specific version is narrower than the external pattern, because the `## Sessions` block already exists as the durable Quick Reference. What's missing is the entry-point that consumes it.

## The diagnosis

**Schema rule missing.** `/wrap` produces a `## Sessions` entry but nothing names the consume operation. Without a named entry-point, Diego's session-start behavior is improvisational. With one, the load step is muscle-memory and predictable.

(`/compress` from the external pattern is not proposed here — `/wrap` already does the synthesis-at-session-end role. Adding `/compress` as a separate skill would be redundant.)

## Current text

> (no current rule — session-start behavior is unspecified beyond the life-space session-start lint nudge)

## Proposed text

### `skills/resume/SKILL.md`

```markdown
---
name: resume
description: Load context from the most recent `## Sessions` entry across the life-space journal so the current session can pick up cleanly. Surfaces what was discussed, decisions made, what's in-flight, and which files were touched. Trigger when the user says "resume", "/resume", "where were we", "what was I doing", "load context", or starts a session by referencing prior work.
---

# Resume

1. Read the most recent few `spaces/life/journal/YYYY-MM-DD.md` files (today's first, then walk back until you find at least one populated `## Sessions` block, up to 7 days back).
2. Find the most recent `### <slot> — <session-slug>` entry. Read that one in full, plus the entry before it for context.
3. Surface a brief in-chat summary: what was discussed, what was decided, what's in-flight, files touched. Keep it scannable, not narrative.
4. Note any in-flight items the user has *not* mentioned today — those are the candidates for picking up.
5. Do not auto-file anything from the resume itself. It's a load operation, not a write.

If no recent `## Sessions` entries exist (vault is fresh, or the user has been away long enough that the trail is cold), say so — don't fabricate context.

If the most recent session entry was earlier *today*, treat it as continuation rather than resume — surface the in-flight items but skip the full re-read ceremony.
```

Add a cross-reference under "Session entries (within journal)" in `spaces/life/CLAUDE.md`:

> The `## Sessions` block is read at the *start* of subsequent sessions via the `/resume` skill — it's the durable Quick Reference for picking up cleanly. Keep entries scannable so `/resume` can surface them without reformatting.

## Rationale

- **Symmetry with `/wrap`.** `/wrap` writes the session entry; `/resume` reads it. Both should exist or neither.
- **Replaces improvisation with a named step.** Diego's current session-start behavior depends on remembering to look at the journal. A named skill makes it the default move when the user signals continuation.
- **Surfacing in-flight items is the highest-leverage half.** Decisions are usually closed; discussions are usually historical. What blocks fast resume is "what was I in the middle of." That's exactly what the in-flight line captures.
- **No `/compress` companion.** External pattern has both — Diego has `/wrap` for the write side already. Adding `/compress` as a separate skill would create two end-of-session entry-points and confuse the workflow.
- **Tradeoff:** `/resume` overlaps with the session-start lint nudge. They're orthogonal: lint nudge surfaces *system drift* (overdue health check), `/resume` surfaces *user state* (what you were doing). Both can fire in the same session-start.
- **Tradeoff:** if the user explicitly clears (`/clear`) and then starts fresh without `/resume`, they'll get no auto-load. That's fine — explicit clear means explicit start-from-zero.

## Scope

- [ ] Affects only one space
- [ ] Affects identity / root CLAUDE.md
- [x] Affects repo structure (new skill directory)

## Open questions

- Should `/resume` look at `spaces/life/log.md` in addition to journal `## Sessions`? Default proposal: no — `log.md` is operational noise, the Sessions block is curated context. If something's missing from Sessions, the fix is the wrap, not the resume.
- Should `/resume` ever extend across spaces (e.g., load work-space context too)? Default proposal: no — single-space focus is part of why it stays fast.
- Should resume default-fire when the assistant detects a continuation phrase ("where were we") even without the slash? Probably not — explicit invocation keeps the contract clean.

## Discussion

(To be filled in during refinement.)
