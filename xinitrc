#!/bin/sh

# # Japanese with ibus
# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus
# ibus-daemon -d -x

# # Japanese with uim
# export GTK_IM_MODULE='uim'
# export QT_IM_MODULE='uim'
# export XMODIFIERS='@im=uim'

# Load .Xresources
if [ -s ~/.Xresources ]; then
    xrdb -merge ~/.Xresources
fi

# Load key remapping
if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

# sxhkd &
picom &
xfce4-power-manager &
nm-applet &
blueman-applet &
xfce4-volumed &
thunar --daemon & # automounting

exec i3
