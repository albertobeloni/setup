-- Windows, workspaces and monitors: rules, behavior and keybinds.
--
-- Windows open floating and centered, at the size the app asks for.
-- SUPER + SHIFT + drag (or arrows) tiles them, and dwindle handles the layout.

-- How close to an outer screen edge a drop has to be, in pixels.
local EDGE = 2

--------------------------------------------------------------------------------
-- Rules (applied top to bottom; the last match wins)
--------------------------------------------------------------------------------

hl.window_rule({
	name = "defaults",
	match = { class = ".*" },
	float = true,
	center = true,
	suppress_event = "maximize",
	idle_inhibit = "fullscreen",
})

hl.window_rule({
	name = "tile-scratchpad",
	match = { workspace = "special:scratchpad" },
	tile = true,
})

hl.window_rule({
	name = "file-chooser",
	match = { class = "^(xdg-desktop-portal-gtk)$" },
	size = { "monitor_w*0.5", "monitor_h*0.6" },
})

hl.window_rule({
	name = "picture-in-picture",
	match = { title = "^(Picture-in-Picture)$" },
	pin = true,
	keep_aspect_ratio = true,
	size = { "monitor_w*0.25", "monitor_h*0.25" },
	move = { "monitor_w*0.75-24", "monitor_h*0.75-24" },
})

-- XWayland drag-and-drop helpers are invisible and must not take focus.
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

--------------------------------------------------------------------------------
-- State, keyed by window address (cleared on config reload)
--------------------------------------------------------------------------------

-- The size each window opened with, restored when it floats again.
local opening_size = {}

-- Where a floating window was before SUPER + SHIFT + F maximized it.
local floating_geometry = {}

hl.on("window.open", function(window)
	if window.floating then
		opening_size[window.address] = { width = window.size.x, height = window.size.y }
	end
end)

hl.on("window.close", function(window)
	opening_size[window.address] = nil
	floating_geometry[window.address] = nil
end)

--------------------------------------------------------------------------------
-- Geometry
--------------------------------------------------------------------------------

local function box(window)
	local left, top = window.at.x, window.at.y
	local right, bottom = left + window.size.x, top + window.size.y

	return {
		left = left,
		top = top,
		right = right,
		bottom = bottom,
		center_x = (left + right) / 2,
		center_y = (top + bottom) / 2,
	}
end

-- Other tiled windows on the same workspace.
local function tiled_windows(window)
	local result = {}
	local workspace = window.workspace

	if workspace == nil then
		return result
	end

	for _, other in ipairs(workspace:get_windows()) do
		if other.mapped and not other.hidden and not other.floating and other.address ~= window.address then
			table.insert(result, other)
		end
	end

	return result
end

-- The nearest tiled window in a direction that overlaps it on the other axis.
local function tiled_neighbour(window, direction)
	local a = box(window)
	local best, best_distance, best_overlap = nil, math.huge, -1

	for _, other in ipairs(tiled_windows(window)) do
		local b = box(other)
		local distance, overlap

		if direction == "left" or direction == "right" then
			overlap = math.min(a.bottom, b.bottom) - math.max(a.top, b.top)
			distance = direction == "left" and a.left - b.right or b.left - a.right
		else
			overlap = math.min(a.right, b.right) - math.max(a.left, b.left)
			distance = direction == "up" and a.top - b.bottom or b.top - a.bottom
		end

		-- Windows that share an edge can be a pixel apart either way.
		if overlap > 0 and distance > -1 then
			if distance < best_distance or (distance == best_distance and overlap > best_overlap) then
				best, best_distance, best_overlap = other, distance, overlap
			end
		end
	end

	return best
end

-- The tiled window closest to a screen edge. Ties go to the one nearest the
-- window.
local function edge_most_tiled(window, direction)
	local a = box(window)
	local best, best_reach, best_offset = nil, -math.huge, math.huge

	for _, other in ipairs(tiled_windows(window)) do
		local b = box(other)

		-- A larger reach means closer to the edge.
		local reach, offset

		if direction == "left" then
			reach, offset = -b.left, math.abs(b.center_y - a.center_y)
		elseif direction == "right" then
			reach, offset = b.right, math.abs(b.center_y - a.center_y)
		elseif direction == "up" then
			reach, offset = -b.top, math.abs(b.center_x - a.center_x)
		else
			reach, offset = b.bottom, math.abs(b.center_x - a.center_x)
		end

		if reach > best_reach + 1 or (math.abs(reach - best_reach) <= 1 and offset < best_offset) then
			best, best_reach, best_offset = other, reach, offset
		end
	end

	return best
end

-- Returns "up" or "down" when the point is at the top or bottom edge of its
-- monitor with no other monitor beyond it. get_monitor_at returns the closest
-- monitor for points outside all of them, so a point past the edge only
-- resolves to a different monitor if one is actually there.
local function outer_edge(point)
	local monitor = hl.get_monitor_at(point)

	if monitor == nil then
		return nil
	end

	-- Width and height are in pixels and don't account for rotation, so swap
	-- them for rotated (odd) transforms.
	local height = (monitor.transform % 2 == 1 and monitor.width or monitor.height) / monitor.scale
	local top, bottom = monitor.y, monitor.y + height

	local function nothing_beyond(y)
		local beyond = hl.get_monitor_at({ x = point.x, y = y })
		return beyond == nil or beyond.id == monitor.id
	end

	if point.y <= top + EDGE and nothing_beyond(top - 1) then
		return "up"
	elseif point.y >= bottom - 1 - EDGE and nothing_beyond(bottom) then
		return "down"
	end

	return nil
end

--------------------------------------------------------------------------------
-- Actions
--------------------------------------------------------------------------------

-- Dwindle decides where a tiled window goes: next to the active tiled window,
-- or the one under the cursor, on the side the cursor is on (smart_split).
local function tile(window)
	hl.dispatch(hl.dsp.window.float({ window = window, action = "disable" }))
end

-- Floats a window at the given size, and position if there is one. Otherwise
-- it's centered.
local function float_at(window, geometry)
	hl.dispatch(hl.dsp.window.float({ window = window, action = "enable" }))

	if geometry ~= nil then
		hl.dispatch(hl.dsp.window.resize({ window = window, x = geometry.width, y = geometry.height }))
	end

	if geometry ~= nil and geometry.x ~= nil then
		hl.dispatch(hl.dsp.window.move({ window = window, x = geometry.x, y = geometry.y }))
		return
	end

	hl.dispatch(hl.dsp.window.center({ window = window }))
end

-- Moves a window to a workspace or monitor and follows it. Floating windows
-- are re-centered.
local function relocate(window, destination)
	local floating = window.floating

	destination.window = window
	destination.follow = true
	hl.dispatch(hl.dsp.window.move(destination))

	if floating then
		hl.dispatch(hl.dsp.window.center({ window = window }))
	end
end

-- Tiles a floating window, or floats a tiled one back at its opening size.
local function toggle_floating(window)
	if window.fullscreen ~= 0 then
		return
	end

	if window.floating then
		tile(window)
	else
		float_at(window, opening_size[window.address])
	end
end

-- Tiled windows toggle between maximized and their place in the layout.
-- Floating windows are tiled and maximized, then return to where they were.
local function toggle_maximized(window)
	if window.fullscreen ~= 0 then
		local geometry = floating_geometry[window.address]

		floating_geometry[window.address] = nil

		-- Clears maximized, fullscreen or both.
		hl.dispatch(hl.dsp.window.fullscreen_state({ window = window, internal = 0, client = 0 }))

		if geometry ~= nil then
			float_at(window, geometry)
		end

		return
	end

	if window.floating then
		floating_geometry[window.address] = {
			x = window.at.x,
			y = window.at.y,
			width = window.size.x,
			height = window.size.y,
		}

		tile(window)
	else
		floating_geometry[window.address] = nil
	end

	hl.dispatch(hl.dsp.window.fullscreen({ window = window, mode = "maximized", action = "set" }))
end

-- Tiled windows swap with their neighbor, keeping the layout's shape. With no
-- neighbor that way, they move to the next monitor, like focus does. Floating
-- windows tile against that edge, splitting the tiled window closest to it.
local function move_towards(window, direction)
	if window.fullscreen ~= 0 then
		return
	end

	if not window.floating then
		local other = tiled_neighbour(window, direction)

		if other ~= nil then
			hl.dispatch(hl.dsp.window.swap({ window = window, target = other }))
		elseif hl.get_monitor(direction:sub(1, 1)) ~= nil then
			-- Dwindle's own move crosses monitors and lands on the near
			-- side. Only use it when there's a monitor that way, since
			-- otherwise it re-splits this workspace.
			hl.dispatch(hl.dsp.window.move({ window = window, direction = direction }))
		end

		return
	end

	local target = edge_most_tiled(window, direction)

	if target ~= nil then
		-- Dwindle splits the active tiled window (use_active_for_splits).
		hl.dispatch(hl.dsp.focus({ window = target }))
		hl.dispatch(hl.dsp.layout("preselect " .. direction:sub(1, 1)))
	end

	tile(window)
	hl.dispatch(hl.dsp.focus({ window = window }))
end

-- "up" is the previous workspace and "down" is the next one.
local function send_to_workspace(window, side)
	local workspace = window.workspace

	if workspace == nil or workspace.special or (side == "up" and workspace.id <= 1) then
		return
	end

	relocate(window, { workspace = side == "up" and "r-1" or "r+1" })
end

-- Uses Hyprland's own lookup for the monitor next to the focused one, which
-- never returns the focused monitor itself.
local function send_to_monitor(window, side)
	local target = hl.get_monitor(side:sub(1, 1))

	if target ~= nil then
		relocate(window, { monitor = target })
	end
end

-- Runs after a drag, once the window has been dropped. At an outer top or
-- bottom edge, it sends the window to the previous or next workspace.
-- Otherwise it tiles a floating window if tile_floating is set.
local function drop(tile_floating)
	local window = hl.get_active_window()

	if window == nil or window.pinned or window.fullscreen ~= 0 then
		return
	end

	local side = outer_edge(hl.get_cursor_pos())

	if side ~= nil then
		send_to_workspace(window, side)
	elseif tile_floating and window.floating then
		tile(window)
	end
end

--------------------------------------------------------------------------------
-- Keybinds
--------------------------------------------------------------------------------

-- Binds keys to an action that receives the active window.
local function bind_active(keys, action, ...)
	local arguments = { ... }

	hl.bind(keys, function()
		local window = hl.get_active_window()

		if window ~= nil then
			action(window, table.unpack(arguments))
		end
	end)
end

-- Mouse

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:272", function() drop(false) end, { drag = true })
hl.bind("SUPER + SHIFT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + SHIFT + mouse:272", function() drop(true) end, { drag = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Focus and move (both cross to the next monitor when nothing is that way)

for _, direction in ipairs({ "left", "right", "up", "down" }) do
	hl.bind("SUPER + " .. direction, hl.dsp.focus({ direction = direction }))
	bind_active("SUPER + SHIFT + " .. direction, move_towards, direction)
end

-- Cycles through windows and raises the new one.
local function cycle(next)
	return function()
		hl.dispatch(hl.dsp.window.cycle_next({ next = next }))
		hl.dispatch(hl.dsp.window.bring_to_top())
	end
end

hl.bind("ALT + Tab", cycle(true))
hl.bind("ALT + SHIFT + Tab", cycle(false))

-- Window state

bind_active("SUPER + F", toggle_floating)
bind_active("SUPER + SHIFT + F", toggle_maximized)
hl.bind("SUPER + Q", hl.dsp.window.close())

-- Tiling (dwindle)

hl.bind("SUPER + equal", hl.dsp.layout("splitratio +0.1"))
hl.bind("SUPER + minus", hl.dsp.layout("splitratio -0.1"))

-- Monitors and workspaces

for _, side in ipairs({ "left", "right" }) do
	bind_active("SUPER + CTRL + " .. side, send_to_monitor, side)
end

for _, side in ipairs({ "up", "down" }) do
	bind_active("SUPER + CTRL + " .. side, send_to_workspace, side)
end

for i = 1, 10 do
	local key = i % 10
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Jumps to an empty workspace, or back if you're already on one.
hl.bind("SUPER + D", function()
	local workspace = hl.get_active_workspace()

	if workspace ~= nil and workspace.is_empty then
		hl.dispatch(hl.dsp.focus({ workspace = "previous" }))
	else
		hl.dispatch(hl.dsp.focus({ workspace = "emptym" }))
	end
end)

hl.bind("SUPER + apostrophe", hl.dsp.workspace.toggle_special("scratchpad"))
