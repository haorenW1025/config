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

run xfsettingsd
run nm-applet
run thunar --daemon
run pa-applet
run pamac-tray

## The following are not included in minimal edition by default
## but autorun.sh will pick them up if you install them

modifiedkey.sh
polybar.sh
run ibus-daemon -drx --panel /usr/lib/ibus/ibus-ui-gtk3
run picom --experimental-backends --fading
run blueman-applet
run nitrogen --restore
run msm_notifier
run xmodmap ~/.xmodmap
