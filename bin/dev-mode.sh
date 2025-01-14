#!/bin/sh

kitty @ set-tab-title "zsh"
kitty @ launch --type=tab --title "testing" --cwd "$(pwd)"
kitty @ launch --type=tab --title "dev" --cwd "$(pwd)"
kitty @ focus-tab --match index:0
clear
