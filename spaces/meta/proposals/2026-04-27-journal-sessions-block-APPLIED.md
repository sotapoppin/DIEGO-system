---
type: proposal
status: applied
created: 2026-04-27
applied: 2026-04-27
file: spaces/life/CLAUDE.md
---

# Add `## Sessions` block to life-space journal entries

## The friction

Conversations had with the assistant don't have a structured home anywhere in the wiki. The reflective journal entry captures the day at a thematic level, and `log.md` lists operations as terse one-liners, but there's nothing in between — no per-session record of what was discussed, what got decided, what's in flight, and which files were touched. The next session opens cold and has to reconstruct context by reading narrative prose.

This is the same gap surfaced in an external write-up earlier in the day (the `/resume` + `/compress` pattern around scannable session logs), and it was logged as a friction. The user named it organically a few hours later, asking where conversations were tracked.

## The diagnosis

**Schema rule missing.** The life-space schema covers reflective journals (free-form prose) and operational logs (terse one-liners) but has no convention for per-session structured summaries. The journal template is intentionally narrative; adding structure there would dilute its theme-detection value, and creating a parallel `sessions/` directory would mean the day's record is split across two files.

The lightest viable fix: keep journals as the canonical day record, but require a `## Sessions` block at the end of each entry containing scannable per-session summaries. One file per day, two registers within it — narrative on top, structured at the bottom.

## Current text

In the journal page-template entry of `spaces/life/CLAUDE.md`:

> **journal**: dated synthesis of a day or week. Not transcript — *reflection.* What happened, what was felt, what patterns showed up, what's unresolved.

(no convention for session-level entries)

## Proposed text

**1. Update the journal template entry** to point at the new convention:

> **journal**: dated synthesis of a day or week. Not transcript — *reflection.* What happened, what was felt, what patterns showed up, what's unresolved. End the entry with a `## Sessions` block (see "Session entries" below) for scannable per-session summaries.

**2. Add a new "Session entries (within journal)" subsection** after the page templates list and before `## Operations`. Specifies a `## Sessions` heading at the end of each day's journal, with `### <slot> — <session-slug>` per session, each with `Discussed / Decisions / In-flight / Files touched` lines. `<slot>` is `morning` / `afternoon` / `evening` or a specific time. Sessions are appended as they end, not retroactively reconstructed unless asked.

## Rationale

- **Closes a real gap** — the conversation record was previously distributed across the user's memory, the reflective journal, and Claude Code's raw JSONL transcripts (which Diego doesn't read). Now there's a single structured location.
- **Two registers, one file** — keeps the journal as the canonical day record. Narrative for theme detection (human-friendly, slow to scan); Sessions block for context loading (scannable, structured).
- **Lightest viable form** — no new directory, no new file type, no new operation. One new heading convention plus a four-field entry shape.
- **Tradeoff:** journals get longer. For high-activity days (today, for example) the Sessions block can get big. Mitigation deferred — if it becomes a real friction, the page-bloat archive convention (separately friction-logged) covers it.

## Scope

- [x] Affects only one space (life)
- [ ] Affects identity / root CLAUDE.md (high-care change)
- [ ] Affects multiple spaces

## Discussion

User picked option 2 of three offered (heaviest = read Claude Code JSONLs at startup; medium = augment journal with Sessions block; lightest = standalone session-summary skill writing to a sessions directory). Option 2 won on the same instinct that's been visible across the day's meta-loop work: prefer one canonical home over parallel structures. Schema applied immediately rather than left as `open` because the format is small, the gap was concrete, and the user was inside the gap when the proposal was written.

## Applied

Applied 2026-04-27. Edits made to `spaces/life/CLAUDE.md`: journal template entry updated to reference the new convention; new "Session entries (within journal)" subsection added between Page templates and Operations. Today's journal (`wiki/journal/2026-04-27.md`) retroactively populated with a Sessions block covering the morning (system understanding + identity seeding) and evening (friendly-mode + tooling + people roster + YAML fix + sessions schema) sessions, as a one-time bootstrap and a worked example of the convention. Changelog entry recorded.
