#!/usr/bin/env bash

set -ouex pipefail


notify-send -a "Doom Emacs" "Updating Doom" "Please refrain from opening Emacs for a moment"

# get doom emacs ready to go, regardless of whether or not it is already installed

TODAY=$(date +%Y%m%d)
OLD_BACKUPS=$(find $HOME -maxdepth 2 -regex '.*emacs[\.d]*\.backup' 2>/dev/null)

# backup ~/.emacs.d if it exists
if [ -d $HOME/.emacs.d ]; then
  mv $HOME/.emacs.d $HOME/.emacs.d.backup-$TODAY
fi

# backup ~/.config/emacs if it exists
if [ -d $HOME/.config/emacs ]; then
  mv $HOME/.config/emacs $HOME/.config/emacs.backup-$TODAY
fi

# # copy the current version of doom over to XDG home
if [ ! -d $HOME/.config/emacs ]; then
  rsync -r /usr/local/etc/emacs $HOME/.config/
fi

$HOME/.config/emacs/bin/doom install --doomdir ~/.config/doom --force || \
  (notify-send -a "Doom Emacs" "Something went wrong" "Failed to install Doom. Try running 'doom install' on your own" && exit 1)
$HOME/.config/emacs/bin/doom sync --doomdir ~/.config/doom -e --force || \
  (notify-send -a "Doom Emacs" "Something went wrong" "Failed to sync Doom packages. Try running 'doom sync' on your own" && exit 1)

notify-send -a "Doom Emacs" "Update complete" "Ready to go\! Yay Evil\!"

rm -rf $OLD_BACKUPS
