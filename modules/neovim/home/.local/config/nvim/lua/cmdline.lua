local interface = require("vim._core.ui2")
local command_line = require("vim._core.ui2.cmdline")

interface.enable()

vim.o.cmdheight = 0

-- ------------------------------------------------------------------------------
-- Statusline
-- ------------------------------------------------------------------------------

local visibility = nil

vim.api.nvim_create_autocmd("CmdlineEnter", {
	nested = true,
	callback = function()
		if visibility == nil then
			visibility = vim.o.laststatus
			vim.o.laststatus = 0
		end
	end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
	nested = true,
	callback = function()
		if vim.v.event.cmdlevel == 1 and visibility ~= nil then
			vim.o.laststatus = visibility
			visibility = nil
		end
	end,
})

-- ------------------------------------------------------------------------------
-- Indicator
-- ------------------------------------------------------------------------------

local namespace = vim.api.nvim_create_namespace("cmdline")

local indicators = {
	[":"] = " C ",
}

local show = command_line.cmdline_show

function command_line.cmdline_show(content, position, first_character, prompt, ...)
	show(content, position, first_character, prompt, ...)

	local indicator = prompt == "" and indicators[first_character] or ""

	vim.api.nvim_buf_clear_namespace(interface.bufs.cmd, namespace, 0, -1)

	if indicator ~= "" then
		vim.api.nvim_buf_set_extmark(interface.bufs.cmd, namespace, command_line.erow, 0, {
			virt_text = { { indicator, "CmdlineIndicator" } },
			virt_text_pos = "inline",
			right_gravity = false,
		})
	end

	vim.api.nvim_win_set_config(interface.wins.cmd, { _cmdline_offset = vim.fn.strdisplaywidth(indicator) })
end

local hide = command_line.cmdline_hide

function command_line.cmdline_hide(...)
	vim.api.nvim_buf_clear_namespace(interface.bufs.cmd, namespace, 0, -1)
	hide(...)
end
