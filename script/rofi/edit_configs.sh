#!/bin/bash


declare options=("
alacritty
xmonad
awesome
neovim
lf
browser
zsh
quit")

choice=$(echo -e "${options[@]}" | dmenu -l 10 -p 'Edit config file: ')

case "$choice" in
	quit)
		echo "Program terminated." && exit 1
	;;
	alacritty)
		choice="$HOME/.config/alacritty/alacritty.yml"
	;;
	xmonad)
		choice="$HOME/.xmonad/xmonad.hs"
    ;;
	awesome)
		choice="$HOME/.config/awesome/rc.lua"
	;;
	neovim)
		choice="$HOME/.config/nvim/init.vim"
	;;
	lf)
		choice="$HOME/.config/lf/lfrc"
	;;
	zsh)
		choice="$HOME/.zshrc"
	;;
    browser)
        choice="$HOME/script/rofi/bookmark/browser.yaml"
    ;;
	*)
		exit 1
	;;
esac
kitty -e nvim -c 'cd %:p:h' "$choice"

