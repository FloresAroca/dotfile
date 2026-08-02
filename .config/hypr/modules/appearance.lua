-- ==================================================================================
-- ░█████╗░██████╗░██████╗░███████╗░█████╗░██████╗░░█████╗░███╗░░██╗░█████╗░███████╗
-- ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗████╗░██║██╔══██╗██╔════╝
-- ███████║██████╔╝██████╔╝█████╗░░███████║██████╔╝███████║██╔██╗██║██║░░╚═╝█████╗░░
-- ██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██║██╔══██╗██╔══██║██║╚████║██║░░██╗██╔══╝░░
-- ██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██║░░██║██║░░██║██║░╚███║╚█████╔╝███████╗
-- ╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝

--  modules/appearance.lua
--  Visual settings: borders, gaps, blur, shadows, layouts, misc.
--  Docs: https://wiki.hypr.land/Configuring/Basics/Variables/
-- ==================================================================================

local colors = require("colors/colors")

-- ---- General ------------------------------------------------
hl.config({
	general = {
		gaps_in = 4,
		-- gaps_out    = 20,
		gaps_out = {
			top = 5,
			right = 5,
			bottom = 5,
			left = 5,
		},

		border_size = 0,

		col = {
			-- Al pasar los colores dentro de una tabla {}, Hyprland interpreta el degradado de forma interna
			active_border = {
				colors = { colors.primary, colors.error },
				angle = 25,
			},
			inactive_border = colors.outline,
		},

		--		col = {
		-- Borde activo simple
		-- active_border = colors.primary .. " ".. colors.primary_container .. " 45deg",
		--active_border = colors.primary .. " " .. colors.outline .. " 45deg",
		--			inactive_border = colors.outline,
		--		},

		-- Allow resizing windows by dragging on borders/gaps
		resize_on_border = false,
		-- Read https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before enabling
		allow_tearing = false,
		layout = "dwindle",
	},
})

-- ---- Decoration ---------------------------------------------
hl.config({
	decoration = {
		rounding = 15, -- 5
		rounding_power = 3, -- 3.0

		active_opacity = 1,
		inactive_opacity = 1,

		shadow = {
			enabled = true,
			render_power = 5,
			range = 20,
			sharp = false,
			render_power = 10,
			color = 0x44000000,
		},

		blur = {
			enabled = true,
			size = 6,
			passes = 2,
			new_optimizations = true,
			xray = true,
			vibrancy = 0.3002, --0.1696
		},
	},
})

-- ---- Layouts ------------------------------------------------
-- Dwindle: https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
hl.config({
	dwindle = {
		preserve_split = true,
	},
})

-- Master: https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
hl.config({
	master = {
		new_status = "master",
	},
})

-- Scrolling: https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

-- ---- Misc ---------------------------------------------------
hl.config({
	misc = {
		-- -1 keeps the default; set to 0 or 1 to disable anime mascot wallpaper
		force_default_wallpaper = -1,
		-- Set true to disable the random Hyprland logo background
		disable_hyprland_logo = false,
	},
})

-- ---- Smart gaps (uncomment to enable "no gaps when only") ---
-- Docs: https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0, rounding = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0, rounding = 0,
-- })
