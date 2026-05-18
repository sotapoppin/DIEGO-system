---
type: proposal
status: open
created: 2026-04-29
applied: null
file: CLAUDE.md (root, `## Voice and text output` section)
---

# Reinforce `<speak>` headline discipline

## The friction

The `## Voice and text output` section in root `CLAUDE.md` already specifies the rule: *"the spoken line is a headline, not a recap. Don't restate what the text already shows; surface the one thing the user most needs to hear right now."* Behavior drifts back to recap anyway — the `<speak>` block ends up paraphrasing the first paragraph of the text response, defeating the two-channel design.

Logged 2026-04-28. The rule exists; the rule isn't sticking. Pure-text reinforcement may not be enough — what's needed is concrete contrast (*this is a recap, this is a headline*) so the model has an example to anchor against.

## The diagnosis

**Judgment call within the rules**, but the rules can be tightened with examples. The current rule is abstract ("headline, not recap"). The drift suggests the model is interpreting "summarize what's worth hearing" as "summarize the response," which is exactly the failure mode. Concrete contrast — bad example next to good example — is the lowest-cost reinforcement.

## Current text

From root `CLAUDE.md`, `## Voice and text output`:

> When a turn has a meaningful update worth saying aloud, lead with a `<speak>...</speak>` block — one or two short sentences, conversational, no markdown. The block is consumed by a TTS hook and stripped from the rendered text before the user sees it. Everything else in the response is text-only: structured detail, file paths, draft entries, lists, code.
>
> The spoken line is a *headline*, not a recap. Don't restate what the text already shows; surface the one thing the user most needs to hear right now (a result, a decision point, a blocker).

## Proposed text

Replace the second paragraph above with:

> The spoken line is a *headline*, not a recap. It carries a different payload than the text — surface the one thing the user most needs to hear right now (a result, a decision point, a blocker), not a compressed restatement of what the text already shows.
>
> Concretely:
>
> - **Recap (wrong):** *"I've drafted the proposal, applied the changes, and updated the changelog."* — restates what the text response already lists.
> - **Headline (right):** *"Proposal's drafted — needs your read before I apply."* — names the next move, which the user couldn't get from a glance at the diff.
> - **Recap (wrong):** *"Found three frictions and three potential proposals."* — restates the list that's already on screen.
> - **Headline (right):** *"Five proposals up — the archive-convention one is the load-bearing change."* — points at what to read first.
>
> If the spoken line could be deleted without the user losing information, it's a recap. Rewrite or skip.

## Rationale

- **Examples beat rules for behavior that drifts.** The "headline not recap" rule is correct; the drift means the model needs a sharper anchor than the rule alone provides. Two contrasting pairs make the failure mode concrete.
- **The "deleted without losing information" test is operational.** It's the same logic the rule already implies, but stated as a check the model can run on its own draft before emitting.
- **Tradeoff:** adds ~6 lines to root CLAUDE.md. The root is the most-read file in the system; adding to it is high-cost. Justified here because the rule is already in the section and is failing — the addition is reinforcement, not new convention.
- **Tradeoff:** examples can age (if the proposal-drafting workflow evolves, the example phrasing may feel dated). Keeping them generic ("a result, a decision point, a blocker" + concrete sentences) limits the rot.
- **No mechanism change.** This is a rule-text reinforcement, not a hook or skill. If drift continues after this, the next escalation would be a Stop-hook check that flags `<speak>` blocks paraphrasing the first paragraph of the response, but that's heavyweight — try the text reinforcement first.

## Scope

- [ ] Affects only one space
- [x] Affects identity / root CLAUDE.md (high-care change)
- [ ] Affects multiple spaces

The change is to the output-convention section of root `CLAUDE.md`. Identity-level care applies — every space inherits this rule.

## Open questions

- Should the examples be replaced with examples that better fit the user's actual usage patterns? Worth a pass before applying.
- Is the "deleted without losing information" check too strict? It rules out turns where the spoken line legitimately echoes a key text point because the user is listening rather than reading. Probably acceptable — those turns are exactly the recap case the rule is trying to prevent.

## Discussion

(To be filled in during refinement.)
