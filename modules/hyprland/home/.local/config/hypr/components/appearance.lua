hl.config({

	general = {
		border_size = 2,
		gaps_in = 8,
		gaps_out = 32,
		resize_on_border = true,

		col = {
			active_border = "rgba(117, 117, 117, 0.15)",
			inactive_border = "rgba(117, 117, 117, 0.15)",
		},

	},

	group = {
		groupbar = {
			height = 16,
		},
	},

	decoration = {
		active_opacity = 1.0,
		dim_special = 0.5,
		inactive_opacity = 1.0,
		rounding = 8,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = true,
			passes = 2,
			size = 8,
			special = true,
		},

	},

	misc = {
		disable_hyprland_guiutils_check = true,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
	},

})
