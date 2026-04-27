# Why the router

**Date written:** 2026-04-27 (initial design)

## The problem

Diego started as two separate vaults — `diego-life/` and `diego-work/`. Two `CLAUDE.md` files, two terminals, two Claudes. The user pushed back: this isn't really one assistant. It's two assistants that happen to share a name. JARVIS isn't two JARVISes.

## The decision

One conceptual entity, one entry point, one Diego. Multiple **spaces** internally. A top-level `CLAUDE.md` that contains identity (constant across spaces) and routing logic (which space does this request belong to?). Each space has its own operational `CLAUDE.md` for the specifics.

## Why this and not the alternatives

- **Two vaults:** rejected. Forces context-switching. A unified assistant doesn't ask "which mode are you in." Also makes cross-space queries awkward.
- **One vault, no spaces:** rejected. Different domains have genuinely different conventions — citation discipline matters in research, doesn't in journaling; affect-preservation matters in personal reflection, doesn't in research. Forcing one schema produces a worst-of-both result.
- **Skills-based system:** deferred. Skills are best designed once you know the workflow. We don't know the workflow yet. Revisit at v0.5.

## Tradeoffs being accepted

- **Routing will sometimes be wrong.** Diego will guess the wrong space occasionally. Corrections become friction-log entries and improve the router over time.
- **Two-step lookup on every operation.** Cheap in practice but worth flagging.
- **The root file is a single point of failure.** Treated as sacred — changes go through the meta loop.

## What would tell us this was wrong

- If routing failures are frequent (>20% of requests in early weeks).
- If users find themselves prefixing every request with the space name to bypass the router.
- If the spaces' schemas drift so far apart that maintaining identity in the root file becomes contortion.
