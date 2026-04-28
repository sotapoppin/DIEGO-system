# Diego Changelog

Every approved schema change to Diego, dated, with rationale and grouped under a version. The full proposal lives in `proposals/`; this file is the chronological index.

Format:
```
## vX.Y — YYYY-MM-DD — <theme>

(one-line description of what this version represents)

### [YYYY-MM-DD] <short title>
**File:** <path> · **Proposal:** [[proposals/...]]
What changed. Why. What to watch for.
```

Versions are simple integers (`1.0`, `1.1`, `2.0`). Minor bumps for additive schema changes, major bumps for identity or breaking architectural shifts. New entries are prepended above older ones inside the current version section.

---

## v1.0 — 2026-04-28 — first milestone

Initial bootstrap plus the 2026-04-27 schema iterations (about page, commit prefixes, lint nudge, friendly-mode, YAML fix, sessions block, canonical skills + `/wrap`) plus the 2026-04-28 speak-mode dual-output convention. The accumulated state at which the system was first declared coherent enough to version.

### [2026-04-28] add speak-mode dual-output convention
**File:** CLAUDE.md, .claude/settings.json (per install), .claude/hooks/voice-speak.sh (per install) · **Proposal:** [[proposals/2026-04-28-voice-mode-dual-output]]

Added a `## Voice and text output` section to the root `CLAUDE.md` defining a two-channel output convention: a `<speak>...</speak>` block leads when there's something worth saying aloud (consumed by a TTS Stop hook and stripped from the spoken pipeline), and the rest of the response is text-only with structured detail. A vault-side Stop hook in `.claude/settings.json` extracts the block, kills any in-flight `say` process, and pipes the contents to macOS `say` in the background. Why: three friction entries from 2026-04-27 (token-cost worry, TTS desire, dual-mode need) were three faces of the same dual-channel problem — separating *what's heard* from *what's read* resolves all three at once. What to watch for: token-cost inflation from the extra `<speak>` blocks (the original concern); the block being visible in chat (Claude Code renders before Stop fires, so the markup stays on screen until a render-time strip mechanism exists); macOS-only as written (no Linux fallback yet).

### [2026-04-27] relocate skills to system repo + add `/wrap`
**File:** skills/, install.sh · **Proposal:** [[proposals/2026-04-27-canonical-skills-and-wrap-APPLIED]]

Created top-level `DIEGO-system/skills/` directory with three canonical skills (`commit`, `push`, `wrap`) and modified `install.sh` to symlink `vault/.claude/skills` → `system/skills` so updates propagate to all installs (mirroring the meta-space symlink pattern). New `/wrap` skill triggers the just-applied `## Sessions` journal convention — synthesizes the current session into a structured `### <slot> — <slug>` entry and appends it under today's `## Sessions` block. Skills now use path-portable system-repo detection (via the `CLAUDE.md` symlink) instead of hardcoded user paths. Why: skill improvements should propagate centrally rather than fork per-install, the Sessions convention needed an actual trigger, and hardcoded user paths broke portability. What to watch for: per-install customization need (no override pattern yet), and any Claude Code change that affects how it follows symlinks during skill discovery.

### [2026-04-27] add `## Sessions` block to life-space journal entries
**File:** spaces/life/CLAUDE.md · **Proposal:** [[proposals/2026-04-27-journal-sessions-block-APPLIED]]

Added a convention requiring every day's `journal/YYYY-MM-DD.md` to end with a `## Sessions` block of structured per-session summaries (`### <slot> — <slug>` with Discussed / Decisions / In-flight / Files touched lines). The reflective narrative at the top of the entry stays as-is; the Sessions block is the scannable record next-session-Diego reads first to load context. Why: conversations had with the assistant had no structured home — the journal captured the day thematically and `log.md` listed operations terse-style, but there was no per-session record of what was discussed, decided, in flight, or touched. What to watch for: journals growing too long on high-activity days (the page-bloat archive convention, separately friction-logged, is the eventual mitigation), and drift back toward putting session summaries inside the narrative rather than the structured block.

### [2026-04-27] fix invalid YAML in life-space frontmatter example
**File:** spaces/life/CLAUDE.md · **Proposal:** [[proposals/2026-04-27-frontmatter-yaml-fix-APPLIED]]

Converted the frontmatter example for `sources` and `related` from comma-separated bare wikilinks (which Obsidian's properties feature parses as malformed) to proper YAML block lists with double-quoted wikilink strings. Added a one-sentence note explaining why the previous form failed. Why: every page produced by following the example had invalid frontmatter — caught after 14 vault pages had been written with the broken pattern. What to watch for: any future schema example introducing inline `[[...]]` syntax in YAML — same trap.

### [2026-04-27] friendly-mode identity tuning
**File:** CLAUDE.md · **Proposal:** [[proposals/2026-04-27-friendly-mode-APPLIED]]

Modified the root identity section to a warmer, more anticipatory register: librarian becomes *anticipatory* librarian (surfaces adjacent context unprompted, holds the line at "surface, don't direct"); direct gets a *dry edge* (wit when it serves clarity); honest is reinforced to make pushback non-negotiable ("friendliness is not agreement"); new bullets added for first-name familiarity (read from memory; schema stays impersonal) and consistent voice. Tested on branch `friendly-mode` for one session before merging via `--no-ff` to preserve the test arc in history. Why: the prior identity covered what to *avoid* (sycophancy, throat-clearing, coaching) but didn't articulate a positive register, defaulting to flat. What to watch for: anticipation drifting into coaching — if Diego starts inferring what the user *should* do rather than just what's relevant, the "surface, don't direct" guardrail needs tightening; also watch for token-cost inflation from the warmer register (logged as friction) and any erosion of pushback under social pressure to agree.

### [2026-04-27] add session-start lint nudge for the life space
**File:** spaces/life/CLAUDE.md · **Proposal:** [[proposals/2026-04-27-session-start-lint-nudge-APPLIED]]

Added a `lint-reports/` directory to the life space, a report file template (`type: lint-report`) with a status field, and a new `## Session-start check` section that fires when the user first routes to life and the most recent lint is >14 days old (or doesn't exist). Why: the existing `lint` operation only ran when the user explicitly asked, so wiki drift went uncaught. What to watch for: false-positive nudges if 14 days is too aggressive, missed drift if it's too lax. The cadence threshold is intentionally tunable.

### [2026-04-27] adopt Diego-native commit prefixes
**File:** spaces/meta/CLAUDE.md · **Proposal:** [[proposals/2026-04-27-commit-prefixes-APPLIED]]

Replaced Conventional Commits vocabulary (`feat:`, `chore:`) with Diego-native prefixes that map to meta operations: `schema:`, `meta:`, `space:`, `repo:`, `docs:`. Why: `chore:` framed structural work as filler, and the Conventional Commits vocabulary doesn't fit a system that doesn't ship features. What to watch for: drift back to generic vocabulary on small commits, and ambiguity when a commit straddles two prefix categories — the rule is to prefer `schema:` when any schema edit is included.

### [2026-04-27] add `about` page type for life-space self-anchor
**File:** spaces/life/CLAUDE.md · **Proposal:** [[proposals/2026-04-27-self-anchor-APPLIED]]

Added `about` as a new page type, an `about.md` entry at the top of the wiki/ tree, and a page template describing the self-anchor. Why: the existing `person` template assumes asymmetric relational scaffolding that doesn't fit the user themselves, who is the *subject* of the entire life space. What to watch for: overlap between the `about` anchor and `journal/` entries on identity-touching reflections — the convention is `about` = stable identity facts and long arcs, `journal` = dated reflections.

### [2026-04-27] initial schema (bootstrap)
**File:** root + spaces/* · **Proposal:** none (initial design)

Created Diego as a system/vault split: schema and meta content in the version-controlled system repo, personal data in a local-only vault. Three spaces (life, work, meta) with a top-level router. Identity in root `CLAUDE.md`; operational schemas per-space. What to watch for: routing failures (Diego picks the wrong space), meta-loop friction (proposal cycle too heavy or too light), and — most critically — any leakage of vault content into system files. The last would be a serious failure of the public-meta discipline rule.
