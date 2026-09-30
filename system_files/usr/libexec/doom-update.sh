#!/usr/bin/env bash

# Doom's core is read-only in /usr/share/doomemacs and only changes with image updates.
# This keeps each user's packages (in $DOOMLOCALDIR) in step with that core.
# DOOMLOCALDIR and DOOMPROFILELOADFILE come from /usr/lib/environment.d/60-doomemacs.conf

set -ouex pipefail

function popup() {
  notify-send -a "Doom Emacs Updater" "$1" "$2" --icon=/usr/share/icons/doom-emacs/doom-emacs.svg --hint=STRING:desktop-entry:doom-emacs
}

NOW=$(date +%Y%m%d%H%M)
LOG_FOLDER=$HOME/.local/doom-updater
THESE_LOGS=$LOG_FOLDER/$NOW.log

mkdir -p "$LOG_FOLDER"

popup "Starting update" "Please refrain from opening Emacs for a moment"

if ! /usr/bin/doom sync --doomdir "$HOME/.config/doom" -e --force &>> "$THESE_LOGS"; then
  echo "FAILURE" >> "$THESE_LOGS"
  popup "Something went wrong" "Failed to sync Doom. See $THESE_LOGS for logs"
  exit 1
fi

echo "SUCCESS" >> "$THESE_LOGS"
popup "Success" "Emacs is ready to go\! Yay Evil\!"
