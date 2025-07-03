local M = HodorReflexes.modules.share
local anim = HodorReflexes.anim

function M.BuildIconsMenu()

	local panel = HodorReflexes.GetModulePanelConfig(GetString(HR_MENU_ICONS))

	local options = {
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_ICONS_VISIBILITY)),
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ICONS_VISIBILITY_HORN),
			tooltip = GetString(HR_MENU_ICONS_VISIBILITY_HORN_TT),
			default = M.default.enableUltimateIcons,
			getFunc = function() return M.sw.enableUltimateIcons end,
			setFunc = function(value)
				M.sw.enableUltimateIcons = value or false
			end,
			requiresReload = true,
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ICONS_VISIBILITY_DPS),
			tooltip = GetString(HR_MENU_ICONS_VISIBILITY_DPS_TT),
			default = M.default.enableDamageIcons,
			getFunc = function() return M.sw.enableDamageIcons end,
			setFunc = function(value)
				M.sw.enableDamageIcons = value or false
			end,
			requiresReload = true,
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ICONS_VISIBILITY_COLOS),
			tooltip = GetString(HR_MENU_ICONS_VISIBILITY_COLOS_TT),
			default = M.default.enableColosIcons,
			getFunc = function() return M.sw.enableColosIcons end,
			setFunc = function(value)
				M.sw.enableColosIcons = value or false
			end,
			requiresReload = true,
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ICONS_VISIBILITY_ATRONACH),
			tooltip = GetString(HR_MENU_ICONS_VISIBILITY_ATRONACH_TT),
			default = M.default.enableAtronachIcons,
			getFunc = function() return M.sw.enableAtronachIcons end,
			setFunc = function(value)
				M.sw.enableAtronachIcons = value or false
			end,
			requiresReload = true,
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ICONS_VISIBILITY_MISCULTIMATES),
			tooltip = GetString(HR_MENU_ICONS_VISIBILITY_MISCULTIMATES_TT),
			default = M.default.enableMiscUltimateIcons,
			getFunc = function() return M.sw.enableMiscUltimateIcons end,
			setFunc = function(value)
				M.sw.enableMiscUltimateIcons = value or false
			end,
			requiresReload = true,
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ICONS_VISIBILITY_COLORS),
			tooltip = GetString(HR_MENU_ICONS_VISIBILITY_COLORS_TT),
			default = M.default.enableColoredNames,
			getFunc = function() return M.sw.enableColoredNames end,
			setFunc = function(value)
				M.sw.enableColoredNames = value or false
			end,
			requiresReload = true,
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ICONS_VISIBILITY_ANIM),
			tooltip = GetString(HR_MENU_ICONS_VISIBILITY_ANIM_TT),
			default = M.default.enableAnimIcons,
			getFunc = function() return M.sw.enableAnimIcons end,
			setFunc = function(value)
				M.sw.enableAnimIcons = value or false
			end,
			requiresReload = true,
		},
	}

    LibAddonMenu2:RegisterAddonPanel(M.name .. "IconsMenu", panel)
    LibAddonMenu2:RegisterOptionControls(M.name .. "IconsMenu", options)
end