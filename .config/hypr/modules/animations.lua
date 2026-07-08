-- ============================================================================
-- ░█████╗░███╗░░██╗██╗███╗░░░███╗░█████╗░████████╗██╗░█████╗░███╗░░██╗░██████╗
-- ██╔══██╗████╗░██║██║████╗░████║██╔══██╗╚══██╔══╝██║██╔══██╗████╗░██║██╔════╝
-- ███████║██╔██╗██║██║██╔████╔██║███████║░░░██║░░░██║██║░░██║██╔██╗██║╚█████╗░
-- ██╔══██║██║╚████║██║██║╚██╔╝██║██╔══██║░░░██║░░░██║██║░░██║██║╚████║░╚═══██╗
-- ██║░░██║██║░╚███║██║██║░╚═╝░██║██║░░██║░░░██║░░░██║╚█████╔╝██║░╚███║██████╔╝
-- ╚═╝░░╚═╝╚═╝░░╚══╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░╚════╝░╚═╝░░╚══╝╚═════╝░
-- ============================================================================


-- ============================================================
-- animations.lua — Animaciones suaves y prolijas para Hyprland
-- Requiere Hyprland 0.55+ (config nativa en Lua)
-- Guardar en: ~/.config/hypr/animations.lua
-- Cargar desde tu hyprland.lua principal con:
--     require("animations")
-- ============================================================

-- ---------------- CURVAS ----------------
-- Todas sin "overshoot" (ningún punto Y > 1): eso es lo que genera
-- el efecto rebote/bamboleo. Acá todo desacelera limpio y se asienta.
hl.curve("easeOutExpo",    { type = "bezier", points = { {0.16, 1.00}, {0.30, 1.00} } })
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1.00}, {0.32, 1.00} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1.00} } })
hl.curve("linear",         { type = "bezier", points = { {0.00, 0.00}, {1.00, 1.00} } })

-- ---------------- ANIMACIONES ----------------
-- Base global
hl.animation({ leaf = "global", enabled = true, speed = 4, bezier = "easeOutExpo" })

-- Ventanas: pop sutil (92%, casi no se nota el "crecimiento") y sin rebote
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 3.5, bezier = "easeOutExpo",    style = "popin 92%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 2.5, bezier = "easeOutExpo",    style = "popin 92%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "easeInOutCubic" })

-- Fades: consistentes, sin cortes bruscos
hl.animation({ leaf = "fadeIn",     enabled = true, speed = 3.0, bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeOut",    enabled = true, speed = 2.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 2.0, bezier = "linear" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 2.0, bezier = "linear" })
hl.animation({ leaf = "fadeDim",    enabled = true, speed = 3.0, bezier = "easeOutQuint" })

-- Bordes: transición de color prolija; el giro de ángulo (borderangle en loop)
-- lo dejamos OFF por default porque es lo más molesto: gira sin parar y gasta batería/CPU.
hl.animation({ leaf = "border",      enabled = true, speed = 6, bezier = "linear" })
hl.animation({ leaf = "borderangle", enabled = false })
-- Si en algún momento lo querés de nuevo, descomentá esto y borrá la línea de arriba:
-- hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "linear", style = "loop" })

-- Workspaces: slide limpio, sin rebote al llegar
hl.animation({ leaf = "workspaces",       enabled = true, speed = 4.0, bezier = "easeOutExpo", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3.5, bezier = "easeOutExpo", style = "slidevert" })

-- Layers (rofi, waybar, notificaciones, etc.): entran y salen sin drama
hl.animation({ leaf = "layersIn",  enabled = true, speed = 3.0, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2.2, bezier = "easeOutQuint", style = "slide" })