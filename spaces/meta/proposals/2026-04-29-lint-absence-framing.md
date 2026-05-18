---
type: proposal
status: open
created: 2026-04-29
applied: null
file: spaces/life/CLAUDE.md (Lint operation), skills/lint/SKILL.md (if/when adopted)
---

# Lint absence-framing default

## The friction

Lint passes implicitly frame sparse or empty wiki areas as deficiencies to fill. The output structure ("orphans," "promotable concepts," etc.) reads as a punch list — *what's missing that should be there*. But absence often reflects what's actually true: the user genuinely hasn't been thinking about practices, or hasn't formed enough thinking about a person to warrant a page, or has stopped engaging with a goal because the goal is dormant for real reasons.

Without an explicit framing, lint nudges toward artificial seeding — Diego suggests creating a page because three mentions hit a threshold, the user creates the page out of compliance, and the wiki gets a stub that doesn't reflect any actual thinking.

Logged 2026-04-28. Open question at the time was whether to add a "this might just be true absence" framing to lint output by default.

## The diagnosis

**Schema rule missing.** The lint operation specifies *what to look for* but not *how to interpret what's found*. Without an interpretive default, Diego treats every finding as actionable, which biases toward filling. A small framing addition rebalances toward "report, don't recommend."

## Current text

From `spaces/life/CLAUDE.md`, `### Lint` section:

> Look for orphan pages, stale entries (90+ days), contradictions across pages, concepts mentioned 3+ times without their own page, goals with no recent activity in `log.md`, frontmatter inconsistencies. **Report; don't fix without permission.**

## Proposed text

Replace the line above with:

> Look for orphan pages, stale entries (90+ days), contradictions across pages, concepts mentioned 3+ times without their own page, goals with no recent activity in `log.md`, frontmatter inconsistencies. **Report; don't fix without permission.**
>
> **Absence is not deficiency by default.** Empty page types, sparse directories, or unchanged sections may faithfully reflect where the user's intellectual or emotional life actually is right now. Frame findings as observations, not gaps to fill: *"no `practices/` pages exist"* rather than *"missing practice pages"*. Promotable concepts and stale entries are worth surfacing as candidates, not as deficits — leave the decision to file or revisit with the user, who knows whether the absence is real or accidental.

Add a parallel line to the lint report template body conventions:

> Findings are observations, not action items. The `## Notes` section is the right place to flag when an absence likely reflects true state rather than drift.

## Rationale

- **Bias the framing once, at the rule level.** Without this, the bias has to be reapplied per-lint, and Diego's default produce-a-punch-list register fights the rule every time.
- **The cost of a stub page is higher than the cost of a missing one.** A stub gets indexed, searched, linked, and looks like content — it pollutes the graph. A missing page is just absent; the user notices when it should exist and asks for it.
- **Preserves the value of the lint pass.** Real drift (stale goals the user *wants* to revisit, contradictions across pages, broken frontmatter) still surfaces. The framing change is interpretive, not exclusionary.
- **Lint is the right place for this rule.** `Reflect` already says "honest, not flattering" — the parallel for `Lint` is "observational, not prescriptive."
- **Tradeoff:** the user may sometimes *want* a punch list. Acceptable — they can ask for one explicitly, or override the framing in the moment. The default just isn't that.
- **Tradeoff:** "absence is not deficiency" can over-correct into never recommending. The phrasing keeps "candidates" alive — the operation still surfaces, the framing just doesn't editorialize.

## Scope

- [x] Affects only one space (life)
- [ ] Affects identity / root CLAUDE.md
- [ ] Affects multiple spaces (work-space lint, when it exists, would inherit the same default)

## Open questions

- Should this framing extend to `Reflect`? `Reflect` is already framed as "honest, not flattering," which trends toward observation, but doesn't explicitly cover the absence-vs-deficiency case. Probably worth a one-line parallel addition.
- Should the lint report template include an explicit `## True absence` section header for findings the user has confirmed are not drift? Defer until a real example surfaces — adding sections speculatively bloats the template.

## Discussion

(To be filled in during refinement.)
