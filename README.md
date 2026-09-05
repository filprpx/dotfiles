# Personal configuration

This repository contains personal overrides on top of Omarchy Quattro.

Omarchy owns its defaults. The files here are only the user-specific configuration
that is intentionally kept across updates.

## Packages

- `hypr`: Hyprland overrides
- `nvim`: Neovim and LazyVim configuration
- `foot`: Foot terminal configuration
- `opencode`: OpenCode configuration and instructions

The configuration files under `~/.config` are linked to this repository. Do not
replace Omarchy's files under `/usr/share/omarchy` or `~/.local/share/omarchy`.

## Neovim Setup

Install only the Neovim configuration on another machine:

```bash
./install-nvim.sh --dry-run
./install-nvim.sh
```

The installer requires Neovim 0.11 or newer. It backs up an existing
`~/.config/nvim` before creating the repository link and never modifies
Neovim's plugin/cache directories. On Ubuntu, missing command-line tools can
be installed explicitly with `--install-deps`.
