local fallbacks = {
	CmdlineIndicator = "StatusLineMode",
	CursorLineNrSeparator = "CursorLineNr",
	LineNrSeparator = "LineNr",
	StatusLineMode = "StatusLine",
	StatusLineModified = "StatusLine",
}

local function link()
	for group, fallback in pairs(fallbacks) do
		vim.api.nvim_set_hl(0, group, { link = fallback, default = true })
	end
end

link()

vim.api.nvim_create_autocmd("ColorScheme", { callback = link })

vim.o.background = "dark"
pcall(vim.cmd.colorscheme, "rose")
