--- Print a file with Neovim's tree-sitter highlighting as ANSI escape sequences,
--- using the parsers and colorscheme of the Neovim configuration
---
--- nvim -l render.lua <file> <tabstop>
---
--- Exits with status 2 when there is no tree-sitter parser for the file.

local path = arg[1]
local tabstop = tonumber(arg[2]) or 8

vim.o.termguicolors = true

pcall(require, "colors")

local lines = vim.fn.readfile(path)
local buffer = vim.api.nvim_create_buf(false, true)

vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)

local filetype = vim.filetype.match({ filename = path, buf = buffer })
local language = filetype and vim.treesitter.language.get_lang(filetype)
local found, parser = pcall(vim.treesitter.get_parser, buffer, language)

if not language or not found or not parser then
	os.exit(2)
end

-- ------------------------------------------------------------------------------
-- Highlights
-- ------------------------------------------------------------------------------

local styles = {}

-- Attributes of a highlight group, falling back to less specific groups (e.g.
-- "@keyword.lua" to "@keyword") like Neovim does
local function style(group)
	if styles[group] == nil then
		local name = group

		styles[group] = false

		while name do
			local attributes = vim.api.nvim_get_hl(0, { name = name, link = false })

			if next(attributes) then
				styles[group] = attributes
				break
			end

			name = name:match("^(.+)%.[^.]+$")
		end
	end

	return styles[group]
end

-- Style and priority of each byte, where captures with a higher or equal
-- priority override earlier ones like in Neovim's highlighter
local cells = {}
local priorities = {}

for row = 1, #lines do
	cells[row] = {}
	priorities[row] = {}
end

parser:parse(true)
parser:for_each_tree(function(tree, tree_parser)
	local name = tree_parser:lang()
	local query = vim.treesitter.query.get(name, "highlights")

	if not query then
		return
	end

	for id, node, metadata in query:iter_captures(tree:root(), buffer) do
		local capture = query.captures[id]
		local attributes = capture:sub(1, 1) ~= "_" and style("@" .. capture .. "." .. name)

		if attributes then
			local priority = tonumber(metadata.priority or (metadata[id] and metadata[id].priority)) or 100
			local first_row, first_column, last_row, last_column = node:range()

			for row = first_row + 1, math.min(last_row + 1, #lines) do
				local first = row == first_row + 1 and first_column + 1 or 1
				local last = row == last_row + 1 and last_column or #lines[row]

				for column = first, last do
					if priority >= (priorities[row][column] or 0) then
						cells[row][column] = attributes
						priorities[row][column] = priority
					end
				end
			end
		end
	end
end)

-- ------------------------------------------------------------------------------
-- Output
-- ------------------------------------------------------------------------------

local normal = style("Normal") or {}

local function escape(attributes)
	local codes = { "0" }
	local foreground = attributes.fg or normal.fg

	if attributes.bold then
		table.insert(codes, "1")
	end

	if attributes.italic then
		table.insert(codes, "3")
	end

	if attributes.underline then
		table.insert(codes, "4")
	end

	if foreground then
		table.insert(codes, ("38;2;%d;%d;%d"):format(
			bit.rshift(foreground, 16),
			bit.band(bit.rshift(foreground, 8), 0xff),
			bit.band(foreground, 0xff)
		))
	end

	return "\27[" .. table.concat(codes, ";") .. "m"
end

-- Replace tabs with spaces up to the next tab stop, from the given column
local function expand(text, column)
	return (text:gsub("([^\t]*)\t", function(before)
		local position = column + vim.api.nvim_strwidth(before)

		column = position + tabstop - position % tabstop

		return before .. (" "):rep(column - position)
	end))
end

local output = {}

for row, line in ipairs(lines) do
	local parts = {}
	local width = 0
	local first = 1

	while first <= #line do
		local attributes = cells[row][first] or normal
		local last = first

		while last < #line and (cells[row][last + 1] or normal) == attributes do
			last = last + 1
		end

		local text = expand(line:sub(first, last), width)

		table.insert(parts, escape(attributes) .. text)

		width = width + vim.api.nvim_strwidth(text)
		first = last + 1
	end

	table.insert(output, table.concat(parts) .. "\27[0m")
end

io.stdout:write(table.concat(output, "\n"), "\n")
