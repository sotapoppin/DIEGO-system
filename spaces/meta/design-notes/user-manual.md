# Diego — user manual

**Audience:** the user (Sota), to read top-to-bottom when reconsidering workflow.
**Status:** living reference. If a step here doesn't match what Diego actually does, that's a friction worth logging.

This manual describes the *current* shape of the system. It is not the schema — the schema is the `CLAUDE.md` files. If they disagree, the schema wins, and this file is wrong and should be updated.

---

## 1. What Diego is

Diego is a single assistant with one identity that operates across a few **spaces**, each with its own conventions. The user works inside a vault (private content) that symlinks to a system repo (schema and meta, public-safe). Everything is just markdown files. There is no database, no background process, no scheduler beyond "Diego notices when you show up."

The intent: a low-ceremony way to capture life and research, accrete a personal wiki over time, and keep the system itself improvable without losing the history of why it works the way it does.

---

## 2. The two physical locations

```
~/DIEGO/
  diego-system/    ← schema + meta. In git. May be public.
  diego-vault/     ← all real content. Never in git. Local only.
```

The vault is the working directory. It contains symlinks back to the system repo for the schema files, so from inside the vault everything looks like one tree.

**The split is load-bearing.** Anything written under `diego-system/` may end up on GitHub. Anything written under `diego-vault/` stays on disk. If a single piece of personal content slips into a system file and gets committed, removing it requires a force-push that rewrites history.

What goes where:

| Lives in `diego-system/` (public-safe) | Lives in `diego-vault/` (private) |
|---|---|
| All `CLAUDE.md` files | All `raw/` content (voice memos, notes, clips) |
| `spaces/meta/` (changelog, friction-log, proposals, design-notes, patterns) | All `wiki/` content |
| `README.md`, `install.sh`, vault template | Real `index.md` files per space |
| (this manual) | Real `log.md` files per space and at vault root |

---

## 3. The three spaces

Each space has its own `CLAUDE.md` in the system repo describing its operational details. Identity is constant across spaces.

### 3.1 `spaces/life/` — personal life

Subject: the user.

Vault layout:
```
spaces/life/
  raw/{voice,notes,clips,assets}/
  wiki/{about,people,projects,themes,goals,health,journal,decisions,practices}/
  lint-reports/
  index.md  log.md  CLAUDE.md
```

Page types: `about` (one self-anchor), `person`, `project`, `theme`, `goal`, `health`, `journal`, `decision`, `practice`.

The journal has a `## Sessions` block at the bottom for scannable per-session entries; the narrative above it is for human reading and theme detection.

### 3.2 `spaces/work/` — research, learning, the world

Subject: external knowledge. Whatever domain the user is going deep on.

Vault layout:
```
spaces/work/
  raw/{voice,notes,papers,clips,transcripts,assets}/
  wiki/{concepts,entities,sources,questions,syntheses,comparisons,glossary}/
  index.md  log.md  CLAUDE.md
```

Every ingested source gets a `sources/` page. Web search is fair game here, but always with a sources-page trail.

### 3.3 `spaces/meta/` — Diego itself

Subject: the system. **Lives in the system repo, may be public.** No vault content allowed in meta files; abstract third parties, redact specifics.

Layout:
```
spaces/meta/
  CLAUDE.md
  changelog.md         ← every approved schema change, dated
  friction-log.md      ← lightweight log of things that felt off
  proposals/           ← active and applied proposals
  design-notes/        ← longer essays on why Diego works a certain way
  patterns/            ← frictions that have happened 3+ times
```

---

## 4. The router

Every request gets routed to a space. Often the user doesn't name one. Diego infers.

Rough rules:
- Anyone in your actual life, your moods/sleep/health, your goals, your decisions, journal-style reflection → **life**.
- Papers, articles, concepts, methods, authors-as-thinkers, comparisons, syntheses → **work**.
- "That felt off," "this keeps happening," questions about Diego's behavior or schema → **meta**.

When ambiguous, Diego asks one short question (e.g. "filing this under life or work?"). Routine routing is silent; cross-space and corrected routing get a top-level `log.md` entry or a meta friction respectively.

---

## 5. Voice and text — two channels

A response can carry both:

- A `<speak>...</speak>` block — one or two short sentences, conversational, no markdown. Stripped before render and read aloud by a TTS hook.
- The text response — structured detail, paths, lists, code.

The speak block is a *headline*, not a recap. Skipped for tool-only turns, simple confirmations, and turns where there's nothing the text wouldn't carry better.

In-turn narration (mid-tool spoken updates) goes through `say -r 180 "..." & disown` Bash calls, not tags — the TTS hook can't see intra-turn tags.

---

## 6. The five skills (slash commands you can type)

These are your verbs for driving Diego.

### `/ingest`
Enters batched-ingest mode. You start dumping context — voice memos, notes, half-formed thoughts, things you want to file. Diego asks broad clarifying questions inline (1–2 per topic, breadth over depth) but does **not** edit the wiki on each turn. Context accumulates in the conversation. Use this when you have multiple things to add and don't want per-fact ceremony.

### `/update`
Exits batched-ingest mode by synthesizing everything accumulated into actual wiki edits, journal entries, index updates, and a `log.md` entry. One commit-worth of vault changes from the whole batch. Triggered by "update," "commit," "update the wiki," or saying you're done.

### `/wrap`
Ends the current working session by appending a structured `### <slot> — <slug>` entry to the `## Sessions` block of today's life journal. Captures discussed / decisions / in-flight / files touched. Use at end of session to make next-session-Diego able to load context fast.

### `/commit`
Stages and commits pending changes in `diego-system` using Diego-native prefixes: `schema:`, `meta:`, `space:`, `repo:`, `docs:`. Drafts the message from the diff and confirms before committing. Only operates on the system repo — vault is never committed.

### `/push`
Pushes the current `diego-system` branch to origin. Sets upstream tracking on first push of a new branch.

---

## 7. Operations per space

Skills are user-invoked. Operations are the work Diego does inside a space. Some operations have skills attached; others are triggered by phrases or context.

### Life space
- **Ingest** — point at files in `raw/`. Diego briefs back, asks a clarifying question or two, edits wiki, updates journal + index + log. New top-level pages are conservative (3+ mentions for a `person`, pattern across 3+ sources for a `theme`).
- **Query** — just ask. Diego reads `index.md`, finds candidates, answers conversationally with citations. If the answer reveals a synthesis worth filing, Diego asks; doesn't auto-file.
- **Reflect** — "what are you seeing," "what's the pattern." Reads recent journal + log + most-touched pages, surfaces 3–5 honest observations.
- **Lint** — "lint" / "health check" or session-start nudge. Looks for orphans, stale entries, contradictions, promotable concepts, frontmatter issues. Produces a chat summary *and* a dated report file at `lint-reports/YYYY-MM-DD-lint.md`. Reports; doesn't fix without permission. Status flow: `open → reviewed → actioned | dismissed`.

**Session-start lint nudge:** the first time a session routes to or works in life space, Diego checks `lint-reports/`. If empty or most recent is >14 days old, it surfaces one sentence offering a lint pass. Defer once and Diego drops it for the rest of the session.

### Work space
- **Ingest** — "ingest this paper / article / memo." Diego briefs back, creates a `sources/` page (always), updates relevant `concepts/`, `entities/`, `questions/`, and any `syntheses/` the source bears on with a dated revision-trail entry.
- **Query** — same shape as life. Reads `index.md` and `syntheses/` for thesis-level questions.
- **Lint** — orphans, stale stubs, missing source pages, syntheses avoiding revision despite on-topic ingests, frontmatter issues.
- **Web search** — fair game; always paired with a `sources/` page.

### Meta space — the four operations
- **`friction`** — one-line log entry to `friction-log.md`. No fix, no analysis. Apply public-meta discipline (abstract specifics). If this is the third instance of similar friction, Diego asks whether to graduate it to a pattern.
- **`propose` / `tune`** — full meta loop. Diagnose → trace cause (rule wrong / rule missing / judgment call) → write a proposal in `proposals/` → discuss/refine → on approval, apply the schema edit, rename proposal `*-APPLIED.md`, append to `changelog.md`, suggest a `schema:` commit.
- **`pattern`** — graduate a recurring friction to `patterns/<slug>.md`. Diagnostic shape, references to friction-log entries, strict public-meta discipline.
- **`reflect`** — read recent changelog + frictions + active proposals, surface what's been changing, what's stalled, what patterns may be forming.

---

## 8. The end-to-end loops

### Capture loop (life)
1. You drop a voice memo / note into `raw/` (often via Obsidian).
2. Type `/ingest` and start talking through what you want filed (or point at the file).
3. Diego accumulates context, asks 1–2 broad questions per topic.
4. When done, type `/update`. Diego synthesizes: wiki edits, journal entry, index + log updates.
5. Optionally `/wrap` at session end to append a Sessions block.

### Research loop (work)
1. Drop a paper / article / clip into `raw/`.
2. "Ingest this." Diego briefs back; asks if anything is ambiguous about how to file.
3. On go-ahead: creates a `sources/` page; updates concepts, entities, questions, syntheses (with revision trail).
4. Updates `index.md` and `log.md`.

### Improvement loop (meta)
1. Something feels off. You say so, or say "log a friction."
2. Diego writes a one-line friction-log entry (abstracted).
3. If you want a real change: "let's tune that" → propose → discuss → approve → apply → changelog.
4. `/commit` (prefix: usually `schema:`, sometimes `meta:` for proposal-only commits).
5. `/push` when ready.

---

## 9. Commit conventions (system repo only)

Diego-native prefixes, not Conventional Commits:

| Prefix | When |
|---|---|
| `schema:` | Edits to any `CLAUDE.md` (root, space-level, meta-level). The rules changed. |
| `meta:` | Meta-space artifacts only — proposals, design-notes, friction-log lines, changelog entries — without an accompanying schema edit. |
| `space:` | Edits to non-`CLAUDE.md` space files (rare; most space content lives in vault). |
| `repo:` | Filesystem layout, install scripts, `.gitignore`, structural moves. |
| `docs:` | Top-level README, public-facing docs. |

When a commit contains both a schema edit and supporting meta artifacts (typical applied meta loop), use `schema:` — that's the headline.

The vault is never committed. There is no `vault:` prefix because there is no vault git.

---

## 10. Versioning

Simple integers. `1.0` was declared on 2026-04-28 with the speak-mode merge. Minor bumps (`1.0` → `1.1`) for additive schema changes; major bumps (`1.x` → `2.0`) for identity changes or breaking architectural shifts. The user calls the bump on milestone moments. Changelog entries between bumps accumulate under the current open `## vX.Y` header.

---

## 11. Tone and behavioral defaults

Set in the root `CLAUDE.md`. Summarized:

- **Anticipatory librarian, not coach.** Surface adjacent things, don't direct.
- **Honest, including when it's uncomfortable.** Pushback is part of being useful.
- **Direct, dry, plainspoken.** No preamble, no hedging, no "great question."
- **First-name basis.** "Sota," not "the user," in conversation.
- **Conservative about adding to the system.** Wiki pages, themes, syntheses are earned.
- **Careful with your own words.** Preserve trajectory and affect, not exact wording.
- **Curious about the system.** Flag friction.

Behavioral defaults learned over time (lives in auto-memory, not the schema):
- Make assumptions, don't ask permission for routine choices.
- In batched ingest: breadth over depth, fewer tiny questions.
- Don't read too deep into coincidences or trajectories as patterns.
- Tone stays warm; flagging the same concern again is fine, not preachy.

---

## 12. Linting and the session-start check

The lightest scheduling mechanism Diego has. No cron, no daemon. The "schedule" is: when you next show up and start working in life space, Diego checks `lint-reports/` and offers a lint pass if it's been >14 days. You can defer; it'll drop the nudge for the session. The threshold is the current default and tunable via meta loop.

Lint reports are durable artifacts (`lint-reports/YYYY-MM-DD-lint.md`) with status `open → reviewed → actioned | dismissed`. The chat summary is for in-the-moment review; the file is the record.

---

## 13. What Diego will not do

- Write personal content into a system file. (Highest-stakes rule.)
- Edit `raw/` — it's immutable source.
- Auto-file a conversation. Always asks first.
- Write wiki entries in your first-person voice. Synthesis is third-person/neutral.
- Invent details or citations. Ambiguity stays ambiguous.
- Give advice unless asked.
- Edit the root `CLAUDE.md` (identity / routing) without explicit approval.
- Propose schema changes you didn't ask for. Logs frictions unprompted; doesn't write proposals unprompted.
- Re-litigate applied schema decisions.

---

## 14. Where this manual doesn't match reality

If anything here is wrong or out of date, log it as a friction and we fix this file in the same loop as the schema. Likely candidates for friction (places the workflow is currently fuzzy or overlapping):

- The boundary between `/ingest` (batched) and one-shot ingest (point at a file, file it now). Both work; the trigger isn't always clean.
- `/wrap` writes only to life-space journals. If a session was mostly work or meta, the Sessions block doesn't have a natural home.
- The session-start lint nudge fires for life only. Work-space lint has no equivalent prompt.
- This manual's location in `design-notes/` is a placeholder. It's reference, not an essay on rationale, and may want its own top-level slot in the meta directory.
- "Operation" vs "skill" vs "trigger phrase" terminology overlaps. Not all operations have skills; some skills span operations.

These are honest seams, not bugs to silently route around. They're the candidates for the next round of meta-loop work.
