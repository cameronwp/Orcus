#!/usr/bin/env bash

set -ouex pipefail


notify-send "Doom Emacs" "Updating Doom. Please refrain from opening Emacs for a moment"

# get doom emacs ready to go, regardless of whether or not it is already installed

# TODO make sure this script does what it says it does

TODAY=$(date +%Y%m%d)
# OLD_BACKUPS=(ls $HOME | grep -P ".emacs.d.backup*")
# OLD_BACKUPS+=(ls $HOME/.config | grep -P "emacs.backup*")

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
  rsync -r /usr/local/etc/emacs $HOME/.config/emacs
fi

$HOME/.config/emacs/bin/doom install --doomdir ~/.config/doom --force || \
  (notify-send "Doom Emacs" "Failed to install Doom. Try running 'doom install' on your own" && exit 1)
$HOME/.config/emacs/bin/doom sync --doomdir ~/.config/doom -e --force || \
  (notify-send "Doom Emacs" "Failed to sync Doom. Try running 'doom sync' on your own" && exit 1)

notify-send "Doom Emacs" "Ready to go\! Yay Evil\!"

# TODO clean up old backups. needs testing, this is wrong
# ls $HOME | grep -P ".emacs.d.backup-{!${TODAY}}$" | xargs -d"\n" rm
# ls $HOME/.config | grep -P "emacs.backup-{!${TODAY}}$" | xargs -d"\n" rm
