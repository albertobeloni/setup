local fallbacks = {
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

vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = function()
		pcall(vim.cmd.colorscheme, "lumen")
	end,
})

pcall(vim.cmd.colorscheme, "lumen")
