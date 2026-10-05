-- Moving windows: by direction, to other workspaces and monitors, and by
-- dragging.

local geometry = require("helpers.geometry")
local neighbors = require("helpers.neighbors")
local floating = require("helpers.floating")

local Helper = {}

-- How close to the top or bottom of the screen a drop must be, in pixels.
local EDGE = 2

-- Tiles a window against an edge by splitting target, the tiled window
-- closest to that edge. Without a target, dwindle places it as usual.
local function tile_against(window, target, direction)
	if target ~= nil then
		-- Dwindle splits the active tiled window
		-- (use_active_for_splits).
		hl.dispatch(hl.dsp.focus({ window = target }))
		hl.dispatch(hl.dsp.layout("preselect " .. direction))
	end

	floating.tile(window)
	hl.dispatch(hl.dsp.focus({ window = window }))
end

-- Moves a window in a direction:
-- - A tiled window swaps with its neighbor, keeping the layout's shape.
-- - With no neighbor that way, it tiles against that edge, as long as another
--   tiled window also reaches it. Two rows become two columns with left or
--   right, and two columns become two rows with up or down.
-- - If it already has that edge to itself, it moves to the next monitor in
--   that direction, if there is one.
-- - A floating window tiles against that edge, next to the tiled window
--   closest to it.
function Helper.towards(window, direction)
	if window.fullscreen ~= 0 then
		return
	end

	if window.floating then
		tile_against(window, neighbors.edge_most_tiled(window, direction), direction)
		return
	end

	local other = neighbors.tiled(window, direction)

	if other ~= nil then
		hl.dispatch(hl.dsp.window.swap({ window = window, target = other }))
		return
	end

	-- Picked while the window is still tiled, so its position breaks ties.
	local target, target_reach = neighbors.edge_most_tiled(window, direction)

	if target ~= nil and target_reach >= geometry.reach(geometry.box(window), direction) - 1 then
		-- Floating takes it out of the layout so it can be tiled again
		-- elsewhere. Its floating size doesn't matter here.
		hl.dispatch(hl.dsp.window.float({ window = window, action = "enable" }))
		tile_against(window, target, direction)
	elseif hl.get_monitor(direction) ~= nil then
		-- Dwindle's own move crosses to the monitor and lands on
		-- the near side. Only use it when there's a monitor that
		-- way; otherwise, it re-splits this workspace.
		hl.dispatch(hl.dsp.window.move({ window = window, direction = direction }))
	end
end

-- Moves a window to a workspace or monitor and follows it. Floating windows
-- are recentered.
local function relocate(window, destination)
	local was_floating = window.floating

	destination.window = window
	destination.follow = true
	hl.dispatch(hl.dsp.window.move(destination))

	if was_floating then
		hl.dispatch(hl.dsp.window.center({ window = window }))
	end
end

-- Sends a window to the previous ("up") or next ("down") workspace.
function Helper.to_workspace(window, side)
	local workspace = window.workspace

	if workspace == nil or workspace.special or (side == "up" and workspace.id <= 1) then
		return
	end

	relocate(window, { workspace = side == "up" and "r-1" or "r+1" })
end

-- Sends a window to the monitor in a direction. Hyprland's lookup never
-- returns the focused monitor itself.
function Helper.to_monitor(window, side)
	local target = hl.get_monitor(side)

	if target ~= nil then
		relocate(window, { monitor = target })
	end
end

-- Returns "up" or "down" when the point is at the top or bottom edge of its
-- monitor with no other monitor beyond it. get_monitor_at returns the closest
-- monitor for points outside all of them, so a point past the edge only finds
-- a different monitor if one is actually there.
local function outer_edge(point)
	local monitor = hl.get_monitor_at(point)

	if monitor == nil then
		return nil
	end

	local area = geometry.monitor_box(monitor).y

	local function nothing_beyond(y)
		local beyond = hl.get_monitor_at({ x = point.x, y = y })
		return beyond == nil or beyond.id == monitor.id
	end

	if point.y <= area.min + EDGE and nothing_beyond(area.min - 1) then
		return "up"
	elseif point.y >= area.max - 1 - EDGE and nothing_beyond(area.max) then
		return "down"
	end

	return nil
end

-- Runs after a drag, once the window is dropped:
-- - At the outer top or bottom edge, the window goes to the previous or next
--   workspace.
-- - With tile_floating (SUPER + SHIFT), a floating window is tiled.
-- - Without it (SUPER), a tiled window floats at its opening size under the
--   cursor. Hyprland puts a dragged tiled window back into the layout on
--   drop, so a window that's tiled now was tiled when the drag started.
function Helper.drop(tile_floating)
	local window = hl.get_active_window()

	if window == nil or window.pinned or window.fullscreen ~= 0 then
		return
	end

	local cursor = hl.get_cursor_pos()
	local side = outer_edge(cursor)

	if side ~= nil then
		Helper.to_workspace(window, side)
	elseif tile_floating and window.floating then
		floating.tile(window)
	elseif not tile_floating and not window.floating then
		floating.float_under(window, cursor)
	end
end

return Helper
