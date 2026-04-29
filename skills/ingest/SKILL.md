---
name: ingest
description: Enter batched ingest mode — accumulate user-supplied life-space context across multiple turns, asking broad clarifying questions inline, without per-fact wiki edits. Trigger when the user says "ingest", "/ingest", "I'm gonna dump some info", "let me tell you about X", or signals they want to add to the wiki without immediate filing. Exit via the `update` skill or when the user explicitly signals commit.
---

# Batched ingest mode

Default Diego behavior is to file each user-supplied fact immediately — read sources, update the affected wiki pages, log the operation. That works for one-shot voice memos and explicit ingest sessions. It does **not** work for live conversational dumps where the user wants to share a lot of context fast and have Diego synthesize it at the end.

This skill enters **batched ingest mode**: stop per-fact filing, ask broad questions, accumulate context in conversation, commit later via `/update`.

## When this is the right mode

- User is conversationally walking through people, projects, history, etc.
- User says "let me tell you about my X" or "I'm gonna dump info."
- User explicitly invokes `/ingest`.
- More than 2 small facts are likely incoming and per-fact filing would create churn.

## How to operate while in this mode

1. **Acknowledge entering the mode briefly.** One sentence is enough: "OK, batched mode on. I'll hold off on filing until you say `/update` or hit a natural pause."

2. **Stop filing.** No `Edit`/`Write` calls to wiki pages, index, or log while accumulating. The whole point of the mode is to not generate that churn.

3. **Ask broad clarifying questions, not granular ones.**
   - 1–2 broad questions per topic, then **move on to the next topic**. Don't drill.
   - Topic *breadth* > topic *depth* — texture accretes across sessions.
   - If a question is granular ("exact date," "is this person in X group"), either skip it or fold it into a broader question.
   - "Optional / no pressure" questions are still energy to skip — if it's optional, just drop it.

4. **Hold the accumulating context in your working memory.** You'll synthesize it at commit time. Keep mental notes of:
   - New people / entities mentioned.
   - Updates to existing people / entities.
   - Relationships between them.
   - Open questions the user didn't answer (to surface as `## Open questions` on pages later).

5. **Stay warm.** Care, light register, dry edge per identity; no clipped/curt tone just because you're not filing. The mode change is structural, not affective.

6. **Honest observations are still on.** If something the user is saying surfaces a contradiction, an avoidance, a pattern worth naming — say it (warmly, plainly). Batched mode doesn't suppress honesty; it suppresses per-fact filing.

7. **Brief back lightly when topics shift.** A one-line "got it — A is the clean one, B is the messy one, conflict from year one" is enough to confirm capture without filing. Don't make this ceremonial.

## Exit conditions

- User says `/update`, "commit", "update the wiki", or similar — invoke the `update` skill.
- User signals natural pause ("ok that's it for now," "that's all," "let's stop"). Confirm whether to commit or hold.
- Session is about to end (e.g. user says they're heading out) — proactively offer to `/update` so accumulated context isn't lost.

## What NOT to do

- **Don't auto-file partway through.** The mode's value is in batching; defeating it with mid-mode commits negates the friction reduction.
- **Don't pile up a long structured "captured so far" list mid-session.** The user can't read your mental notes anyway, and writing them out replicates the per-fact churn this mode exists to avoid.
- **Don't skip honesty to seem efficient.** If you'd flag a concern in normal mode, flag it in batched mode too.
- **Don't ask permission for routine framing decisions.** If you'd put a fact under section X on a page, just plan to put it there at commit time. Don't pre-validate the structure.
