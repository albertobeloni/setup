local external = "HDMI-A-1"
local laptop = "eDP-1"

for i = 1, 5 do
	hl.workspace_rule({ workspace = tostring(i), monitor = external, default = (i == 1) })
end

for i = 6, 10 do
	hl.workspace_rule({ workspace = tostring(i), monitor = laptop, default = (i == 6) })
end

hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = "uwsm app -- kitty & uwsm app -- kitty" })
