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
alias reload='source ~/.bashrc'
alias xreload='source xrdb ~/.Xresources'

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1="\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ "

POLYBAR_HEIGHT=50; export POLYBAR_HEIGHT
TERM=alacritty; export TERM
BROWSER=chromium; export BROWSER
