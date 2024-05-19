local M = HodorReflexes.modules.share

function M.BuildMenu()

	local options = {
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_GENERAL))
		},
		{
			reference = "HodorReflexesMenu_Share_enabled",
			type = "checkbox",
			name = function()
				return string.format(M.sw.enabled and "|c00FF00%s|r" or "|cFF0000%s|r", GetString(HR_MENU_GENERAL_ENABLED))
			end,
			tooltip = GetString(HR_MENU_GENERAL_ENABLED_TT),
			default = M.default.enabled,
			getFunc = function() return M.sw.enabled end,
			setFunc = function(value)
				M.sw.enabled = value or false
				HodorReflexesMenu_Share_enabled.label:SetText(string.format(value and "|c00FF00%s|r" or "|cFF0000%s|r", GetString(HR_MENU_GENERAL_ENABLED)))
			end,
			requiresReload = true,
		},
		{
			type = "checkbox",
			name = 'Debug',
			getFunc = function() return M.debug end,
			setFunc = function(value)
				M.debug = value
			end
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_GENERAL_UI_LOCKED),
			tooltip = GetString(HR_MENU_GENERAL_UI_LOCKED_TT),
			getFunc = function() return M.uiLocked end,
			setFunc = function(value)
				if not value then
					M.UnlockUI()
				else
					M.LockUI()
				end
			end
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_GENERAL_EXIT_INSTANCE),
			tooltip = GetString(HR_MENU_GENERAL_EXIT_INSTANCE_TT),
			default = HodorReflexes.default.confirmExitInstance,
			getFunc = function() return HodorReflexes.sv.confirmExitInstance end,
			setFunc = function(value)
				HodorReflexes.sv.confirmExitInstance = value and true
			end
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_GENERAL_DISABLE_PVP),
			tooltip = GetString(HR_MENU_GENERAL_DISABLE_PVP_TT),
			default = M.default.disablePvP,
			getFunc = function() return M.sw.disablePvP end,
			setFunc = function(value)
				M.sw.disablePvP = value or false
				M.ToggleShare()
			end
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_GENERAL_ACCOUNT_WIDE),
			tooltip = GetString(HR_MENU_GENERAL_ACCOUNT_WIDE_TT),
			default = M.default.accountWide,
			getFunc = function() return HodorReflexesSV.Default[GetDisplayName()]['$AccountWide']["share"]["accountWide"] end,
			setFunc = function(value) HodorReflexesSV.Default[GetDisplayName()]['$AccountWide']["share"]["accountWide"] = value end,
			requiresReload = true,
		},
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_DAMAGE))
		},
		{
			type = "dropdown",
			name = GetString(HR_MENU_DAMAGE_SHOW),
			tooltip = GetString(HR_MENU_DAMAGE_SHOW_TT),
			default = M.default.enableDamageList,
			getFunc = function() return M.sv.enableDamageList end,
			setFunc = function(value)
				M.sv.enableDamageList = value or false
			end,
			choices = {
				GetString(HR_MENU_DAMAGE_SHOW_NEVER), GetString(HR_MENU_DAMAGE_SHOW_ALWAYS), GetString(HR_MENU_DAMAGE_SHOW_OUT), GetString(HR_MENU_DAMAGE_SHOW_NONBOSS),
			},
			choicesValues = {
				0, 1, 2, 3,
			},
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_DAMAGE_SHARE),
			tooltip = GetString(HR_MENU_DAMAGE_SHARE_TT),
			default = M.default.enableDamageShare,
			getFunc = function() return M.sv.enableDamageShare end,
			setFunc = function(value)
				M.sv.enableDamageShare = value or false
				M.ToggleShare()
			end,
			width = 'half',
		},
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_HORN))
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_HORN_SHOW),
			tooltip = GetString(HR_MENU_HORN_SHOW_TT),
			default = M.default.enableUltimateList,
			getFunc = function() return M.sv.enableUltimateList end,
			setFunc = function(value)
				M.sv.enableUltimateList = value or false
			end,
			width = 'half',
		},
		{
			type = "dropdown",
			name = GetString(HR_MENU_HORN_SHARE),
			tooltip = GetString(HR_MENU_HORN_SHARE_TT),
			default = M.default.enableUltimateShare,
			getFunc = function() return M.sv.enableUltimateShare or 0 end,
			setFunc = function(value)
				M.sv.enableUltimateShare = value or 0
				M.ToggleShare()
			end,
			choices = {
				GetString(HR_MENU_HORN_SHARE_NONE), GetString(HR_MENU_HORN_SHARE_HORN), GetString(HR_MENU_HORN_SHARE_SAXHLEEL1), GetString(HR_MENU_HORN_SHARE_SAXHLEEL250),
			},
			choicesValues = {
				0, true, 1, 250,
			},
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_HORN_SHOW_PERCENT),
			tooltip = GetString(HR_MENU_HORN_SHOW_PERCENT_TT),
			default = function() if M.default.showHornPercentValue == 1 then return true end return false end,
			getFunc = function() if M.sv.showHornPercentValue == 1 then return true end return false end,
			setFunc = function(value) if value then M.sv.showHornPercentValue = 1 return end M.sv.showHornPercentValue = 0 end,
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_HORN_SHOW_RAW),
			tooltip = GetString(HR_MENU_HORN_SHOW_RAW_TT),
			default = function() if M.default.showHornRawValue == 1 then return true end return false end,
			getFunc = function() if M.sv.showHornRawValue == 1 then return true end return false end,
			setFunc = function(value) if value then M.sv.showHornRawValue = 1 return end M.sv.showHornRawValue = 0 end,
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_HORN_SELFISH),
			tooltip = GetString(HR_MENU_HORN_SELFISH_TT),
			default = M.default.selfishMode,
			getFunc = function() return M.sv.selfishMode end,
			setFunc = function(value)
				M.sv.selfishMode = value or false
				M.ToggleHornDuration()
			end,
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_HORN_ICON),
			tooltip = GetString(HR_MENU_HORN_ICON_TT),
			default = M.default.enableHornIcon,
			getFunc = function() return M.sv.enableHornIcon end,
			setFunc = function(value)
				M.sv.enableHornIcon = value or false
			end,
			requiresReload = true,
			width = 'half',
		},
		{
			type = "dropdown",
			name = GetString(HR_MENU_HORN_COUNTDOWN_TYPE),
			tooltip = GetString(HR_MENU_HORN_COUNTDOWN_TYPE_TT),
			default = M.sv.hornCountdownType,
			getFunc = function() return M.sv.hornCountdownType end,
			setFunc = function(value)
				M.sv.hornCountdownType = value or 'none'
			end,
			choices = {
				GetString(HR_MENU_HORN_COUNTDOWN_TYPE_NONE), GetString(HR_MENU_HORN_COUNTDOWN_TYPE_SELF), GetString(HR_MENU_HORN_COUNTDOWN_TYPE_ALL), GetString(HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_SELF), GetString(HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_ALL),
			},
			choicesValues = {
				'none', 'horn_self', 'horn_all', 'force_self', 'force_all',
			},
			width = 'half',
		},
		{
			type = "colorpicker",
			name = GetString(HR_MENU_HORN_COUNTDOWN_COLOR),
			default = ZO_ColorDef:New(unpack(M.default.hornCountdownColor)),
			getFunc = function() return unpack(M.sv.hornCountdownColor) end,
			setFunc = function(r, g, b)
				M.sv.hornCountdownColor = {r, g, b}
				HodorReflexes_Share_HornCountdown_Label:SetColor(unpack(M.sv.hornCountdownColor))
			end,
			width = 'half',
		},
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_COLOS)),
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_COLOS_SHOW),
			tooltip = GetString(HR_MENU_COLOS_SHOW_TT),
			default = M.default.enableColosList,
			getFunc = function() return M.sv.enableColosList end,
			setFunc = function(value)
				M.sv.enableColosList = value or false
			end,
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_COLOS_SHARE),
			tooltip = GetString(HR_MENU_COLOS_SHARE_TT),
			default = M.default.enableColosShare,
			getFunc = function() return M.sv.enableColosShare end,
			setFunc = function(value)
				M.sv.enableColosShare = value or false
				M.ToggleShare()
			end,
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_COLOS_SHOW_PERCENT),
			tooltip = GetString(HR_MENU_COLOS_SHOW_PERCENT_TT),
			default = function() if M.default.showColosPercentValue == 1 then return true end return false end,
			getFunc = function() if M.sv.showColosPercentValue == 1 then return true end return false end,
			setFunc = function(value) if value then M.sv.showColosPercentValue = 1 return end M.sv.showColosPercentValue = 0 end,
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_COLOS_SHOW_RAW),
			tooltip = GetString(HR_MENU_COLOS_SHOW_RAW_TT),
			default = function() if M.default.showColosRawValue == 1 then return true end return false end,
			getFunc = function() if M.sv.showColosRawValue == 1 then return true end return false end,
			setFunc = function(value) if value then M.sv.showColosRawValue = 1 return end M.sv.showColosRawValue = 0 end,
			width = 'half',
		},
		--{
		--	type = "dropdown",
		--	name = GetString(HR_MENU_COLOS_PRIORITY),
		--	tooltip = GetString(HR_MENU_COLOS_PRIORITY_TT),
		--	default = M.sv.colosPriority,
		--	getFunc = function()
		--		local priority = M.sv.colosPriority
		--		if priority == 'tank' then priority = 'default' end
		--		return priority end,
		--	setFunc = function(value)
		--		M.sv.colosPriority = value or 'default'
		--	end,
		--	choices = {
		--		GetString(HR_MENU_COLOS_PRIORITY_DEFAULT), GetString(HR_MENU_COLOS_PRIORITY_ALWAYS), GetString(HR_MENU_COLOS_PRIORITY_NEVER),
		--	},
		--	choicesValues = {
		--		'default', 'always', 'never',
		--	},
		--	width = 'half',
		--},
		{
			type = "checkbox",
			name = GetString(HR_MENU_COLOS_SUPPORT_RANGE),
			tooltip = GetString(HR_MENU_COLOS_SUPPORT_RANGE_TT),
			default = M.default.colosSupportRange,
			getFunc = function() return M.sv.colosSupportRange end,
			setFunc = function(value)
				M.sv.colosSupportRange = value or false
			end,
			--width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_COLOS_COUNTDOWN),
			tooltip = GetString(HR_MENU_COLOS_COUNTDOWN_TT),
			default = M.default.enableColosCountdown,
			getFunc = function() return M.sv.enableColosCountdown end,
			setFunc = function(value)
				M.sv.enableColosCountdown = value or false
			end,
			--width = 'half',
		},
		--[[
		{
			type = "checkbox",
			name = "Boss Only:",
			tooltip = "Show countdown only on bosses.",
			default = M.default.colosCountdownBossOnly,
			getFunc = function() return M.sv.colosCountdownBossOnly end,
			setFunc = function(value)
				M.sv.colosCountdownBossOnly = value or false
			end,
			width = 'half',
		},
		]]
		{
			type = "editbox",
			name = GetString(HR_MENU_COLOS_COUNTDOWN_TEXT),
            default = M.default.colosCountdownText,
			getFunc = function() return M.sv.colosCountdownText end,
			setFunc = function(value)
				M.sv.colosCountdownText = value or ""
			end,
			isMultiline = false,
			isExtraWide = false,
		},
		{
			type = "colorpicker",
			name = GetString(HR_MENU_COLOS_COUNTDOWN_COLOR),
			default = ZO_ColorDef:New(unpack(M.default.colosCountdownColor)),
			getFunc = function() return unpack(M.sv.colosCountdownColor) end,
			setFunc = function(r, g, b)
				M.sv.colosCountdownColor = {r, g, b}
				HodorReflexes_Share_ColosCountdown_Label:SetColor(unpack(M.sv.colosCountdownColor))
			end,
		},
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_ATRONACH)),
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ATRONACH_SHOW),
			tooltip = GetString(HR_MENU_ATRONACH_SHOW_TT),
			default = M.default.enableAtronachList,
			getFunc = function() return M.sv.enableAtronachList end,
			setFunc = function(value)
				M.sv.enableAtronachList = value or false
			end,
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ATRONACH_SHARE),
			tooltip = GetString(HR_MENU_ATRONACH_SHARE_TT),
			default = M.default.enableAtronachShare,
			getFunc = function() return M.sv.enableAtronachShare end,
			setFunc = function(value)
				M.sv.enableAtronachShare = value or false
				M.ToggleShare()
			end,
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ATRONACH_SHOW_PERCENT),
			tooltip = GetString(HR_MENU_ATRONACH_SHOW_PERCENT_TT),
			default = function() if M.default.showAtronachPercentValue == 1 then return true end return false end,
			getFunc = function() if M.sv.showAtronachPercentValue == 1 then return true end return false end,
			setFunc = function(value) if value then M.sv.showAtronachPercentValue = 1 return end M.sv.showAtronachPercentValue = 0 end,
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ATRONACH_SHOW_RAW),
			tooltip = GetString(HR_MENU_ATRONACH_SHOW_RAW_TT),
			default = function() if M.default.showAtronachRawValue == 1 then return true end return false end,
			getFunc = function() if M.sv.showAtronachRawValue == 1 then return true end return false end,
			setFunc = function(value) if value then M.sv.showAtronachRawValue = 1 return end M.sv.showAtronachRawValue = 0 end,
			width = 'half',
		},
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_MISCULTIMATES))
		},
		{
			type = "dropdown",
			name = GetString(HR_MENU_MISCULTIMATES_SHOW),
			tooltip = GetString(HR_MENU_MISCULTIMATES_SHOW_TT),
			default = M.default.enableMiscUltimateList,
			getFunc = function() return M.sv.enableMiscUltimateList end,
			setFunc = function(value)
				M.sv.enableMiscUltimateList = value or false
			end,
			choices = {
				GetString(HR_MENU_DAMAGE_SHOW_NEVER), GetString(HR_MENU_DAMAGE_SHOW_ALWAYS), GetString(HR_MENU_DAMAGE_SHOW_OUT), GetString(HR_MENU_DAMAGE_SHOW_NONBOSS),
			},
			choicesValues = {
				0, 1, 2, 3,
			},
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_MISCULTIMATES_SHARE),
			tooltip = GetString(HR_MENU_MISCULTIMATES_SHARE_TT),
			default = M.default.enableMiscUltimateShare,
			getFunc = function() return M.sv.enableMiscUltimateShare end,
			setFunc = function(value)
				M.sv.enableMiscUltimateShare = value or false
			end,
			width = 'half',
		},
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_MISC)),
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_MISC_TOXIC),
			tooltip = GetString(HR_MENU_MISC_TOXIC_TT),
			default = HodorReflexes.default.toxicMode,
			getFunc = function() return HodorReflexes.sv.toxicMode end,
			setFunc = function(value)
				HodorReflexes.sv.toxicMode = value and true
			end
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_MISC_DISABLEDEPENDENCYWARNING),
			tooltip = GetString(HR_MENU_MISC_DISABLEDEPENDENCYWARNING_TT),
			default = false,
			getFunc = function() return HodorReflexes.sv.disableIncompatibleDependencyWarning end,
			setFunc = function(value)
				HodorReflexes.sv.disableIncompatibleDependencyWarning = value and true
			end
		},
		{
			type = "description",
			text = GetString(HR_MENU_MISC_DESC),
		},
	}
	HodorReflexes.RegisterOptionControls(options)

end