hl.config({

	general = {
		gaps_in = 8,
		gaps_out = 16,
		-- Thicker border so the focused column is easy to spot (colors come with the theme step)
		border_size = 4,
		-- Drag window borders and gaps to resize
		resize_on_border = true,
	},

	group = {
		groupbar = {
			height = 16,
		},
	},

	decoration = {
		rounding = 0,
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = false,
		},

		-- Only used by translucent surfaces (the desktop shell later)
		blur = {
			enabled = true,
			size = 16,
			passes = 3,
		},
	},

	misc = {
		disable_hyprland_guiutils_check = true,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
	},

})
