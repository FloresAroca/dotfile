#!/usr/bin/env bash
# ~/.config/waybar/scripts/cava_waybar.sh

CAVA_CONFIG="${HOME}/.config/cava/waybar"
CHARS=('▁' '▁' '▂' '▃' '▄' '▅' '▆' '▇' '█')
TOOLTIP="Visualizador de audio · clic para mixer"

if ! command -v cava &>/dev/null; then
    echo '{"text":"󰝚 sin cava","class":"error","tooltip":"sudo pacman -S cava"}'
    exit 1
fi

if [[ ! -f "$CAVA_CONFIG" ]]; then
    echo '{"text":"󰝚 sin config","class":"error","tooltip":"Falta ~/.config/cava/waybar"}'
    exit 1
fi

# stdbuf -oL fuerza flush línea a línea — necesario para que waybar reciba el output
stdbuf -oL cava -p "$CAVA_CONFIG" | while IFS= read -r line; do

    IFS=';' read -ra values <<< "$line"
    bar_text=""
    all_zero=true

    for val in "${values[@]}"; do
        [[ -z "$val" ]] && continue
        idx=$(( val < 0 ? 0 : val > 7 ? 7 : val ))
        bar_text+="${CHARS[$idx]}"
        [[ "$idx" -gt 0 ]] && all_zero=false
    done

    $all_zero && css_class="muted" || css_class="active"

    printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' \
        "$bar_text" "$css_class" "$TOOLTIP"

done
