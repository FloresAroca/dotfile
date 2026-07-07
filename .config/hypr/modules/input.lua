-- =============================================================
-- ██╗███╗░░██╗██████╗░██╗░░░██╗████████╗░██████╗
-- ██║████╗░██║██╔══██╗██║░░░██║╚══██╔══╝██╔════╝
-- ██║██╔██╗██║██████╔╝██║░░░██║░░░██║░░░╚█████╗░
-- ██║██║╚████║██╔═══╝░██║░░░██║░░░██║░░░░╚═══██╗
-- ██║██║░╚███║██║░░░░░╚██████╔╝░░░██║░░░██████╔╝
-- ╚═╝╚═╝░░╚══╝╚═╝░░░░░░╚═════╝░░░░╚═╝░░░╚═════╝░

--  modules/input.lua
--  Keyboard, mouse, touchpad, gestures, and per-device config.
--  Docs: https://wiki.hypr.land/Configuring/Basics/Variables/
-- =============================================================

-- ---- Keyboard & mouse ---------------------------------------
hl.config({
    input = {
        kb_layout  = "latam",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

		repeat_delay = 250,
		repeat_rate  = 50,
		
        follow_mouse = 1,
        -- Range: -1.0 to 1.0 (0 = no modification)
        sensitivity  = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- ---- Gestures -----------------------------------------------
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- ---- Per-device overrides -----------------------------------
-- Docs: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
