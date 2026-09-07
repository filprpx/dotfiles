#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./install-nvim.sh [--dry-run]

The installer backs up an existing ~/.config/nvim before migrating it to
Stow-managed symlinks.
EOF
}

dry_run=false
for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=true ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done

repo_root=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source_config="$repo_root/nvim/.config/nvim"
target_config="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

[[ -d "$source_config" ]] || {
  printf 'Neovim package not found: %s\n' "$source_config" >&2
  exit 1
}
command -v stow >/dev/null 2>&1 || {
  printf 'Required command not found: stow\n' >&2
  exit 1
}
command -v nvim >/dev/null 2>&1 || {
  printf 'Required command not found: nvim\n' >&2
  exit 1
}

backup=''
if [[ -e "$target_config" || -L "$target_config" ]]; then
  timestamp=$(date +%Y%m%d-%H%M%S)
  backup="${target_config}.backup-${timestamp}"
  while [[ -e "$backup" || -L "$backup" ]]; do
    timestamp=$(date +%Y%m%d-%H%M%S)
    backup="${target_config}.backup-${timestamp}"
    sleep 1
  done
fi

if "$dry_run"; then
  printf 'Neovim %s detected.\n' "$(nvim --version | sed -n '1s/^NVIM v//p')"
  [[ -n "$backup" ]] && printf 'Dry run: would move %s to %s\n' "$target_config" "$backup"
  printf 'Dry run: would Stow the nvim package into %s\n' "$HOME"
  cd "$repo_root"
  stow --simulate --verbose --restow --target="$HOME" nvim
  exit 0
fi

if [[ -n "$backup" ]]; then
  mv -- "$target_config" "$backup"
  printf 'Backed up existing Neovim config to %s\n' "$backup"
fi

cd "$repo_root"
stow --restow --target="$HOME" nvim
printf 'Installed Neovim package with Stow.\n'
