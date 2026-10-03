hl.window_rule({
	name = "suppress-maximize",
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})

hl.window_rule({
	name = "idle-inhibit-fullscreen",
	match = {
		class = ".*",
	},
	idle_inhibit = "fullscreen",
})

hl.window_rule({
	name = "float-file-chooser",
	match = {
		class = "^(xdg-desktop-portal-gtk)$",
	},
	float = true,
	size = { "monitor_w*0.5", "monitor_h*0.6" },
})

hl.window_rule({
	name = "picture-in-picture",
	match = {
		title = "^(Picture-in-Picture)$",
	},
	float = true,
	pin = true,
	keep_aspect_ratio = true,
	size = { "monitor_w*0.25", "monitor_h*0.25" },
	move = { "monitor_w*0.75-24", "monitor_h*0.75-24" },
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
