-- The tiling layout of a workspace, and actions that differ between layouts.
-- Workspaces use dwindle unless a workspace rule picks scrolling.

local Helper = {}

-- Whether the window's workspace uses the scrolling layout.
function Helper.scrolling(window)
	local workspace = window.workspace
	return workspace ~= nil and workspace.tiled_layout == "scrolling"
end

-- Grows (positive delta) or shrinks the active tiled window: dwindle changes
-- its split ratio, scrolling the width of its column.
function Helper.resize(delta)
	local workspace = hl.get_active_workspace()
	local scrolling = workspace ~= nil and workspace.tiled_layout == "scrolling"
	local message = scrolling and "colresize" or "splitratio"

	hl.dispatch(hl.dsp.layout(string.format("%s %+.1f", message, delta)))
end

return Helper
