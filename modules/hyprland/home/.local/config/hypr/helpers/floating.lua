-- Switching windows between floating and tiled, and maximizing them.
--
-- Floating windows always come back at the size they opened with. Hyprland
-- only remembers the last floating size, which changes when the window is
-- resized, tiled or made fullscreen.

local geometry = require("helpers.geometry")

local Helper = {}

-- State, keyed by window address and cleared on config reload: the size each
-- window opened with, and the position and size of floating windows
-- maximized with toggle_maximized.
local opening_size = {}
local maximized_geometry = {}

hl.on("window.open", function(window)
	if window.floating then
		opening_size[window.address] = { width = window.size.x, height = window.size.y }
	end
end)

hl.on("window.close", function(window)
	opening_size[window.address] = nil
	maximized_geometry[window.address] = nil
end)

-- Tiles a window. Dwindle places it next to the active tiled window, or the
-- one under the cursor, on the side the cursor is on (smart_split).
function Helper.tile(window)
	hl.dispatch(hl.dsp.window.float({ window = window, action = "disable" }))
end

-- Floats a window at the given size, or at the size it opened with. Windows
-- that opened tiled (the scratchpad) have no recorded size and keep the size
-- Hyprland picks.
local function float(window, size)
	size = size or opening_size[window.address]

	hl.dispatch(hl.dsp.window.float({ window = window, action = "enable" }))

	if size ~= nil then
		hl.dispatch(hl.dsp.window.resize({ window = window, x = size.width, y = size.height }))
	end
end

-- Floats a window at the given placement (position and size), or at its
-- opening size, centered.
local function float_at(window, placement)
	float(window, placement)

	if placement ~= nil then
		hl.dispatch(hl.dsp.window.move({ window = window, x = placement.x, y = placement.y }))
	else
		hl.dispatch(hl.dsp.window.center({ window = window }))
	end
end

-- Floats a window at its opening size, centered on a point and kept within
-- that point's monitor.
function Helper.float_under(window, point)
	float(window)

	-- The window's size already reads as the new size here.
	local width, height = window.size.x, window.size.y
	local x, y = point.x - width / 2, point.y - height / 2
	local monitor = hl.get_monitor_at(point)

	if monitor ~= nil then
		local area = geometry.monitor_box(monitor)

		x = math.max(area.x.min, math.min(x, area.x.max - width))
		y = math.max(area.y.min, math.min(y, area.y.max - height))
	end

	hl.dispatch(hl.dsp.window.move({ window = window, x = math.floor(x), y = math.floor(y) }))
end

-- Tiles a floating window, or floats a tiled one centered at its opening size.
function Helper.toggle(window)
	if window.fullscreen ~= 0 then
		return
	end

	if window.floating then
		Helper.tile(window)
	else
		float_at(window)
	end
end

-- Toggles maximize. Floating windows are tiled first, then return to their
-- previous position and size when unmaximized.
function Helper.toggle_maximized(window)
	if window.fullscreen ~= 0 then
		local previous = maximized_geometry[window.address]

		maximized_geometry[window.address] = nil

		-- Clears maximized, fullscreen or both.
		hl.dispatch(hl.dsp.window.fullscreen_state({ window = window, internal = 0, client = 0 }))

		if previous ~= nil then
			float_at(window, previous)
		end

		return
	end

	-- Clear any stale geometry, in case a floating window was unmaximized
	-- some other way.
	maximized_geometry[window.address] = nil

	if window.floating then
		maximized_geometry[window.address] = {
			x = window.at.x,
			y = window.at.y,
			width = window.size.x,
			height = window.size.y,
		}

		Helper.tile(window)
	end

	hl.dispatch(hl.dsp.window.fullscreen({ window = window, mode = "maximized", action = "set" }))
end

return Helper
