# Orcus

![Orcus](system_files/usr/share/pixmaps/orcus.png)

---

Published images: [ghcr.io/cameronwp/orcus](https://github.com/cameronwp/Orcus/pkgs/container/orcus)

![latest](https://ghcr-badge.egpl.dev/cameronwp/orcus/tags?color=%2344cc11&ignore=sha256*&n=1&label=latest&trim=)&nbsp;![container size](https://ghcr-badge.egpl.dev/cameronwp/orcus/size?color=%2344cc11&tag=latest&label=image+size&trim=)
---

A gently modified Kinoite build for my specific development needs and general preferences.

**Features**:
* layered on top of [ublue-os/kinoite-main](https://github.com/ublue-os/main/pkgs/container/kinoite-main)
* lots of my favoriate utilities and programming langauges, see [packages.txt](build_files/packages.txt)
* ready-to-use virtualization
* `zsh` is the default shell. vim mode is on by default
* defaults to a dark plasma theme with a better desktop selector and lightly modified shortcuts
  - `alt-tab` window switching that behaves like GNOME (sorry, I'm just used to it)
  - `ctrl-alt-t` to open Konsole
  - Launch Media (usually F12) shows desktop
* a few default dotfiles
* removes the default Firefox installation that's missing codecs - install the Firefox flatpak from Discover instead

See [TESTING.md](TESTING.md) for a full list of changes.

See the template's [README](docs/README.md) for more info.

*Orcus logo modified from: https://thesolarsystem.fandom.com/wiki/Orcus*
