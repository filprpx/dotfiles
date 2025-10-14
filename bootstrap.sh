#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${HOME}/dotfiles"
PACKAGES=(hypr waybar nvim shell)  # add more package folders here later
BACKUP="${HOME}/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "[dotfiles] repo: ${DOTFILES}"
cd "$DOTFILES"

# Ensure package directories exist; harmless if already there
for pkg in "${PACKAGES[@]}"; do
  case "$pkg" in
    hypr)   mkdir -p "$DOTFILES/$pkg/.config/hypr" ;;
    waybar) mkdir -p "$DOTFILES/$pkg/.config/waybar" ;;
    nvim)   mkdir -p "$DOTFILES/$pkg/.config/nvim" ;;
    shell)  mkdir -p "$DOTFILES/$pkg" ;;
    *)      mkdir -p "$DOTFILES/$pkg" ;;
  esac
done

# Helper: back up conflicting real files (not links), then stow
mkdir -p "$BACKUP"
for pkg in "${PACKAGES[@]}"; do
  echo -e "\n[stow] preview $pkg"
  # Dry-run to capture conflicts
  if ! stow -nv "$pkg" > /tmp/stow_preview 2>&1; then
    # Some stow versions return nonzero even on harmless previews; that's OK
    :
  fi

  # Move any blocking files to backup
  grep -E 'existing target is neither a link nor a directory: (.+)$' /tmp/stow_preview \
    | sed -E 's/.*: (.+)$/\1/' \
    | while read -r path; do
        echo "[backup] $path -> $BACKUP$path"
        mkdir -p "$BACKUP/$(dirname "$path")"
        mv "$HOME/$path" "$BACKUP/$path"
      done

  echo "[stow] apply $pkg"
  # Use --adopt so if there are user files already on the machine, they get pulled into the repo
  stow -v --adopt "$pkg"
done

echo -e "\n[done] backup dir (if any conflicts): $BACKUP"
EOS

chmod +x ~/dotfiles/bootstrap.sh

