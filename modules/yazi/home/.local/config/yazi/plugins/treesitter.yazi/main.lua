--- Preview code with Neovim's tree-sitter highlighting, using the parsers and
--- colorscheme of the Neovim configuration. Files without a tree-sitter parser
--- fall back to Yazi's built-in code previewer.

local previewer = {}

-- ------------------------------------------------------------------------------
-- Rendering
-- ------------------------------------------------------------------------------

-- Latest modification time of the Neovim colorscheme files, so cached renders
-- are refreshed when the colorscheme changes
local stamp = nil

local function version()
	if stamp == nil then
		local config = Url(os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")):join("nvim")
		local files = fs.read_dir(config:join("colors"), {}) or {}

		stamp = 0

		table.insert(files, { url = config:join("lua/colors.lua") })

		for _, file in ipairs(files) do
			local cha = fs.cha(file.url, true)

			if cha and cha.mtime then
				stamp = math.max(stamp, math.floor(cha.mtime))
			end
		end
	end

	return stamp
end

-- Render the file into the cache, which stays empty when there is no
-- tree-sitter parser for it
local function render(job)
	local cache = ya.file_cache({ file = job.file, skip = version() })

	if not cache then
		return nil
	end

	local cha = fs.cha(cache)

	if cha then
		return cha.len > 0 and cache or nil
	end

	local renderer = rt.path.config_dir:join("plugins/treesitter.yazi/render.lua")
	local output = Command("nvim")
		:arg({ "-l", tostring(renderer), tostring(job.file.path), tostring(rt.preview.tab_size) })
		:stdout(Command.PIPED)
		:stderr(Command.NULL)
		:output()

	if output and output.status.success then
		fs.write(cache, output.stdout)
		return cache
	elseif output and output.status.code == 2 then
		fs.write(cache, "")
	end

	return nil
end

-- ------------------------------------------------------------------------------
-- Previewer
-- ------------------------------------------------------------------------------

function previewer:peek(job)
	local cache = render(job)
	local file = cache and io.open(tostring(cache), "r")

	if not file then
		return require("code"):peek(job)
	end

	local lines = {}

	for line in file:lines() do
		table.insert(lines, line)
	end

	file:close()

	local bound = math.max(0, #lines - job.area.h)

	if job.skip > bound then
		return ya.emit("peek", { bound, only_if = job.file.url, upper_bound = true })
	end

	local text = table.concat(lines, "\n", job.skip + 1, math.min(#lines, job.skip + job.area.h))
	local wrap = rt.preview.wrap == "yes" and ui.Wrap.YES or ui.Wrap.NO

	ya.preview_widget(job, ui.Text.parse(text):area(job.area):wrap(wrap))
end

function previewer:seek(job) require("code"):seek(job) end

return previewer
