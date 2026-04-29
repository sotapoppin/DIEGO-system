---
type: proposal
status: applied
created: 2026-04-28
applied: 2026-04-28
file: skills/ingest/, skills/update/
---

# Add `/ingest` and `/update` skills for batched wiki authoring

## The friction

Default Diego behavior fires a full ingest cycle on every user-supplied fact: read sources, update affected wiki pages, update the index, append to the log, emit a speak block. That works for the canonical "ingest a voice memo" path, but it falls apart in live conversational dumps where the user wants to share a lot of context fast.

Three concrete pain points surfaced during the 2026-04-28 wiki build-out:

1. **Per-turn latency.** Each small fact triggered 4–8 file edits and a structured response. The conversation crawled.
2. **Tool noise.** Heavy `Edit`/`Write` traffic between every user turn made it hard for either side to think.
3. **Granular question density.** With per-fact filing, the assistant kept asking 3–4 follow-ups per topic instead of moving on; the user wanted breadth over depth.

Logged as friction-log entries on 2026-04-28 (see lines 23–25). User explicitly requested codification as slash skills.

## The diagnosis

The `Ingest` operation in `spaces/life/CLAUDE.md` assumes a *file-based* source (voice memo, note, clip). For *conversational* sources, the same operation needs a different shape: accumulate context across turns, ask broad questions, commit once.

This isn't a replacement for the file-based ingest — it's a parallel mode for a different input type. Naming them as explicit skills (`/ingest` to enter, `/update` to commit) gives the user direct control over which mode is active.

## Proposed change (now applied)

**Two new skills** in `diego-system/skills/`:

- **`ingest`** — enters batched mode. Stops per-fact filing. Asks 1–2 broad questions per topic before moving on. Holds context in working memory. Stays warm; honesty rules unchanged.
- **`update`** — commits the accumulated batch in one synthesized pass. Plans the writes, briefs back tightly, edits in parallel, single log entry, single journal mention if warranted. Exits batched mode.

Both skills are symlinked into vaults via `install.sh` (no install changes needed — directory iteration already picks them up).

## Composition with existing memory

Three existing feedback memories shape behavior inside batched mode:

- `feedback_register_caring.md` — warm tone, recurring concerns are fine.
- `feedback_ingest_question_density.md` — 1–2 broad questions per topic, then move on.
- `feedback_make_assumptions.md` — for routine framing/structure choices, pick and proceed; only confirm for irreversible / shared-state actions.

The skills reference these implicitly. The skills define the *shape* of the workflow; the memories define the *register* within it.

## What to watch for

- **Context loss on `/clear` or compaction.** Accumulated batch state lives only in conversation. Mitigation written into the `update` skill: commit at natural pauses, not just at explicit user signal.
- **Brief-back ceremony creep.** The `update` skill explicitly tells assistant to keep brief-back tight or skip when trust is high. If brief-backs grow into manifests, that defeats the purpose.
- **Mode confusion.** If user invokes `/ingest` but then drops a single fact, doesn't matter — mode is cheap. But if user says "actually file this immediately" mid-batch, that's a single-fact escape hatch that should work without exiting batched mode.

## Trial run

The skills were designed in dialogue during the 2026-04-28 wiki session, with the workflow trial-run informally before codification. The trial surfaced the question-density issue (logged separately and reflected in the `ingest` skill body). First formal use will be the next time the user invokes `/ingest`.
