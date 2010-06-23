#!/bin/bash
#
# start urxvt daemon
urxvtd -q -f -o &
#
# set wallpaper
eval `cat $HOME/.fehbg` &
#
# load Xdefaults
xrdb $HOME/.Xdefaults &
#
# switch language
setxkbmap us,ru -option grp_led:caps,grp:caps_toggle &
#
# req'd for xmonad's cursor
xsetroot -cursor_name left_ptr
#
# start wi-fi connection
#
# sudo wpa_supplicant -B -Dwext -i wlan0 -c /etc/wpa_supplicant.conf &
# sleep 10 && sudo dhcpcd wlan0 &
#
# start gnome stuff
nm-applet --sm-disable &
bluetooth-applet &
gnome-power-manager &
#gnome-settings-daemon &
#
# start Dropbox deamon
~/.dropbox-dist/dropboxd &
#
# this start mpd as normal user
mpd /home/enko/.mpd/config &
#
# set tray
sleep 5 && trayer --edge bottom --align right --expand true --SetDockType true --SetPartialStrut true --tint 0x303030 --alpha 0 --transparent true --widthtype request --height 15 --margin 0 &
#
# and finaly start xmonad
xmonad
# 
# all messages added to ~/.xsession-errors
exec >> $HOME/.xsession-errors 2>&1
