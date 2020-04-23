#!/bin/sh

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xrandr --output Virtual1 --mode 1440x900
VBoxClient-all

xrdb -merge ~/.Xresources
exec i3
