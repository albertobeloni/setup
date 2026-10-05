-- Geometry shared by the window helpers: directions, boxes and monitor areas.

local Helper = {}

-- For each direction: the axis it moves along, the axis across it, and its
-- sign along that axis. Hyprland's monitor lookups and dwindle's preselect
-- accept the direction names directly.
Helper.DIRECTIONS = {
	left = { along = "x", across = "y", sign = -1 },
	right = { along = "x", across = "y", sign = 1 },
	up = { along = "y", across = "x", sign = -1 },
	down = { along = "y", across = "x", sign = 1 },
}

local function span(min, max)
	return { min = min, max = max, mid = (min + max) / 2 }
end

-- A window's extent on each axis, so the code can work along or across any
-- direction in the same way.
function Helper.box(window)
	return {
		x = span(window.at.x, window.at.x + window.size.x),
		y = span(window.at.y, window.at.y + window.size.y),
	}
end

-- The area a monitor covers, in layout coordinates. Its width and height are
-- in pixels, so they're divided by the scale and swapped for rotated (odd)
-- transforms.
function Helper.monitor_box(monitor)
	local rotated = monitor.transform % 2 == 1
	local width = (rotated and monitor.height or monitor.width) / monitor.scale
	local height = (rotated and monitor.width or monitor.height) / monitor.scale

	return {
		x = span(monitor.x, monitor.x + width),
		y = span(monitor.y, monitor.y + height),
	}
end

-- How much two spans overlap. Negative when they don't.
function Helper.overlap(a, b)
	return math.min(a.max, b.max) - math.max(a.min, b.min)
end

-- Whether box b lies inside box a, with a pixel of tolerance.
function Helper.inside(b, a)
	return b.x.min >= a.x.min - 1 and b.x.max <= a.x.max + 1 and b.y.min >= a.y.min - 1 and b.y.max <= a.y.max + 1
end

-- How close a box is to the screen edge in a direction. Larger is closer.
function Helper.reach(b, direction)
	local d = Helper.DIRECTIONS[direction]
	return (d.sign > 0 and b[d.along].max or b[d.along].min) * d.sign
end

return Helper
