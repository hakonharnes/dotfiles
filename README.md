# Dotfiles

A curated collection of my personal dotfiles and configurations for MacOS.

## Overview

- **aerospace**: Window manager (for [my fork](https://github.com/hakonharnes/AeroSpace))
- **glint**: Window borders ([glint](https://github.com/hakonharnes/homebrew-tap), `brew install hakonharnes/tap/glint`)
- **ghostty**: Terminal emulator
- **nvim**: Neovim editor
- **sioyek**: PDF reader
- **tmux**: Terminal multiplexer
- **yazi**: Terminal file manager
- **starship**: Shell prompt
- **zsh**: Shell
- **.local/bin**: `kill-ghost-windows` (AeroSpace's empty windows; needs `jq`)

The status bar, [vibebar](https://git.pillar.as/hakonh/vibebar), is its own
repository with its own setup; the AeroSpace config here leaves room for it
(32 pt at the top) and restarts it on `alt-shift-backspace`.

## Installation

The easiest way to install these dotfiles is to use [Stow](https://www.gnu.org/software/stow/):

```sh
git clone https://github.com/hakonharnes/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .
```

`stow .` links every file here into your home folder and refuses to replace
files that are already there: move those aside first, or stow a part, e.g.
`stow --adopt .` to take yours in and then look at `git diff`.
