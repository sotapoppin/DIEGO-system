---
type: proposal
status: applied
created: 2026-04-27
applied: 2026-04-27
file: skills/, install.sh
---

# Relocate operational skills to system repo + add `/wrap` skill

## The friction

The `/commit` and `/push` skills created earlier in the day lived only in the user's personal vault at `diego-vault/.claude/skills/`. That meant: (1) skill improvements wouldn't propagate to other installs of Diego, (2) the skills hardcoded the user's specific filesystem path, and (3) the just-applied `## Sessions` journal convention had no triggering mechanism — relying on the assistant to remember to append session summaries doesn't work in practice.

Two things needed to land together: skills should be canonical in the system repo and symlinked into vaults (mirroring how `CLAUDE.md` works), and a `/wrap` skill should exist to actually drive the Sessions convention.

## The diagnosis

**Schema rule missing** plus **architectural inconsistency**:

- The Sessions block convention specifies "Sessions are appended as they end (or via an end-of-session trigger)" but no trigger existed. The convention without the skill rots.
- Skills are operational tooling that should be schema-like (versioned, shared, propagating) but were treated as per-install starter content. The system has a clear pattern for shared schema (symlinks from system repo), and skills should follow it.

## Current text / state

- `diego-vault/.claude/skills/commit/SKILL.md` and `diego-vault/.claude/skills/push/SKILL.md` existed only locally, with hardcoded `/Users/sotashimizu/DIEGO/DIEGO-system/` paths.
- `install.sh` did not handle skills at all.
- No `/wrap` skill existed.

## Proposed change

1. **Create `DIEGO-system/skills/`** at the top level of the system repo. Three skills:
   - `commit/SKILL.md` — DIEGO-system git commits with Diego-native prefixes (path-portable: detects system repo via the `CLAUDE.md` symlink).
   - `push/SKILL.md` — push current branch to origin (path-portable).
   - `wrap/SKILL.md` — *new*. Appends a structured `### <slot> — <slug>` entry under the `## Sessions` block of today's life-space journal. Determines slot from current time, synthesizes discussed/decisions/in-flight/files-touched, confirms with user, writes.
2. **Update `install.sh`** to symlink `vault/.claude/skills` → `DIEGO-system/skills` (similar to how the meta space is handled). Per-install `.claude/settings.json` stays local.
3. **Migrate the existing vault** by replacing the local skills directory with the symlink. The pre-existing local copies are preserved as `.claude/skills.local-backup/` for safety until the symlinked versions are confirmed working.

## Rationale

- **`/wrap` makes the Sessions convention real.** Without a trigger, conventions decay. With `/wrap`, the user has one explicit motion to close a session and the assistant has one specific procedure to follow.
- **Symlinking matches the existing schema-distribution pattern.** Every install gets the latest skills automatically; updates to a skill flow to all vaults the same way `CLAUDE.md` updates do.
- **Path portability** — canonical skills detect the system repo via the `CLAUDE.md` symlink rather than hardcoding the user's home directory. Necessary for Diego to be installable by anyone other than its first user.
- **Tradeoff:** users can't customize skills per-install with this scheme. If that becomes a need, an override pattern (`vault/.claude/skills.local/` taking precedence over the symlinked canonical version) can be added — not built now.
- **Tradeoff:** symlinking `.claude/skills` means Claude Code needs to follow symlinks during skill discovery. It does, but worth flagging if a future Claude Code change ever breaks this.

## Scope

- [ ] Affects only one space
- [ ] Affects identity / root CLAUDE.md (high-care change)
- [x] Affects repo structure and install path (cross-cutting)

## Discussion

The user surfaced the install-time question directly: "also I think it's worth adding to the setup install file for diego." That made the architectural choice explicit — skills should be canonical in the system repo, not per-install. The migration path was straightforward because the existing local skills had no user customization yet (they were created earlier the same day from canonical-style templates).

## Applied

Applied 2026-04-27.
- Created `DIEGO-system/skills/{commit,push,wrap}/SKILL.md` with path-portable system-repo detection.
- Modified `install.sh` to symlink `vault/.claude/skills` → `system/skills` after the meta-space symlink section.
- Migrated `diego-vault/.claude/skills/` to the symlink; preserved prior local copies at `.claude/skills.local-backup/` for verification.
- Changelog entry recorded.

User may need to restart Claude Code for the symlinked `/wrap` skill to appear in the slash-command listing.
