#!/bin/bash

cmd="rofi -dmenu -sort"

choice=$(apropos . | awk '{print $1}' | $cmd -p "open man pages: ") || exit

alacritty -e man $choice
