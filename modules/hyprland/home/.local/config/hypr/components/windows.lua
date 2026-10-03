hl.window_rule({
	name = "center-floating",
	match = {
		float = true,
	},
	center = true,
})

hl.window_rule({
	name  = "fix-xwayland-drags",
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
