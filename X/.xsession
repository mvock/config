[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
export LANG=en_US
export LC_ALL=en_US.UTF-8
export SSH_ASKPASS='ssh-askpass'
export PATH="$HOME/.local/bin:$PATH"
export BROWSER="conkeror"
export _JAVA_AWT_WM_NONREPARENTING=1

setxkbmap de neo

# Infrastructure
xscreensaver -no-splash &
xcompmgr -cf &
notification-daemon &

# Set up an icon tray
trayer --edge top --align left --SetDockType true --SetPartialStrut false --expand true --width 10 --widthtype percent --height 22 --heighttype pixel --transparent true --tint 0x000000 --alpha 50 --monitor primary &

# Set the background color
#xsetbg -border black -at -2,0 'images/wallpapers/current.jpg' &

# Start remind daemon
remind -z -k'gxmessage -center -title "reminders" %s &' ~/.reminders &
# Show reminders for today (once)
remind -q ~/.reminders | sed -e "s/$(echo '\0033\c')[^a-zA-Z]\+[a-zA-Z]//g" | gxmessage -title "reminders" -center -file - &

# Fire up apps
pidgin &
workrave &

ssh-add < /dev/null &

exec xmonad
