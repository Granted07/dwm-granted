#!bin/sh

nitrogen --restore >> ~/.config/dwm/AutoStart.log 

/usr/lib/xfce-polkit/xfce-polkit &

dunst &
sxhkd -c .config/sxhkd/sxhkdrc-dwm &
autorandr --change primary >> ~/.config/dwm/AutoStart.log & 


