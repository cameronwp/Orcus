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
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf5 install -y code

# install tailscale
# https://tailscale.com/kb/1511/install-fedora-2
sudo dnf5 config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
sudo dnf5 install -y tailscale
# uncomment to turn on tailscale by default
# systemctl enable tailscaled

# remove the firefox RPM that's missing codecs
dnf5 remove -y firefox


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
### misc
###

# install typst
wget -q -O /tmp/typst-aarch64-unknown-linux-musl.tar.xz https://github.com/typst/typst/releases/latest/download/typst-aarch64-unknown-linux-musl.tar.xz
tar -xf /tmp/typst-aarch64-unknown-linux-musl.tar.xz -C /tmp
install /tmp/typst-aarch64-unknown-linux-musl/typst /usr/local/bin/


###
### clean up
###

dnf5 clean all
