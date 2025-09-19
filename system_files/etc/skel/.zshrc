ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# more user binaries
export PATH=$PATH:$HOME/.local/bin

# vim all the things
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

bindkey -v
export KEYTIMEOUT=1

# this is a non-standard setup for oh-my-zsh that lets us update omz when this image is built
# - base installation is in /usr/local/etc/ohmyzsh - you can't edit this
# - plugins and all customizations live in $HOME/.config/ohmyzsh-custom - you can edit this
export ZSH=/usr/local/etc/ohmyzsh
export ZSH_CUSTOM=$HOME/.config/ohmyzsh-custom

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="random"

plugins=(docker git git-prompt tmux vi-mode zsh-completions zsh-autosuggestions)
fpath=($ZSH/completion $fpath)
fpath+=${ZSH_CUSTOM}/plugins/zsh-completions/src
autoload -U compinit && compinit

# actually turn on oh-my-zsh
source $ZSH/oh-my-zsh.sh

# fzf
source /usr/share/fzf/shell/key-bindings.zsh

# doom emacs
export PATH=$PATH:$HOME/.config/emacs/bin

# golang
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

# julia
export JULIA_NUM_THREADS=6
export PATH=$PATH:$HOME/.julia/bin

# rust
export PATH=$PATH:$HOME/.local/cargo/bin
# run the next line before sourcing the cargo env
#   CARGO_HOME=$HOME/.local/cargo RUSTUP_HOME=$HOME/.local/rustup rustup-init -y
# source $HOME/.local/cargo/env

# fnm (depends on rust, see above)
# https://github.com/Schniz/fnm
# eval "`fnm env`"

# texlive
# export PATH=$PATH:$HOME/.local/share/texlive/2023/bin/x86_64-linux
# export MANPATH=$MANPATH:$HOME/.local/share/texlive/2023/texmf-dist/doc/man
# export INFOPATH=$INFOPATH:$HOME/.local/share/texlive/2023/texmf-dist/doc/info

# something grep was compaining about
export GREP_COLORS='mt=1;33'
