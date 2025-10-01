# Manual Testing

## OS / root
- [X] everything from packages.txt are present
- [X] virtualization is available
- [X] `podman` is available
- [X] System Settings > About shows info about Orcus
- [X] `/etc/os-release` is accurate
- [X] the image tag in GRUB shows the correct version
- [X] `typst` is installed
- [X] `dockfmt` installed
- [X] `framework_tool` installed
- [X] firefox is removed

## Plasma
- [X] plasma defaults to dark mode
- [X] plasma has kara desktop switcher installed
- [X] plasma has updated keyboard shortcuts
  - [X] alt-tab behavior
  - [X] launch media key to show/hide desktop
  - [X] ctrl-alt-t to open konsole
- [X] custom icons are available
- [X] application launcher defaults to the framework icon
- [X] custom framework splash screen
  - [X] installed and available in system settings
  - [X] active by default
- [ ] custom framework color profile for 2K screen
  - [X] available with `colormgr get-profiles`
  - [ ] selected by default (try [this](https://www.reddit.com/r/kde/comments/1g9lyut/comment/lt768rp/)?)
- [X] custom framework speaker easy effects profile
  - [X] available in easy effects profile
  - [X] selected by default

## Dotfiles
- [X] the shell is `zsh` by default
  - [X] custom dotfiles are present
  - [X] ohmyzsh is active
  - [X] $HOME/.config/ohmyzsh-custom is being applied
- [X] doom emacs is setup
  - [X] doom emacs is available in `/usr/local/etc/emacs`
  - [X] emacs has the right custom icon in the launcher, switcher, and panel
  - [X] the doom updater automatically runs when a user logs in and notifies the user when doom is ready
  - [X] ~/.config/doom is available
  - [X] doom, not vanilla emacs, always loads
  - [X] the updater can be disabled
  - [X] nerd fonts are pre-installed (`.local/share/fonts/NFM.ttf`)
