# Diego

**D**aily **I**ntelligence **E**ngine & **G**eneral **O**rganizer.

A personal AI assistant built on the [LLM Wiki](https://github.com/karpathy/llm-wiki) pattern: a persistent, compounding knowledge base maintained by an LLM (via [Claude Code](https://docs.claude.com/en/docs/claude-code)), navigated and viewed via [Obsidian](https://obsidian.md).

This repo contains the **system** — the schema, the workflows, the design rationale, and the meta-loop that lets Diego improve itself over time. It contains *no* personal data. The actual content (voice memos, journal entries, wiki pages) lives in a separate, local-only vault on the user's machine.

## What this is

Diego is one entity organized into **spaces**:

- **`spaces/life/`** — personal life. Voice memos, journal, people, goals, health, decisions, themes. The user is the subject.
- **`spaces/work/`** — research and learning. Papers, concepts, sources, syntheses on whatever the user is going deep on. The world is the subject.
- **`spaces/meta/`** — Diego itself. Schema changes, friction reports, design rationale, the changelog of how Diego has evolved. **You** are the subject.

The top-level `CLAUDE.md` defines Diego's identity (constant) and the **router** that decides which space a request belongs to. Each space's `CLAUDE.md` defines that space's operational schema.

## The system/vault split

```
diego-system/        ← this repo. Schema, meta, design notes. Public-safe.
  CLAUDE.md          ← identity + router
  spaces/
    life/CLAUDE.md   ← schema only
    work/CLAUDE.md   ← schema only
    meta/            ← entire meta space lives here
  vault-template/    ← starter files for new installs
  install.sh         ← bootstraps a vault for you

diego-vault/         ← created by install.sh, lives on your machine. Never pushed.
  spaces/
    life/raw/, wiki/, index.md, log.md
    work/raw/, wiki/, index.md, log.md
  log.md
  (symlinks to system for CLAUDE.md files and the meta directory)
```

The vault contains the user's actual data. The system repo contains schemas and meta. Symlinks unify them at runtime. **Personal content never enters the system repo, ever.**

This split is what makes Diego safely shareable. You can fork this repo, get all the schemas and meta-improvements, and start your own Diego — without ever seeing my journal entries, and without my ever risking that your vault content ends up in my repo's history.

## Install

Requires: macOS or Linux, [Claude Code](https://docs.claude.com/en/docs/claude-code), [Obsidian](https://obsidian.md) (optional but recommended for browsing the vault).

```bash
# Clone the system repo somewhere stable
git clone https://github.com/YOURNAME/diego-system.git ~/diego-system

# Run the install script — it'll create the vault and set up symlinks
cd ~/diego-system
./install.sh ~/diego-vault

# Open your vault and start Claude Code
cd ~/diego-vault
claude
```

First message to Diego should be: **"read CLAUDE.md and tell me what you understand."** This forces a full schema load and surfaces any misreadings before you start operating.

Open `~/diego-vault` as an Obsidian vault for the graph view, wikilink navigation, and Web Clipper integration.

## Usage

You talk to Diego; Diego routes to the right space and operates there.

```
"Ingest the new memo in spaces/life/raw/voice"     → life ingest
"What was I thinking about Project X last week"     → life query
"Ingest this paper" (with PDF dropped in raw/papers) → work ingest
"That last entry felt off — let's talk about it"    → meta loop
"How does this paper relate to my Ridgeline thing"  → cross-space
```

Diego picks the space. When it picks wrong, you correct it, and the correction becomes a friction-log entry that improves the router over time.

## Improving Diego (the meta loop)

The interesting part. When something feels off about how Diego works, you tell it:

- **"Log a friction"** — adds a one-liner to `spaces/meta/friction-log.md`. No fix required. Most things go here.
- **"Let's tune Diego"** — full proposal cycle. Diego diagnoses, proposes a concrete schema change, you approve, Diego edits the schema and logs the change. Every change becomes a real git commit you can push.

A friction that recurs 3+ times graduates to a recognized pattern; a pattern triggers a schema proposal; an approved proposal gets committed and shipped.

This is what makes the system repo interesting on GitHub: the git log of `diego-system/` is essentially the biography of Diego — every schema change, when, why, what proposal it came from.

## Public-meta discipline

Because this repo is public-shareable, every meta entry (friction-log, proposals, design-notes, patterns) is written as if a stranger will read it. No real names, no specific projects, no quoted user content. Diagnostic content lives in the *behavior of the system*, not the user's content; the latter can always be abstracted.

The rule is enforced by `spaces/meta/CLAUDE.md`. If a friction can't be described without naming specifics, it belongs in the vault's log instead.

## Forking your own

You're welcome to fork this. If you do:

1. Clone your fork.
2. Run `./install.sh` against a vault path you own.
3. Start using it. Your schema will diverge from mine as you encounter different friction patterns.
4. If you build improvements you'd like to share back, open a PR with the schema changes (and only the schema changes — no vault content, please).

## Status

v0.1. Iterating in public. The schema is the *current* best guess at how Diego should work — expect it to change as friction accumulates.

## Background

Pattern based on Karpathy's [LLM Wiki](https://github.com/karpathy/llm-wiki). The shape of Diego — system/vault split, meta-as-space, router — is documented in `spaces/meta/design-notes/` if you want the rationale.
