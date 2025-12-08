-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal

local util = addon.util
local LHAS = LibHarvensAddonSettings

local addon_extensions = addon.extensions
local extension = addon_extensions.configurator

function extension:GetSubMenuOptions()
    local options = {
        {
            type = LHAS.ST_SECTION,
            label = string.format("|cFFFACD%s|r", GetString(HR_MENU_ICONS_SECTION_CUSTOM))
        },
        {
            type = LHAS.ST_LABEL,
            label = string.format(GetString(HR_MENU_ICONS_README_1))
        },
        {
            type = LHAS.ST_SECTION,
            label = string.format("|cFFFACD1. %s|r", GetString(HR_MENU_ICONS_HEADER_ICONS))
        },
        {
            type = LHAS.ST_LABEL,
            label = GetString(HR_MENU_ICONS_README_2)
        },

        {
            type = LHAS.ST_SECTION,
            label = string.format("|cFFFACD2. %s|r", GetString(HR_MENU_ICONS_HEADER_TIERS))
        },
        {
            type = LHAS.ST_LABEL,
            label = GetString(HR_MENU_ICONS_README_3)
        },
        {
            type = LHAS.ST_SLIDER,
            label = GetString(HR_MENU_ICONS_README_DONATION_TIER),
            tooltip = GetString(HR_MENU_ICONS_README_DONATION_TIER_TT),
            min = 1,
            max = 3,
            step = 1,
            default = 1,
            format = "%.0f",
            getFunction = function() return self.sw.selectedDonationTier end,
            setFunction = function(value) self.sw.selectedDonationTier = value end,
        },
        --
        --{
        --    type = "header",
        --    name = string.format("|cFFFACD3. %s|r", GetString(HR_MENU_ICONS_HEADER_CUSTOMIZE))
        --},
        --{
        --    type = "description",
        --    text = GetString(HR_MENU_ICONS_README_4)
        --},
        --{
        --    type = "editbox",
        --    name = GetString(LCN_MENU_NAME_VAL),
        --    tooltip = GetString(LCN_MENU_NAME_VAL_TT),
        --    default = self.svDefault.nameRaw,
        --    getFunc = function() return self.sw.nameRaw end,
        --    setFunc = function(value)
        --        if value ~= self.sw.nameRaw then
        --            self.sw.nameRaw = value or ""
        --            _generateColoredNameWrapper(true)
        --        end
        --    end,
        --},
        --{
        --    type = "checkbox",
        --    name = GetString(LCN_MENU_GRADIENT),
        --    tooltip = GetString(LCN_MENU_GRADIENT_TT),
        --    default = false,
        --    getFunc = function() return self.sw.nameGradient end,
        --    setFunc = function(value)
        --        self.sw.nameGradient = value
        --        _generateColoredNameWrapper(true)
        --    end,
        --},
        --{
        --    type = "colorpicker",
        --    name = GetString(LCN_MENU_COLOR1),
        --    default = ZO_ColorDef:New(1, 1, 1, 1),
        --    getFunc = function() return unpack(self.sw.nameColorBegin) end,
        --    setFunc = function(r2, g2, b2)
        --        local r1, g1, b1 = unpack(self.sw.nameColorBegin)
        --        if r1 ~= r2 or g1 ~= g2 or b1 ~= b2 then
        --            self.sw.nameColorBegin = {r2, g2, b2}
        --            _generateColoredNameWrapper(true)
        --        end
        --    end,
        --    width = 'full',
        --},
        --{
        --    type = "colorpicker",
        --    name = GetString(LCN_MENU_COLOR2),
        --    default = ZO_ColorDef:New(1, 1, 1, 1),
        --    getFunc = function() return unpack(self.sw.nameColorEnd) end,
        --    setFunc = function(r2, g2, b2)
        --        local r1, g1, b1 = unpack(self.sw.nameColorEnd)
        --        if r1 ~= r2 or g1 ~= g2 or b1 ~= b2 then
        --            self.sw.nameColorEnd = {r2, g2, b2}
        --            _generateColoredNameWrapper(true)
        --        end
        --    end,
        --    width = 'full',
        --},
        --{
        --    type = "description",
        --    text = GetString(LCN_MENU_PREVIEW),
        --    width = "half",
        --},
        --{
        --    type = "description",
        --    text = _generatePreview(),
        --    reference = menuReference .. "_preview",
        --    width = "half",
        --},
        --
        --{
        --    type = "header",
        --    name = string.format("|cFFFACD4. %s|r", GetString(HR_MENU_ICONS_HEADER_TICKET))
        --},
        --{
        --    type = "description",
        --    text = GetString(HR_MENU_ICONS_README_5),
        --},
        --{
        --    type = "editbox",
        --    tooltip = GetString(HR_MENU_ICONS_CONFIGURATOR_LUA_TT),
        --    default = _generateCodeWrapper(),
        --    getFunc = function() return _generateCodeWrapper() end,
        --    setFunc = function(value) end,
        --    isMultiline = true,
        --    isExtraWide = true,
        --    reference = menuReference .. "_Code",
        --},
        --{
        --    type = "description",
        --    text = GetString(HR_MENU_ICONS_README_6),
        --},
        --{
        --    type = "button",
        --    name = GetString(HR_MENU_ICONS_CONFIGURATOR_DISCORD),
        --    tooltip = GetString(HR_MENU_ICONS_CONFIGURATOR_DISCORD_TT),
        --    func = function() RequestOpenUnsafeURL(self.discordURL) end,
        --    width = "full"
        --},
        --{
        --    type = "header",
        --    name = string.format("|cFFFACD6. %s|r", GetString(HR_MENU_ICONS_HEADER_DONATION))
        --},
        --{
        --    type = "description",
        --    text = string.format(GetString(HR_MENU_ICONS_README_7), LAM.util.L.DONATION),
        --},
        --{
        --    type = "button",
        --    name = LAM.util.L.DONATION,
        --    tooltip = GetString(HR_MENU_ICONS_CONFIGURATOR_DONATE_TT),
        --    func = addon.Donate,
        --    width = "full"
        --},
        --{
        --    type = "header",
        --    name = string.format("|cFFFACD%s|r", GetString(HR_MENU_ICONS_HEADER_INFO))
        --},
        --{
        --    type = "description",
        --    text = GetString(HR_MENU_ICONS_INFO),
        --},
    }

    return options
end