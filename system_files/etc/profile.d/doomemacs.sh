# Doom core in /usr/share/doomemacs is read-only; keep per-user state in $HOME
# (mirrors /usr/lib/environment.d/60-doomemacs.conf for TTY/SSH logins)
export DOOMLOCALDIR="${HOME}/.local/share/doomemacs/"
export DOOMPROFILELOADFILE="${HOME}/.local/share/doomemacs/profiles/load.el"
