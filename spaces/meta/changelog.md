# Diego Changelog

Every approved schema change to Diego, dated, with rationale. The full proposal lives in `proposals/`; this file is the chronological index.

Format:
```
## [YYYY-MM-DD] <short title>
**File:** <path> · **Proposal:** [[proposals/...]]
What changed. Why. What to watch for.
```

---

## [2026-04-27] fix invalid YAML in life-space frontmatter example
**File:** spaces/life/CLAUDE.md · **Proposal:** [[proposals/2026-04-27-frontmatter-yaml-fix-APPLIED]]

Converted the frontmatter example for `sources` and `related` from comma-separated bare wikilinks (which Obsidian's properties feature parses as malformed) to proper YAML block lists with double-quoted wikilink strings. Added a one-sentence note explaining why the previous form failed. Why: every page produced by following the example had invalid frontmatter — caught after 14 vault pages had been written with the broken pattern. What to watch for: any future schema example introducing inline `[[...]]` syntax in YAML — same trap.

## [2026-04-27] friendly-mode identity tuning
**File:** CLAUDE.md · **Proposal:** [[proposals/2026-04-27-friendly-mode-APPLIED]]

Modified the root identity section to a warmer, more anticipatory register: librarian becomes *anticipatory* librarian (surfaces adjacent context unprompted, holds the line at "surface, don't direct"); direct gets a *dry edge* (wit when it serves clarity); honest is reinforced to make pushback non-negotiable ("friendliness is not agreement"); new bullets added for first-name familiarity (read from memory; schema stays impersonal) and consistent voice. Tested on branch `friendly-mode` for one session before merging via `--no-ff` to preserve the test arc in history. Why: the prior identity covered what to *avoid* (sycophancy, throat-clearing, coaching) but didn't articulate a positive register, defaulting to flat. What to watch for: anticipation drifting into coaching — if Diego starts inferring what the user *should* do rather than just what's relevant, the "surface, don't direct" guardrail needs tightening; also watch for token-cost inflation from the warmer register (logged as friction) and any erosion of pushback under social pressure to agree.

## [2026-04-27] add session-start lint nudge for the life space
**File:** spaces/life/CLAUDE.md · **Proposal:** [[proposals/2026-04-27-session-start-lint-nudge-APPLIED]]

Added a `lint-reports/` directory to the life space, a report file template (`type: lint-report`) with a status field, and a new `## Session-start check` section that fires when the user first routes to life and the most recent lint is >14 days old (or doesn't exist). Why: the existing `lint` operation only ran when the user explicitly asked, so wiki drift went uncaught. What to watch for: false-positive nudges if 14 days is too aggressive, missed drift if it's too lax. The cadence threshold is intentionally tunable.

## [2026-04-27] adopt Diego-native commit prefixes
**File:** spaces/meta/CLAUDE.md · **Proposal:** [[proposals/2026-04-27-commit-prefixes-APPLIED]]

Replaced Conventional Commits vocabulary (`feat:`, `chore:`) with Diego-native prefixes that map to meta operations: `schema:`, `meta:`, `space:`, `repo:`, `docs:`. Why: `chore:` framed structural work as filler, and the Conventional Commits vocabulary doesn't fit a system that doesn't ship features. What to watch for: drift back to generic vocabulary on small commits, and ambiguity when a commit straddles two prefix categories — the rule is to prefer `schema:` when any schema edit is included.

## [2026-04-27] add `about` page type for life-space self-anchor
**File:** spaces/life/CLAUDE.md · **Proposal:** [[proposals/2026-04-27-self-anchor-APPLIED]]

Added `about` as a new page type, an `about.md` entry at the top of the wiki/ tree, and a page template describing the self-anchor. Why: the existing `person` template assumes asymmetric relational scaffolding that doesn't fit the user themselves, who is the *subject* of the entire life space. What to watch for: overlap between the `about` anchor and `journal/` entries on identity-touching reflections — the convention is `about` = stable identity facts and long arcs, `journal` = dated reflections.

## [2026-04-27] initial schema (v0.1)
**File:** root + spaces/* · **Proposal:** none (initial design)

Created Diego as a system/vault split: schema and meta content in the version-controlled system repo, personal data in a local-only vault. Three spaces (life, work, meta) with a top-level router. Identity in root `CLAUDE.md`; operational schemas per-space.

What to watch for: routing failures (Diego picks the wrong space), meta-loop friction (proposal cycle too heavy or too light), and — most critically — any leakage of vault content into system files. The last would be a serious failure of the public-meta discipline rule.
