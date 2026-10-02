# Orcus

![Orcus](system_files/usr/share/pixmaps/orcus.png)

Orcus is a [dwarf planet](https://en.wikipedia.org/wiki/Orcus_(dwarf_planet)) and the name of this Fedora spin.

*The planet artwork was modified from: [here](https://thesolarsystem.fandom.com/wiki/Orcus)*

---

Published images: [ghcr.io/cameronwp/orcus](https://github.com/cameronwp/Orcus/pkgs/container/orcus)

![latest](https://ghcr-badge.egpl.dev/cameronwp/orcus/tags?color=%2344cc11&ignore=sha256*&n=1&label=latest&trim=)&nbsp;![container size](https://ghcr-badge.egpl.dev/cameronwp/orcus/size?color=%2344cc11&tag=latest&label=image+size&trim=)

---

A gently modified Kinoite build for my specific development needs, general preferences, and [Framework 13 laptop](https://frame.work/laptop13).

### Features

* layered on top of [ublue-os/kinoite-main](https://github.com/ublue-os/main/pkgs/container/kinoite-main) with the penultimate version of Fedora
* lots of my favorite utilities and programming langauges, see [packages.txt](build_files/packages.txt)
  - runtimes, compilers, dependency management, and utilities for Common Lisp, Golang, Julia, Python, Node, Rust
  - useful networking tools
  - ImageMagick, [GIMP](https://www.gimp.org), and [Inkscape](https://inkscape.org/) for image editing
  - apps like [Stellarium](https://stellarium.org/) (of course), [Steam](https://store.steampowered.com/)
  - [Sigil](https://sigil-ebook.com/) for epub editing
* ([doom](https://github.com/doomemacs/doomemacs)) emacs comes pre-installed
    - there's a service that syncs your Doom packages at every login. disable with `systemctl --user disable doom-update.service`
    - Doom core is read-only in `/usr/share/doomemacs` and updates with the image; your packages live in `~/.local/share/doomemacs`, your config in `~/.config/doom`
* ready-to-use virtualization
* removes the default Firefox installation that's missing codecs - you need to install the Firefox flatpak from Discover instead
* defaults to [ghostty](https://ghostty.org/) terminal
* The option to boot into Steam Gamescope from SDDM

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
* display profile specific to Laptop 13 2K screen (WIP)
* the application launcher uses the Framework icon
* the KDE splash screen uses the Framework wordmark and spinning icon
  - modified from [link](https://github.com/dblanque/framework-kde-splash)
* installs [`framework_tool`](https://github.com/FrameworkComputer/framework-system?tab=readme-ov-file#installation)

### Switching to Orcus

Images are signed with [cosign.pub](cosign.pub) in CI. Switch with signature verification enforced:

```bash
sudo bootc switch --enforce-container-sigpolicy ghcr.io/cameronwp/orcus:latest
```

If you're coming from a non-Orcus image, the signing policy isn't on the machine yet. Run the command without `--enforce-container-sigpolicy` first, reboot, then run it again with the flag and reboot.

Confirm verification is on (look for `"signature": "containerPolicy"`):

```bash
sudo bootc status --format=json | jq '.status.booted.image.image'
```

> [!WARNING]
> Any later `bootc switch` without `--enforce-container-sigpolicy` (e.g. to test a local build) silently turns verification off. Re-run the command above to turn it back on.

See [TESTING.md](TESTING.md) for a more detailed list of changes.

See the template's [README](docs/README.md) for more info.
