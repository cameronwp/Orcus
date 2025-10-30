ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# something grep was compaining about
export GREP_COLORS='mt=1;33'

# vim all the things
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

bindkey -v
export KEYTIMEOUT=1

# more user binaries
export PATH=$PATH:$HOME/.local/bin

###
### oh my zsh
###

# this is a non-standard setup for oh-my-zsh that lets us update omz when this image is built
# - base installation is in /usr/local/etc/ohmyzsh - you can't edit this
# - plugins and all customizations live in $HOME/.config/ohmyzsh-custom - you can edit this
export ZSH=/usr/local/etc/ohmyzsh
export ZSH_CUSTOM=$HOME/.config/ohmyzsh-custom

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="random"

# feel free to edit. zsh-completions and zsh-autosuggestions have already been installed
plugins=(docker git git-prompt tmux vi-mode zsh-completions zsh-autosuggestions)
fpath=($ZSH/completion $fpath)
fpath+=${ZSH_CUSTOM}/plugins/zsh-completions/src
autoload -U compinit && compinit

# actually turn on oh-my-zsh
source $ZSH/oh-my-zsh.sh

# fzf
source /usr/share/fzf/shell/key-bindings.zsh

###
### programming languages
###

# doom emacs
export PATH=$PATH:$HOME/.config/emacs/bin

# golang
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

# rust
export PATH=$PATH:$HOME/.local/cargo/bin
# run the next line before sourcing the cargo env
#   CARGO_HOME=$HOME/.local/cargo RUSTUP_HOME=$HOME/.local/rustup rustup-init -y
# source $HOME/.local/cargo/env

# fnm (depends on rust, see above)
# https://github.com/Schniz/fnm
# eval "`fnm env`"

###
### texlive
###

# https://www.tug.org/texlive/quickinstall.html
# installing to $HOME is a good idea on an immutable OS where you don't want to add 5GB and 4000 packages to the image (which is what you get when you dnf install texlive-scheme-full)

# The following flags will install to $HOME instead of /usr (change the year as appropriate).
#   perl install-tl -texdir $HOME/.local/share/texlive/2025 -texmflocal $HOME/.local/share/texlive/texmf-local

# uncomment after running the command above (change the year if necessary)
# export PATH=$PATH:$HOME/.local/share/texlive/2025/bin/x86_64-linux
# export MANPATH=$MANPATH:$HOME/.local/share/texlive/2025/texmf-dist/doc/man
# export INFOPATH=$INFOPATH:$HOME/.local/share/texlive/2025/texmf-dist/doc/info
