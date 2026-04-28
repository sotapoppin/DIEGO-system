# Friction Log

Append-only log of things that felt off. One line per entry. No fix required.

**Public-meta discipline applies.** Every entry is abstracted — no names, no specific projects, no quoted user content. See `CLAUDE.md` in this directory for the rule.

Format: `- [YYYY-MM-DD] <space> | <abstracted one-sentence description>`

A friction that recurs 3+ times graduates to a `pattern` (see `patterns/`). A friction the user wants fixed graduates to a `proposal` (see `proposals/`).

---

- [2026-04-27] meta | identity-tuning experiment may inflate response length and token usage; revisit after a week of real use to check whether warmer register costs meaningfully more output
- [2026-04-27] meta | text-only output limits the conversational feel; user wants Diego to speak responses aloud (TTS), not just type — relevant when scoping voice-interface work
- [2026-04-27] meta | one register doesn't fit both modalities; user wants two output modes — a terse voice-mode (responses kept short for TTS playback) and the current text-mode (full structure, lists, code blocks)
- [2026-04-27] meta | self-reference drift — assistant slipped into third person about itself ("Diego's outputs are X," "the system depends on Y") in extended operational discussion, losing first-person identity stance
- [2026-04-27] life | name collision between the assistant's first name and a recurring person in the user's life (same given name); the collision is intentional — assistant was named after the person; disambiguation in voice-memo ingest will need to lean on context (system/operational mentions vs social/personal mentions)
- [2026-04-27] meta | no session-continuity layer — journal entries are reflective narrative, not optimized for scanning at the next session's start; missing a "what's in flight / what's pending" quick-reference that the next session can load fast (pattern from external write-up: /resume + /compress skills with a scannable Quick Reference section in session logs)
- [2026-04-27] meta | canonical anchor pages (e.g. self-anchor, project pages) have no size threshold or archive convention; will grow unbounded over time; missing an auto-archive rule that moves stale sections to a sibling archive page while protecting designated core sections (pattern from external write-up: line-count threshold trigger with protected-section list)
- [2026-04-27] meta | git-workflow slash commands exist (/commit, /push) but space-level operations have no shortcut equivalents; candidates for parity: /journal, /ingest, /lint, /reflect — would lower friction on the most common life-space operations
