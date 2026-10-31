local statusline = {}

function statusline.render()
	if vim.o.laststatus == 0 then
		return ""
	end

	local mode = vim.fn.mode(1)
	local name = vim.fn.expand("%:."):gsub("%%", "%%%%")
	local modified = vim.bo.modified and "%#StatusLineModified#" or "%#StatusLine#"

	return table.concat({
		"%#StatusLineMode# ",
		mode,
		" %#StatusLine# ",
		modified,
		name,
		"%#StatusLine#%=",
	})
end

local function separate()
	local hidden = vim.o.laststatus == 0
	local separator = hidden and (vim.opt.fillchars:get().horiz or "─") or " "
	local highlights = hidden and "StatusLine:WinSeparator,StatusLineNC:WinSeparator" or ""

	vim.opt.fillchars:append({ stl = separator, stlnc = separator })

	for _, window in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(window).relative == "" then
			vim.wo[window].winhighlight = highlights
		end
	end
end

vim.o.laststatus = 0
vim.o.statusline = "%!v:lua.require'statusline'.render()"

separate()

vim.api.nvim_create_autocmd("OptionSet", { pattern = "laststatus", callback = separate })

vim.api.nvim_create_autocmd("ModeChanged", {
	callback = function()
		vim.cmd.redrawstatus()
	end,
})

vim.keymap.set("n", "<leader>s", function()
	vim.o.laststatus = vim.o.laststatus == 0 and 3 or 0
end, { desc = "Toggle statusline" })

return statusline
