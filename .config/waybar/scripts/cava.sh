#!/bin/bash

# Ejecuta cava y lee la salida línea por línea
cava -p ~/.config/cava/config_waybar | while read -r line; do
    # Elimina todos los espacios de la línea para comprobar si queda alguna barra
    stripped="${line// /}"

    if [[ -z "$stripped" ]]; then
        # Si la línea está vacía (silencio), no imprimimos nada
        echo ""
    else
        # Si hay sonido, imprimimos las barras
        echo "$line"
    fi
done
