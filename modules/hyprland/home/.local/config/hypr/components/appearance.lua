hl.config({

	general = {
		border_size = 2,
		gaps_in = 8,
		gaps_out = 32,
		resize_on_border = true,

		col = {
			active_border = "rgb(777777)",
			inactive_border = "rgb(262626)",
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
		rounding = 0,

		shadow = {
			color = "rgba(0, 0, 0, 0.25)",
			color_inactive = "rgba(0, 0, 0, 0.25)",
			enabled = true,
			offset = {4, 4},
			range = 0,
			sharp = true,
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
