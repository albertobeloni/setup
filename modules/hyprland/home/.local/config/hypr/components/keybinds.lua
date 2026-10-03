local terminal = "uwsm app -- kitty"

local modifier = "SUPER"

-- Hyprland: Exit
-- hl.bind(modifier .. " + SHIFT + Escape", hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.exit()'"))

-- Application: Terminal
hl.bind(modifier .. " + Return", hl.dsp.exec_cmd(terminal))

-- Window: Close
hl.bind(modifier .. " + Escape", hl.dsp.window.close())
-- Window: Focus
hl.bind(modifier .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(modifier .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(modifier .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(modifier .. " + down",  hl.dsp.focus({ direction = "down" }))
-- Window: Move
hl.bind(modifier .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
-- Window: Resize
hl.bind(modifier .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
-- Window: Float
hl.bind(modifier .. " + F", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.center())
end)
-- Window: Switch
hl.bind("ALT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.bring_to_top())
end)
-- Window: Send to Desktop
hl.bind(modifier .. " + SHIFT + left", hl.dsp.window.move({ window = "activewindow", direction = "left" }))
hl.bind(modifier .. " + SHIFT + right", hl.dsp.window.move({ window = "activewindow", direction = "right" }))
hl.bind(modifier .. " + SHIFT + up", hl.dsp.window.move({ window = "activewindow", direction = "up" }))
hl.bind(modifier .. " + SHIFT + down", hl.dsp.window.move({ window = "activewindow", direction = "down" }))

-- Workspace: Focus and Move
for i = 1, 10 do
	local key = i % 10
	hl.bind(modifier .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(modifier .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
-- Workspace: Switch
hl.bind(modifier .. " + Tab", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(modifier .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("ALT + SHIFT + Tab", hl.dsp.focus({ workspace = "e+1" }))

-- Screen: Screenshot
hl.bind(modifier .. " + SHIFT + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" "$(xdg-user-dir PICTURES)/Screenshots/$(date +'%Y%m%d-%H%M%S').png"]]))
-- Screen: Lock
hl.bind(modifier .. " + L", hl.dsp.exec_cmd("uwsm app -- hyprlock"))

-- Function Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Layout: Columns
hl.bind(modifier .. " + period", hl.dsp.layout("move +col"))
hl.bind(modifier .. " + comma", hl.dsp.layout("move -col"))
hl.bind(modifier .. " + SHIFT + period", hl.dsp.layout("swapcol r"))
hl.bind(modifier .. " + SHIFT + comma", hl.dsp.layout("swapcol l"))
hl.bind(modifier .. " + equal", hl.dsp.layout("colresize +conf"))
hl.bind(modifier .. " + minus", hl.dsp.layout("colresize -conf"))
