---
type: proposal
status: applied
created: 2026-04-27
applied: 2026-04-27
file: spaces/life/CLAUDE.md
---

# Add `about` page type for the life-space self-anchor

## The friction

While onboarding to the life space, the user asked where their own canonical anchor page should live. The existing `person` template is shaped around relationships *to* someone (recent interactions, open commitments to them, recurring threads with them) — it doesn't fit the user themselves, who is the *subject* of the entire life space rather than a person within it. Filing the user under `wiki/people/` would distort both the people directory (now mixing self with others) and the about-the-user page (forced into a relationship template that doesn't apply).

## The diagnosis

Schema rule **missing**. The life-space schema covers relationships, projects, themes, goals, health, journal entries, decisions, and practices — but has no provision for an identity anchor about the user themselves. The omission was tolerable in v0.1 (the whole space is *implicitly* about the user) but produces real friction the first time identity-level facts need a home.

## Current text

`spaces/life/CLAUDE.md` frontmatter type enum:
> `type: person | project | theme | goal | health | journal | decision | practice`

`spaces/life/CLAUDE.md` page templates section: *(no `about` entry)*

`spaces/life/CLAUDE.md` directory structure: *(no `about.md` in the wiki/ tree)*

## Proposed text

**1. Frontmatter type enum** — add `about` as the first option:
> `type: about | person | project | theme | goal | health | journal | decision | practice`

**2. Directory structure** — add `about.md` as the first item under `wiki/`:
> `  wiki/`
> `    about.md    # the self-anchor — distinct from people/`
> `    people/     # one page per person who matters`
> `    ...`

**3. Page templates** — add an `about` entry at the top of the list:
> **about**: the canonical identity-anchor for the user (the subject of the space). Sections: identity (name, origin, where the user lives now), current context (work, key relationships at a high level, ongoing situations), recurring threads or arcs across time, open questions about the user's own trajectory. Distinct from `people/` — that directory is for *others* in the user's life. Exactly one `about.md` per life space.

## Rationale

- **Lightest viable change.** One new page type, one canonical filename. No new directory, no parallel structure, no facet pages.
- **Solves a real distortion.** The `person` template assumes asymmetric relational scaffolding that doesn't apply to self.
- **Earns wikilinks.** `[[about]]` becomes a natural anchor for any page touching identity-level facts (origin, location, work-life context).
- **Tradeoff:** introduces one additional `type` value, slightly enlarging the schema vocabulary.
- **Tradeoff:** the about-anchor and `journal/` can blur, since both touch on the user. Convention to apply: `about` = stable identity facts and long-arc threads; `journal` = dated reflections.

## Scope

- [x] Affects only one space (life)
- [ ] Affects identity / root CLAUDE.md (high-care change)
- [ ] Affects multiple spaces

## Discussion

User raised the issue while onboarding to the life space and asked for an opinion. We considered three options: (a) file the self under `people/` like anyone else, (b) introduce a `self/` directory in case multiple self-pages are wanted later (current self / past arcs / facets), (c) a single anchor file with a new `about` type. Settled on (c) as the lightest viable structure that solves the asymmetry without pre-engineering for unproven needs. User approved scope explicitly: one anchor per life space, type name `about`, no facets.

## Applied

Applied 2026-04-27. Edits made to `spaces/life/CLAUDE.md`: added `about` to the frontmatter type enum, added `about.md` to the wiki/ directory tree, added `about` page template entry. Changelog entry recorded.
