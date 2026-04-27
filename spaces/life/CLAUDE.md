# Life Space

You are operating in the **life space** — the user's personal life. Voice memos, journal entries, people, projects, goals, health, decisions, themes. The user is the subject. Treat with care.

Identity (tone, values) is in the root `CLAUDE.md`. This file covers operational details for this space.

**Vault note:** All `raw/` and `wiki/` content for this space lives in the user's vault, never in the system repo. Only this `CLAUDE.md` is in the system repo (read via symlink). When you write a wiki page or update a journal entry, you are writing to the vault.

## The three layers

1. **`raw/`** — immutable source material. Voice transcripts, clipped articles, photos. **Never edit.**
2. **`wiki/`** — your domain. All synthesis, all entity pages, all cross-references.
3. **`index.md`** + **`log.md`** — navigation aids, updated on every operation.

## Directory structure (in the vault)

```
spaces/life/
  raw/
    voice/      # voice memo transcripts: YYYY-MM-DD-HHMM-slug.md
    notes/      # quick text captures
    clips/      # web articles via Obsidian Web Clipper
    assets/     # images, attachments
  wiki/
    about.md    # the self-anchor — distinct from people/
    people/     # one page per person who matters
    projects/   # active and dormant projects
    themes/     # recurring patterns: ambition, anxiety, creativity
    goals/      # current goals, with status and history
    health/     # physical, mental, sleep, energy
    journal/    # synthesized daily/weekly entries (you write these)
    decisions/  # decisions being wrestled with or resolved
    practices/  # habits, routines, rituals being built
  lint-reports/ # dated lint outputs (YYYY-MM-DD-lint.md)
  index.md
  log.md
  CLAUDE.md     # symlink to diego-system/spaces/life/CLAUDE.md
```

Create directories on demand — don't pre-populate empty folders.

## Page conventions

### Frontmatter

```yaml
---
type: about | person | project | theme | goal | health | journal | decision | practice
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: [list of paths to raw/ files this page draws from]
related: [[other-page]], [[another-page]]
status: active | dormant | resolved | archived
---
```

### Body

- Open with a one-sentence definition or summary.
- Use `[[wikilinks]]` liberally — the graph view is how the user navigates.
- Cite specific sources inline: `According to [[raw/voice/2026-04-15-1430-morning-walk]], ...`
- When sources contradict, **don't paper over it.** Note the contradiction with dates: "On 2026-03-01 the user wrote X; on 2026-04-10 they said Y. The shift coincides with [[event]]."

### Page templates

- **about**: the canonical identity-anchor for the user (the subject of the space). Sections: identity (name, origin, where the user lives now), current context (work, key relationships at a high level, ongoing situations), recurring threads or arcs across time, open questions about the user's own trajectory. Distinct from `people/` — that directory is for *others* in the user's life. Exactly one `about.md` per life space.
- **person**: relationship, recent interactions, recurring threads, open commitments to them, open questions.
- **project**: what it is, why it matters, current state, blockers, next steps, history of evolving thinking.
- **theme**: definition, when it shows up, triggers, how the user has described it over time, related themes/people.
- **goal**: what, why, current status, dated progress history, obstacles, related practices.
- **journal**: dated synthesis of a day or week. Not transcript — *reflection.* What happened, what was felt, what patterns showed up, what's unresolved.
- **decision**: the question, options, what's pulling each way, current lean, what would resolve it, history.
- **practice**: what the habit is, why, current adherence, history of attempts.

## Operations

### Ingest

Triggered by the user pointing you at one or more files in `raw/`.

1. Read the source(s).
2. **Brief back first.** Before writing to `wiki/`, summarize what you heard in 2-4 sentences and ask 1-2 clarifying questions only if genuinely needed. Don't over-ask.
3. Decide what wiki pages need updating or creating. State the plan briefly. Get a go-ahead.
4. Make the edits. For each, briefly note what you changed.
5. Append a journal entry for the day if missing, or update the existing one.
6. Update `index.md` if you created new pages.
7. Append to `log.md`.

**Be conservative about new top-level pages.** Prefer updating existing pages. New `people/` page: 3+ mentions or clearly recurring. New `themes/` page: pattern in 3+ separate sources. New `goals/` page: explicit goal-setting, not vague intention.

### Query

1. Read `index.md` first to find candidate pages.
2. Read relevant pages.
3. For recent topics, also check the last few `journal/` entries and `log.md`.
4. Answer conversationally with citations.
5. If the answer reveals a useful synthesis not yet in the wiki, **ask** about filing it. Don't auto-file.

### Reflect

Triggered weekly or on-demand: "what are you seeing," "what's the pattern."

1. Read the last 7-30 days of `journal/` and `log.md`.
2. Skim most-touched wiki pages from that period.
3. Surface 3-5 observations: stalled goals, recurring themes, contradictions, things the user has stopped mentioning, energy patterns. Honest, not flattering.
4. Propose 1-2 follow-up questions or actions.

### Lint

Triggered by "lint" / "health check," or by the user accepting a session-start nudge (see "Session-start check" below).

Look for orphan pages, stale entries (90+ days), contradictions across pages, concepts mentioned 3+ times without their own page, goals with no recent activity in `log.md`, frontmatter inconsistencies. **Report; don't fix without permission.**

**Output:** every lint pass produces two artifacts:
1. A conversational summary surfaced in the chat.
2. A dated report file at `lint-reports/YYYY-MM-DD-lint.md` using the template below. The file is the durable record; the conversational summary is for in-the-moment review.

**Lint report template:**

```yaml
---
type: lint-report
ran: YYYY-MM-DD
status: open | reviewed | actioned | dismissed
findings: <count>
---
```

Body sections (omit any with zero findings): `## Orphans`, `## Stale`, `## Contradictions`, `## Promotable concepts`, `## Frontmatter issues`, `## Notes`.

Append one line to `log.md` when a lint runs. Move the report's `status` to `reviewed` after the user has discussed it; to `actioned` after follow-up edits; to `dismissed` if no action will be taken. Status updates are part of the operation, not bookkeeping the user has to ask for.

## Session-start check

The first time in a session you route to or do work in the life space, check `lint-reports/`:

- If empty, or the most recent report is dated **>14 days ago**, surface this briefly *before* doing the requested work: one sentence noting the gap, offer to run a lint pass.
- If the user defers ("not now," "later"), proceed with the requested work and don't ask again this session.
- If the user agrees, run `lint` (which produces a new dated report), then proceed.
- If the most recent report exists and is ≤14 days old, no nudge — proceed silently.

The 14-day threshold is the current default. Tune via meta loop if it proves too noisy or too quiet in practice.

This is the lightest scheduling mechanism — no cron, no background execution. The "schedule" is just "Diego notices when you show up and lint is overdue."

## Voice-memo handling

Voice transcripts are messier than written notes. When ingesting:

- **Preserve affect, not wording.** Frustration → "frustrated about X," not the rambling quote.
- **Distinguish what was said from what was meant.** Voice memos are thinking-out-loud. The endpoint often contradicts the opening. Capture the *trajectory.*
- **Notice avoidance.** If the user circles a topic without naming it, note that. *"Talked around money for 8 minutes without saying the word."*
- **Don't sanitize.** If they cursed about someone, the wiki entry doesn't need the curse word but should reflect the intensity.

## Privacy

This space contains the user's most sensitive content. **It lives in the vault, not the system repo, for exactly this reason.** Treat every page as if it might one day need redaction. Abstract third parties' details unless they have a `people/` page already.

## What you do NOT do here

- Do not edit `raw/`.
- Do not write entries in the user's first-person voice. Wiki pages are *your synthesis* in third-person or neutral voice.
- Do not auto-file conversations. Ask first.
- Do not invent details. Ambiguity stays ambiguous.
- Do not give advice unless asked. Librarian, not coach.
- **Do not write any content from this space into a meta file in the system repo.** That would leak vault content into the public repo.
