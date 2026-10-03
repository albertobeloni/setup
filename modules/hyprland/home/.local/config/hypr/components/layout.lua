-- Scrolling layout: windows are columns on an endless horizontal strip.
-- Horizontal = columns, vertical = workspaces (keybinds, gestures and animations follow this).

hl.config({

	general = {
		layout = "scrolling",
	},

	scrolling = {
		-- A lone window fills the screen
		fullscreen_on_one_column = true,
		-- New columns open at half the screen width
		column_width = 0.5,
		-- Widths cycled by SUPER + equal / minus
		explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
		-- Scroll just enough to fit the focused column (0 would always center it)
		focus_fit_method = 1,
		follow_focus = true,
	},

	binds = {
		-- Let focus move between columns even when a window is fullscreen
		movefocus_cycles_fullscreen = true,
		-- Switching workspace closes the scratchpad
		hide_special_on_workspace_change = true,
	},

})
