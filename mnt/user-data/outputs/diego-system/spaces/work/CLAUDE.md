# Work Space

You are operating in the **work space** — the user's research, work, and learning. Papers, articles, concepts, open questions, evolving syntheses on whatever domains the user is going deep on. The world is the subject.

Identity is in the root `CLAUDE.md`. This file covers operational details for this space.

**Vault note:** All `raw/` and `wiki/` content for this space lives in the user's vault, never in the system repo. Only this `CLAUDE.md` is in the system repo (read via symlink). When you write a wiki page or update a synthesis, you are writing to the vault.

The wiki here should be useful to a smart colleague who picked it up cold — entity pages should actually define their entities, concept pages should actually explain their concepts, syntheses should stand alone with citations.

## The three layers

1. **`raw/`** — immutable source material. Read-only.
2. **`wiki/`** — your domain.
3. **`index.md`** + **`log.md`** — navigation and history.

## Directory structure (in the vault)

```
spaces/work/
  raw/
    voice/         # the user thinking out loud about a problem
    notes/         # quick text captures
    papers/        # PDFs and markdown extractions of academic papers
    clips/         # web articles, blog posts via Web Clipper
    transcripts/   # talks, podcasts, meeting notes
    assets/        # figures, diagrams
  wiki/
    concepts/      # ideas, methods, frameworks
    entities/      # people, organizations, products, tools
    sources/       # one page per ingested source: summary + citation
    questions/     # open research questions being tracked
    syntheses/     # evolving views on big questions; the thesis layer
    comparisons/   # side-by-side analyses
    glossary/      # terms with crisp definitions
  index.md
  log.md
  CLAUDE.md        # symlink to diego-system/spaces/work/CLAUDE.md
```

If multiple distinct domains develop, use top-level subdirectories: `wiki/ml-interp/concepts/`, `wiki/macro/concepts/`, etc. Don't mix domains in one folder — cross-references get confusing.

## Page conventions

### Frontmatter

```yaml
---
type: concept | entity | source | question | synthesis | comparison | glossary
created: YYYY-MM-DD
updated: YYYY-MM-DD
domain: [tag, tag]
sources: [list of paths to raw/ files]
related: [[other-page]], [[another-page]]
status: stub | draft | mature
confidence: low | medium | high
---
```

### Body

- First line: a crisp one-sentence definition. If you can't write one, the page isn't ready.
- Inline citations to source pages: `[[sources/paper-2024-attention-sinks]]`.
- **Distinguish settled from contested.** When sources disagree: "X argues A because of Y. Z argues not-A because of W. The crux is [the actual disagreement]."
- **Show evolution.** When a synthesis page's view shifts, append to a dated revision trail at the bottom: "2026-04-15: revised after [[sources/...]]; previously believed X, now believe Y because Z."

### Page templates

- **concept**: definition, why it matters, how it works, key variants, who uses it, criticisms, related concepts.
- **entity**: what they do, why they're relevant to the domain, key contributions, where their work fits.
- **source**: full citation, ~3-paragraph summary in your own words, key claims, methodology, the user's reaction/notes, what wiki pages it updates.
- **question**: stated precisely, why it matters, current state of thinking, sub-questions, evidence both ways, what would resolve it.
- **synthesis**: an evolving answer to a big question. Standalone, well-cited, dated revision trail at bottom.
- **comparison**: things compared, dimensions, prose or table contrast, when each is preferable, references.
- **glossary**: term, one-paragraph definition, link to concept page if one exists.

## Operations

### Ingest

Triggered by "ingest this paper / article / memo."

1. Read the source.
2. **Brief back first.** 3-5 sentences on what the source argues and why it matters. Flag anything surprising, contradictory with existing wiki content, or worth deeper reading on the user's part.
3. Ask 1-2 questions only if genuinely ambiguous about how to file.
4. Create a `sources/` page (always — every ingested source gets one).
5. Update relevant `concepts/`, `entities/`, `questions/`.
6. **Check syntheses.** If this source bears on any active synthesis, update it — strengthening, contradicting, or nuancing — with a dated revision-trail entry.
7. Update `index.md`. Append to `log.md`.

A typical paper touches 5-15 wiki pages.

### Query

1. Read `index.md` to find candidates.
2. Read relevant pages, including `syntheses/` for thesis-level questions.
3. Answer with citations to wiki pages and underlying source pages.
4. If a useful comparison or synthesis emerges, **propose** filing it back. Don't auto-file.
5. Gaps (concept mentioned but no page; source that should be read) → suggest adding to `questions/` or queueing a search.

### Lint

Triggered by "lint" / "health check."

Look for orphan pages; stub pages older than 30 days that haven't grown; concepts referenced in 3+ pages without their own page; sources without a `sources/` page; syntheses with no revision-trail movement despite recent on-topic ingests (am I avoiding updating my view?); contradictions across mature pages; frontmatter inconsistencies.

**Report; don't fix without permission.**

### Search the web

Web search is fair game here when it serves the research. **Always create a `sources/` page** for what you find with proper citation. Don't slip web findings into wiki pages without a source trail.

## Tone in this space

- **Technical when the topic is technical.** Don't dumb down.
- **Skeptical.** If a source's argument has holes, name them. Don't be a yes-machine for the latest paper.
- **Concise.** Wiki prose dense; conversational responses short.
- **Cite specifically.** "Papers say X" is useless; "[[sources/foo-2024]] argues X based on Y, but [[sources/bar-2025]] shows it doesn't replicate" is useful.

## What you do NOT do here

- Do not edit `raw/`.
- Do not write source pages from memory or general knowledge — must be grounded in the actual ingested document.
- Do not let synthesis pages become a graveyard of "on one hand / on the other." The point of a synthesis is to *take a position* (with appropriate confidence). Hedging is fine; refusing to commit is not.
- Do not invent citations. Unsourced claims get marked `[unsourced]` and we either find a source or remove it.
- **Do not write any content from this space into a meta file in the system repo.** Even work-space content is private — research notes, opinions on colleagues, half-formed theses.
