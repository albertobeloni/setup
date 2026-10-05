-- Workspace and monitor rules and keybinds.

local bind = require("helpers.bind")
local move = require("helpers.move")

hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = "uwsm app -- kitty & uwsm app -- kitty" })

-- Workspaces 1 to 10 (key 0 is workspace 10)

for i = 1, 10 do
	local key = i % 10
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Previous and next workspaces

hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("SUPER + ALT + up", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("SUPER + ALT + down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("SUPER + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Left and right send the window to the next monitor; up and down send it to
-- the previous or next workspace.
for side, action in pairs({ left = move.to_monitor, right = move.to_monitor, up = move.to_workspace, down = move.to_workspace }) do
	bind.active("SUPER + CTRL + " .. side, action, side)
end

-- Jumps to an empty workspace, or back if already on one.
hl.bind("SUPER + D", function()
	local workspace = hl.get_active_workspace()

	if workspace ~= nil and workspace.is_empty then
		hl.dispatch(hl.dsp.focus({ workspace = "previous" }))
	else
		hl.dispatch(hl.dsp.focus({ workspace = "emptym" }))
	end
end)

-- Scratchpad

hl.bind("SUPER + apostrophe", hl.dsp.workspace.toggle_special("scratchpad"))
