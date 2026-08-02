#!/usr/bin/env bash

CONFIG="$HOME/.config/waybar/system.jsonc"

if pgrep -f "waybar -c $CONFIG" >/dev/null; then
  pkill -f "waybar -c $CONFIG"
else
  waybar -c "$CONFIG" &
fi
