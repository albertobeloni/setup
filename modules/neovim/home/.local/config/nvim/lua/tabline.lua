local tabline = {}

function tabline.render()
	local current = vim.api.nvim_get_current_tabpage()
	local tabs = {}

	for index, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local buffer = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab))
		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buffer), ":t"):gsub("%%", "%%%%")
		local highlight = tab == current and "%#TabLineSel#" or "%#TabLine#"

		table.insert(tabs, ("%s%%%dT %s %%T"):format(highlight, index, name ~= "" and name or "New file"))
	end

	return table.concat(tabs) .. "%#TabLineFill#"
end

vim.o.tabline = "%!v:lua.require'tabline'.render()"

return tabline
