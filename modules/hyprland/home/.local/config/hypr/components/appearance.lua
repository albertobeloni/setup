hl.config({

	general = {
		border_size = 1,
		gaps_in = 8,
		gaps_out = 32,
		resize_on_border = true,

		col = {
			active_border = 0xff00ff00,
			inactive_border = 0xff0000ff,
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
		rounding = 4,

		shadow = {
			color = 0x11000000,
			color_inactive = 0x11000000,
			enabled = true,
			offset = {0, 0},
			range = 4,
			render_power = 4,
			-- sharp = true,
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
