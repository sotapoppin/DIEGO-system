# Diego — usage

**Audience:** you, after running `install.sh`. You have a vault, you have Claude Code, you're not sure what to type.

This is the practical manual for driving Diego day-to-day. For the *why* behind any given convention, read `spaces/meta/design-notes/`. For the rules Diego operates by, read the `CLAUDE.md` files — those are authoritative. If anything here disagrees with a `CLAUDE.md`, the `CLAUDE.md` wins.

---

## 1. Before your first session

You should already have:

- The system repo cloned somewhere stable (e.g. `~/diego-system`).
- A vault created by `./install.sh` (e.g. `~/diego-vault`).
- Claude Code installed and working.
- Optional: Obsidian, with the vault opened as a vault. Graph view and wikilink navigation are how Diego is meant to be browsed.

**Mental model in one paragraph:** Diego is one assistant with one identity that operates across **spaces** (life, work, meta). The vault holds your real content (markdown files, organized by space). The system repo holds the rules (`CLAUDE.md` files) and the meta history. Symlinks unify them at runtime. There is no daemon, no scheduler, no database — just files, an LLM, and a few conventions for keeping them coherent.

---

## 2. First session

From inside the vault:

```bash
cd ~/diego-vault
claude
```

Your first message should be:

> read CLAUDE.md and tell me what you understand

This forces Diego to load the full schema before doing anything else. If something looks off in the readback, fix it now — drift here compounds.

Once Diego is oriented, introduce yourself. Tell it your name, your situation, what you want it to help with. This gets stored in auto-memory and shapes future sessions. You don't need to be exhaustive — Diego learns over time.

You do **not** need to manually create any of the wiki directories (`people/`, `projects/`, etc.). They get created on demand the first time something belongs in them.

---

## 3. The three spaces

Each has its own `CLAUDE.md` in `spaces/<name>/`. Read them when you have ten minutes. Short version:

- **`life/`** — your personal life. Voice memos, journal, people you know, projects you're running, goals, decisions, themes. The subject is *you*.
- **`work/`** — research, learning, the world. Papers, articles, concepts, sources, syntheses on whatever you're going deep on. The subject is *external knowledge*.
- **`meta/`** — Diego itself. Schema changes, friction reports, design rationale, changelog. The subject is *the system*. Lives in the system repo and may be public — don't put personal content here.

Every request you make gets routed to a space. Usually Diego infers; when ambiguous, it asks one short question.

---

## 4. The skills (slash commands)

These are the verbs you'll use most. Type them with a leading slash.

| Command | What it does |
|---|---|
| `/ingest` | Enters batched-ingest mode. You dump context across multiple turns; Diego accumulates without per-fact filing. |
| `/update` | Exits batched-ingest mode by synthesizing everything into actual wiki edits, journal updates, index + log entries. |
| `/wrap` | Appends a structured session entry to today's life journal: discussed, decisions, in-flight, files touched. |
| `/commit` | Stages and commits pending changes in the system repo. Drafts the message from the diff. **System repo only — your vault is never committed.** |
| `/push` | Pushes the current system-repo branch to origin. |

`/ingest` and `/update` are the workhorses for capture. `/wrap` is end-of-session. `/commit` and `/push` only matter when you've changed the schema or meta — pure vault edits don't touch git.

---

## 5. The two channels — voice and text

Diego can respond on two channels in the same turn:

- A `<speak>...</speak>` block — short, conversational, read aloud by a TTS hook (and stripped from the rendered output).
- The text response — everything else: structure, paths, lists, code.

You don't need to do anything to enable this — it's wired in by default. If you don't want TTS, disable or remove the hook. If you want to customize the voice/rate, that's in the hook config, not in Diego's schema.

The spoken line is meant to be a headline, not a recap. Diego skips it for tool-only turns and simple confirmations.

---

## 6. Your first capture loop (life space)

A realistic first day:

1. **Drop something into `raw/`.** Could be a voice memo transcript in `spaces/life/raw/voice/`, a note in `notes/`, a clipped article in `clips/`. Filenames are conventionally `YYYY-MM-DD-HHMM-slug.md` for voice; otherwise just descriptive.

2. **Type `/ingest`.** Diego enters batched mode. Start talking through what's in the file, or what's on your mind. Diego will ask 1–2 broad clarifying questions per topic — answer them or wave them off, it'll move on.

3. **Type `/update` when you're done.** Diego synthesizes the whole batch in one pass: creates or updates `wiki/people/`, `wiki/projects/`, `wiki/themes/`, etc. as appropriate; appends a journal entry if today's doesn't exist yet; updates `index.md` for any new pages; appends a single line to `spaces/life/log.md`.

4. **Browse the result in Obsidian.** Graph view shows the new edges. The wikilinks in the pages let you navigate the connections.

5. **Optional: `/wrap` at end of session.** Adds a scannable session entry under today's journal `## Sessions` block, so the next session can load context fast.

That's the loop. Most days, that's all you do.

---

## 7. Querying

Just ask:

```
what was I thinking about Project X last week
who is person Y
what are my active projects
how does this paper connect to anything I've already filed
```

Diego reads `index.md` first, picks candidate pages, and answers conversationally with citations. If the answer surfaces a synthesis worth saving, Diego will *ask* — it doesn't auto-file from a query.

---

## 8. Linting and the session-start nudge

Diego's lightest form of scheduling: when you start a session and route to life space, it checks `lint-reports/`. If empty or the most recent report is older than 14 days, you'll get a one-sentence offer to run a lint pass. Defer once and it drops the nudge for the rest of the session.

A lint pass looks for orphan pages, stale entries (90+ days untouched), contradictions across pages, concepts mentioned multiple times without their own page, and frontmatter inconsistencies. It produces both a chat summary and a dated report file at `lint-reports/YYYY-MM-DD-lint.md`.

Lint **reports**; it doesn't fix without permission. Status flows `open → reviewed → actioned | dismissed`.

You can trigger one anytime with `lint` or `health check`.

---

## 9. The meta loop — improving Diego

The most interesting part. Diego is supposed to drift to fit you. There are two flavors of friction:

**Casual friction** — "log a friction":
> Hey, that response felt overlong. Log a friction.

Diego writes one abstracted line in `spaces/meta/friction-log.md`. No diagnosis, no fix. Most things go here.

**Real change** — "let's tune that":
> The session-start lint nudge is too aggressive. Let's tune it.

Diego enters the full meta loop: diagnose → trace cause → write a proposal in `spaces/meta/proposals/` → discuss → on approval, edit the schema, rename the proposal `*-APPLIED.md`, append to `changelog.md`. You then `/commit` (usually with `schema:` prefix) and `/push`.

A friction that recurs 3+ times can graduate to a `patterns/<slug>.md` entry, which makes the recurrence visible and often prompts a proposal.

This is what makes the system repo's git log interesting: it's a biography of the assistant — every schema change, when, why, what proposal it came from.

---

## 10. Public-meta discipline

`spaces/meta/` lives in the **system repo**, which may be public. Anything in there gets written as if a stranger will read it.

- No real names. Abstract third parties.
- No specific project names from your vault.
- No quoted user content.
- Diagnose the *behavior of the system*, not your content. If you can't describe a friction without naming specifics, it doesn't belong in meta — it belongs in the vault's `log.md`.

`spaces/meta/CLAUDE.md` enforces this. If Diego ever drafts a meta entry that quotes your content, push back — it's a leak.

---

## 11. Commit conventions (system repo only)

Diego uses its own commit prefixes, not Conventional Commits:

| Prefix | When |
|---|---|
| `schema:` | Edits to any `CLAUDE.md`. The rules changed. |
| `meta:` | Meta-space artifacts (proposals, design-notes, friction-log, changelog) without an accompanying schema edit. |
| `space:` | Edits to non-`CLAUDE.md` space files (rare). |
| `repo:` | Filesystem layout, install scripts, `.gitignore`. |
| `docs:` | Top-level README, public-facing docs. |

When a commit contains both a schema edit and supporting meta artifacts (typical applied meta loop), `schema:` wins — that's the headline.

Your vault is never committed. There is no `vault:` prefix because there is no vault git.

---

## 12. Versioning

Simple integers. The repo ships at `1.0`. Minor bumps (`1.0` → `1.1`) for additive schema changes; major bumps (`1.x` → `2.0`) for identity changes or breaking architectural shifts. You call the bump on milestone moments. Changelog entries accumulate under the current open `## vX.Y` header.

---

## 13. What Diego will not do

By design:

- Write personal content into a system file. (Highest-stakes rule.)
- Edit `raw/` — it's immutable source material.
- Auto-file a conversation. It always asks first.
- Write wiki entries in your first-person voice. Synthesis is third-person/neutral.
- Invent details or citations. Ambiguity stays ambiguous.
- Give advice unless asked. It's a librarian, not a coach.
- Edit the root `CLAUDE.md` without explicit approval.
- Propose schema changes you didn't ask for. (Will log frictions unprompted; won't write proposals.)
- Re-litigate applied schema decisions.

If you catch Diego doing any of these, that's a friction worth logging.

---

## 14. Forking and divergence

You're welcome to fork the system repo. If you do:

1. Clone your fork.
2. Run `./install.sh` against a vault path you own.
3. Start using it. Your schema will drift over time as you encounter friction the upstream user didn't.
4. If you build improvements you'd like to share back, open a PR with **schema changes only** — no vault content, please.

Your fork and the upstream are both right *for their respective users*. Diego is meant to fit. Don't try to keep your fork in lock-step with upstream unless the upstream changes are clearly improvements that apply to you.

---

## 15. Things that are intentionally fuzzy

Some seams in the system that you'll bump into:

- The boundary between `/ingest` (batched) and one-shot ingest (point at a file, file it now). Both work; the trigger isn't always clean.
- `/wrap` writes only to life-space journals. If a session was mostly work or meta, the Sessions block doesn't have a natural home.
- The session-start lint nudge fires for life only. Work space has no equivalent prompt.
- "Operation" vs "skill" vs "trigger phrase" terminology overlaps. Not all operations have skills; some skills span operations.

These are honest seams, not bugs to route around. They're candidates for the next round of meta-loop work — yours, if you want them.

---

## 16. Where to look when something feels off

| Symptom | Where to look |
|---|---|
| Diego ignored a rule you thought it knew | The relevant `CLAUDE.md`. If the rule isn't there, it's not a rule. |
| Diego routed to the wrong space | Root `CLAUDE.md` § "The router." Correct it; the correction becomes a friction. |
| A skill behaved unexpectedly | `~/.claude/skills/<name>/SKILL.md` or `.claude/skills/<name>/` inside the vault. |
| TTS isn't speaking | Check the hook in `~/.claude/settings.json` and look for a recent `tts-silent-failure` friction. |
| A page lints "orphan" but you know it's used | Check the wikilink syntax. Obsidian's frontmatter parser is strict about `[[...]]` in list fields. |
| Commit prefix unclear | This file § 11, or `spaces/meta/CLAUDE.md`. |
| You want a rule changed | "Let's tune that" → meta loop. |

If none of those help, log a friction and move on. The system improves through accumulated friction; one mystery is a data point, not a blocker.
