#############
##  Basic  ##
#############
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL='alacritty'
export BROWSER='firefox'

export HISTFILE="$HOME/.zhistory"
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export HISTSIZE=10000
export SAVEHIST=10000

setopt correct
setopt interactive_comments

bindkey -v

#############
##  Alias  ##
#############
alias _='sudo '
alias pls='sudo'
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias afind='ack -il'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias gc1='git clone --recursive --depth=1'
alias globurl='noglob urlglobber '
alias grep='grep --color=auto'
alias md='mkdir -p'

#############
## Replace ##
#############
# exa
if [[ $(command -v exa) ]] {
    DISABLE_LS_COLORS=true
    unset LS_BIN_FILE
    for i (/bin/ls ${PREFIX}/bin/ls /usr/bin/ls /usr/local/bin/ls) {
        [[ ! -x ${i} ]] || {
            local LS_BIN_FILE=${i}
            break
        }
    }
    [[ -n ${LS_BIN_FILE} ]] || local LS_BIN_FILE=$(whereis ls 2>/dev/null | awk '{print $2}')
    alias lls=${LS_BIN_FILE} 
    # lls is the original ls
    alias ls="exa --color=auto" 
    alias l='exa -lbah --icons'
    alias la='exa -labgh --icons'
    alias ll='exa -lbg --icons'
    alias lsa='exa -lbagR --icons'
    alias lst='exa -lTabgh --icons' # lst as tree
} else {
    alias ls='ls --color=auto'
    alias lst='tree -pCsh'
    alias l='ls -lah'
    alias la='ls -lAh'
    alias ll='ls -lh'
    alias lsa='ls -lah'
}
[[ ! $(command -v tmoe) ]] || alias t=tmoe
# bat
set_bat_paper_variable() {
    unset CAT_BIN_FILE i
    for i (/bin/cat ${PREFIX}/bin/cat /usr/bin/cat /usr/local/bin/cat) {
        [[ ! -x ${i} ]] || {
            local CAT_BIN_FILE=${i}
            unset i
            break
        }
    }
    [[ -n ${CAT_BIN_FILE} ]] || local CAT_BIN_FILE=$(whereis cat 2>/dev/null | awk '{print $2}')
    alias lcat=${CAT_BIN_FILE} 
    # lcat is the original cat.
    typeset -g BAT_PAGER="less -m -RFQ"
}
for i (batcat bat) {
    if [[ $(command -v ${i}) ]] {
        alias cat="${i} -pp"
        set_bat_paper_variable
        break
    }
}

#############
##  Zinit  ##
#############
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit load zdharma-continuum/history-search-multi-word
zpcompinit; zpcdreplay
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship
