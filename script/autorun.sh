#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run {
   if (command -v $1 && ! pgrep $1); then
     $@&
   fi
}

## run (only once) processes which spawn with different name
if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
    gnome-keyring-daemon --daemonize --login &
fi
if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    start-pulseaudio-x11 &
fi
if (command -v /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 && ! pgrep polkit-mate-aut) ; then
    /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
fi
if (command -v  xfce4-power-manager && ! pgrep xfce4-power-man) ; then
    xfce4-power-manager &
fi

run nm-applet
run thunar --daemon
run pa-applet

## The following are not included in minimal edition by default
## but autorun.sh will pick them up if you install them

modifiedkey.sh
run ibus-daemon -drx --panel /usr/lib/ibus/ibus-ui-gtk3
run ~/packages/picom/build/src/picom --experimental-backends --fading
run blueman-applet
run msm_notifier

nitrogen --restore &
xrandr --output DP-0 --pos 0x0 --mode 1920x1080 --rate 144.00 --output HDMI-0 --pos 1920x0 --mode 1920x1200 --rotate left &
xmodmap ~/.xmodmap &
