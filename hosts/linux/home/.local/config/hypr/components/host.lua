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

-- Lid: with an external monitor connected, closing the lid turns the laptop panel off
-- and its workspaces move to the external monitor. Without one, logind suspends as usual.

local function external_connected()
	for _, monitor in ipairs(hl.get_monitors()) do
		if monitor.name ~= laptop then
			return true
		end
	end

	return false
end

local function laptop_panel(enabled)
	hl.monitor({ output = laptop, disabled = not enabled })
end

hl.bind("switch:on:Lid Switch", function()
	if external_connected() then
		laptop_panel(false)
	end
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
	laptop_panel(true)
end, { locked = true })

-- Unplugging the external monitor with the lid closed brings the panel back
hl.on("monitor.removed", function()
	if not external_connected() then
		laptop_panel(true)
	end
end)
