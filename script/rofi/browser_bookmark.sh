#!/bin/bash

cmd="rofi -dmenu -matching fuzzy"

choice=$(cat $HOME/script/rofi/bookmark/browser.yaml| yq -r -c keys | sed -r 's/(\[|\]|\")//g' | tr "," "\n" | $cmd -p "Open in Browser: ") || exit

bookmark=$(cat $HOME/script/rofi/bookmark/browser.yaml | yq -r ."${choice}".url)

firefox ${bookmark}
