# Why the system/vault split

**Date written:** 2026-04-27 (initial design)

## The problem

Diego's initial v0.1 design had everything in one repo. The user wanted to be able to:

1. Push the schema to GitHub for version control, quickstart on new devices, and possible public sharing.
2. Keep their actual journal entries, voice memos, and personal wiki content private.

These two goals are incompatible if everything lives in one repo. Even a private GitHub repo is a meaningful exposure surface for the kind of content in `spaces/life/` (raw thoughts about family, health, decisions). And the user explicitly wanted public-shareable, which raises the stakes further.

## The decision

Split Diego into two physical locations:

- **`diego-system/`** — the schema, identity, and meta content. Version-controlled. May be public.
- **`diego-vault/`** — the actual content. Local-only. Backed up via the user's own private mechanisms.

The vault contains symlinks back to the system repo for schema files, so Diego experiences both as a unified filesystem. From the user's perspective, they `cd` into the vault and run `claude`; everything works as if it were one directory.

## What goes where

The test: **"would a stranger forking this repo to start their own Diego need this file?"** If yes, system. If it's about this user specifically, vault.

System repo contains: all `CLAUDE.md` files, README, install script, vault template, and the entire `spaces/meta/` contents (changelog, friction-log, proposals, design-notes, patterns).

Vault contains: all `raw/` content, all `wiki/` content, real `index.md` files, real `log.md` files.

## The public-meta discipline rule

The meta space is mostly *about Diego*, but its entries can incidentally reference vault content as illustration ("user's sister Sarah was the subject of a memo we mishandled"). For a public repo, this is unacceptable.

So the meta `CLAUDE.md` adds a load-bearing rule: every meta entry must be written as if a stranger will read it. No names, no specific projects, no quoted user content. The diagnostic value of meta entries lives in the *behavior of the system*, not the user's content; the latter can always be abstracted.

If a friction is incoherent without specifics, that's a sign it belongs in the vault's log, not the meta space. Some incidents are space-specific, not system-pattern.

## Tradeoffs being accepted

- **Setup is more complex.** `install.sh` does most of it, but the symlinks add a layer of indirection that didn't exist in v0.1.
- **Two locations to think about.** Diego must be careful never to write personal content into a system file. The root `CLAUDE.md` makes this rule explicit.
- **Meta entries are necessarily more abstract.** Some diagnostic richness is lost. The tradeoff is necessary for public-safety.
- **Backup of the vault is the user's separate problem.** The system repo handles itself via git; the vault needs Time Machine, encrypted cloud backup, or similar.

## What would tell us this was wrong

- If meta entries become so abstracted they're useless ("Diego did a thing in a space and it was bad" — too generic to act on).
- If the user finds themselves wanting to commit the vault to git (signal that a private repo would be better than a public one).
- If symlinks cause filesystem issues on the user's setup (rare on Mac/Linux; would matter on Windows).
- If personal content slips into the system repo — even once — and gets pushed before being caught. This would be a serious failure and prompt a redesign of the safeguards.
