#!/bin/bash

set -ouex pipefail


FEDORA_VER="$(rpm -E %fedora)"


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

# read-only core doom. the per-user state lives in $DOOMLOCALDIR (see /usr/lib/environment.d/60-doomemacs.conf)
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/doomemacs/doomemacs /usr/share/doomemacs
ln -s /usr/share/doomemacs/bin/doom /usr/bin/doom

# https://github.com/jessfraz/dockfmt/releases
DOCKFMT_SHA256="f6bc025739cf4f56287e879c75c11cc73ebafdf93a57c9bcd8805d1ab82434a0"
curl -fSL "https://github.com/jessfraz/dockfmt/releases/download/v0.3.3/dockfmt-linux-amd64" -o "/tmp/dockfmt"
echo "${DOCKFMT_SHA256} /tmp/dockfmt" | sha256sum -c -
install /tmp/dockfmt /usr/bin/

# remove old desktop files for emacs before copying our custom file over later
rm /usr/share/applications/emacs.desktop /usr/share/applications/emacs-mail.desktop

# sync doom packages when users log in
systemctl --global enable doom-update.service


###
### oh-my-zsh
###

git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh /usr/share/oh-my-zsh


###
### framework
###

# https://github.com/FrameworkComputer/framework-system?tab=readme-ov-file#installation
wget -q -O /tmp/framework_tool https://github.com/FrameworkComputer/framework-system/releases/latest/download/framework_tool
install /tmp/framework_tool /usr/bin/


###
### gamescope
###

# Terra repo (gamescope build + session packages)
dnf5 -y install --nogpgcheck \
  --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
  terra-release terra-release-extras
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-terra"${FEDORA_VER}"*

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


###
### misc
###

# install typst
wget -q -O /tmp/typst-x86_64-unknown-linux-musl.tar.xz https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz
tar -xf /tmp/typst-x86_64-unknown-linux-musl.tar.xz -C /tmp
install /tmp/typst-x86_64-unknown-linux-musl/typst /usr/bin/

# lemonade server
# uninstalling in lieu of using a distrobox
# dnf install -y /ctx/rpms/lemonade-server-10.0.0.x86_64.rpm


###
### clean up
###

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/terra.repo /etc/yum.repos.d/terra-extras.repo
dnf5 clean all
