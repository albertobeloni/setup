hl.config({

	general = {
		layout = "dwindle",
	},

	dwindle = {
		smart_split = true,
		precise_mouse_move = true,
		use_active_for_splits = true,
	},

	scrolling = {
		column_width = 0.5,
	},

	binds = {
		drag_threshold = 8,
		movefocus_cycles_fullscreen = true,
		hide_special_on_workspace_change = true,
	},

})

-- Workspaces use dwindle unless a rule picks scrolling, for example:
-- hl.workspace_rule({ workspace = "2", layout = "scrolling" })
