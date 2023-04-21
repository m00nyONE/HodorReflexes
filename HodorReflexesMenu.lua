local HR = HodorReflexes

function HR.BuildMenu()

	local panel = HodorReflexes.GetModulePanelConfig()

    local options = {}
	-- Add options provided by modules
	local extraOptions = HR.GetOptionControls()
	for _, v in ipairs(extraOptions) do
		options[#options + 1] = v
	end

	LibAddonMenu2:RegisterAddonPanel(HR.name .. "Options", panel)
    LibAddonMenu2:RegisterOptionControls(HR.name .. "Options", options)

end