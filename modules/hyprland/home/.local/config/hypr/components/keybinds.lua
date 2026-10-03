local terminal = "uwsm app -- kitty"

local modifier = "SUPER"

-- Session
hl.bind(modifier .. " + SHIFT + Escape", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(modifier .. " + L", hl.dsp.exec_cmd("uwsm app -- hyprlock"))

-- Applications
hl.bind(modifier .. " + Return", hl.dsp.exec_cmd(terminal))

-- Window: Close
hl.bind(modifier .. " + Escape", hl.dsp.window.close())
-- Window: Focus (left/right cross columns, then monitors at the ends; up/down within a column)
hl.bind(modifier .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(modifier .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(modifier .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(modifier .. " + down", hl.dsp.focus({ direction = "down" }))
-- Window: Cycle
hl.bind("ALT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind("ALT + SHIFT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
	hl.dispatch(hl.dsp.window.bring_to_top())
end)
-- Window: Reorder inside its column
hl.bind(modifier .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(modifier .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
-- Window: Join the neighboring column, or leave its column if it shares one
hl.bind(modifier .. " + CTRL + left", hl.dsp.layout("consume_or_expel prev"))
hl.bind(modifier .. " + CTRL + right", hl.dsp.layout("consume_or_expel next"))
-- Window: Send to the monitor on the left/right
hl.bind(modifier .. " + ALT + left", hl.dsp.window.move({ monitor = "l" }))
hl.bind(modifier .. " + ALT + right", hl.dsp.window.move({ monitor = "r" }))
-- Window: Fullscreen and maximize
hl.bind(modifier .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(modifier .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
-- Window: Float
hl.bind(modifier .. " + V", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.center())
end)
-- Window: Move and resize with the mouse
hl.bind(modifier .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(modifier .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Column: Swap with the neighbor
hl.bind(modifier .. " + SHIFT + left", hl.dsp.layout("swapcol l"))
hl.bind(modifier .. " + SHIFT + right", hl.dsp.layout("swapcol r"))
-- Column: Cycle widths (0.333, 0.5, 0.667, 1.0)
hl.bind(modifier .. " + equal", hl.dsp.layout("colresize +conf"))
hl.bind(modifier .. " + minus", hl.dsp.layout("colresize -conf"))
-- Column: Center
hl.bind(modifier .. " + C", hl.dsp.layout("center"))
-- Strip: Scroll without moving focus
hl.bind(modifier .. " + period", hl.dsp.layout("move +col"))
hl.bind(modifier .. " + comma", hl.dsp.layout("move -col"))
hl.bind(modifier .. " + mouse_down", hl.dsp.layout("move +col"))
hl.bind(modifier .. " + mouse_up", hl.dsp.layout("move -col"))

-- Resize mode: arrows resize the window, Escape or Return to leave
hl.bind(modifier .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	hl.bind("right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
	hl.bind("left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
	hl.bind("down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })
	hl.bind("up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
	hl.bind("Escape", hl.dsp.submap("reset"))
	hl.bind("Return", hl.dsp.submap("reset"))
end)

-- Workspace: Focus and move window (1-5 external monitor, 6-0 laptop)
for i = 1, 10 do
	local key = i % 10
	hl.bind(modifier .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(modifier .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
-- Workspace: Previous/next on this monitor (vertical, like the gesture)
hl.bind(modifier .. " + Page_Down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(modifier .. " + Page_Up", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(modifier .. " + Tab", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(modifier .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(modifier .. " + SHIFT + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(modifier .. " + SHIFT + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
-- Workspace: Send the whole workspace to the monitor on the left/right
hl.bind(modifier .. " + ALT + SHIFT + left", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(modifier .. " + ALT + SHIFT + right", hl.dsp.workspace.move({ monitor = "r" }))
-- Workspace: Scratchpad
hl.bind(modifier .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(modifier .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- Screenshots: saved to Pictures/Screenshots and copied to the clipboard
hl.bind("Print", hl.dsp.exec_cmd("screenshot region"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("screenshot screen"))

-- Function Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
