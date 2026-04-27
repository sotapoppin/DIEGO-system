---
type: proposal
status: applied
created: 2026-04-27
applied: 2026-04-27
file: spaces/meta/CLAUDE.md
---

# Replace Conventional Commits style with Diego-native commit prefixes

## The friction

The system repo's existing commit history uses Conventional Commits style (`feat:`, `chore:`, `docs:`). The user objected to this — `chore:` in particular carries a dismissive tone, treating maintenance and structural work as filler. More fundamentally, the Conventional Commits vocabulary was designed for software products that "ship features" and "fix bugs" — Diego doesn't operate in those categories. Its meaningful unit of change is the meta-loop artifact: a schema edit, a proposal, a design note, a friction log entry. The vocabulary should match.

The existing meta-space `CLAUDE.md` even references the desired direction implicitly: it suggests committing schema changes as `git commit -m "schema: <one-line summary>"`. But it doesn't define the broader prefix set, leading to inconsistent prefix choices commit-to-commit.

## The diagnosis

Schema rule **missing**. Commit conventions for the system repo were never formalized. The result: ad-hoc prefix choice, fallback to generic Conventional Commits vocabulary, occasional `chore:` for changes that aren't really chores.

## Current text

`spaces/meta/CLAUDE.md`, in the "propose / tune" section:
> Suggest the user commit: `git -C ~/diego-system add . && git commit -m "schema: <one-line summary>"`.

No dedicated "commit conventions" section.

## Proposed text

**1. Add a new section** between "Templates" and "Tone in the meta space" titled `## Commit conventions`. Content:

> Commits to `DIEGO-system` use Diego-native prefixes that map to the kind of change being made. Avoid Conventional Commits vocabulary (`feat:`, `chore:`, `fix:`) — Diego is not a software product shipping features.
>
> The prefixes:
>
> - **`schema:`** — edits to any `CLAUDE.md` (root, space-level, or meta-level). The rules themselves changed.
> - **`meta:`** — additions or edits to meta-space artifacts only (proposals, design notes, friction-log entries, patterns, changelog entries) without an accompanying schema edit.
> - **`space:`** — edits to space-level files that are *not* `CLAUDE.md` (e.g., seeding `index.md` structure, structural template content). Rare, since most space content lives in the vault.
> - **`repo:`** — filesystem layout, install scripts, `.gitignore`, structural moves of files between directories, anything affecting how the repo itself is shaped.
> - **`docs:`** — top-level README, public-facing documentation aimed at outside readers.
>
> When a single commit contains both a schema edit and the meta artifacts that support it (typical for an applied meta loop), use `schema:` — the schema change is the headline; the proposal and changelog entries are supporting evidence in the same commit.
>
> Commit message bodies (the lines after the title) follow standard prose style — no prefix required. Apply public-meta discipline as always: no vault content.

**2. Update the example commit line** in the "propose / tune" section to reference the conventions:
> Suggest the user commit, using the prefixes from "Commit conventions" below: `git -C ~/diego-system add . && git commit -m "schema: <one-line summary>"`.

## Rationale

- **Avoids `chore:`.** The user's primary objection. Removes the dismissive framing for maintenance work.
- **Maps to actual operations.** Every prefix corresponds to a real artifact type Diego produces. Reading the prefix tells you what *kind* of meta-loop activity the commit represents.
- **Preserves filterability.** `git log --grep="^schema:"` returns the history of schema evolution; `^meta:` returns the lighter-weight friction/design log; etc.
- **Tradeoff:** new vocabulary to learn (5 prefixes), and a small lock-in cost — once it's the convention, deviating creates inconsistency. Acceptable; the vocabulary is small and intuitive.
- **Tradeoff:** existing commits in the repo use Conventional Commits style. We don't rewrite history. Going forward, Diego-native prefixes apply; older commits remain as-is.

## Scope

- [x] Affects only one space (meta) — but the conventions documented here apply to *all* commits in the system repo
- [ ] Affects identity / root CLAUDE.md
- [ ] Affects multiple spaces

## Discussion

User flagged dislike of `chore:` prefix while reviewing a recent commit. We considered three options: (1) drop prefixes entirely, (2) Diego-native prefixes mapped to meta operations, (3) hybrid (prefix only for meta-loop changes, plain otherwise). Settled on (2) for consistency and filterability. User picked the option directly.

## Applied

Applied 2026-04-27. Edits made to `spaces/meta/CLAUDE.md`: new "Commit conventions" section added, example commit line updated to reference the new conventions. Changelog entry recorded.
