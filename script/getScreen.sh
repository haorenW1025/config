#!/bin/bash

## Get screen info
screen1=($(xrandr | grep -w connected  | awk -F'[ +]' '{print $1,$3,$4}' | sed 's/primary //' |
    head -n 1))
screen2=($(xrandr | grep -w connected  | awk -F'[ +]' '{print $1,$3,$4}' | sed 's/primary //' |
    tail -n 1))

## Figure out which screen is to the right of which
if [[ ${screen1[1]} -eq 0  ]]
then
    right=(${screen2[@]});
    left=(${screen1[@]});
else
    right=(${screen1[@]});
    left=(${screen2[@]});

fi

## Get window position
pos=$(xwininfo -id $(xdotool getactivewindow) | grep "Absolute upper-left X" | 
      awk '{print $NF}')

## Which screen is this window displayed in? If $pos
## is greater than the offset of the rightmost screen,
## then the window is on the right hand one
if [[ "$pos" -gt "${right[2]}" ]]
then
    echo "${right[0]} : ${right[1]}"    
else
    echo "${left[0]} : ${left[1]}"    
fi
