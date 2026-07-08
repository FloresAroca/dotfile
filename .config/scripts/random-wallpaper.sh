#!/usr/bin/env bash

set -euo pipefail

WALL_DIR="$HOME/.config/wallpapers"
LAST_WALL="$HOME/.cache/last_wallpaper"

# Obtener lista de imágenes
mapfile -t WALLS < <(
    find "$WALL_DIR" -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \)
)

# Salir si no hay fondos
(( ${#WALLS[@]} == 0 )) && exit 1

# Leer el último fondo utilizado
LAST=""
[[ -f "$LAST_WALL" ]] && LAST=$(<"$LAST_WALL")

# Elegir uno aleatorio diferente al anterior
while :; do
    SELECTED="${WALLS[RANDOM % ${#WALLS[@]}]}"

    if [[ "${#WALLS[@]}" -eq 1 || "$SELECTED" != "$LAST" ]]; then
        break
    fi
done

echo "$SELECTED" > "$LAST_WALL"

# Iniciar awww si no está abierto
if ! pgrep -x "awww" >/dev/null; then
    awww &
    sleep 0.2
fi

# Cambiar wallpaper
awww img "$SELECTED" \
    --transition-type=center \
    --transition-pos 1,0 \
    --transition-duration=1.5 \
    --transition-step=255 \
    --transition-fps=100

# Copiar wallpaper para Rofi
cp "$SELECTED" ~/.config/rofi/anime-girl-red-eyes.jpg

# Generar colores
matugen image "$SELECTED" -m dark --source-color-index 0

# Recargar programas
killall -SIGUSR2 waybar
killall dunst
dunst &
pkill -USR1 cava
killall -SIGUSR1 kitty
