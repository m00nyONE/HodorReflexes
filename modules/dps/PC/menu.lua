-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local util = addon.util

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "dps"
local module = addon_modules[module_name]

-- TODO: translations
function module:GetSubMenuOptions()
    local general = {
        {
            type = "header",
            name = string.format("|cFFFACD%s|r", "General")
        },
        {
            type = "checkbox",
            name = "account wide settings",
            tooltip = "enable/disable account-wide settings.",
            default = true,
            getFunc = function() return self.sw.accountWide end,
            setFunc = function(value)
                self.sw.accountWide = value
            end,
            requiresReload = true,
        },
    }

    local damageList = {
        {
            type = "header",
            name = string.format("|cFFFACD%s|r", "Damage List")
        },
        {
            type = "checkbox",
            name = "Disable in PvP",
            tooltip = "disable the damage list when in PvP.",
            default = self.damageList.svDefault.disableInPvP,
            getFunc = function() return self.damageList.sw.disableInPvP end,
            setFunc = function(value)
                self.damageList.sw.disableInPvP = value
                self.damageList:RefreshVisibility()
            end,
        },
        {
            type = "dropdown",
            name = "visibility",
            tooltip = "set the visibility of the damage list.",
            default = self.damageList.svDefault.enabled,
            choices = {
                GetString(HR_VISIBILITY_SHOW_NEVER),
                GetString(HR_VISIBILITY_SHOW_ALWAYS),
                GetString(HR_VISIBILITY_SHOW_OUT_OF_COMBAT),
                GetString(HR_VISIBILITY_SHOW_NON_BOSSFIGHTS)
            },
            choicesValues = {
                0, 1, 2, 3
            },
            getFunc = function() return self.damageList.sv.enabled end,
            setFunc = function(value)
                self.damageList.sv.enabled = value
                self.damageList:RefreshVisibility()
            end,
            width = "full",
        },
        {
            type = "slider",
            name = "List width",
            min = 227,
            max = 450,
            step = 1,
            decimals = 0,
            default = self.damageList.svDefault.windowWidth,
            clampInput = true,
            getFunc = function() return self.damageList.sw.windowWidth end,
            setFunc = function(value)
                self.damageList.sw.windowWidth = value
                self.damageList.window:SetWidth(self.damageList.sw.windowWidth)
            end,
        },
        {
            type = "divider"
        },
        {
            type = "colorpicker",
            name = "Total Damage Color",
            tooltip = "",
            default = util.Hex2RGB(self.damageList.svDefault.colorDamageTotal),
            getFunc = function() return util.Hex2RGB(self.damageList.sw.colorDamageTotal) end,
            setFunc = function(r, g, b)
                self.damageList.sw.colorDamageTotal = util.RGB2Hex(r, g, b)
                self.damageList:Update()
            end,
        },
        {
            type = "colorpicker",
            name = "Boss Damage Color",
            tooltip = "",
            default = util.Hex2RGB(self.damageList.svDefault.colorDamageBoss),
            getFunc = function() return util.Hex2RGB(self.damageList.sw.colorDamageBoss) end,
            setFunc = function(r, g, b)
                self.damageList.sw.colorDamageBoss = util.RGB2Hex(r, g, b)
                self.damageList:Update()
            end,
        },
        {
            type = "colorpicker",
            name = "player row highlight color",
            tooltip = "highlight color for the player's row in the damage list.",
            default = ZO_ColorDef:New(unpack(self.damageList.svDefault.listPlayerHighlightColor)),
            getFunc = function() return unpack(self.damageList.sw.listPlayerHighlightColor) end,
            setFunc = function(r, g, b, o)
                self.damageList.sw.listPlayerHighlightColor = {r, g, b, o}
                self.damageList:Update()
            end,
        },
        {
            type = "divider"
        },
        {
            type = "slider",
            name = "Header Opacity",
            tooltip = "set the opacity of the damage list header.",
            min = 0,
            max = 1,
            step = 0.05,
            decimals = 2,
            clampInput = true,
            default = self.damageList.svDefault.listHeaderOpacity,
            getFunc = function() return self.damageList.sw.listHeaderOpacity end,
            setFunc = function(value)
                self.damageList.sw.listHeaderOpacity = value
                self.damageList:Update()
            end,
        },
        {
            type = "slider",
            name = "Even Row Opacity",
            tooltip = "set the opacity of the even rows in the damage list.",
            min = 0,
            max = 1,
            step = 0.05,
            decimals = 2,
            clampInput = true,
            default = self.damageList.svDefault.listRowEvenOpacity,
            getFunc = function() return self.damageList.sw.listRowEvenOpacity end,
            setFunc = function(value)
                self.damageList.sw.listRowEvenOpacity = value
                self.damageList:Update()
            end,
        },
        {
            type = "slider",
            name = "Odd Row Opacity",
            tooltip = "set the opacity of the odd rows in the damage list.",
            min = 0,
            max = 1,
            step = 0.05,
            decimals = 2,
            clampInput = true,
            default = self.damageList.svDefault.listRowOddOpacity,
            getFunc = function() return self.damageList.sw.listRowOddOpacity end,
            setFunc = function(value)
                self.damageList.sw.listRowOddOpacity = value
                self.damageList:Update()
            end,
        },
        {
            type = "divider"
        },
        {
            type = "slider",
            name = "Timer Interval (ms)",
            tooltip = "set the update interval of timers in the damage list (in milliseconds). Lower values increase update frequency but may impact performance.",
            min = 50,
            max = 1000,
            step = 25,
            decimals = 0,
            clampInput = true,
            default = self.damageList.svDefault.timerUpdateInterval,
            getFunc = function() return self.damageList.sw.timerUpdateInterval end,
            setFunc = function(value)
                self.damageList.sw.timerUpdateInterval = value
            end,
            requiresReload = true,
        },
    }

    local options = {}
    for _, option in ipairs(general) do
        table.insert(options, option)
    end
    for _, option in ipairs(damageList) do
        table.insert(options, option)
    end

    return options
end