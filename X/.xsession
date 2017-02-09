# Setting up environment
## Site-wide common configuration
. /usr/local/lib/site.xinitrc

# set PATH so it includes user's private bin if it exists
if test -d "$HOME/bin" ; then
    export PATH="$HOME/bin:$PATH"
fi

if test -d "$HOME/.local/bin" ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if test -f ~/.Xresources ; then
    xrdb -merge ~/.Xresources
fi

setxkbmap de neo

~/.screenlayout/default.sh

trayer --edge top --align left --SetDockType true --SetPartialStrut false --expand true --width 10 --height 20 --monitor 0 --transparent true --tint 0x000000 --alpha 0 &

xcompmgr &

# pidgin &

exec xmonad
