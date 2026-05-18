---
type: proposal
status: open
created: 2026-04-29
applied: null
file: skills/ (new skill directories), spaces/life/CLAUDE.md (cross-reference)
---

# Space-level slash skills (`/journal`, `/lint`, `/reflect`)

## The friction

Git-workflow skills (`/commit`, `/push`, `/wrap`) and ingest skills (`/ingest`, `/update`) exist as canonical slash entry-points to common operations. Space-level operations don't. The user has to *describe* what they want ("can you run a lint pass," "do a reflection across the last two weeks") rather than invoke the operation by name. The result: the operations are documented in `spaces/life/CLAUDE.md` but the friction of invoking them by description means they fire less often than they should — particularly `lint` and `reflect`, which are the operations most prone to skipping.

Logged 2026-04-27. Candidates named: `/journal`, `/lint`, `/reflect`. (`/ingest` already exists as of 2026-04-28.)

## The diagnosis

**Schema rule missing.** Current skills are scoped to repo-level git operations and ingest workflows. Space-level operations have schema definitions but no skill scaffolding. The asymmetry creates friction proportional to how often each operation should fire — `lint` should fire weekly-ish but doesn't, because the only way to invoke it is to remember it exists.

## Current text

> (no current rule — `skills/` contains `commit`, `push`, `wrap`, `ingest`, `update`; no parallel coverage for space-level ops)

## Proposed text

Add three new skill directories under `skills/`:

### `skills/journal/SKILL.md`

```markdown
---
name: journal
description: Open or update today's life-space journal entry. Triggers the reflective-narrative section if missing, then the `## Sessions` block. Trigger when the user says "journal", "/journal", "open today's journal", or wants to add to the day's reflective log without a full ingest.
---

# Journal

Find today's `spaces/life/journal/YYYY-MM-DD.md`. If it doesn't exist, create it with frontmatter (`type: journal`) and an empty reflective-narrative section above an empty `## Sessions` block.

If the user is asking to *append* to the narrative, ask once: "Add to the narrative or open a session entry?" Default to a session entry if ambiguous.

For session entries, use the `### <slot> — <session-slug>` shape from `spaces/life/CLAUDE.md` (Discussed / Decisions / In-flight / Files touched).

Append to `spaces/life/log.md` after writing.
```

### `skills/lint/SKILL.md`

```markdown
---
name: lint
description: Run a life-space lint pass — check for orphans, stale entries, contradictions, promotable concepts, frontmatter issues, and oversize anchor pages. Produces a dated report in `lint-reports/`. Trigger when the user says "lint", "/lint", "health check", "what's drifting", or accepts a session-start nudge.
---

# Lint

Run the full `Lint` operation defined in `spaces/life/CLAUDE.md`:

1. Scan `wiki/` for orphans, stale (>90 days), contradictions, promotable concepts (3+ mentions without a page), goals with no recent `log.md` activity, frontmatter inconsistencies, oversize anchor pages.
2. Surface a conversational summary in chat.
3. Write a dated report at `spaces/life/lint-reports/YYYY-MM-DD-lint.md` using the template (`type: lint-report`, status `open`).
4. Append one line to `spaces/life/log.md`.

Apply the absence-framing default (see `spaces/life/CLAUDE.md` "Lint"): empty or sparse areas may faithfully reflect the user's actual state, not a deficiency to fill.
```

### `skills/reflect/SKILL.md`

```markdown
---
name: reflect
description: Surface 3-5 honest observations across the last 7-30 days of life-space activity — stalled goals, recurring themes, contradictions, things stopped being mentioned, energy patterns. Not flattering; not coaching. Trigger when the user says "reflect", "/reflect", "what are you seeing", or "what's the pattern".
---

# Reflect

Run the `Reflect` operation defined in `spaces/life/CLAUDE.md`:

1. Read the last 7-30 days of `spaces/life/journal/` and `spaces/life/log.md`.
2. Skim most-touched wiki pages from that period.
3. Surface 3-5 observations. Honest, not flattering. Pushback is fine — friendliness is not agreement.
4. Propose 1-2 follow-up questions or actions.

Do not auto-file the reflection. If the user wants it captured, ask whether to write it as a journal-entry session, a theme-page update, or just leave it ephemeral.
```

Add a one-line cross-reference to `spaces/life/CLAUDE.md` near the top of `## Operations`:

> Each of these operations also has a slash-skill entry-point: `/journal`, `/lint`, `/reflect`. The skill body is the lightweight invocation; the schema sections below are the full operational definition.

## Rationale

- **Lower the activation cost of well-defined operations.** A named skill is muscle memory; a described request is friction.
- **Mirror the existing skill pattern.** `/commit`, `/push`, `/wrap`, `/ingest`, `/update` already exist. The asymmetry between repo/git ops and space ops is the friction itself.
- **Skill bodies stay thin.** The schema in `spaces/life/CLAUDE.md` is the source of truth; skills just point at it. This keeps the rule in one place.
- **Tradeoff:** more skills means more list-clutter when listing available skills. Acceptable — these are space-level fundamentals, not niche utilities.
- **Tradeoff:** skills bypass the routing step (Diego doesn't have to infer "this is a life-space request"). Mostly fine for these — `/journal`, `/lint`, `/reflect` are unambiguously life-space. If work-space ever grows parallel operations, namespace them (`/work-reflect`?) or make the skill space-aware.

## Scope

- [x] Affects only one space (life — though skills directory itself is system-wide)
- [ ] Affects identity / root CLAUDE.md
- [x] Affects repo structure (new skill directories)

## Open questions

- Should `/lint` produce *just* the report file, or also do the conversational summary? Default proposal: both, matching current schema. The report is the durable record; the chat summary is for in-the-moment discussion.
- Should `/reflect` ever update the wiki on its own, or always stay ephemeral? Default proposal: always ephemeral — the user explicitly files what's worth keeping.
- Work-space parallels (`/work-ingest`, `/work-lint`?) deferred until work-space activity warrants.

## Discussion

(To be filled in during refinement.)
