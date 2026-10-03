local function app(command)
	return hl.dsp.exec_cmd("uwsm app -- " .. command)
end

local function at_edge(direction)
	local window = hl.get_active_window()

	if window == nil then
		return false
	end

	if window.floating then
		return true
	end

	for _, other in ipairs(window.workspace:get_windows()) do
		if not other.floating and other.address ~= window.address then
			if direction == "left" and other.at.x < window.at.x then
				return false
			elseif direction == "right" and other.at.x > window.at.x then
				return false
			end
		end
	end

	return true
end

local function monitor_towards(direction)
	local current = hl.get_active_monitor()

	if current == nil then
		return false
	end

	for _, monitor in ipairs(hl.get_monitors()) do
		if direction == "left" and monitor.x < current.x then
			return true
		elseif direction == "right" and monitor.x > current.x then
			return true
		end
	end

	return false
end

local function move_window(direction)
	return function()
		if at_edge(direction) then
			if monitor_towards(direction) then
				hl.dispatch(hl.dsp.window.move({ monitor = direction }))
			end
		elseif direction == "left" then
			hl.dispatch(hl.dsp.layout("swapcol l"))
		else
			hl.dispatch(hl.dsp.layout("swapcol r"))
		end
	end
end

hl.bind("SUPER + L", app("hyprlock"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("uwsm stop"))

hl.bind("SUPER + Return", app("kitty"))
hl.bind("CTRL + ALT + T", app("kitty"))
hl.bind("SUPER + E", app("org.gnome.Nautilus.desktop"))
hl.bind("CTRL + SHIFT + Escape", app("net.nokyan.Resources.desktop"))

hl.bind("SUPER + Q", hl.dsp.window.close())

hl.bind("ALT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind("ALT + SHIFT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
	hl.dispatch(hl.dsp.window.bring_to_top())
end)

hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))

hl.bind("SUPER + SHIFT + left", move_window("left"))
hl.bind("SUPER + SHIFT + right", move_window("right"))

hl.bind("SUPER + SHIFT + up", hl.dsp.window.fullscreen({ mode = "maximized", action = "set" }))
hl.bind("SUPER + SHIFT + down", function()
	hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized", action = "unset" }))
	hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen", action = "unset" }))
end)
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + SHIFT + F", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.center())
end)

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("SUPER + equal", hl.dsp.layout("colresize +conf"))
hl.bind("SUPER + minus", hl.dsp.layout("colresize -conf"))
hl.bind("SUPER + C", hl.dsp.layout("center"))

hl.bind("SUPER + bracketleft", hl.dsp.layout("consume_or_expel prev"))
hl.bind("SUPER + bracketright", hl.dsp.layout("consume_or_expel next"))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + mouse_down", hl.dsp.layout("move +col"))
hl.bind("SUPER + mouse_up", hl.dsp.layout("move -col"))

for i = 1, 10 do
	local key = i % 10
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + CTRL + up", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("SUPER + CTRL + down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("SUPER + D", function()
	local workspace = hl.get_active_workspace()

	if workspace ~= nil and workspace.is_empty then
		hl.dispatch(hl.dsp.focus({ workspace = "previous" }))
	else
		hl.dispatch(hl.dsp.focus({ workspace = "emptym" }))
	end
end)

hl.bind("SUPER + apostrophe", hl.dsp.workspace.toggle_special("scratchpad"))

hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("screenshot region"))
hl.bind("Print", hl.dsp.exec_cmd("screenshot screen"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("screenshot region"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("screenshot window"))

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
