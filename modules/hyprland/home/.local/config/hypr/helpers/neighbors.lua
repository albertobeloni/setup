-- Finds windows relative to another one: tiled neighbors, the window closest
-- to an edge, and the window to focus in a direction.

local geometry = require("helpers.geometry")

local DIRECTIONS = geometry.DIRECTIONS
local box, overlap, inside, reach = geometry.box, geometry.overlap, geometry.inside, geometry.reach

local M = {}

-- The other visible windows on the same workspace, or only the tiled ones.
function M.others(window, tiled_only)
	local result = {}

	if window.workspace == nil then
		return result
	end

	for _, other in ipairs(window.workspace:get_windows()) do
		if other.mapped and not other.hidden and other.address ~= window.address and not (tiled_only and other.floating) then
			table.insert(result, other)
		end
	end

	return result
end

-- The nearest tiled window that way, overlapping it on the other axis.
function M.tiled(window, direction)
	local d = DIRECTIONS[direction]
	local a = box(window)
	local best, best_gap, best_overlap = nil, math.huge, -1

	for _, other in ipairs(M.others(window, true)) do
		local b = box(other)
		local shared = overlap(a[d.across], b[d.across])

		-- The gap between the facing edges. Windows that share an
		-- edge can be a pixel apart either way.
		local facing_a = d.sign > 0 and a[d.along].max or a[d.along].min
		local facing_b = d.sign > 0 and b[d.along].min or b[d.along].max
		local gap = (facing_b - facing_a) * d.sign

		if shared > 0 and gap > -1 and (gap < best_gap or (gap == best_gap and shared > best_overlap)) then
			best, best_gap, best_overlap = other, gap, shared
		end
	end

	return best
end

-- The tiled window closest to the screen edge in a direction, and its reach.
-- Ties go to the one nearest the window.
function M.edge_most_tiled(window, direction)
	local d = DIRECTIONS[direction]
	local a = box(window)
	local best, best_reach, best_offset = nil, -math.huge, math.huge

	for _, other in ipairs(M.others(window, true)) do
		local b = box(other)
		local r = reach(b, direction)
		local offset = math.abs(b[d.across].mid - a[d.across].mid)

		if r > best_reach + 1 or (math.abs(r - best_reach) <= 1 and offset < best_offset) then
			best, best_reach, best_offset = other, r, offset
		end
	end

	return best, best_reach
end

-- How far apart two rank entries must be to count as different. The group
-- and the focus recency are compared exactly; the rest are in pixels and
-- allow one pixel of tolerance.
local RANK_TOLERANCE = { 0, 1, 1, 1, 0 }

-- Whether rank comes before other, comparing entry by entry.
local function ranks_before(rank, other)
	for i = 1, #rank do
		if math.abs(rank[i] - other[i]) > RANK_TOLERANCE[i] then
			return rank[i] < other[i]
		end
	end

	return false
end

-- How recently a window was focused: 0 is the latest; never focused is last.
local function recency(window)
	local id = window.focus_history_id or -1
	return id < 0 and math.huge or id
end

-- The window to focus in a direction, tiled or floating. Candidates are
-- ranked by group (below), then distance, then closeness to the line of
-- travel, overlap and how recently they were focused. line is the point focus
-- has been moving through; it settles ties, like a floating window centered
-- over a grid (see helpers/focus.lua).
function M.to_focus(window, direction, line)
	local d = DIRECTIONS[direction]
	local a = box(window)
	local best, best_rank = nil, nil

	for _, other in ipairs(M.others(window, false)) do
		local b = box(other)
		local along, across = b[d.along], b[d.across]

		local beyond = (along.min - a[d.along].min) * d.sign > 0 and (along.max - a[d.along].max) * d.sign > 0
		local distance = (along.mid - a[d.along].mid) * d.sign
		local offset = math.abs(across.mid - a[d.across].mid)
		local shared = overlap(a[d.across], across)
		local deviation = math.abs(across.mid - line[d.across])
		local nested = inside(b, a)
		local rank = nil

		-- Straight ahead: entirely further that way and overlapping on
		-- the other axis (so a big window sticking out a little doesn't
		-- count), or inside the current window on that side.
		if (nested and distance > 1) or (beyond and shared > 0) then
			rank = { 0, distance, deviation, -shared, recency(other) }

		-- Off to the side: within 45 degrees, with the offset counting
		-- double.
		elseif beyond and offset <= distance then
			rank = { 1, distance + 2 * offset, deviation, 0, recency(other) }

		-- Last resort, in any direction: a window centered inside the
		-- current one, then the window the current one sits inside.
		elseif nested and distance > -1 then
			rank = { 2, 0, deviation, 0, recency(other) }
		elseif inside(a, b) then
			rank = { 2, 2, deviation, 0, recency(other) }
		end

		if rank ~= nil and (best_rank == nil or ranks_before(rank, best_rank)) then
			best, best_rank = other, rank
		end
	end

	return best
end

return M
