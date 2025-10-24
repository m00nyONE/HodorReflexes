-- SPDX-FileCopyrightText: 2025 andy.s m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local M = HodorReflexes.modules.share

function M.BuildMenu()

	local options = {
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_GENERAL))
		},
		{
			type = "button",
			name = "|cFFD700Send Donation|r",
			tooltip = "If you enjoy HodorReflexes and want to support me, feel free to send me gold on Xbox NA YoZoPoClo :)",
			func = function() HodorReflexes.Donation() end,
			width = "full"
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
				if HodorReflexesMenu_Share_enabled and HodorReflexesMenu_Share_enabled.label then
					HodorReflexesMenu_Share_enabled.label:SetText(string.format(value and "|c00FF00%s|r" or "|cFF0000%s|r", GetString(HR_MENU_GENERAL_ENABLED)))
				end
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
			name = GetString(HR_MENU_MISCULTIMATES_SHOW_PERCENT),
			tooltip = GetString(HR_MENU_MISCULTIMATES_SHOW_PERCENT_TT),
			default = function() if M.default.showMiscUltimatesPercentValue == 1 then return true end return false end,
			getFunc = function() if M.sv.showMiscUltimatesPercentValue == 1 then return true end return false end,
			setFunc = function(value) if value then M.sv.showMiscUltimatesPercentValue = 1 return end M.sv.showMiscUltimatesPercentValue = 0 end,
			width = 'half',
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_MISCULTIMATES_SHOW_RAW),
			tooltip = GetString(HR_MENU_MISCULTIMATES_SHOW_RAW_TT),
			default = function() if M.default.showMiscUltimatesRawValue == 1 then return true end return false end,
			getFunc = function() if M.sv.showMiscUltimatesRawValue == 1 then return true end return false end,
			setFunc = function(value) if value then M.sv.showMiscUltimatesRawValue = 1 return end M.sv.showMiscUltimatesRawValue = 0 end,
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
			type = "description",
			text = GetString(HR_MENU_MISC_DESC),
		},
		
		-- ═══════════════════════════════════════════════════════════════
		-- UI POSITIONING & SCALING
		-- ═══════════════════════════════════════════════════════════════
		{
			type = "header",
			name = "|cFFD700━━━ UI Positioning & Scaling ━━━|r"
		},
		{
			type = "description",
			text = "|cFFFFFF• Unlock UI in General settings to drag elements with your mouse\n" ..
			       "• Use these sliders for precise positioning\n" ..
			       "• Scale values: 0 = 75%, 20 = 100% (default), 100 = 150%|r"
		},
		{
			type = "button",
			name = "Reset All Positions to Default",
			tooltip = "Resets all UI element positions and scales to their default values",
			func = function()
				M.sv.ultimateX = M.default.ultimateX
				M.sv.ultimateY = M.default.ultimateY
				M.sv.ultimateScale = M.default.ultimateScale
				M.sv.damageX = M.default.damageX
				M.sv.damageY = M.default.damageY
				M.sv.damageScale = M.default.damageScale
				M.sv.colosX = M.default.colosX
				M.sv.colosY = M.default.colosY
				M.sv.colosScale = M.default.colosScale
				M.sv.colosCountdownX = M.default.colosCountdownX
				M.sv.colosCountdownY = M.default.colosCountdownY
				M.sv.colosCountdownScale = M.default.colosCountdownScale
				M.sv.atronachX = M.default.atronachX
				M.sv.atronachY = M.default.atronachY
				M.sv.atronachScale = M.default.atronachScale
				M.sv.miscUltimateX = M.default.miscUltimateX
				M.sv.miscUltimateY = M.default.miscUltimateY
				M.sv.miscUltimateScale = M.default.miscUltimateScale
				M.sv.hornCountdownX = M.default.hornCountdownX
				M.sv.hornCountdownY = M.default.hornCountdownY
				M.sv.hornCountdownScale = M.default.hornCountdownScale
				M.sv.hornIconX = M.default.hornIconX
				M.sv.hornIconY = M.default.hornIconY
				M.sv.hornIconScale = M.default.hornIconScale
				M.RestorePosition()
				d("|c00FF00HodorReflexes: All UI positions reset to defaults!|r")
			end,
			width = "full",
			warning = "This will reset all UI element positions!",
		},
		
		-- War Horn Ultimate List
		{
			type = "header",
			name = "|cFFD700War Horn Ultimate List|r"
		},
		{
			type = "slider",
			name = "X Position",
			min = 0, max = 2000, step = 10,
			default = M.default.ultimateX,
			getFunc = function() return M.sv.ultimateX end,
			setFunc = function(value) M.sv.ultimateX = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider", 
			name = "Y Position",
			min = 0, max = 2000, step = 10,
			default = M.default.ultimateY,
			getFunc = function() return M.sv.ultimateY end,
			setFunc = function(value) M.sv.ultimateY = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Scale",
			min = 0, max = 100, step = 5,
			default = M.default.ultimateScale,
			getFunc = function() return M.sv.ultimateScale end,
			setFunc = function(value) M.sv.ultimateScale = value; M.RestorePosition() end,
			width = "half"
		},
		
		-- Damage List
		{
			type = "header",
			name = "|cFFD700Damage List|r"
		},
		{
			type = "slider",
			name = "X Position",
			min = 0, max = 2000, step = 10,
			default = M.default.damageX,
			getFunc = function() return M.sv.damageX end,
			setFunc = function(value) M.sv.damageX = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Y Position", 
			min = 0, max = 2000, step = 10,
			default = M.default.damageY,
			getFunc = function() return M.sv.damageY end,
			setFunc = function(value) M.sv.damageY = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Scale",
			min = 0, max = 100, step = 5,
			default = M.default.damageScale,
			getFunc = function() return M.sv.damageScale end,
			setFunc = function(value) M.sv.damageScale = value; M.RestorePosition() end,
			width = "half"
		},
		
		-- Colossus List
		{
			type = "header",
			name = "|cFFD700Colossus Ultimate List|r"
		},
		{
			type = "slider",
			name = "X Position",
			min = 0, max = 2000, step = 10,
			default = M.default.colosX,
			getFunc = function() return M.sv.colosX end,
			setFunc = function(value) M.sv.colosX = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Y Position",
			min = 0, max = 2000, step = 10,
			default = M.default.colosY,
			getFunc = function() return M.sv.colosY end,
			setFunc = function(value) M.sv.colosY = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Scale",
			min = 0, max = 100, step = 5,
			default = M.default.colosScale,
			getFunc = function() return M.sv.colosScale end,
			setFunc = function(value) M.sv.colosScale = value; M.RestorePosition() end,
			width = "half"
		},
		
		-- Atronach List
		{
			type = "header",
			name = "|cFFD700Atronach Ultimate List|r"
		},
		{
			type = "slider",
			name = "X Position",
			min = 0, max = 2000, step = 10,
			default = M.default.atronachX,
			getFunc = function() return M.sv.atronachX end,
			setFunc = function(value) M.sv.atronachX = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Y Position",
			min = 0, max = 2000, step = 10,
			default = M.default.atronachY,
			getFunc = function() return M.sv.atronachY end,
			setFunc = function(value) M.sv.atronachY = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Scale",
			min = 0, max = 100, step = 5,
			default = M.default.atronachScale,
			getFunc = function() return M.sv.atronachScale end,
			setFunc = function(value) M.sv.atronachScale = value; M.RestorePosition() end,
			width = "half"
		},
		
		-- Misc Ultimate List
		{
			type = "header",
			name = "|cFFD700Other Ultimates List|r"
		},
		{
			type = "slider",
			name = "X Position",
			min = 0, max = 2000, step = 10,
			default = M.default.miscUltimateX,
			getFunc = function() return M.sv.miscUltimateX end,
			setFunc = function(value) M.sv.miscUltimateX = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Y Position",
			min = 0, max = 2000, step = 10,
			default = M.default.miscUltimateY,
			getFunc = function() return M.sv.miscUltimateY end,
			setFunc = function(value) M.sv.miscUltimateY = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Scale",
			min = 0, max = 100, step = 5,
			default = M.default.miscUltimateScale,
			getFunc = function() return M.sv.miscUltimateScale end,
			setFunc = function(value) M.sv.miscUltimateScale = value; M.RestorePosition() end,
			width = "half"
		},
		
		-- Colossus Countdown Display
		{
			type = "header",
			name = "|cFFD700Colossus Countdown Display|r"
		},
		{
			type = "slider",
			name = "X Position",
			min = 0, max = 2000, step = 10,
			default = M.default.colosCountdownX,
			getFunc = function() return M.sv.colosCountdownX end,
			setFunc = function(value) M.sv.colosCountdownX = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Y Position",
			min = 0, max = 2000, step = 10,
			default = M.default.colosCountdownY,
			getFunc = function() return M.sv.colosCountdownY end,
			setFunc = function(value) M.sv.colosCountdownY = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Scale",
			min = 0, max = 100, step = 5,
			default = M.default.colosCountdownScale,
			getFunc = function() return M.sv.colosCountdownScale end,
			setFunc = function(value) M.sv.colosCountdownScale = value; M.RestorePosition() end,
			width = "half"
		},
		
		-- Horn Countdown Display
		{
			type = "header",
			name = "|cFFD700Horn Countdown Display|r"
		},
		{
			type = "slider",
			name = "X Position",
			min = 0, max = 2000, step = 10,
			default = M.default.hornCountdownX,
			getFunc = function() return M.sv.hornCountdownX end,
			setFunc = function(value) M.sv.hornCountdownX = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Y Position",
			min = 0, max = 2000, step = 10,
			default = M.default.hornCountdownY,
			getFunc = function() return M.sv.hornCountdownY end,
			setFunc = function(value) M.sv.hornCountdownY = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Scale",
			min = 0, max = 100, step = 5,
			default = M.default.hornCountdownScale,
			getFunc = function() return M.sv.hornCountdownScale end,
			setFunc = function(value) M.sv.hornCountdownScale = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "header",
			name = "|cFFD700Horn Icon Display|r"
		},
		{
			type = "slider",
			name = "X Position", 
			min = 0, max = 2000, step = 10,
			default = M.default.hornIconX,
			getFunc = function() return M.sv.hornIconX end,
			setFunc = function(value) M.sv.hornIconX = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Y Position",
			min = 0, max = 2000, step = 10,
			default = M.default.hornIconY,
			getFunc = function() return M.sv.hornIconY end,
			setFunc = function(value) M.sv.hornIconY = value; M.RestorePosition() end,
			width = "half"
		},
		{
			type = "slider",
			name = "Scale",
			min = 0, max = 100, step = 5,
			default = M.default.hornIconScale,
			getFunc = function() return M.sv.hornIconScale end,
			setFunc = function(value) M.sv.hornIconScale = value; M.RestorePosition() end,
			width = "half"
		},
		
	}
	HodorReflexes.RegisterOptionControls(options)

end