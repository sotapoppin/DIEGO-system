---
name: push
description: Push the current branch in the DIEGO-system repo to origin. Sets upstream tracking on first push of a new branch. Trigger when the user says "push", "/push", or wants local commits sent to GitHub.
---

# Push current branch to origin

## First: locate DIEGO-system

The system repo is the parent directory of the file `CLAUDE.md` symlinks to:

```bash
SYSTEM_REPO="$(cd "$(dirname "$(readlink CLAUDE.md)")" && pwd)"
```

Use `$SYSTEM_REPO` in all git commands below.

## Steps

1. **Survey state.** Run in parallel:
   - `git -C "$SYSTEM_REPO" status` — verify clean working tree (or note uncommitted changes)
   - `git -C "$SYSTEM_REPO" branch --show-current` — current branch
   - `git -C "$SYSTEM_REPO" log @{u}..HEAD --oneline 2>/dev/null` — commits ahead of upstream (will fail if no upstream set)
   - `git -C "$SYSTEM_REPO" rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null` — upstream tracking ref (empty if none)
   - `git -C "$SYSTEM_REPO" remote get-url origin` — origin URL (used to construct compare/PR URL after push)

2. **Decide push form.**
   - If upstream is set and there are commits ahead: `git push`
   - If no upstream tracking: `git push -u origin <current-branch>`
   - If working tree has uncommitted changes: flag this to the user before pushing — they may have meant `/commit` first
   - If zero commits ahead and upstream is set: tell the user there's nothing to push

3. **Run the push.**
   ```bash
   git -C "$SYSTEM_REPO" push  # or: push -u origin <branch>
   ```

4. **Report back.** One short line: branch name, commit range pushed, and the GitHub compare URL if it's a non-main branch. Construct the URL from the origin remote (e.g. `git@github.com:owner/repo.git` → `https://github.com/owner/repo/pull/new/<branch>`).

## Don't

- **Force-push without explicit ask.** If the user says "force push," confirm specifically before running `git push --force-with-lease` (preferred over `--force`).
- **Force-push to `main`/`master`** under any circumstance without a strong, explicit confirmation. Warn loudly first.
- Skip hooks (`--no-verify`) or signing unless explicitly asked.
- Push if the working tree has uncommitted changes the user clearly intended to include — surface and ask.
