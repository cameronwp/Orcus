# Orcus

![Orcus](system_files/usr/share/pixmaps/orcus.png)

---

Published images: [ghcr.io/cameronwp/orcus](https://github.com/cameronwp/Orcus/pkgs/container/orcus)

![latest](https://ghcr-badge.egpl.dev/cameronwp/orcus/tags?color=%2344cc11&ignore=sha256*&n=1&label=latest&trim=)&nbsp;![container size](https://ghcr-badge.egpl.dev/cameronwp/orcus/size?color=%2344cc11&tag=latest&label=image+size&trim=)
---

A gently modified Kinoite build for my specific development needs, general preferences, and [Framework 13 laptop](https://frame.work/laptop13).

### Features

* layered on top of [ublue-os/kinoite-main](https://github.com/ublue-os/main/pkgs/container/kinoite-main)
* lots of my favorite utilities and programming langauges, see [packages.txt](build_files/packages.txt)
  - runtimes, compilers, dependency management, and utilities for Common Lisp, Golang, Julia, Python, Node, Rust
  - useful networking tools
  - ImageMagick, [GIMP](https://www.gimp.org), and [Inkscape](https://inkscape.org/) for image editing
  - apps like [Stellarium](https://stellarium.org/) (of course), [Steam](https://store.steampowered.com/)
  - [Sigil](https://sigil-ebook.com/) for epub editing
* ([doom](https://github.com/doomemacs/doomemacs)) emacs comes pre-installed
    - there's a service that syncs your Doom packages at every login. disable with `systemctl --user disable doom-updater.service`
* ready-to-use virtualization
* removes the default Firefox installation that's missing codecs - you need to install the Firefox flatpak from Discover instead

#### Look and Feel

* defaults to a dark plasma theme with a [better desktop selector](https://store.kde.org/p/2200890) and lightly modified shortcuts
  - `alt-tab` window switching that behaves like GNOME (sorry, I'm just used to it)
  - `ctrl-alt-t` to open Konsole
  - Launch Media (usually F12) shows desktop
* `zsh` is the default shell with:
  - [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and a couple useful plugins pre-installed
  - vim mode
* a few default dotfiles
  - tmux, vim, zsh

#### Framework-specific

* sound profile specific to Laptop 13
* display profile specific to Laptop 13 (WIP)
* the application launcher uses the Framework icon
* the KDE splash screen uses the Framework wordmark and spinning icon
  - modified from [link](https://github.com/dblanque/framework-kde-splash)
* installs [`framework_tool`](https://github.com/FrameworkComputer/framework-system?tab=readme-ov-file#installation)

See [TESTING.md](TESTING.md) for a more detailed list of changes.

See the template's [README](docs/README.md) for more info.

*Orcus logo modified from: https://thesolarsystem.fandom.com/wiki/Orcus*
