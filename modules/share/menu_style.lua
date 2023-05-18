local M = HodorReflexes.modules.share

function M.BuildStyleMenu()

	local panel = HodorReflexes.GetModulePanelConfig(GetString(HR_MENU_STYLE))

	local options = {
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_GENERAL))
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_STYLE_PINS),
			tooltip = GetString(HR_MENU_STYLE_PINS_TT),
			default = M.default.enableMapPins,
			getFunc = function() return M.sw.enableMapPins end,
			setFunc = function(value)
				M.sw.enableMapPins = value or false
			end,
			requiresReload = true,
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ANIMATIONS),
			tooltip = GetString(HR_MENU_ANIMATIONS_TT),
			default = M.default.enableAnimations,
			getFunc = function() return M.sw.enableAnimations end,
			setFunc = function(value)
				M.ToggleAnimations(value, true)
			end,
		},
		{
			type = "slider",
			name = GetString(HR_MENU_STYLE_TIMER_OPACITY),
			tooltip = GetString(HR_MENU_STYLE_TIMER_OPACITY_TT),
			min = 0,
			max = 1,
			step = 0.05,
			decimals = 2,
			clampInput = true,
			getFunc = function() return M.sw.styleZeroTimerOpacity end,
			setFunc = function(value)
				M.sw.styleZeroTimerOpacity = value
				M.RestoreColors()
			end,
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_STYLE_TIMER_BLINK),
			tooltip = GetString(HR_MENU_STYLE_TIMER_BLINK_TT),
			default = M.default.styleTimerBlink,
			getFunc = function() return M.sw.styleTimerBlink end,
			setFunc = function(value)
				M.sw.styleTimerBlink = value
			end,
		},
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_STYLE_DPS)),
		},
		{
			type = "dropdown",
			name = GetString(HR_MENU_STYLE_DPS_FONT),
			tooltip = "",
			--default = M.sw.styleDamageNumFont,
			getFunc = function() return M.sw.styleDamageNumFont end,
			setFunc = function(value)
				M.sw.styleDamageNumFont = value or 'gamepad'
				M.ApplyStyle()
			end,
			choices = {
				GetString(HR_MENU_STYLE_DPS_FONT_DEFAULT), GetString(HR_MENU_STYLE_DPS_FONT_GAMEPAD),
			},
			choicesValues = {
				'default', 'gamepad',
			},
		},
		{
			type = "colorpicker",
			name = GetString(HR_MENU_STYLE_DPS_BOSS_COLOR),
			tooltip = "",
			getFunc = function() return HodorReflexes.util.Hex2RGB(M.sw.styleBossDamageColor) end,
			setFunc = function(r, g, b)
				M.sw.styleBossDamageColor = HodorReflexes.util.RGB2Hex(r, g, b)
			end,
		},
		{
			type = "colorpicker",
			name = GetString(HR_MENU_STYLE_DPS_TOTAL_COLOR),
			tooltip = "",
			getFunc = function() return HodorReflexes.util.Hex2RGB(M.sw.styleTotalDamageColor) end,
			setFunc = function(r, g, b)
				M.sw.styleTotalDamageColor = HodorReflexes.util.RGB2Hex(r, g, b)
			end,
		},
		{
			type = "slider",
			name = GetString(HR_MENU_STYLE_DPS_HEADER_OPACITY),
			min = 0,
			max = 1,
			step = 0.05,
			decimals = 2,
			clampInput = true,
			getFunc = function() return M.sw.styleDamageHeaderOpacity end,
			setFunc = function(value)
				M.sw.styleDamageHeaderOpacity = value
				M.ApplyStyle()
			end,
		},
		{
			type = "slider",
			name = GetString(HR_MENU_STYLE_DPS_EVEN_OPACITY),
			min = 0,
			max = 1,
			step = 0.05,
			decimals = 2,
			clampInput = true,
			getFunc = function() return M.sw.styleDamageRowEvenOpacity end,
			setFunc = function(value)
				M.sw.styleDamageRowEvenOpacity = value
			end,
		},
		{
			type = "slider",
			name = GetString(HR_MENU_STYLE_DPS_ODD_OPACITY),
			min = 0,
			max = 1,
			step = 0.05,
			decimals = 2,
			clampInput = true,
			getFunc = function() return M.sw.styleDamageRowOddOpacity end,
			setFunc = function(value)
				M.sw.styleDamageRowOddOpacity = value
			end,
		},
		{
			type = "colorpicker",
			name = GetString(HR_MENU_STYLE_DPS_HIGHLIGHT),
			tooltip = GetString(HR_MENU_STYLE_DPS_HIGHLIGHT_TT),
			--default = ZO_ColorDef:New(unpack(M.default.damageRowColor)),
			getFunc = function() return unpack(M.sw.damageRowColor) end,
			setFunc = function(r, g, b, o)
				M.sw.damageRowColor = {r, g, b, o}
			end,
		},
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_HORN))
		},
		{
			type = "colorpicker",
			name = GetString(HR_MENU_STYLE_HORN_COLOR),
			tooltip = "",
			getFunc = function() return unpack(M.sw.styleHornColor) end,
			setFunc = function(r, g, b)
				M.sw.styleHornColor = {r, g, b}
				M.RestoreColors()
			end,
		},
		{
			type = "colorpicker",
			name = GetString(HR_MENU_STYLE_FORCE_COLOR),
			tooltip = "",
			getFunc = function() return unpack(M.sw.styleForceColor) end,
			setFunc = function(r, g, b)
				M.sw.styleForceColor = {r, g, b}
				M.RestoreColors()
			end,
		},
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_ATRONACH))
		},
		{
			type = "colorpicker",
			name = GetString(HR_MENU_STYLE_ATRONACH_COLOR),
			tooltip = "",
			getFunc = function() return unpack(M.sw.styleAtronachColor) end,
			setFunc = function(r, g, b)
				M.sw.styleAtronachColor = {r, g, b}
				M.RestoreColors()
			end,
		},
		{
			type = "colorpicker",
			name = GetString(HR_MENU_STYLE_BERSERK_COLOR),
			tooltip = "",
			getFunc = function() return unpack(M.sw.styleBerserkColor) end,
			setFunc = function(r, g, b)
				M.sw.styleBerserkColor = {r, g, b}
				M.RestoreColors()
			end,
		},
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_COLOS)),
		},
		{
			type = "colorpicker",
			name = GetString(HR_MENU_STYLE_COLOS_COLOR),
			tooltip = "",
			getFunc = function() return unpack(M.sw.styleColosColor) end,
			setFunc = function(r, g, b)
				M.sw.styleColosColor = {r, g, b}
				M.RestoreColors()
			end,
		},
	}

    LibAddonMenu2:RegisterAddonPanel(M.name .. "StyleMenu", panel)
    LibAddonMenu2:RegisterOptionControls(M.name .. "StyleMenu", options)

end