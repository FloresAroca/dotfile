#!/usr/bin/env bash

# ░██████╗░█████╗░██████╗░██╗██████╗░████████╗
# ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝
# ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░
# ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░
# ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░
# ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░

# Path configurations
WALL_DIR="$HOME/.config/wallpapers"
CACHE_DIR="$HOME/.cache/wallselect/thumbs"

# Ensure thumbnail cache directory exists
mkdir -p "$CACHE_DIR"

# Array to map selection index back to original wallpaper file
declare -a WALLPAPERS
ROFI_INPUT=""
GEN_LIST=$(mktemp)

# Scan wallpapers and prepare rofi input entries
while IFS= read -r -d '' img; do
    WALLPAPERS+=("$img")
    
    # Generate unique thumbnail filename from path MD5 hash
    hash_name=$(echo -n "$img" | md5sum | cut -d' ' -f1)
    thumb="$CACHE_DIR/${hash_name}.jpg"
    
    # Queue thumbnail generation if missing or source wallpaper modified
    if [[ ! -f "$thumb" || "$img" -nt "$thumb" ]]; then
        printf '%s\t%s\n' "$img" "$thumb" >> "$GEN_LIST"
    fi
    
    # Format relative path for display label (e.g., "Dark  •  wallpaper")
    rel_path="${img#$WALL_DIR/}"
    display_name="${rel_path%.*}"
    display_name="${display_name//\//  •  }"
    
    ROFI_INPUT+="${display_name}\0icon\x1f${thumb}\n"
done < <(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0 | sort -z)

# Batch generate missing thumbnails in parallel using ffmpeg
if [[ -s "$GEN_LIST" ]]; then
    cat "$GEN_LIST" | xargs -P "$(nproc)" -n 2 bash -c '
        ffmpeg -loglevel error -y -i "$1" -vf "scale=360:202:force_original_aspect_ratio=increase,crop=360:202" -q:v 3 "$2"
    ' _
fi
rm -f "$GEN_LIST"

# Display Rofi wallpaper picker and get selected index
SELECTED_INDEX=$(printf '%b' "$ROFI_INPUT" | rofi -dmenu -i -format i -p "󰸉 Wallpapers" -theme "$HOME/.config/rofi/wallselect/style.rasi")

# Exit cleanly if user cancelled selection
[[ -z "$SELECTED_INDEX" ]] && exit 0

# Retrieve exact wallpaper file path from array
SELECTED="${WALLPAPERS[$SELECTED_INDEX]}"

# Start wallpaper daemon if not running
if ! pgrep -x "awww" > /dev/null; then
    awww &
    sleep 0.2
fi

# Set wallpaper with transition animation
awww img "$SELECTED" \
  --transition-type=center --transition-pos 1,0 --transition-duration=1.5 --transition-step=255 --transition-fps=100

# Copy selection for default avatar/wall target
cp "$SELECTED" ~/.config/rofi/anime-girl-red-eyes.jpg

# Update system color palette dynamically
matugen image "$SELECTED" -m dark --source-color-index 0

# Reload system bars, notifications, and terminal aesthetics
killall -SIGUSR2 waybar && killall dunst && dunst &
pkill -USR1 cava
killall -SIGUSR1 kitty
