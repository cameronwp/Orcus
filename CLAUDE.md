# CLAUDE.md

Custom Universal Blue image built on **ublue Kinoite** (Fedora Atomic, KDE Plasma), Fedora 44.
Target machine: AMD APU, SDDM display manager. Built both locally and in GitHub Actions.

## Repo layout

- `Containerfile` — image definition; build context is mounted at `/ctx`
- `build_files/build.sh` — main build script (runs as `/ctx/build.sh`)
- `build_files/packages.txt` — Fedora packages installed with `dnf5 install -y $(</ctx/packages.txt)`
- `build_files/branding.sh` — vanity/branding changes
- `system_files/` — files copied into the image root (unit files, scripts, desktop entries, sudoers, etc.)

Adjust these paths if the repo differs; keep this section accurate.

## BUILDING - IMPORTANT

YOU CANNOT BUILD ON THIS MACHINE. Prompt the user to build and test.

## Filesystem rules (bootc / Fedora Atomic) — most important

- `/usr` is immutable and replaced on every image update. **Everything the image ships goes under `/usr`.**
  - Binaries → `/usr/bin`, helper scripts → `/usr/libexec`, data/apps → `/usr/share`, user units → `/usr/lib/systemd/user`.
- **Never write to `/usr/local` or `/var` in the build.** `/usr/local` is a symlink to `/var/usrlocal`; bootc only copies `/var` content on *first install*, so later image changes never reach existing machines. In GitHub builds `/var/usrlocal` may not exist, so `/usr/local` is a dangling symlink and `mkdir -p` fails.
- `/etc` in the image is fine (3-way merged on update), but prefer `/usr/lib/...` equivalents when the tool supports them.
- Anything that must be writable at runtime (caches, package installs, state) goes in `$HOME`, redirected via env vars — see Doom and oh-my-zsh below.
- Machine-specific config (e.g. anything containing the username) stays **out of the image**.
- Final Containerfile step should be `RUN bootc container lint`; treat its warnings about `/var` content as bugs.

## build.sh conventions

- Runs with `set -ouex pipefail`; every command must succeed.
- Use `dnf5`. Third-party repos/COPRs are enabled only for the steps that need them, then disabled or removed so they don't leak into the running system.
- `dnf5 config-manager setopt <repo>.exclude=...` **replaces** the exclude list — merge with any existing excludes.
- Downloaded binaries: pin versions and verify sha256 where possible (see dockfmt), download the **x86_64** asset, `install` into `/usr/bin`.
- End with `dnf5 clean all`.

## Gamescope / Steam Gaming Mode

Goal: an SDDM-selectable Steam gamescope session. No autologin; the user picks the session at the SDDM login screen.

Packages:
- Steam comes from RPM Fusion (installed earlier in the build).
- gamescope comes from **Terra** (`terra-gamescope`, `terra-gamescope-libs` x86_64 + i686), replacing Fedora's `gamescope` via `dnf5 swap` (conditional on Fedora's being present). Fedora's gamescope is excluded from `fedora*`/`updates*` repos so it can't return. `gamescope` must not appear in `packages.txt`.
- Session: `gamescope-session` + `gamescope-session-steam`, which resolve from **Terra**. The package installs `/usr/share/wayland-sessions/gamescope-session-steam.desktop`, which is the SDDM entry; the build fails if it's missing.
- Terra is installed via `terra-release`/`terra-release-extras`, keys imported with `rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-terra${FEDORA_VER}*`, and disabled at the end of the section.

Session switching:
- No custom scripts. Steam's "Switch to Desktop" calls the package's `/usr/bin/steamos-session-select`, which runs `steam -shutdown`; the session ends and SDDM shows the login screen.
- Don't ship a file at `/usr/bin/steamos-session-select`; the package install overwrites it. For custom switching behaviour, the package's script execs `/usr/libexec/os-session-select` if present.
- Removed 2026-09-30: autologin-based switching (`set-sddm-session`, sudoers rule, `enter-gaming-mode.desktop`), the `ublue-os/bazzite` COPR, and the 1.4 GB `bootstrap_steam.tar.gz` download (nothing referenced it).

Known noise:
- Terra mirror curl errors (unresolvable `mirror.us.zephyra.lol`, checksum mismatches on stale mirrors) are harmless as long as the transaction ends in `Complete!`; dnf5 falls back to other mirrors.

## Doom Emacs

- Core cloned (depth 1, keep `.git`) to `/usr/share/doomemacs`; `/usr/bin/doom` symlinks to its `bin/doom`. Core updates come only from image rebuilds.
- Writable state redirected per user via `DOOMLOCALDIR=${HOME}/.local/share/doomemacs/` and `DOOMPROFILELOADFILE=${HOME}/.local/share/doomemacs/profiles/load.el`, set in **both** `/usr/lib/environment.d/60-doomemacs.conf` (graphical session + systemd user services) and `/etc/profile.d/doomemacs.sh` (TTY/SSH).
- User config stays in `~/.config/doom` and installs many packages.
- `doom-update.service` (user unit, `systemctl --global enable`) runs **`doom sync` only** at login — never `doom upgrade`/`git pull`, since core is read-only. This keeps user packages in step with the core. It has worked reliably; don't remove it.
- Custom `emacs.desktop` launches `emacs --init-directory=/usr/share/doomemacs %F`; the stock `emacs.desktop`/`emacs-mail.desktop` are deleted in the build.

## oh-my-zsh

- Cloned (depth 1) to `/usr/share/oh-my-zsh`.
- zshrc sets, before sourcing: `ZSH=/usr/share/oh-my-zsh`, `ZSH_CACHE_DIR` and `ZSH_COMPDUMP` under `~/.cache/oh-my-zsh`, `ZSH_CUSTOM=~/.config/ohmyzsh-custom`, `zstyle ':omz:update' mode disabled`, and `DISABLE_AUTO_UPDATE=true`. (Planned with the Doom move: `alias emacs='emacs --init-directory=/usr/share/doomemacs'`.)
- `/etc/skel` only affects new users; existing `~/.zshrc` files need manual edits.

## Migration in progress (as of 2026-09-30 — verify against current files)

- [ ] Remove the `mkdir -p /usr/local/bin` guard at the top of `build.sh`.
- [ ] Move all `/usr/local/bin` installs (dockfmt, framework_tool, typst) to `/usr/bin`.
- [x] Fix typst: it downloads the **aarch64** tarball; use `typst-x86_64-unknown-linux-musl.tar.xz`.
- [ ] Move Doom to `/usr/share/doomemacs` and oh-my-zsh to `/usr/share/oh-my-zsh` as described above; update `doom-update.service`, `emacs.desktop`, and zshrc.
- [ ] Add `RUN bootc container lint` as the final Containerfile step.
- [x] Drop the `ublue-os/bazzite` COPR from the gamescope section (confirm with a build).
- [ ] On existing machines after rollout: `sudo rm -rf /var/usrlocal/etc/{emacs,ohmyzsh}` once the new paths work.

## Working style

- Make minimal, targeted edits to `build.sh`; keep its `###` section structure.
- When a build fails, read the actual dnf5 transaction/conflict output before changing anything.
- Don't add machine-specific or user-specific values to the image.