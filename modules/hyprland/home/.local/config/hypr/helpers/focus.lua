-- Directional focus that reaches tiled and floating windows alike. Hyprland's
-- own movefocus only considers windows with the same floating state as the
-- current one.

local geometry = require("helpers.geometry")
local neighbors = require("helpers.neighbors")

local Helper = {}

-- The line focus is traveling along: the window it last landed on and the
-- point it passed through. Focusing a window any other way, such as by
-- clicking, starts a new line from that window's center.
local line_state = nil

-- Focuses the nearest window in a direction and raises it. If there's none on
-- this workspace, focus moves to the next monitor.
function Helper.towards(direction)
	local window = hl.get_active_window()

	if window ~= nil and window.fullscreen ~= 0 then
		line_state = nil
		hl.dispatch(hl.dsp.focus({ direction = direction }))
		return
	end

	local target = nil
	local line = nil

	if window ~= nil then
		local a = geometry.box(window)

		if line_state ~= nil and line_state.address == window.address then
			line = { x = line_state.x, y = line_state.y }
		else
			line = { x = a.x.mid, y = a.y.mid }
		end

		target = neighbors.to_focus(window, direction, line)
	end

	if target == nil then
		line_state = nil

		local monitor = hl.get_monitor(direction)

		if monitor ~= nil then
			hl.dispatch(hl.dsp.focus({ monitor = monitor }))
		end

		return
	end

	-- The line keeps its position across the direction of travel and moves
	-- along with the target.
	local along = geometry.DIRECTIONS[direction].along

	line[along] = geometry.box(target)[along].mid
	line_state = { address = target.address, x = line.x, y = line.y }

	hl.dispatch(hl.dsp.focus({ window = target }))

	if target.floating then
		hl.dispatch(hl.dsp.window.bring_to_top())
	end
end

return Helper
