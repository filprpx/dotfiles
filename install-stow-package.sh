#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s PACKAGE [--dry-run]\n' "$(basename "$0")"
}

if (($# < 1 || $# > 2)); then
  usage >&2
  exit 2
fi

package=$1
dry_run=false
if (($# == 2)); then
  [[ $2 == --dry-run ]] || { usage >&2; exit 2; }
  dry_run=true
fi

repo_root=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

[[ -d "$repo_root/$package" ]] || {
  printf 'Stow package not found: %s\n' "$package" >&2
  exit 1
}
command -v stow >/dev/null 2>&1 || {
  printf 'Required command not found: stow\n' >&2
  exit 1
}

stow_args=(--restow --target="$HOME" "$package")
if "$dry_run"; then
  stow_args=(--simulate --verbose "${stow_args[@]}")
  printf 'Dry run: '
fi

cd "$repo_root"
stow "${stow_args[@]}"
