# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/reed/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# opam configuration
test -r /home/reed/.opam/opam-init/init.zsh && . /home/reed/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
