-- ============================================================================
-- ░█████╗░███╗░░██╗██╗███╗░░░███╗░█████╗░████████╗██╗░█████╗░███╗░░██╗░██████╗
-- ██╔══██╗████╗░██║██║████╗░████║██╔══██╗╚══██╔══╝██║██╔══██╗████╗░██║██╔════╝
-- ███████║██╔██╗██║██║██╔████╔██║███████║░░░██║░░░██║██║░░██║██╔██╗██║╚█████╗░
-- ██╔══██║██║╚████║██║██║╚██╔╝██║██╔══██║░░░██║░░░██║██║░░██║██║╚████║░╚═══██╗
-- ██║░░██║██║░╚███║██║██║░╚═╝░██║██║░░██║░░░██║░░░██║╚█████╔╝██║░╚███║██████╔╝
-- ╚═╝░░╚═╝╚═╝░░╚══╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░╚════╝░╚═╝░░╚══╝╚═════╝░
-- ============================================================================

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.1, 0},     {0.0, 1}     } })
hl.curve("hobbyist",       { type = "spring", mass = 1, stiffness = 24, dampening = 6 } )

hl.animation({ leaf = "global",        enabled = true,  speed = 8,    bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 1,    bezier = "almostLinear" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 8,    spring = "hobbyist",         style = "slide" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 8,    spring = "hobbyist",         style = "slide" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 8,    spring = "hobbyist",         style = "slide bottom" })
hl.animation({ leaf = "windowsMove",   enabled = true,  speed = 8,    spring = "hobbyist" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 2,    bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint",     style = "slide bottom" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 4,    bezier = "almostLinear",     style = "slide bottom" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 10,   spring = "hobbyist",         style = "slidevert" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 8,    bezier = "quick" })
