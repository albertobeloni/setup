require("cmdline")
require("colors")
require("statuscolumn")
require("statusline")
require("tabline")
require("treesitter")

-- ------------------------------------------------------------------------------
-- Interface
-- ------------------------------------------------------------------------------

vim.o.cursorline = true
vim.o.guicursor = "n-v-c:hor25,i-ci-ve:hor25,r-cr:hor25,o:hor25"
vim.o.ruler = false
vim.o.showmode = false
vim.o.termguicolors = true

vim.opt.fillchars:append({ eob = " " })
vim.opt.shortmess:append("I")

-- ------------------------------------------------------------------------------
-- Indentation
-- ------------------------------------------------------------------------------

vim.o.expandtab = false
vim.o.shiftwidth = 0
vim.o.tabstop = 4

-- ------------------------------------------------------------------------------
-- Editing
-- ------------------------------------------------------------------------------

vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.smartcase = true
vim.o.undofile = true
vim.o.wrap = false

vim.opt.formatoptions:remove("t")

-- ------------------------------------------------------------------------------
-- File Explorer
-- ------------------------------------------------------------------------------

vim.g.netrw_banner = 0
vim.g.netrw_dirhistmax = 0
vim.g.netrw_sort_options = "i"
vim.g.netrw_sort_sequence = [[[\/]$,*]]
