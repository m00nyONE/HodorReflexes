local HR = HodorReflexes
local M = HodorReflexes.modules.share

local LCI = LibCustomIcons
local LCN = LibCustomNames
local LAM = LibAddonMenu2

local strfmt = string.format
local currentFolder = "misc7"
local discordURL = "https://discord.gg/8YpvXJhAyz"



local function getVisibilityOptions()
	return {
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
end

local function getCustomIconOptions()
	local sv = M.sv

	local displayName = GetDisplayName('player')

	if not sv.selectedDonationTier then sv.selectedDonationTier = 1 end

	-- Convert FFFFFF to 1, 1, 1
	local function Hex2RGB(hex)
		hex = hex:gsub("#", "")
		return tonumber("0x" .. hex:sub(1, 2)) / 255, tonumber("0x" .. hex:sub(3, 4)) / 255, tonumber("0x" .. hex:sub(5, 6)) / 255
	end

	-- Convert 1, 1, 1 to FFFFFF
	local function RGB2Hex(r, g, b)
		return strfmt("%.2x%.2x%.2x", zo_round(r * 255), zo_round(g * 255), zo_round(b * 255))
	end

	-- Generate gradient user name.
	local _generateGradient = function()
		local r1, g1, b1 = unpack(sv.myIconColor1)
		local r2, g2, b2 = unpack(sv.myIconColor2)
		local s = sv.myIconNameRaw
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
					t[i] = strfmt('|c%s%s|r', RGB2Hex(r1, g1, b1), t[i])
				end
			end
			return table.concat(t)
		else
			return ""
		end
	end

	-- Create preview string and update control if needed.
	local _generatePreview = function(updateControl)
		local s = strfmt("                    %s", sv.myIconNameFormatted)
		if updateControl then
			HodorReflexes_ShareIconsMenu_preview.data.text = s
		end
		return s
	end

	-- Generate formatted name based on raw name and selected colors.
	local _generateName = function(updateControl)
		if sv.myIconGradient then
			sv.myIconNameFormatted = _generateGradient()
		else
			sv.myIconNameFormatted = strfmt('|c%s%s|r', RGB2Hex(unpack(sv.myIconColor1)), sv.myIconNameRaw)
		end
		if updateControl then
			_generatePreview(true)
		end
		return sv.myIconNameFormatted
	end

	local _escapeName = function(displayName)
		local name = displayName:gsub("^@", "")
		name = name:gsub("[^%w%-_]", "")
		return name
	end

	local _generateNameCode = function(displayName)
		local s = strfmt('n["%s"] = {"%s", "%s"}', displayName, sv.myIconNameRaw, sv.myIconNameFormatted)
		return s
	end

	local _generateStaticCode = function(displayName)
		local s = strfmt('s["%s"] = "LibCustomIcons/icons/%s/%s.dds"', displayName, currentFolder, _escapeName(displayName))
		return s
	end
	local _generateAnimatedCode = function(displayName)
		local s = strfmt('a["%s"] = {"LibCustomIcons/icons/%s/%s_anim.dds", 0, 0, 0}', displayName, currentFolder, _escapeName(displayName))
		return s
	end

	local _generateCode = function(tier)
		local code = "```\n"
		if tier >= 1 then
			code = code .. _generateNameCode(displayName)
			code = code .. "\n"
		end
		if tier >= 2 then
			code = code .. _generateStaticCode(displayName)
			code = code .. "\n"
		end
		if tier >= 3 then
			code = code .. _generateAnimatedCode(displayName)
			code = code .. "\n"
		end
		code = code .. "```"

		if HodorReflexes_ShareIconsMenu_Code then
			HodorReflexes_ShareIconsMenu_Code.container:SetHeight(24 * 6)
			HodorReflexes_ShareIconsMenu_Code:SetHeight(24 * 6)
		end

		return code
	end

	-- main LAM options
	return {
		{
			type = "divider"
		},
		{
			type = "header",
			name = strfmt("|cFFFACD%s|r", GetString(HR_MENU_ICONS_SECTION_CUSTOM))
		},
		{
			type = "description",
			text = strfmt(GetString(HR_MENU_ICONS_README_1))
		},
		{
			type = "header",
			name = strfmt("|cFFFACD1. %s|r", GetString(HR_MENU_ICONS_HEADER_ICONS))
		},
		{
			type = "description",
			text = GetString(HR_MENU_ICONS_README_2)
		},

		{
			type = "header",
			name = strfmt("|cFFFACD2. %s|r", GetString(HR_MENU_ICONS_HEADER_TIERS))
		},
		{
			type = "description",
			text = GetString(HR_MENU_ICONS_README_3)
		},
		{
			type = "slider",
			name = GetString(HR_MENU_ICONS_README_DONATION_TIER),
			tooltip = GetString(HR_MENU_ICONS_README_DONATION_TIER_TT),
			min = 1,
			max = 3,
			step = 1,
			default = 1,
			decimals = 0,
			clampInput = true,
			getFunc = function() return sv.selectedDonationTier end,
			setFunc = function(value) sv.selectedDonationTier = value end,
		},

		{
			type = "header",
			name = strfmt("|cFFFACD3. %s|r", GetString(HR_MENU_ICONS_HEADER_CUSTOMIZE))
		},
		{
			type = "description",
			text = GetString(HR_MENU_ICONS_README_4)
		},
		{
			type = "editbox",
			name = GetString(LCN_MENU_NAME_VAL),
			tooltip = GetString(LCN_MENU_NAME_VAL_TT),
			default = sv.myIconNameRaw,
			getFunc = function() return sv.myIconNameRaw end,
			setFunc = function(value)
				if value ~= sv.myIconNameRaw then
					sv.myIconNameRaw = value or ""
					_generateName(true)
				end
			end,
		},
		{
			type = "checkbox",
			name = GetString(LCN_MENU_GRADIENT),
			tooltip = GetString(LCN_MENU_GRADIENT_TT),
			default = false,
			getFunc = function() return sv.myIconGradient end,
			setFunc = function(value)
				sv.myIconGradient = value
				_generateName(true)
			end,
		},
		{
			type = "colorpicker",
			name = GetString(LCN_MENU_COLOR1),
			default = ZO_ColorDef:New(1, 1, 1, 1),
			getFunc = function() return unpack(sv.myIconColor1) end,
			setFunc = function(r2, g2, b2)
				local r1, g1, b1 = unpack(sv.myIconColor1)
				if r1 ~= r2 or g1 ~= g2 or b1 ~= b2 then
					sv.myIconColor1 = {r2, g2, b2}
					_generateName(true)
				end
			end,
			width = 'full',
		},
		{
			type = "colorpicker",
			name = GetString(LCN_MENU_COLOR2),
			default = ZO_ColorDef:New(1, 1, 1, 1),
			getFunc = function() return unpack(sv.myIconColor2) end,
			setFunc = function(r2, g2, b2)
				local r1, g1, b1 = unpack(sv.myIconColor2)
				if r1 ~= r2 or g1 ~= g2 or b1 ~= b2 then
					sv.myIconColor2 = {r2, g2, b2}
					_generateName(true)
				end
			end,
			width = 'full',
		},
		{
			type = "description",
			text = GetString(LCN_MENU_PREVIEW),
			width = "half",
		},
		{
			type = "description",
			text = _generatePreview(),
			reference = "HodorReflexes_ShareIconsMenu_preview",
			width = "half",
		},

		{
			type = "header",
			name = strfmt("|cFFFACD4. %s|r", GetString(HR_MENU_ICONS_HEADER_TICKET))
		},
		{
			type = "description",
			text = GetString(HR_MENU_ICONS_README_5),
		},
		{
			type = "editbox",
			tooltip = GetString(HR_MENU_ICONS_CONFIGURATOR_LUA_TT),
			default = _generateCode(sv.selectedDonationTier),
			getFunc = function() return _generateCode(sv.selectedDonationTier) end,
			setFunc = function(value) end,
			isMultiline = true,
			isExtraWide = true,
			reference = "HodorReflexes_ShareIconsMenu_Code",
		},
		{
			type = "description",
			text = GetString(HR_MENU_ICONS_README_6),
		},
		{
			type = "button",
			name = GetString(HR_MENU_ICONS_CONFIGURATOR_DISCORD),
			tooltip = GetString(HR_MENU_ICONS_CONFIGURATOR_DISCORD_TT),
			func = function() RequestOpenUnsafeURL(discordURL) end,
			width = "full"
		},
		{
			type = "header",
			name = strfmt("|cFFFACD6. %s|r", GetString(HR_MENU_ICONS_HEADER_DONATION))
		},
		{
			type = "description",
			text = strfmt(GetString(HR_MENU_ICONS_README_7), LAM.util.L.DONATION),
		},
		{
			type = "button",
			name = LAM.util.L.DONATION,
			tooltip = GetString(HR_MENU_ICONS_CONFIGURATOR_DONATE_TT),
			func = HR.Donation,
			width = "full"
		},
		{
			type = "header",
			name = strfmt("|cFFFACD%s|r", GetString(HR_MENU_ICONS_HEADER_INFO))
		},
		{
			type = "description",
			text = GetString(HR_MENU_ICONS_INFO),
		},
	}
end


function M.BuildIconsMenu()
	if not LCI or not LCN then return end

	local panel = HodorReflexes.GetModulePanelConfig(GetString(HR_MENU_ICONS))

	local options = {}

	local visibilityOptions = getVisibilityOptions()
	for _, entry in ipairs(visibilityOptions) do
		table.insert(options, entry)
	end

	local customIconsOptions = getCustomIconOptions()
	for _, entry in ipairs(customIconsOptions) do
		table.insert(options, entry)
	end

    LibAddonMenu2:RegisterAddonPanel(M.name .. "IconsMenu", panel)
    LibAddonMenu2:RegisterOptionControls(M.name .. "IconsMenu", options)
end