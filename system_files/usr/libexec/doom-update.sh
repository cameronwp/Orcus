#!/usr/bin/env bash

set -ouex pipefail

function popup() {
  notify-send -a "Doom Emacs Updater" "$1" "$2" --icon=/usr/share/icons/doom-emacs/doom-emacs.svg
}

popup "Starting update" "Please refrain from opening Emacs for a moment"

# get doom emacs ready to go, regardless of whether or not it is already installed

NOW=$(date +%Y%m%d%H%M)
# ignore all errors. if there's a permissions error, find will exit with an error code
OLD_BACKUPS=$(find $HOME -maxdepth 2 -regex '.*emacs[\.d]*\.backup.*' 2>/dev/null || true)
CURRENT_DOOM_LOCATION=""
BACKED_UP_DOOM=""
LOG_FOLDER=$HOME/.local/doom-updater
THESE_LOGS=$LOG_FOLDER/$NOW.log

mkdir -p $LOG_FOLDER
touch $THESE_LOGS

function failed {
  if [ -n $CURRENT_DOOM ]; then
    mv $BACKED_UP_DOOM $CURRENT_DOOM_LOCATION
    echo "Returned $BACKED_UP_DOOM to $CURRENT_DOOM_LOCATION" >> $THESE_LOGS
    echo "FAILURE" >> $THESE_LOGS
  fi
  popup "Something went wrong" "Failed to $@ Doom. See $THESE_LOGS for logs. All changes to your current setup have been reverted"
}

# backup ~/.emacs.d if it exists
if [ -d $HOME/.emacs.d ]; then
  BACKED_UP_DOOM=$HOME/.emacs.d.backup-$NOW
  CURRENT_DOOM_LOCATION=$HOME/.emacs.d
  mv $HOME/.emacs.d $BACKED_UP_DOOM
  echo "Backed up ~/.emacs.d to $BACKED_UP_DOOM" >> $THESE_LOGS
fi

# backup ~/.config/emacs if it exists
if [ -d $HOME/.config/emacs ]; then
  BACKED_UP_DOOM=$HOME/.config/emacs.backup-$NOW
  CURRENT_DOOM_LOCATION=$HOME/.config/emacs
  cp -r $HOME/.config/emacs $BACKED_UP_DOOM
  echo "Backed up ~/.config/emacs to $BACKED_UP_DOOM" >> $THESE_LOGS
fi

# copy the current version of doom over to XDG config
if [ ! -d $HOME/.config/emacs ]; then
  rsync -rlv --exclude ".cache" --exclude ".local" --exclude "eln-cache" /usr/local/etc/emacs $HOME/.config/
  echo "Copied /usr/local/etc/emacs to ~/.config/emacs" >> $THESE_LOGS
fi

$HOME/.config/emacs/bin/doom install --doomdir ~/.config/doom --force &>> $THESE_LOGS || \
  (failed "install" && exit 1)

$HOME/.config/emacs/bin/doom sync --doomdir ~/.config/doom -e --force &>> $THESE_LOGS || \
  (failed "sync" && exit 1)

# make 100% sure there isn't a competing emacs installation
rm -rf $HOME/.emacs $HOME/.emacs.d

rm -rf $OLD_BACKUPS
echo "Removed old backups: $OLD_BACKUPS"

echo "SUCCESS" >> $THESE_LOGS
popup "Success" "Emacs is ready to go\! Yay Evil\!"
