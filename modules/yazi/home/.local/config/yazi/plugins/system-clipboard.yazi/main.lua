local formats = {
	"text/uri-list",
	"x-special/gnome-copied-files",
	"x-special/mate-copied-files"
}

-- ------------------------------------------------------------------------------
-- System Clipboard
-- ------------------------------------------------------------------------------

local function read(arguments)
	local output = Command("wl-paste"):arg(arguments):stdout(Command.PIPED):stderr(Command.NULL):output()

	return output and output.status.success and output.stdout or ""
end

local function write(arguments, content)
	local child = Command("wl-copy")
		:arg(arguments)
		:stdin(Command.PIPED)
		:stdout(Command.NULL)
		:stderr(Command.NULL)
		:spawn()

	if child then
		child:write_all(content or "")
		child:flush()
		ya.drop(child:take_stdin())
		child:wait()
	end
end

local function clipboard()
	local available = {}
	for format in read({ "--list-types" }):gmatch("[^\n]+") do
		available[format] = true
	end

	for _, format in ipairs(formats) do
		if available[format] then
			local uris = {}
			for line in read({ "--no-newline", "--type", format }):gmatch("[^\r\n]+") do
				if line:match("^file://") then
					table.insert(uris, line)
				end
			end

			return uris
		end
	end

	return {}
end

-- ------------------------------------------------------------------------------
-- Yazi
-- ------------------------------------------------------------------------------

local function collect()
	local uris = {}
	for _, file in pairs(cx.yanked) do
		table.insert(uris, "file://" .. ya.percent_encode(tostring(file.path)))
	end

	return uris
end

local yanked = ya.sync(collect)

local import = ya.sync(function(_, list) require("clipboard").copy_uri_list(list) end)

-- ------------------------------------------------------------------------------
-- Plugin
-- ------------------------------------------------------------------------------

local function setup()
	local written = ""

	ps.sub("@yank", function()
		local list = table.concat(collect(), "\r\n")

		ya.async(function()
			if list ~= "" then
				write({ "--type", "text/uri-list" }, list)
			elseif written ~= "" and read({ "--no-newline", "--type", "text/uri-list" }) == written then
				write({ "--clear" })
			end

			written = list
		end)
	end)
end

local function entry()
	local uris = clipboard()

	if #uris == 0 or table.concat(uris, "\r\n") == table.concat(yanked(), "\r\n") then
		ya.emit("paste", {})
	else
		import(table.concat(uris, "\n"))
	end
end

return { setup = setup, entry = entry }
