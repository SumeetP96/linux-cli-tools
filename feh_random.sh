#!/bin/bash

# Change wallpaper randomly
# This script uses feh to manage wallpapers
# https://wiki.archlinux.org/title/feh

directory=/home/$USER/Pictures/backgrounds/*

# Run
feh --bg-fill --randomize --recursive $directory
