-- Keybind helpers.

local Helper = {}

-- Binds keys to an action that receives the active window, followed by any
-- extra arguments. Does nothing when no window is focused.
function Helper.active(keys, action, ...)
	local arguments = { ... }

	hl.bind(keys, function()
		local window = hl.get_active_window()

		if window ~= nil then
			action(window, table.unpack(arguments))
		end
	end)
end

return Helper
