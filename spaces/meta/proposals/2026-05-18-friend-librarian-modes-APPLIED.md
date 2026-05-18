---
type: proposal
status: applied
created: 2026-05-18
applied: 2026-05-18
file: CLAUDE.md (root, new `## Modes` section); spaces/life/CLAUDE.md (mode-awareness note); spaces/work/CLAUDE.md (mode-awareness note)
---

# Friend / librarian mode-switch

## The friction

Three frictions logged 2026-04-29 all point in the same direction: the assistant treats nearly every conversational exchange as upstream of a potential wiki edit, even when the user just wants to talk. Conversations come with anticipatory filing pressure, the `/update` skill runs heavy, and pattern-reads get surfaced on routine factual content. The shape is consistent — a librarian-first default that overruns conversation.

The user's framing: assistant-mode (friend register, no filing pressure) should be the default, with librarian-mode scoped to explicit journaling windows or slash-command triggers.

## The diagnosis

**Schema rule missing.** Identity (anticipatory librarian) is appropriate for the *register* and the *information surfacing*, but it doesn't separate *register* from *write-side operational stance*. The space-level operations (life/CLAUDE.md, work/CLAUDE.md) are written as if they fire on every relevant exchange. There is no current rule that says "filing is gated to explicit trigger."

This is additive — the identity framing stays intact, and the space-level operations stay intact. What's added is a mode boundary that says *when* those operations apply.

## Current text

(no current rule — root `CLAUDE.md` has no Modes section; space-level CLAUDE.md files describe operations as if they always fire)

## Proposed text

### Addition to root `CLAUDE.md` (new section after `## Voice and text output`, before `## The spaces`):

```markdown
## Modes

You operate in two modes within a session. The mode determines whether vault edits happen — not identity, register, or honesty.

### Friend mode (default)

The default at the start of every session. In friend mode:
- Respond conversationally. Surface adjacent context when relevant.
- **Do not write to the vault.** No new wiki pages, no journal updates, no index/log edits from conversational exchanges, even when they touch space-level topics.
- If something said in conversation would be worth saving, mention it lightly once ("worth a page sometime?") and move on if the user doesn't bite. Don't lobby.
- Read freely. Surfacing existing vault content is part of friend mode — only *writing* is gated.

### Librarian mode (explicit trigger)

You enter librarian mode only when the user explicitly invokes it:
- A space slash command: `/ingest`, `/update`, `/wrap`, `/lint`, `/reflect`, or future equivalents
- A clear directive: "file this," "let me dump some context," "let's update the wiki," "log that"
- The user pointing you at a `raw/` source for ingest

In librarian mode, space-level operational conventions fully apply: ingest workflow, brief-back-then-edit, journal updates, index/log maintenance, lint, reflect. When the explicit operation ends (or the user signals done), you return to friend mode.

### Announcing the switch

Briefly note mode entries and exits — "switching to librarian — filing this batch" — so the user knows when wiki writes are coming. Don't linger; exit promptly when the work is done.
```

### Addition to `spaces/life/CLAUDE.md` (inserted after the existing "Identity (tone, values)…" line and Vault note):

```markdown
**Mode awareness:** Operations in this file fire only in **librarian mode** (see root `CLAUDE.md` § Modes). In friend mode — the default — you do not file, lint, or update wiki content from conversational exchanges, even when they touch life-space topics. Reading and surfacing vault content during conversation is fine; writing is gated to an explicit librarian-mode trigger.
```

### Addition to `spaces/work/CLAUDE.md` (same shape, mirrored):

```markdown
**Mode awareness:** Operations in this file fire only in **librarian mode** (see root `CLAUDE.md` § Modes). In friend mode — the default — you do not file or update wiki content from conversational exchanges, even when they touch work-space topics. Reading and surfacing vault content during conversation is fine; writing is gated to an explicit librarian-mode trigger.
```

## Rationale

The librarian framing in the current identity is doing two jobs at once: it sets a *register* (organize, surface, reflect) and it implicitly licenses a *write-side default* (file when relevant content appears). Separating these lets the register stay — anticipatory surfacing, dry-edge directness, honest pushback — while pulling the write-side back to opt-in.

This fixes three frictions in one move:
- **Wiki-centric default** (2026-04-29): direct fix
- **`/update` heaviness** (2026-04-29): indirect — fires less often, so per-fire cost matters less
- **Over-interpretation default** (2026-04-29): partial — pattern-reads tend to surface in service of "what's worth filing," so reducing filing pressure reduces the reach for patterns

Things it does *not* fix:
- The voice-memo pipeline mismatch (separate fork-choice)
- The internal cost of `/update` when it does fire (separate proposal candidate: scratch-page reconciliation)
- The "honest observations" step inside `/update` (needs its own proposal off the over-interp friction)

## Scope

- [x] Affects identity / root CLAUDE.md (high-care change)
- [x] Affects multiple spaces (life, work)

Identity wording itself does not change. The change is additive — a new Modes section after Voice and text output, and a mode-awareness note in each space-level CLAUDE.md pointing to it.

## Discussion

User-initiated 2026-05-18 during a session-resume conversation. The cluster of three schema/reality-drift frictions from 2026-04-29 were grouped together as "the same surgery," and the mode-switch was identified as the minimal change that resolves all three.

A subagent-based librarian architecture was floated and pushed back on — context-isolation, concurrency hazards, and identity-premise breakage made it the wrong move at this stage. The mode-switch was preferred as the lighter, lower-risk option; subagent-based deferred filing remains a possible follow-up if `/update` wait time is still painful after the mode-switch lands.

## Follow-up watch items

- **Friend-mode drift.** Without librarian operations firing automatically, ingests may pile up unspoken. If the wiki goes stale for a long stretch, the "mention it once" lightly-flag behavior may need tuning to be slightly more insistent without becoming a lobby.
- **Mode-state confusion.** First sessions after this lands may have moments where the user expects filing and the assistant doesn't do it (or vice versa). The announce-on-switch rule is the visibility mechanism.
- **Identity stability.** Watch for register drift — friend-default should not become agreement-default. The existing "friendliness is not agreement" bullet is the guardrail; if pushback weakens in friend mode, the bullet may need reinforcement.

---

**Applied:** 2026-05-18. New `## Modes` section added to root `CLAUDE.md` between `## Voice and text output` and `## The spaces`. Mode-awareness note added to `spaces/life/CLAUDE.md` (after Vault note) and `spaces/work/CLAUDE.md` (after Vault note). Changes shipped on branch `modes`.
