local external = "HDMI-A-1"
local laptop = "eDP-1"

-- Workspaces 1-5 on the external monitor, 6-10 on the laptop.
-- Without the external monitor, all of them move to the laptop automatically.
for i = 1, 5 do
	hl.workspace_rule({ workspace = tostring(i), monitor = external, default = (i == 1) })
end

for i = 6, 10 do
	hl.workspace_rule({ workspace = tostring(i), monitor = laptop, default = (i == 6) })
end

-- Scratchpad (SUPER + S) opens a terminal when it's empty
hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = "uwsm app -- kitty" })
