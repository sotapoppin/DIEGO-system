#!/usr/bin/env bash
#
# Diego install script.
#
# Bootstraps a Diego vault by:
#   1. Creating the vault directory structure from vault-template/
#   2. Symlinking schema files (CLAUDE.md, meta/) from the system repo
#
# Usage:
#   ./install.sh /absolute/path/to/your/vault
#
# Or, with no args, it'll prompt for the vault location.
#
# Idempotent: re-running it is safe. It won't overwrite existing vault content,
# only create missing directories and refresh symlinks.

set -euo pipefail

# --- Resolve paths ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYSTEM_REPO="$SCRIPT_DIR"
TEMPLATE_DIR="$SYSTEM_REPO/vault-template"

if [[ $# -ge 1 ]]; then
  VAULT_DIR="$1"
else
  read -rp "Where should the vault live? (e.g. ~/diego-vault): " VAULT_INPUT
  # Expand ~ manually — the shell won't do it on a read variable
  VAULT_DIR="${VAULT_INPUT/#\~/$HOME}"
fi

# Make absolute
VAULT_DIR="$(cd "$(dirname "$VAULT_DIR")" 2>/dev/null && pwd)/$(basename "$VAULT_DIR")" \
  || VAULT_DIR="$VAULT_INPUT"

echo ""
echo "System repo: $SYSTEM_REPO"
echo "Vault:       $VAULT_DIR"
echo ""

# --- Sanity check ---
if [[ ! -d "$TEMPLATE_DIR" ]]; then
  echo "ERROR: vault-template/ not found in $SYSTEM_REPO"
  echo "Are you running this from inside the diego-system repo?"
  exit 1
fi

# --- Confirm ---
if [[ ! -d "$VAULT_DIR" ]]; then
  echo "Vault does not exist yet — will create it."
else
  echo "Vault exists. Will only fill in missing pieces (idempotent)."
fi

read -rp "Proceed? [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

# --- Create vault directories ---
echo ""
echo "Creating vault directories..."
mkdir -p "$VAULT_DIR"

# Copy template structure (directories + starter files like index.md, log.md)
# We use cp -n so existing files in the vault are never overwritten.
cp -Rn "$TEMPLATE_DIR/." "$VAULT_DIR/"

# --- Create symlinks back to the system repo ---
echo "Creating symlinks to system repo..."

# Helper: create symlink, replacing any existing symlink (but not real files)
link() {
  local target="$1"
  local linkpath="$2"

  if [[ -L "$linkpath" ]]; then
    rm "$linkpath"
  elif [[ -e "$linkpath" ]]; then
    echo "  WARNING: $linkpath exists and is not a symlink. Skipping."
    echo "           If you want it linked, move/delete it manually and re-run."
    return
  fi

  ln -s "$target" "$linkpath"
  echo "  $linkpath -> $target"
}

# Root CLAUDE.md
link "$SYSTEM_REPO/CLAUDE.md" "$VAULT_DIR/CLAUDE.md"

# Per-space CLAUDE.md files
link "$SYSTEM_REPO/spaces/life/CLAUDE.md" "$VAULT_DIR/spaces/life/CLAUDE.md"
link "$SYSTEM_REPO/spaces/work/CLAUDE.md" "$VAULT_DIR/spaces/work/CLAUDE.md"

# The meta space is entirely a symlink — its content lives in the system repo
if [[ -L "$VAULT_DIR/spaces/meta" ]]; then
  rm "$VAULT_DIR/spaces/meta"
elif [[ -e "$VAULT_DIR/spaces/meta" ]]; then
  echo "  WARNING: $VAULT_DIR/spaces/meta exists and is not a symlink."
  echo "           The meta space must be a symlink to $SYSTEM_REPO/spaces/meta."
  echo "           Move/delete it manually and re-run."
else
  ln -s "$SYSTEM_REPO/spaces/meta" "$VAULT_DIR/spaces/meta"
  echo "  $VAULT_DIR/spaces/meta -> $SYSTEM_REPO/spaces/meta"
fi

# Skills directory — canonical operational skills (/commit, /push, /wrap, etc.)
# live in the system repo and are symlinked into the vault's .claude/skills/ so
# updates to skills propagate to every install. Per-install Claude Code settings
# (.claude/settings.json) stay local and are not managed here.
mkdir -p "$VAULT_DIR/.claude"
if [[ -L "$VAULT_DIR/.claude/skills" ]]; then
  rm "$VAULT_DIR/.claude/skills"
elif [[ -e "$VAULT_DIR/.claude/skills" ]]; then
  echo "  WARNING: $VAULT_DIR/.claude/skills exists and is not a symlink."
  echo "           Move or delete it manually and re-run to use the canonical skills."
else
  ln -s "$SYSTEM_REPO/skills" "$VAULT_DIR/.claude/skills"
  echo "  $VAULT_DIR/.claude/skills -> $SYSTEM_REPO/skills"
fi

# --- Vault .gitignore (just in case the user runs `git init` in the vault) ---
if [[ ! -f "$VAULT_DIR/.gitignore" ]]; then
  cat > "$VAULT_DIR/.gitignore" <<'EOF'
# This vault contains personal content. By default, ignore EVERYTHING
# except the .gitignore itself. If you want to track parts of the vault
# in a separate private repo, edit this file.
*
!.gitignore
EOF
  echo "  Created defensive .gitignore in vault (ignores everything by default)."
fi

# --- Done ---
echo ""
echo "Done."
echo ""
echo "Next steps:"
echo "  cd $VAULT_DIR"
echo "  claude"
echo ""
echo "Then say: 'read CLAUDE.md and tell me what you understand.'"
