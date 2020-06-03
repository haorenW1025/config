#!/bin/bash

# Dmenu script for launching surfaw, a command line search utility.

cmd="rofi -dmenu"

while [ -z "$engine" ]; do
engine=$(sr -elvi | gawk '{if (NR!=1) { print $1 }}' | $cmd -p "Search engine?") || exit
done

while [ -z "$query" ]; do
query=$(echo "" | $cmd -p "Searching $engine ") || exit
done

sr "$engine" "$query"

