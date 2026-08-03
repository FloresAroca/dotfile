#!/usr/bin/env bash

# ░██████╗░█████╗░██████╗░██╗██████╗░████████╗
# ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝
# ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░
# ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░
# ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░
# ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE="$SCRIPT_DIR/wallselect_engine.py"
THEME="$SCRIPT_DIR/style.rasi"
WALL_DIR="$HOME/.config/wallpapers"

chmod +x "$ENGINE"

ACTION=""
COLOR_ARG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
  --color)
    COLOR_ARG="$2"
    shift 2
    ;;
  --all)
    COLOR_ARG="all"
    shift
    ;;
  --random)
    ACTION="random"
    shift
    ;;
  --menu)
    ACTION="menu"
    shift
    ;;
  *)
    shift
    ;;
  esac
done

SELECTED=""

if [ "$ACTION" = "random" ]; then
  SELECTED=$("$ENGINE" --random "$COLOR_ARG")
else
  CURRENT_CAT="$COLOR_ARG"

  while true; do
    if [ -z "$CURRENT_CAT" ]; then
      # Category Carousel Screen
      RAW_CHOICE=$("$ENGINE" --categories | rofi -dmenu -i -show-icons -theme "$THEME" -p "󰸉  COLOR MATRIX")

      [ -z "$RAW_CHOICE" ] && exit 0

      if [ "$RAW_CHOICE" = "random" ]; then
        SELECTED=$("$ENGINE" --random)
        break
      else
        CURRENT_CAT="$RAW_CHOICE"
      fi
    else
      # Wallpaper Carousel Screen
      TITLE="󰸉  ALL WALLPAPERS"
      if [ "$CURRENT_CAT" != "all" ]; then
        TITLE="󰸉  COLOR: ${CURRENT_CAT^^}"
      fi

      RAW_CHOICE=$("$ENGINE" --wallpapers "$CURRENT_CAT" | rofi -dmenu -i -show-icons -theme "$THEME" -p "$TITLE")

      [ -z "$RAW_CHOICE" ] && exit 0

      if [ "$RAW_CHOICE" = "BACK_TO_MENU" ]; then
        CURRENT_CAT=""
      else
        SELECTED="$RAW_CHOICE"
        break
      fi
    fi
  done
fi

[ -z "$SELECTED" ] || [ ! -f "$SELECTED" ] && exit 0

# Apply wallpaper with awww
if ! pgrep -x "awww-daemon" >/dev/null; then
  awww-daemon &
  sleep 0.2
fi

awww img --transition-type=center --transition-pos=center --transition-duration=2.5 --transition-fps=100 "$SELECTED"

cp "$SELECTED" ~/.config/rofi/anime-girl-red-eyes.jpg

matugen image "$SELECTED" -m dark --source-color-index 0

killall -SIGUSR2 waybar && killall dunst && dunst &
pkill -USR1 cava
killall -SIGUSR1 kitty
