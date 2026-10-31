local treesitter = {}

treesitter.languages = {
	-- Programming
	"bash",
	"c",
	"c_sharp",
	"clojure",
	"commonlisp",
	"cpp",
	"fennel",
	"fish",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"java",
	"javascript",
	"jsdoc",
	"lua",
	"luadoc",
	"php",
	"php_only",
	"phpdoc",
	"python",
	"racket",
	"ruby",
	"rust",
	"scheme",
	"sql",
	"tsx",
	"typescript",
	"zsh",

	-- Configuration
	"cmake",
	"diff",
	"dockerfile",
	"editorconfig",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"ini",
	"json",
	"json5",
	"make",
	"properties",
	"ssh_config",
	"toml",
	"yaml",

	-- Markup
	"bibtex",
	"css",
	"dtd",
	"glimmer",
	"html",
	"latex",
	"markdown",
	"markdown_inline",
	"scss",
	"xml",

	-- Neovim
	"query",
	"vim",
	"vimdoc",

	-- Other
	"comment",
	"printf",
	"regex",
}

function treesitter.install()
	local plugin = require("nvim-treesitter")
	local timeout = 30 * 60 * 1000

	return plugin.install(treesitter.languages):wait(timeout) and plugin.update():wait(timeout)
end

vim.g.tex_flavor = "latex"

vim.api.nvim_create_autocmd("FileType", {
	callback = function(event)
		pcall(vim.treesitter.start, event.buf)
	end,
})

return treesitter
