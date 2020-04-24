#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias vi='vim'
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ll -a'
alias sl='ls'
alias xrel='xrdb -I$HOME -merge ~/.Xresources'
alias reload='source ~/.bashrc'

# startx if there is graphical interface
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then 
    exec startx
fi

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1="\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ "

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"






#PS1='\[\033[00;32m\]\u\[\033[00;33m\]@\[\033[00;32m\]\h\[\033[01;30m\]:\[\033[01;36m\]\w\[\033[01;37m\]$ \[\033[00m\]'
