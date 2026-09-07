#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run] PACKAGE...

Packages:
  nvim      Migrate Neovim and Stow its configuration
  foot      Stow Foot configuration
  hypr      Stow Hyprland configuration
  opencode  Stow OpenCode configuration
  all       Install all packages
EOF
}

dry_run=false
packages=()
for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=true ;;
    -h|--help) usage; exit 0 ;;
    *) packages+=("$arg") ;;
  esac
done

if ((${#packages[@]} == 0)); then
  usage >&2
  exit 2
fi

repo_root=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
if ((${#packages[@]} == 1)) && [[ ${packages[0]} == all ]]; then
  packages=(nvim foot hypr opencode)
fi

for package in "${packages[@]}"; do
  case "$package" in
    nvim|foot|hypr|opencode) ;;
    *) printf 'Unknown package: %s\n' "$package" >&2; usage >&2; exit 2 ;;
  esac

  args=()
  "$dry_run" && args+=(--dry-run)
  "$repo_root/install-$package.sh" "${args[@]}"
done
