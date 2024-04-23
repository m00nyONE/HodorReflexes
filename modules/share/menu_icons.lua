local M = HodorReflexes.modules.share
local anim = HodorReflexes.anim

function M.BuildIconsMenu()

	-- Generate gradient user name.
	local GenerateGradient = function()
		local r1, g1, b1 = unpack(M.sw.myIconColor1)
		local r2, g2, b2 = unpack(M.sw.myIconColor2)
		local s = M.sw.myIconNameRaw
		local t = {} -- raw name split into single characters
		local n = 0 -- number of non spaces
		-- Split raw name into single utf8 characters.
		for i = 1, utf8.len(s) do
			t[i] = string.sub(s, utf8.offset(s, i), utf8.offset(s, i + 1) - 1)
			if t[i] ~= " " then
				n = n + 1
			end
		end
		-- Don't color spaces.
		if n > 0 then
			local rdelta, gdelta, bdelta = (r2 - r1) / n, (g2 - g1) / n, (b2 - b1) / n
			for i = 1, #t do
				if t[i] ~= " " then
					r1 = r1 + rdelta
					g1 = g1 + gdelta
					b1 = b1 + bdelta
					t[i] = string.format('|c%s%s|r', HodorReflexes.util.RGB2Hex(r1, g1, b1), t[i])
				end
			end
			return table.concat(t)
		else
			return ""
		end
	end

	-- Generate new LUA code based on custom name and selected colors.
	local GenerateCode = function()
		local s = string.format('u["%s"] = {"%s", "%s", "%s"}', GetDisplayName('player'), M.sw.myIconNameRaw, M.sw.myIconNameFormatted, M.sw.myIconPathFull)
		return s
	end

	-- Parse LUA code to extract custom name and icon path.
	-- Format: u["@UserID"] = {"name", "|cFFFF00name|r", "HodorReflexes/users/misc/name.dds"}
	local ParseCode = function(value)
		local t = {}
		-- Get all values in double quotes.
		-- If everything is correct, then there will be four: @UserID, name, colored name, file.
		for s in string.gmatch(value, '"([^"]*)"') do t[#t + 1] = s end
		if #t >= 4 then
			M.sw.myIconNameRaw = t[2]
			M.sw.myIconNameFormatted = t[3]
			M.sw.myIconPathFull = t[4]
			HodorReflexesIconsMenu_raw.label:SetColor(1, 1, 1)
		else
			HodorReflexesIconsMenu_raw.label:SetColor(1, 0, 0)
		end
	end

	-- Create preview string and update control if needed.
	local GeneratePreview = function(updateControl)
		local s = string.format('|t22:22:%s|t %s', M.sw.myIconPathFull, M.sw.myIconNameFormatted)
		if updateControl then
			HodorReflexesIconsMenu_preview.data.text = s
		end
		return s
	end

	-- Generate formatted name based on raw name and selected colors.
	local GenerateName = function(updateControl)
		if M.sw.myIconGradient then
			M.sw.myIconNameFormatted = GenerateGradient()
		else
			M.sw.myIconNameFormatted = string.format('|c%s%s|r', HodorReflexes.util.RGB2Hex(unpack(M.sw.myIconColor1)), M.sw.myIconNameRaw)
		end
		if updateControl then
			GeneratePreview(true)
		end
		return M.sw.myIconNameFormatted
	end

	local panel = HodorReflexes.GetModulePanelConfig(GetString(HR_MENU_ICONS))

	local readme = {}
	readme[1] = {
		type = "description",
		text = string.format("|c00FF001.|r %s", GetString(HR_MENU_ICONS_README1))
	}
	readme[2] = {
		type = "description",
		text = string.format("|c00FF002.|r %s", GetString(HR_MENU_ICONS_README2))
	}
	readme[3] = {
		type = "description",
		text = string.format("|c00FF003.|r %s", string.format(GetString(HR_MENU_ICONS_README3), LibAddonMenu2.util.L.WEBSITE))
	}
	readme[4] = {
		type = "texture",
		imageWidth = 32,
		imageHeight = 32,
		reference = 'HodorReflexesIconsMenu_pkdab',
	}

	local options = {
		{
			type = "submenu",
			name = string.format("|cFF8800%s|r", GetString(HR_MENU_ICONS_README)),
			controls = readme,
		},
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_ICONS_MY))
		},
		{
			type = "editbox",
			name = GetString(HR_MENU_ICONS_NAME_VAL),
			tooltip = GetString(HR_MENU_ICONS_NAME_VAL_TT),
            default = M.default.myIconNameRaw,
			getFunc = function() return M.sw.myIconNameRaw end,
			setFunc = function(value)
				if value ~= M.sw.myIconNameRaw then
					M.sw.myIconNameRaw = value or ""
					GenerateName(true)
				end
			end,
		},
		{
			type = "checkbox",
			name = GetString(HR_MENU_ICONS_GRADIENT),
			tooltip = GetString(HR_MENU_ICONS_GRADIENT_TT),
			default = false,
			getFunc = function() return M.sw.myIconGradient end,
			setFunc = function(value)
				M.sw.myIconGradient = value
				GenerateName(true)
			end,
		},
		{
			type = "colorpicker",
			name = GetString(HR_MENU_ICONS_COLOR1),
			default = ZO_ColorDef:New(1, 1, 1, 1),
			getFunc = function() return unpack(M.sw.myIconColor1) end,
			setFunc = function(r2, g2, b2)
				local r1, g1, b1 = unpack(M.sw.myIconColor1)
				if r1 ~= r2 or g1 ~= g2 or b1 ~= b2 then
					M.sw.myIconColor1 = {r2, g2, b2}
					GenerateName(true)
				end
			end,
			width = 'half',
		},
		{
			type = "colorpicker",
			name = GetString(HR_MENU_ICONS_COLOR2),
			default = ZO_ColorDef:New(1, 1, 1, 1),
			getFunc = function() return unpack(M.sw.myIconColor2) end,
			setFunc = function(r2, g2, b2)
				local r1, g1, b1 = unpack(M.sw.myIconColor2)
				if r1 ~= r2 or g1 ~= g2 or b1 ~= b2 then
					M.sw.myIconColor2 = {r2, g2, b2}
					GenerateName(true)
				end
			end,
			width = 'half',
		},
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_ICONS_PREVIEW)),
		},
		{
			type = "description",
			text = GeneratePreview(),
			reference = "HodorReflexesIconsMenu_preview",
		},
		{
			type = "editbox",
			name = GetString(HR_MENU_ICONS_LUA),
			reference = "HodorReflexesIconsMenu_raw",
			tooltip = GetString(HR_MENU_ICONS_LUA_TT),
            default = GenerateCode(),
			getFunc = function() return GenerateCode() end,
			setFunc = function(value) ParseCode(value); GeneratePreview(true) end,
			isMultiline = true,
			isExtraWide = true,
		},
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
		{
			type = "header",
			name = string.format("|cFFFACD%s|r", GetString(HR_MENU_ICONS_INTEGRITY)),
		},
		{
			type = "description",
			text = string.format("|cFFFACD%s|r", GetString(HR_MENU_ICONS_INTEGRITY_DESCRIPTION)),
		},
		{
			type = "button",
			name = GetString(HR_MENU_ICONS_INTEGRITY_CHECK),
			tooltip = GetString(HR_MENU_ICONS_INTEGRITY_DESCRIPTION),
			func = function()
				HodorReflexes.integrity.Check()
			end,
			width = 'half',
		},
	}

    LibAddonMenu2:RegisterAddonPanel(M.name .. "IconsMenu", panel)
    LibAddonMenu2:RegisterOptionControls(M.name .. "IconsMenu", options)

	-- Set font for preview.
	CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", function(p)
		if p.data.name == panel.name then
			HodorReflexesIconsMenu_preview.desc:SetWidth(130)
			HodorReflexesIconsMenu_preview.desc:SetHeight(22)
			HodorReflexesIconsMenu_preview.desc:SetFont('$(MEDIUM_FONT)|$(KB_18)|shadow')
			local bg = WINDOW_MANAGER:CreateControl(nil, HodorReflexesIconsMenu_preview, CT_BACKDROP)
			bg:SetAnchor(TOPLEFT, HodorReflexesIconsMenu_preview, TOPLEFT, 0, 0)
			bg:SetDimensions(130, 24)
			bg:SetCenterColor(0, 0, 0, 0)
			bg:SetEdgeColor(0.35, 0.35, 0.35)
			bg:SetEdgeTexture(nil, 1, 1, 1)
			bg:SetHidden(false)
		end
	end)
	-- Show animated icon.
	CALLBACK_MANAGER:RegisterCallback("LAM-PanelOpened", function(p)
		if p.data.name == panel.name then
			zo_callLater(function() -- apply animation after 500ms to make sure the texture is created
				if anim.RegisterUser("pikadab") and HodorReflexesIconsMenu_pkdab then
					anim.RegisterUserControl("pikadab", HodorReflexesIconsMenu_pkdab.texture)
					anim.RunUserAnimations("pikadab")
				end
			end, 500)
		end
	end)
	CALLBACK_MANAGER:RegisterCallback("LAM-PanelClosed", function(p)
		if p.data.name == panel.name then
			anim.UnregisterUser("pikadab")
		end
	end)

end