local statuscolumn = {}

function statuscolumn.render()
	local window = vim.wo[vim.g.statusline_winid]

	if not (window.number or window.relativenumber) then
		return ""
	end

	local highlight = vim.v.relnum == 0 and window.cursorline and "%#CursorLineNrSeparator#" or "%#LineNrSeparator#"

	return " %l " .. highlight .. "│"
end

vim.o.number = true
vim.o.statuscolumn = "%!v:lua.require'statuscolumn'.render()"

vim.keymap.set("n", "<leader>r", function()
	vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle relative line numbers" })

return statuscolumn
