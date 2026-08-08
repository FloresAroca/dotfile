-- ==================================================================================

-- ██╗░░██╗███████╗██╗░░░██╗██████╗░██╗███╗░░██╗██████╗░██╗███╗░░██╗░██████╗░░██████╗
-- ██║░██╔╝██╔════╝╚██╗░██╔╝██╔══██╗██║████╗░██║██╔══██╗██║████╗░██║██╔════╝░██╔════╝
-- █████═╝░█████╗░░░╚████╔╝░██████╦╝██║██╔██╗██║██║░░██║██║██╔██╗██║██║░░██╗░╚█████╗░
-- ██╔═██╗░██╔══╝░░░░╚██╔╝░░██╔══██╗██║██║╚████║██║░░██║██║██║╚████║██║░░╚██╗░╚═══██╗
-- ██║░╚██╗███████╗░░░██║░░░██████╦╝██║██║░╚███║██████╔╝██║██║░╚███║╚██████╔╝██████╔╝
-- ╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚═════╝░╚═╝╚═╝░░╚══╝╚═════╝░╚═╝╚═╝░░╚══╝░╚═════╝░╚═════╝░
--  modules/keybindings.lua
--  All keyboard and mouse bindings.
--  Docs: https://wiki.hypr.land/Configuring/Basics/Binds/
-- ==================================================================================

local p = require("modules/programs")
local mainMod = "SUPER"

-- ---- Window management --------------------------------------
hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(p.terminal))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- ---- Terminal Apps ---------------------------------------------------
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(p.terminal .. " --hold fastfetch --config ~/.config/fastfetch/os.jsonc"))
hl.bind(mainMod .. " + C",
  hl.dsp.exec_cmd(p.terminal ..
  " --class music -o background_opacity=0 -o hide_window_decorations=yes -o confirm_os_window_close=0 --hold cava"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(p.terminal .. " --hold peaclock"))

-- ---- Apps ---------------------------------------------------
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(p.file_manager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(p.menu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(p.wallpaper))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("~/.config/scripts/random-wallpaper.sh"))
-- ---- Session ------------------------------------------------
hl.bind(
  mainMod .. " + M",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

-- ---- Focus (arrow keys) -------------------------------------
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- ---- Workspaces 1–10 ----------------------------------------
for i = 1, 10 do
  local key = i % 10 -- workspace 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- ---- Special workspace (scratchpad) -------------------------
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- ---- Workspace keys (keyboard arrows) -------------------------
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.focus({ workspace = "+1" }))

-- ---- Workspace scroll (mouse wheel) -------------------------
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- ---- Swap windows (keyboard arrows) ---------------------
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "d" }))

-- ---- Move / resize windows (mouse drag) ---------------------
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ---- Media & hardware keys ----------------------------------
local locked_repeat = { locked = true, repeating = true }
local locked = { locked = true }

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), locked_repeat)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), locked_repeat)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), locked_repeat)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), locked_repeat)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), locked_repeat)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), locked_repeat)

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), locked)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), locked)

-- ---- Screenshot keys | hyprshot ----------------------------------
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainMod .. " + CTRL + SPACE", hl.dsp.exec_cmd("hyprshot -m output"))

-- ---- Wlogout keys ----------------------------------
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("wlogout --buttons-per-row 3"))

-- ---- Waybar key -------------------------------------
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("pkill waybar"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("~/.config/waybar/scripts/toggle_top_bar.sh"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("~/.config/waybar/scripts/toggle_bottom_bar.sh"))
