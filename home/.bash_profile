#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	startx
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/jason/.lmstudio/bin"
# End of LM Studio CLI section

