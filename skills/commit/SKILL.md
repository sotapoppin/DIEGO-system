---
name: commit
description: Stage and commit changes in the DIEGO-system repo using Diego-native commit prefixes (schema/meta/space/repo/docs). Drafts a message from the diff and confirms before committing. Trigger when the user says "commit", "/commit", or wants pending changes saved to git.
---

# Commit changes to DIEGO-system

DIEGO-system is the public-shareable git repo. The vault is **not** a git repo — never run git commands there.

## First: locate DIEGO-system

The system repo is the parent directory of the file `CLAUDE.md` symlinks to. From the vault, run:

```bash
SYSTEM_REPO="$(cd "$(dirname "$(readlink CLAUDE.md)")" && pwd)"
```

If `CLAUDE.md` isn't a symlink (rare), assume the system repo is a sibling directory next to the vault — fall back to checking common locations like `~/DIEGO/DIEGO-system` or asking the user.

Use `$SYSTEM_REPO` in all git commands below: `git -C "$SYSTEM_REPO" ...`.

## Steps

1. **Survey the change.** Run in parallel:
   - `git -C "$SYSTEM_REPO" status` — see all changed/untracked files
   - `git -C "$SYSTEM_REPO" diff` — unstaged changes
   - `git -C "$SYSTEM_REPO" diff --staged` — already-staged changes
   - `git -C "$SYSTEM_REPO" log -5 --oneline` — recent style for reference

2. **Pick the prefix.** Diego-native prefixes (do NOT use `feat:`/`fix:`/`chore:`):
   - `schema:` — edits to any `CLAUDE.md` (root, space-level, or meta-level). The rules themselves changed.
   - `meta:` — additions or edits to meta-space artifacts only (proposals, design notes, friction-log entries, patterns, changelog) **without** an accompanying schema edit.
   - `space:` — edits to space-level files that are *not* `CLAUDE.md`.
   - `repo:` — filesystem layout, install scripts, `.gitignore`, skills directory, structural moves of files.
   - `docs:` — top-level README, public-facing documentation.

   When a single commit contains a schema edit AND supporting meta artifacts (typical applied meta loop), use `schema:` — schema is the headline; the proposal/changelog entries are supporting evidence in the same commit.

3. **Draft the message.**
   - **Title:** `<prefix>: <one-line summary>` — under 70 characters, focus on *why* over *what*.
   - **Body** (only if non-trivial): 1-3 sentences explaining motivation and tradeoffs. Apply public-meta discipline — no vault content, no real names from the user's life, no quoted user words.
   - **Trailer:** `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>`

4. **Show the user** the file list and drafted message. Wait for go-ahead unless the user already said "commit" with explicit context (e.g. "commit and push").

5. **Stage and commit.** Always pass message via heredoc:
   ```bash
   git -C "$SYSTEM_REPO" add <specific files>
   git -C "$SYSTEM_REPO" commit -m "$(cat <<'EOF'
   <prefix>: <title>

   <body if any>

   Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
   EOF
   )"
   ```

6. **Don't push.** That's `/push`. If the user said "commit and push" together, run `/push` after.

## Don't

- Use `git add -A` or `git add .` — stage specific files by name to avoid accidentally staging secrets or unintended files.
- Skip hooks (`--no-verify`) or bypass signing unless explicitly asked.
- Amend existing commits unless the user explicitly says "amend." A failing pre-commit hook means the commit didn't happen — fix and create a new commit.
- Commit files that look like secrets (`.env`, credentials, keys).
- Force-anything.
