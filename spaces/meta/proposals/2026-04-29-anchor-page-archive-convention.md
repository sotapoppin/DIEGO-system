---
type: proposal
status: open
created: 2026-04-29
applied: null
file: spaces/life/CLAUDE.md (and parallel rule in spaces/work/CLAUDE.md if/when work-space anchors emerge)
---

# Anchor-page archive convention

## The friction

Canonical anchor pages — the self-anchor in life, project pages, theme pages, and (eventually) work-space hub pages — accumulate content monotonically. Every ingest layers more onto them. There's no convention for when a page is "too big" or how to relocate stale material without losing it. Left alone for a year, the self-anchor becomes a 4000-line wall that nobody (Diego or user) can scan in a session-start lint.

The friction was logged 2026-04-27 alongside an external-write-up reference: a line-count threshold that triggers archival, with a protected-section list so designated core sections never get moved.

## The diagnosis

**Schema rule missing.** The life-space schema specifies how to *grow* anchor pages but not how to *shed*. The implicit rule today is "keep adding," which is fine for months and breaks for years. Without a rule, future-Diego will either let pages bloat or improvise an archive scheme that varies per page.

## Current text

> (no current rule — anchor-page size and archive behavior are unspecified in `spaces/life/CLAUDE.md`)

## Proposed text

Add a new subsection under `## Page conventions` in `spaces/life/CLAUDE.md`:

```markdown
### Anchor-page size and archive

Anchor pages (`about.md`, individual `projects/`, `themes/`, and `goals/` pages) accumulate content over time. To keep them scannable, each anchor page has a soft size budget and an archive convention.

- **Soft threshold:** ~400 lines. When an anchor page exceeds this, surface it during the next lint pass (do not auto-archive in-session).
- **Sibling archive page:** when archival is approved, move stale sections to `<page-stem>-archive.md` in the same directory (`about-archive.md`, `projects/foo-archive.md`). Cross-link both directions: a `## Archive` section in the live page pointing to the archive, and a header in the archive pointing back.
- **Protected sections:** every anchor page declares an opening `<!-- protected -->` to `<!-- /protected -->` region. Content inside is never moved, regardless of age. Use for identity facts, the project's core definition, the theme's working definition.
- **What gets archived:** dated entries (history-of-thinking blocks) older than ~12 months, resolved decisions, dormant subprojects, threads the user has stopped mentioning. Reflective narrative is preferred over deletion — don't lose context, relocate it.
- **Trigger:** lint surfaces oversize pages as a finding under a new `## Oversize anchors` section. The user decides whether to archive; archive is a deliberate act, not automatic.

The 400-line threshold is the current default; tune via meta loop if it proves too aggressive (every page nags) or too lax (pages quietly grow past usefulness).
```

Add a corresponding line to the lint findings list:

> Look for orphan pages, stale entries (90+ days), contradictions across pages, concepts mentioned 3+ times without their own page, goals with no recent activity in `log.md`, frontmatter inconsistencies, **anchor pages exceeding the soft size threshold (see "Anchor-page size and archive")**.

And a new lint report body section:

> `## Oversize anchors` — list pages over threshold, with line count and a one-line suggestion of which sections look archivable.

## Rationale

- **Soft, not hard.** A hard auto-archive on threshold would surprise the user and risk losing context mid-session. Surfacing in lint means the page only changes when the user signs off.
- **Sibling pages over destination directories.** A single `archive/` directory would lose the per-anchor association — `about-archive.md` next to `about.md` keeps the relationship obvious in the graph view.
- **Protected regions as explicit markup.** Easier than maintaining a list of "core sections to never touch" elsewhere — the rule lives in the file it applies to.
- **12-month dated-entry threshold.** Long enough that recent context is preserved, short enough that a year of Diego usage doesn't bloat any single page beyond scanning.
- **Tradeoff:** archive pages themselves can grow over time. Acceptable for now — they're not in the active scan path. If they ever become a problem, recurse the same convention onto them.
- **Tradeoff:** the protected-region markup adds a small amount of HTML-comment noise to every anchor page. Worth it for the explicitness.

## Scope

- [x] Affects only one space (life — work-space anchor pages don't exist yet; rule will need to be lifted to root or duplicated when they do)
- [ ] Affects identity / root CLAUDE.md
- [ ] Affects multiple spaces

## Open questions

- Should `journal/` entries be subject to a parallel rule? Probably not — journal pages are inherently dated and finite (one per day). A high-activity day can blow past 400 lines, but that's a property of the day, not bloat to archive.
- Should the protected-region markup be standardized across `about`, `projects`, `themes`, and `goals` separately, or is one convention enough? Default proposal: one convention is enough; if a page type needs different protected sections, set them per-page.
- 400 lines is a guess. Worth revisiting once the first oversize page appears in real use.

## Discussion

(To be filled in during refinement.)
