#!/bin/bash

set -ouex pipefail


# I'm not 100% sure why we need this. there seems to be a difference between the local and github build environments at this point
# also, the -p should mean we don't need to check, but the build environment in github seems to get angry about mkdir -p /usr/local/bin
if [ ! -d /usr/local/bin ]; then
  mkdir -p /usr/local/bin
fi


###
### various vanity changes
###

/ctx/branding.sh


###
### manage root-level packages
###

# packages from fedora repos
dnf5 install -y $(</ctx/packages.txt)

# install VS Code
# https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf5 install -y code

# install tailscale
# https://tailscale.com/kb/1511/install-fedora-2
dnf5 config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf5 install -y tailscale
# uncomment to turn on tailscale by default
# systemctl enable tailscaled

# install ghostty
# https://ghostty.org/docs/install/binary#fedora
dnf5 -y copr enable scottames/ghostty
dnf5 install -y ghostty
dnf5 copr remove scottames/ghostty

# remove the firefox RPM that's missing codecs
dnf5 remove -y firefox

# put back the Discover backend that shows OS updates in the GUI
dnf5 install -y plasma-discover-rpm-ostree


###
### virtualization and containers
###

dnf5 group install -y --with-optional virtualization
systemctl enable libvirtd

systemctl enable podman.socket


###
### Doom Emacs
###

git clone --depth 1 https://github.com/doomemacs/doomemacs /usr/local/etc/emacs

# https://github.com/jessfraz/dockfmt/releases
DOCKFMT_SHA256="f6bc025739cf4f56287e879c75c11cc73ebafdf93a57c9bcd8805d1ab82434a0"
curl -fSL "https://github.com/jessfraz/dockfmt/releases/download/v0.3.3/dockfmt-linux-amd64" -o "/tmp/dockfmt"
echo "${DOCKFMT_SHA256} /tmp/dockfmt" | sha256sum -c -
install /tmp/dockfmt /usr/local/bin/

# remove old desktop files for emacs before copying our custom file over later
rm /usr/share/applications/emacs.desktop /usr/share/applications/emacs-mail.desktop

# update doom when users log in
systemctl --global enable doom-update.service


###
### oh-my-zsh
###

git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh /usr/local/etc/ohmyzsh


###
### framework
###

# https://github.com/FrameworkComputer/framework-system?tab=readme-ov-file#installation
wget -q -O /tmp/framework_tool https://github.com/FrameworkComputer/framework-system/releases/latest/download/framework_tool
install /tmp/framework_tool /usr/local/bin/


###
### gamescope
###

FEDORA_VER="$(rpm -E %fedora)"

# Terra repo (gamescope build) + Bazzite COPR (session packages)
dnf5 -y install --nogpgcheck \
  --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
  terra-release terra-release-extras
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-terra"${FEDORA_VER}"*
dnf5 -y copr enable ublue-os/bazzite

# Keep Fedora's gamescope from being pulled back in
# (setopt replaces the exclude list; merge if you already set excludes)
dnf5 -y config-manager setopt "fedora*".exclude="gamescope" "updates*".exclude="gamescope"

# Replace Fedora gamescope if the base image has it, otherwise install fresh
if rpm -q --quiet gamescope; then
  dnf5 -y swap --repo=terra-extras gamescope terra-gamescope
fi

dnf5 -y install \
  terra-gamescope.x86_64 \
  terra-gamescope-libs.x86_64 \
  terra-gamescope-libs.i686 \
  gamescope-session \
  gamescope-session-steam

# Steam bootstrap so the first session launch doesn't have to download the client
mkdir -p /usr/share/gamescope-session-plus
curl --retry 3 -Lo /usr/share/gamescope-session-plus/bootstrap_steam.tar.gz \
  https://large-package-sources.nobaraproject.org/bootstrap_steam.tar.gz

# Work out the session's .desktop name from the package
SESSION_DESKTOP="$( (rpm -ql gamescope-session-steam | grep -E '/wayland-sessions/[^/]+\.desktop$' || true) | head -n1 | xargs -r basename)"
if [[ -z "${SESSION_DESKTOP}" ]]; then
  echo "ERROR: gamescope-session-steam installed no wayland-sessions .desktop" >&2
  exit 1
fi
echo "Gamescope session: ${SESSION_DESKTOP}"

# ── Session switching (Steam "Switch to Desktop" <-> Plasma) ──

sed -i "s|@SESSION@|${SESSION_DESKTOP}|g" \
  /usr/bin/steamos-session-select /usr/libexec/set-sddm-session
chmod 0755 /usr/bin/steamos-session-select /usr/libexec/set-sddm-session

chmod 0440 /etc/sudoers.d/steamos-session-select
visudo -cf /etc/sudoers.d/steamos-session-select

# ── Clean up repos so they don't leak into the running system ──
dnf5 -y copr disable ublue-os/bazzite
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/terra.repo /etc/yum.repos.d/terra-extras.repo


###
### misc
###

# install typst
wget -q -O /tmp/typst-aarch64-unknown-linux-musl.tar.xz https://github.com/typst/typst/releases/latest/download/typst-aarch64-unknown-linux-musl.tar.xz
tar -xf /tmp/typst-aarch64-unknown-linux-musl.tar.xz -C /tmp
install /tmp/typst-aarch64-unknown-linux-musl/typst /usr/local/bin/

# lemonade server
# uninstalling in lieu of using a distrobox
# dnf install -y /ctx/rpms/lemonade-server-10.0.0.x86_64.rpm


###
### clean up
###

dnf5 clean all
