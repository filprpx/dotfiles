#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./install-nvim.sh [--dry-run] [--install-deps]

Options:
  --dry-run       Show what would happen without changing the system.
  --install-deps  Install missing Ubuntu packages with apt (requires sudo).
EOF
}

dry_run=false
install_deps=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=true ;;
    --install-deps) install_deps=true ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n\n' "$arg" >&2; usage >&2; exit 2 ;;
  esac
done

repo_root=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source_config="$repo_root/nvim/.config/nvim"
config_parent="${XDG_CONFIG_HOME:-$HOME/.config}"
target_config="$config_parent/nvim"

if [[ ! -d "$source_config" ]]; then
  printf 'Neovim config not found: %s\n' "$source_config" >&2
  exit 1
fi

missing_commands=()
for command in git curl unzip gcc make rg; do
  command -v "$command" >/dev/null 2>&1 || missing_commands+=("$command")
done

fd_command=''
if command -v fd >/dev/null 2>&1; then
  fd_command=fd
elif command -v fdfind >/dev/null 2>&1; then
  fd_command=fdfind
else
  missing_commands+=(fd)
fi

if (( ${#missing_commands[@]} > 0 )); then
  printf 'Missing commands: %s\n' "${missing_commands[*]}"
  if "$install_deps"; then
    if ! command -v apt-get >/dev/null 2>&1; then
      printf 'Cannot install dependencies: apt-get is unavailable.\n' >&2
      exit 1
    fi
    if ! command -v sudo >/dev/null 2>&1; then
      printf 'Cannot install dependencies: sudo is unavailable.\n' >&2
      exit 1
    fi
    if "$dry_run"; then
      printf 'Dry run: would install git curl unzip build-essential ripgrep fd-find.\n'
    else
      sudo apt-get update
      sudo apt-get install -y git curl unzip build-essential ripgrep fd-find
    fi
  else
    printf 'Run with --install-deps, or install them manually.\n' >&2
    exit 1
  fi
fi

if ! command -v nvim >/dev/null 2>&1; then
  printf 'Neovim is not installed. Install Neovim 0.11 or newer, then rerun this script.\n' >&2
  exit 1
fi

nvim_version=$(nvim --version | sed -n '1s/^NVIM v//p')
if [[ ! "$nvim_version" =~ ^([0-9]+)\.([0-9]+) ]]; then
  printf 'Could not determine the Neovim version.\n' >&2
  exit 1
fi
nvim_major=${BASH_REMATCH[1]}
nvim_minor=${BASH_REMATCH[2]}
if (( nvim_major == 0 && nvim_minor < 11 )); then
  printf 'Neovim %s is too old; this config requires Neovim 0.11 or newer.\n' "$nvim_version" >&2
  exit 1
fi

source_real=$(readlink -f "$source_config")
if [[ -e "$target_config" || -L "$target_config" ]]; then
  target_real=$(readlink -f "$target_config" 2>/dev/null || true)
  if [[ "$target_real" == "$source_real" ]]; then
    printf 'Neovim config is already linked to this repository.\n'
    exit 0
  fi
fi

timestamp=$(date +%Y%m%d-%H%M%S)
backup="$config_parent/nvim.backup-$timestamp"
while [[ -e "$backup" || -L "$backup" ]]; do
  timestamp=$(date +%Y%m%d-%H%M%S)
  backup="$config_parent/nvim.backup-$timestamp"
  sleep 1
done

if "$dry_run"; then
  printf 'Neovim %s detected.\n' "$nvim_version"
  printf 'Dry run: would create %s\n' "$target_config"
  if [[ -e "$target_config" || -L "$target_config" ]]; then
    printf 'Dry run: would move existing config to %s\n' "$backup"
  fi
  printf 'Dry run: would link %s -> %s\n' "$target_config" "$source_config"
  exit 0
fi

mkdir -p "$config_parent"
if [[ -e "$target_config" || -L "$target_config" ]]; then
  mv -- "$target_config" "$backup"
  printf 'Backed up existing config to %s\n' "$backup"
fi
ln -s -- "$source_config" "$target_config"

printf 'Installed Neovim config: %s -> %s\n' "$target_config" "$source_config"
printf 'Neovim plugin installation will occur on first launch.\n'

if [[ "$(uname -r)" =~ [Mm]icrosoft|[Ww][Ss][Ll] ]] && ! command -v win32yank.exe >/dev/null 2>&1; then
  printf 'WSL note: win32yank.exe was not found; clipboard support may require OSC52 or win32yank.\n'
fi

printf 'Optional detected fd command: %s\n' "${fd_command:-not found}"
