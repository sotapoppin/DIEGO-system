---
name: update
description: Commit accumulated batched-ingest context to the wiki — update affected pages, index, and log in one synthesized batch, then exit batched-ingest mode. Trigger when the user says "update", "/update", "update the wiki", "commit", or signals the batch should be filed.
---

# Commit a batched ingest

Counterpart to the `ingest` skill. While in batched ingest mode, Diego accumulates user-supplied context across turns without per-fact filing. This skill commits that context in one synthesized pass and exits the mode.

## Steps

1. **Synthesize the accumulated context internally first.**
   - Group by entity: which existing wiki pages need updates, which new pages need to be created.
   - Group by relationship: cross-references that need to be added on multiple pages (e.g., person A mentioned on person B's page and vice versa).
   - Identify journal-worthy observations (recurring threads, contradictions, named conflicts). These go in the day's journal entry, not on individual pages.

2. **Brief back the planned edits before writing — but tightly.**
   - One short paragraph or bullet list summarizing what will land where. Not a full diff.
   - The point is to give the user a chance to redirect cheaply ("wait, don't file that part yet") without ceremonial review.
   - If the user has already signaled high trust ("just do it," "go") or the accumulated context is small, skip this step and just commit.

3. **Apply the edits in one efficient pass.**
   - Use parallel `Edit` calls where the changes are independent.
   - For new people pages, use `Write` with the standard `type: person` frontmatter (see `spaces/life/CLAUDE.md` Page conventions).
   - Cross-link aggressively: every new entity gets `[[wikilinks]]` to every other relevant entity, and the related: frontmatter on both sides reflects the connection.
   - Don't propagate identical metadata blocks (etymologies, group descriptions) to every member's page — keep that on the canonical anchor (`about.md` or the relevant subgroup page) and let other pages just reference the name.

4. **Update the index.** New people get added under the appropriate subgroup; texture-line should be one short fragment, not a paragraph. Reorganize subgroups if accumulated context introduces a new natural grouping.

5. **Update the about.md `related:` frontmatter.** Add new wikilinks for any new entities directly tied to the user (the about-page subject).

6. **Append a single log entry to `spaces/life/log.md`** summarizing the batch:
   ```
   - [YYYY-MM-DD] batch-ingest | <one-line summary of what landed>; <list of pages touched>
   ```
   One log entry per batch, not one per page edit. The whole point of the mode is to compress.

7. **Update journal if the batch surfaces journal-worthy observations.**
   - Recurring threads, named conflicts, contradictions, patterns the user articulated for the first time → these go in today's `spaces/life/wiki/journal/<date>.md` if it exists, or get folded into the next session entry.
   - Routine factual additions (where someone lives, what class they took) do NOT need journal mention.

8. **Confirm exit from batched mode.** One-line signal back to the user: "Filed. Out of batch mode." If the user wants to keep going under the same mode, they can re-invoke `/ingest`.

## Honesty pass before committing

Before writing, do a quick read of the synthesized batch and ask: is there anything the user said that warrants an honest observation I haven't already raised in conversation? Examples:

- A pattern the user didn't name (e.g. someone consistently described as "distant" who keeps coming up).
- A contradiction with something on an existing page.
- A relationship dynamic that looks structurally heavier than the user's affect suggests.

Surface these in the response after committing — not in the brief-back, which should stay tight. The point is the wiki landed *and* the user got a thoughtful read, not just data ingestion.

## What NOT to do

- **Don't drag out the brief-back step.** The user invoked `/update` to commit, not to review a manifest. Tight summary or skip.
- **Don't ask permission for routine page-structure choices.** If you'd put a fact in `## Relationship` vs. `## Recurring threads`, just pick. The user has explicit feedback to make assumptions on routine moves.
- **Don't repeat etymologies, group descriptions, or identical metadata across multiple pages.** Single source of truth on the anchor; other pages link.
- **Don't generate a multi-page log entry.** One line per batch, summary-style.
- **Don't moralize twice.** If you raised an honest concern in batched mode and the user already responded to it, don't re-raise it on commit. (Per separate feedback memory: recurring care is fine, but don't duplicate within the same arc.)

## Edge cases

- **Mid-session crash / context loss:** if the conversation gets `/clear`'d or compacted, the accumulated context is lost. Mitigate by committing at natural pauses, not just at explicit user signal.
- **Conflicting facts within a batch:** if the user says X early in the batch and Y later that contradicts it, prefer the later statement; note the trajectory if it's affectively meaningful (per voice-memo handling rules in `spaces/life/CLAUDE.md`).
- **User wants to keep accumulating after `/update`:** that's fine — re-enter `ingest` mode. The two skills compose.
