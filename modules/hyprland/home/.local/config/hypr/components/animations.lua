-- Subtle and fast: short durations, no bounce, small movements.
-- speed is in deciseconds (2 = 200 ms).

hl.config({
	animations = {
		enabled = true,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })

hl.animation({ leaf = "global", enabled = true, speed = 2, bezier = "easeOutQuint" })

-- Windows open with a slight scale-up and close with a quick fade
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "easeOutQuint", style = "popin 95%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "linear", style = "popin 95%" })
-- Scrolling the strip, moving and resizing
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2.5, bezier = "easeOutQuint" })

hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "easeOutQuint" })

-- Panels, launcher and notifications from the desktop shell
hl.animation({ leaf = "layers", enabled = true, speed = 2, bezier = "easeOutQuint", style = "fade" })

-- Workspaces stack vertically, columns scroll horizontally
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "easeOutQuint", style = "slidefadevert 20%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2, bezier = "easeOutQuint", style = "slidefadevert 10%" })
