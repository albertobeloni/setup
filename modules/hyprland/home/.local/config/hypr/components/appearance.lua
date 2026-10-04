hl.config({

	general = {
		gaps_in = 8,
		gaps_out = 32,
		border_size = 2,
		resize_on_border = true,
	},

	group = {
		groupbar = {
			height = 16,
		},
	},

	decoration = {
		rounding = 8,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		dim_special = 0.5,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = true,
			size = 16,
			passes = 3,
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
