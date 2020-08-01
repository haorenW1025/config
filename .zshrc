autoload -U promptinit; promptinit
prompt spaceship

ZSH_AUTOSUGGEST_STRATEGY=(history)

setopt auto_cd

zmodload -i zsh/complist

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history

zstyle ':completion:*' menu select
_comp_options+=(globdots)

bindkey -v
bindkey "jk" vi-cmd-mode
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

# Highlight the current autocomplete option
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

autoload -Uz compinit
compinit

# Better SSH/Rsync/SCP Autocomplete
zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Allow for autocomplete to be case insensitive
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  '+l:|?=** r:|?=**'

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
fi


function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q"
}
zle -N zle-line-init
echo -ne '\e[6 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.

echo $TTY | read test
export NVIM_TTY=$test

set -o vi
alias ab='abduco'
alias cp='cp -iv'
alias zf='zathura --fork'
alias activate='source ~/env/bin/activate'
alias ls='exa --icons'
alias rm='rm -i'
alias vim='nvim'
alias tmux='/usr/local/bin/tmux'
set charset="utf-8"
set send_charset="utf-8"
set attach_charset="utf-8"
source $HOME/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.config/zsh/completion.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(lua $HOME/.config/zsh/z.lua/z.lua --init zsh)"
source $HOME/.config/lf/lficon
source $HOME/.cargo/env
source $HOME/.config/zsh/spaceship.zsh

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
