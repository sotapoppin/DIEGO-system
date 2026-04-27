---
type: proposal
status: applied
created: 2026-04-27
applied: 2026-04-27
file: spaces/life/CLAUDE.md
---

# Add session-start lint nudge for the life space

## The friction

The `lint` operation in the life space exists but has no automatic surfacing — it runs only when the user explicitly types "lint" or "health check." In practice users forget to ask, so the wiki accumulates orphans, stale pages, contradictions, and unpromoted concepts unseen. The whole point of `lint` is to catch drift early; if nobody triggers it, it doesn't catch anything.

Two directions were considered. (1) A real scheduled trigger using Claude Code cron — runs lint without the user present, drops a report. (2) A session-start nudge — when the user first routes to the life space in a session, Diego notices that the last lint was >N days ago and offers to run one. Option 2 keeps Diego in librarian mode (responding to the user's presence rather than acting in the background) and is the lightest viable mechanism.

## The diagnosis

Schema rule **missing**. There is no defined trigger for `lint` other than explicit user request, and no convention for how lint output is preserved across sessions (currently it's just conversational, vanishing with the session).

## Current text

`spaces/life/CLAUDE.md`, directory structure section: *(no `lint-reports/` directory)*

`spaces/life/CLAUDE.md`, `### Lint` operation:
> Triggered by "lint" / "health check."
>
> Look for orphan pages, stale entries (90+ days), contradictions across pages, concepts mentioned 3+ times without their own page, goals with no recent activity in `log.md`, frontmatter inconsistencies. **Report; don't fix without permission.**

No "session-start check" section anywhere.

## Proposed text

**1. Directory structure** — add `lint-reports/` as a sibling to `wiki/`:
> `spaces/life/`
> `  raw/`
> `    ...`
> `  wiki/`
> `    ...`
> `  lint-reports/    # dated lint outputs (YYYY-MM-DD-lint.md)`
> `  index.md`
> `  log.md`
> `  CLAUDE.md`

**2. Replace the `### Lint` operation** with:
> ### Lint
>
> Triggered by "lint" / "health check," or by the user accepting a session-start nudge (see "Session-start check" below).
>
> Look for orphan pages, stale entries (90+ days), contradictions across pages, concepts mentioned 3+ times without their own page, goals with no recent activity in `log.md`, frontmatter inconsistencies. **Report; don't fix without permission.**
>
> **Output:** every lint pass produces two artifacts:
> 1. A conversational summary surfaced in the chat.
> 2. A dated report file at `lint-reports/YYYY-MM-DD-lint.md` using the template below. The file is the durable record; the conversational summary is for in-the-moment review.
>
> **Lint report template:**
>
> ```yaml
> ---
> type: lint-report
> ran: YYYY-MM-DD
> status: open | reviewed | actioned | dismissed
> findings: <count>
> ---
> ```
>
> Body sections (omit any with zero findings): `## Orphans`, `## Stale`, `## Contradictions`, `## Promotable concepts`, `## Frontmatter issues`, `## Notes`.
>
> Append one line to `log.md` when a lint runs. Move the report's `status` to `reviewed` after the user has discussed it; to `actioned` after follow-up edits; to `dismissed` if no action will be taken. Status updates are part of the operation, not bookkeeping the user has to ask for.

**3. Add a new section** between `## Operations` and `## Voice-memo handling` titled `## Session-start check`:
> ## Session-start check
>
> The first time in a session you route to or do work in the life space, check `lint-reports/`:
>
> - If empty, or the most recent report is dated **>14 days ago**, surface this briefly *before* doing the requested work: one sentence noting the gap, offer to run a lint pass.
> - If the user defers ("not now," "later"), proceed with the requested work and don't ask again this session.
> - If the user agrees, run `lint` (which produces a new dated report), then proceed.
> - If the most recent report exists and is ≤14 days old, no nudge — proceed silently.
>
> The 14-day threshold is the current default. Tune via meta loop if it proves too noisy or too quiet in practice.
>
> This is the lightest scheduling mechanism — no cron, no background execution. The "schedule" is just "Diego notices when you show up and lint is overdue."

## Rationale

- **Catches drift without requiring the user to remember.** Solves the actual friction.
- **Stays in librarian mode.** Diego doesn't run anything in the background; the nudge fires only when the user is already present.
- **Low blast radius.** A skipped session means the nudge gets delayed, not lost. No reports pile up unseen.
- **Persistent record.** Lint reports are now durable files with a status field, so the user can revisit findings, action them later, or see a history of how the wiki has cleaned up over time.
- **Tradeoff:** depends on the user actually starting sessions. If sessions are sparse, lint slips. Acceptable initial design; if it proves insufficient, the path to true scheduling is open.
- **Tradeoff:** introduces a new top-level directory (`lint-reports/`) and a new file type (`lint-report`). Small additions, but they do enlarge the schema surface.
- **Tradeoff:** the 14-day threshold is a guess. Easy to tune.

## Scope

- [x] Affects only one space (life)
- [ ] Affects identity / root CLAUDE.md
- [ ] Affects multiple spaces

The session-start pattern could later be generalized to a root-level mechanism that any space can opt into, but that's deferred — the work space hasn't built out enough to need it yet.

## Discussion

User asked for "scheduled reorganization of the wiki." We disambiguated: "scheduled" can mean (a) an actual scheduled trigger running without the user present, or (b) a session-start nudge fired by the user's presence. After surfacing the tradeoff (background execution vs. librarian mode), user picked (b) — the lighter, presence-based version. Cadence chosen: 14 days by default, retunable.

## Applied

Applied 2026-04-27. Three edits to `spaces/life/CLAUDE.md`: directory structure now includes `lint-reports/`; the `### Lint` operation describes the new two-artifact output and report template; new `## Session-start check` section added. Changelog entry recorded.
