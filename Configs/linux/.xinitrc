#!/bin/sh
# -------------------------------
# Minimal X session for bspwm
# Reed's setup
# -------------------------------

### --- Environment setup --- ###
export LANG=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"

# Android dev
# Chromium for running a debugger from Expo
export EDGE_PATH=$(which chromium-browser)

# Add Go to path
export PATH=$PATH:/usr/local/go/bin

# Define XDG paths
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"

# Ensure Downloads exists (some apps fail otherwise)
[ -d "$XDG_DOWNLOAD_DIR" ] || mkdir -p "$XDG_DOWNLOAD_DIR"

# Keyboard and input tweaks
setxkbmap us
xset r rate 200 15
# enable tap to click on touchpad
xinput set-prop 11 "libinput Tapping Enabled" 1

# dark GTK theme
export GTK_THEME=Adwaita:dark

# Cursor theme (optional)
xsetroot -cursor_name left_ptr

### --- Startup programs --- ###
# file sync
syncthing &

# Hotkey daemon
sxhkd &

# Notification daemon
dunst &

### --- Launch the WM --- ###
exec bspwm

