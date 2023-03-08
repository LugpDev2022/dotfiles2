#!/bin/sh

# Wallpaper
feh --bg-scale ~/Wallpapers/04.png &
# Automount Devices
udiskie -t &

# Icons
nm-applet &
cbatticon -u 5 &
volumeicon &
