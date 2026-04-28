---
type: proposal
status: applied
created: 2026-04-27
applied: 2026-04-27
file: spaces/life/CLAUDE.md
---

# Fix invalid YAML in life-space frontmatter example

## The friction

The frontmatter example in `spaces/life/CLAUDE.md` showed wikilink fields in a format that Obsidian's properties feature parses incorrectly:

```yaml
sources: [list of paths to raw/ files this page draws from]
related: [[other-page]], [[another-page]]
```

Following this example faithfully produced 14 vault pages with frontmatter Obsidian flagged as invalid. The graph view didn't pick up the relations, and the properties panel showed parse errors on every page that listed multiple wikilinks.

## The diagnosis

**Schema rule wrong** — specifically, the example was wrong. The convention "use wikilinks in `related`" is fine; the format shown was not. Two issues:
- `[[link]]` in YAML is read as a nested array, not a wikilink string. Obsidian's properties feature wants strings.
- Comma-separated `[[a]], [[b]]` is read as a single malformed string, not a list.

Both `sources` and `related` need to be proper YAML lists with quoted wikilink strings.

## Current text

```yaml
sources: [list of paths to raw/ files this page draws from]
related: [[other-page]], [[another-page]]
```

## Proposed text

```yaml
sources:
  - "[[raw/voice/2026-04-15-1430-morning-walk]]"
  - "[[raw/notes/some-note]]"
related:
  - "[[other-page]]"
  - "[[another-page]]"
```

Plus a one-sentence note under the frontmatter block explaining why bare `[[...]]` and comma-separated forms don't work.

## Rationale

- **Literal correction**, not a behavior change. The schema's intent (wikilinks in `related` and `sources`) is unchanged; only the syntax of the example is corrected.
- **Cost of leaving it broken** keeps growing — every new page produced by following the example would need post-hoc fixing.
- **Tradeoff:** the new form is slightly more verbose for single-entry cases (`sources:` with one item now spans two lines instead of one). Worth it for parser correctness.

## Scope

- [x] Affects only one space (life)
- [ ] Affects identity / root CLAUDE.md (high-care change)
- [ ] Affects multiple spaces

## Discussion

Surfaced when the user opened newly-created person pages in Obsidian and saw the properties panel flag invalid frontmatter. 14 vault pages had been written with the broken format before the issue was identified. Vault pages were corrected first; this proposal closes the loop by fixing the source of the error.

## Applied

Applied 2026-04-27. Edit made to `spaces/life/CLAUDE.md` Frontmatter section: `sources` and `related` examples converted to YAML block list format with double-quoted wikilink strings; explanatory note added below the frontmatter block. All 14 affected vault pages corrected separately. Changelog entry recorded.
