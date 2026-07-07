#!/usr/bin/env bash

# ░██████╗░█████╗░██████╗░██╗██████╗░████████╗
# ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝
# ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░
# ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░
# ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░
# ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░

# ░██╗░░░░░░░██╗░█████╗░██╗░░░░░██╗░░░░░░██████╗███████╗██╗░░░░░███████╗░█████╗░████████╗
# ░██║░░██╗░░██║██╔══██╗██║░░░░░██║░░░░░██╔════╝██╔════╝██║░░░░░██╔════╝██╔══██╗╚══██╔══╝
# ░╚██╗████╗██╔╝███████║██║░░░░░██║░░░░░╚█████╗░█████╗░░██║░░░░░█████╗░░██║░░╚═╝░░░██║░░░
# ░░████╔═████║░██╔══██║██║░░░░░██║░░░░░░╚═══██╗██╔══╝░░██║░░░░░██╔══╝░░██║░░██╗░░░██║░░░
# ░░╚██╔╝░╚██╔╝░██║░░██║███████╗███████╗██████╔╝███████╗███████╗███████╗╚█████╔╝░░░██║░░░
# ░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝╚══════╝╚══════╝╚═════╝░╚══════╝╚══════╝╚══════╝░╚════╝░░░░╚═╝░░░

WALL_DIR="$HOME/.config/wallpapers"

SELECTED=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
    | while read -r img; do
        printf '%s\0icon\x1f%s\n' "$img" "$img"
      done \
    | rofi -dmenu -i -show-icons -theme "$HOME/.config/rofi/wallselect/style.rasi"
)

[ -z "$SELECTED" ] && exit 0

if ! pgrep -x "awww" > /dev/null; then
    awww &
    sleep 0.2
fi

awww img "$SELECTED" \
  --transition-type=center --transition-pos 1,0  --transition-duration=2.5 --transition-step=255 --transition-fps=100

cp "$SELECTED" ~/.config/rofi/anime-girl-red-eyes.jpg

matugen image "$SELECTED" -m dark --source-color-index 0

killall -SIGUSR2 waybar && killall dunst && dunst &
pkill -USR1 cava
killall -SIGUSR1 kitty
