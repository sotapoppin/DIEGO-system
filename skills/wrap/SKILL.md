---
name: wrap
description: End the current Diego session by appending a structured `### <slot> — <slug>` entry to the `## Sessions` block of today's life-space journal. Captures discussed / decisions / in-flight / files touched. Trigger when the user says "wrap", "/wrap", "end session", "wrap up", or signals they're done for now.
---

# Wrap the current session

Append a per-session structured summary to today's life-space journal under `## Sessions`. This is what next-session-Diego reads first to load context fast (see `spaces/life/CLAUDE.md` "Session entries" subsection for the canonical convention).

## Steps

1. **Determine date and slot.**
   - Run `date +"%Y-%m-%d %H"` to get today's date (`YYYY-MM-DD`) and current hour (24h).
   - Map hour to slot:
     - `00`–`11` → `morning`
     - `12`–`17` → `afternoon`
     - `18`–`23` → `evening`
   - If the session straddled a clear inflection (e.g. started at 17:55 but most work happened after 18:00), use the dominant slot.

2. **Synthesize the session — be specific, not vague.**
   - **Discussed:** one-line topic summary. Don't list every turn; capture the through-line of the conversation. If the session covered multiple distinct threads, name them with semicolons.
   - **Decisions:** bullets of what got *decided* this session — applied schema changes, accepted plans, scope choices. "None" if nothing decided.
   - **In-flight:** bullets of what's *pending* — open questions, scoped-but-unbuilt work, things to revisit, frictions logged but not yet acted on.
   - **Files touched:** bullets of paths edited or created in this session. Group by location: `- DIEGO-system: ...` and `- vault: ...`. Skip if zero files touched.
   - Pick a 1-3 word **slug** that captures the session's defining theme (e.g. `friendly-mode-merge`, `people-roster-seed`, `voice-frictions`).

3. **Find or create today's journal.** Path: `spaces/life/wiki/journal/<date>.md`.
   - If it exists: read it; find the `## Sessions` heading. If the heading doesn't exist (older journal predating the convention), append it at the end of the file.
   - If it doesn't exist: create the file with frontmatter (`type: journal`, today's date for `created`/`updated`, `related:` as a YAML block list, `status: active`), a one-sentence opening summary of the day so far, then a `## Sessions` heading.

4. **Show the user the draft entry.** Confirm before writing. The user may want to edit phrasing — don't auto-write.

5. **Append the entry under `## Sessions`** in this shape:

   ```markdown
   ### <slot> — <slug>
   **Discussed:** ...
   **Decisions:**
   - ...
   **In-flight:**
   - ...
   **Files touched:**
   - DIEGO-system: ...
   - vault: ...
   ```

   Single-bullet sections can collapse to inline form: `**Decisions:** none.`

6. **Update journal frontmatter.** Set `updated:` to today. If the entry mentions wiki pages not yet in `related:`, add them (as YAML block list with double-quoted wikilinks per the frontmatter convention).

7. **Append a one-line entry to `spaces/life/log.md`:**
   ```
   - [YYYY-MM-DD] wrap | <slot> — <slug> session entry appended to journal
   ```

## Don't

- **Skip the confirmation step.** The user may want to edit synthesis before it lands.
- **Reconstruct earlier portions of the session you don't have visibility into.** If the user `/clear`'d at some point and you only see partial context, note the gap honestly: `**Note:** earlier portion of this session is not visible; this entry covers from the clear forward.`
- **Duplicate entries.** If today's `## Sessions` block already has an entry for the current slot, ask whether to *update* the existing entry or *add* a new one with a sub-slot like `evening (continued)` or a specific time like `20:30`.
- **Vague synthesis.** "Worked on Diego" is useless. "Applied friendly-mode identity tuning, logged 6 frictions, fixed YAML frontmatter convention, added Sessions block" is the right specificity.
- **Edit the reflective narrative at the top of the journal.** That's separate from the Sessions block. Updates to it require an explicit ask.
