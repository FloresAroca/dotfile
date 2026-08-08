-- =================================================================
-- ██████╗░██╗░░░██╗██╗░░░░░███████╗░██████╗
-- ██╔══██╗██║░░░██║██║░░░░░██╔════╝██╔════╝
-- ██████╔╝██║░░░██║██║░░░░░█████╗░░╚█████╗░
-- ██╔══██╗██║░░░██║██║░░░░░██╔══╝░░░╚═══██╗
-- ██║░░██║╚██████╔╝███████╗███████╗██████╔╝
-- ╚═╝░░╚═╝░╚═════╝░╚══════╝╚══════╝╚═════╝░

--  modules/rules.lua
--  Window rules, layer rules, and workspace rules.
--  Docs: https://wiki.hypr.land/Configuring/Basics/Window-Rules/
--        https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- =================================================================

-- ---- Window rules -------------------------------------------

-- Ignore maximize requests from all apps
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Fix dragging issues with XWayland floating windows
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

-- Position the hyprland-run floating window near the bottom-left
hl.window_rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move = "20 monitor_h-120",
  float = true,
})

hl.layer_rule({
  match = { namespace = "waybar" },
  blur = true,
  ignore_alpha = 0.3,
})

hl.layer_rule({
  match = {
    namespace = "selection",
  },
  no_anim = true,
})

hl.layer_rule({
  match = { namespace = "rofi" },
  blur = true,
  ignore_alpha = 0.3,
})

hl.window_rule({
  match = {
    class = "music",
  },

  float = true,
  size = { 1400, 120 },
  move = { -20, 665 },
  no_shadow = true,
  no_anim = true,
  pin = false,
})

-- ---- Layer rules (examples, disabled) ----------------------
-- local overlayRule = hl.layer_rule({
--     name     = "no-anim-overlay",
--     match    = { namespace = "^my-overlay$" },
--     no_anim  = true,
-- })
-- overlayRule:set_enabled(false)
