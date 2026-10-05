-- Notebook: built-in panel plus an external HDMI monitor

local laptop = "eDP-1"
local external = "HDMI-A-1"

hl.monitor({
	output = laptop,
	mode = "1920x1080@144",
	scale = 1,
})

hl.monitor({
	output = external,
	mode = "1920x1080@180",
	scale = 1,
})

for i = 1, 5 do
	hl.workspace_rule({ workspace = tostring(i), monitor = external, default = (i == 1) })
end

for i = 6, 10 do
	hl.workspace_rule({ workspace = tostring(i), monitor = laptop, default = (i == 6) })
end

-- Lid: with an external monitor connected, a closed lid turns the laptop panel off
-- and its workspaces move to the external monitor. Without one, logind suspends as usual.
--
-- The switch binds only fire when the lid changes, so the state is also checked when
-- the config is (re)loaded, when Hyprland starts and when monitors come and go.

local function lid_closed()
	local pipe = io.popen("cat /proc/acpi/button/lid/*/state 2> /dev/null")

	if pipe == nil then
		return false
	end

	local state = pipe:read("*a")
	pipe:close()

	return state:find("closed") ~= nil
end

local function external_connected()
	for _, monitor in ipairs(hl.get_monitors()) do
		if monitor.name ~= laptop then
			return true
		end
	end

	return false
end

local function laptop_panel(enabled)
	if enabled then
		hl.monitor({ output = laptop, mode = "1920x1080@144", scale = 1 })
	else
		hl.monitor({ output = laptop, disabled = true })
	end
end

-- closed is passed by the switch binds; everything else reads it from ACPI
local function sync(closed)
	if closed == nil then
		closed = lid_closed()
	end

	laptop_panel(not (closed and external_connected()))
end

sync()

hl.on("hyprland.start", function() sync() end)
hl.on("monitor.added", function() sync() end)
hl.on("monitor.removed", function() sync() end)

hl.bind("switch:on:Lid Switch", function() sync(true) end, { locked = true })
hl.bind("switch:off:Lid Switch", function() sync(false) end, { locked = true })
