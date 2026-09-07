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

Install the configuration packages on another machine:

```bash
./install.sh --dry-run nvim
./install.sh nvim
./install.sh all
```

The installers use GNU Stow and target the home directory. The Neovim
installer requires Neovim 0.11 or newer and backs up an existing
`~/.config/nvim` before migrating it to Stow-managed links. They do not modify
Neovim's plugin/cache directories.
