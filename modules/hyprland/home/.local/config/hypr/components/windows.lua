-- Window rules and keybinds. The logic behind the keybinds is in helpers/.
--
-- Windows open floating and centered, at the size the app asks for.
-- SUPER + SHIFT + drag (or the arrow keys) tiles them, and dwindle handles
-- the layout. SUPER + drag floats them again, at the size they opened with.

local bind = require("helpers.bind")
local floating = require("helpers.floating")
local focus = require("helpers.focus")
local move = require("helpers.move")

--------------------------------------------------------------------------------
-- Rules (applied top to bottom; the last match wins)
--------------------------------------------------------------------------------

hl.window_rule({
	name = "defaults",
	match = { class = ".*" },
	float = true,
	center = true,
	-- suppress_event = "maximize",
	idle_inhibit = "fullscreen",
})

hl.window_rule({
	name = "tile-scratchpad",
	match = { workspace = "special:scratchpad" },
	tile = true,
})

-- hl.window_rule({
-- 	name = "file-chooser",
-- 	match = { class = "^(xdg-desktop-portal-gtk)$" },
-- 	size = { "monitor_w*0.5", "monitor_h*0.6" },
-- })

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
-- Keybinds
--------------------------------------------------------------------------------

-- Mouse

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:272", function() move.drop(false) end, { drag = true })
hl.bind("SUPER + SHIFT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + SHIFT + mouse:272", function() move.drop(true) end, { drag = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Focus and move (focus falls back to the next monitor; moving tiles
-- against the edge first, see helpers/move.lua)

for _, direction in ipairs({ "left", "right", "up", "down" }) do
	hl.bind("SUPER + " .. direction, function() focus.towards(direction) end)
	bind.active("SUPER + SHIFT + " .. direction, move.towards, direction)
end

-- Cycles through windows and raises the newly focused one.
local function cycle(next)
	return function()
		hl.dispatch(hl.dsp.window.cycle_next({ next = next }))
		hl.dispatch(hl.dsp.window.bring_to_top())
	end
end

hl.bind("ALT + Tab", cycle(true))
hl.bind("ALT + SHIFT + Tab", cycle(false))

-- Window state

bind.active("SUPER + F", floating.toggle)
bind.active("SUPER + SHIFT + F", floating.toggle_maximized)
hl.bind("SUPER + Q", hl.dsp.window.close())

-- Tiling (dwindle)

hl.bind("SUPER + equal", hl.dsp.layout("splitratio +0.1"))
hl.bind("SUPER + minus", hl.dsp.layout("splitratio -0.1"))
