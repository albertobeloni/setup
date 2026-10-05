-- Desktop shell (ags request is quicker than starting the bundle again)

hl.bind("SUPER + space", hl.dsp.exec_cmd("ags request -i desktop launcher"))

-- While the launcher is open, it has the keyboard, so only it should look
-- focused: the focused window's border takes the inactive color until the
-- launcher closes.

local active_border = nil

hl.on("layer.opened", function(layer)
	if layer.namespace ~= "launcher" or active_border ~= nil then
		return
	end

	active_border = hl.get_config("general.col.active_border")
	hl.config({ general = { col = { active_border = hl.get_config("general.col.inactive_border") } } })
end)

hl.on("layer.closed", function(layer)
	if layer.namespace ~= "launcher" or active_border == nil then
		return
	end

	hl.config({ general = { col = { active_border = active_border } } })
	active_border = nil
end)
