#!/bin/bash


declare options=("
alacritty
awesome
neovim
lf
browser
zsh
quit")

choice=$(echo -e "${options[@]}" | rofi -dmenu -p 'Edit config file: ')

case "$choice" in
	quit)
		echo "Program terminated." && exit 1
	;;
	alacritty)
		choice="$HOME/.config/alacritty/alacritty.yml"
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
st -e nvim "$choice"

