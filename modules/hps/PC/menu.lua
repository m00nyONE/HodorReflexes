-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local util = addon.util

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "hps"
local module = addon_modules[module_name]

-- TODO: translations
--- @return table the submenu options for the HPS module
function module:GetSubMenuOptions()
    local fontChoices = {}
    local fontValues = {}
    for _, fontInfo in ipairs(util.GetFontOptions(18)) do
        table.insert(fontChoices, fontInfo.name)
        table.insert(fontValues, fontInfo.data)
    end

    local function GetComonListOptions(listName, list)
        return {
            core.CreateSectionHeader(listName),
            {
                type = "checkbox",
                name = GetString(HR_MENU_DISABLE_IN_PVP),
                tooltip = GetString(HR_MENU_DISABLE_IN_PVP_TT),
                default = list.svDefault.disableInPvP,
                getFunc = function() return list.sw.disableInPvP end,
                setFunc = function(value)
                    list.sw.disableInPvP = value
                    list:RefreshVisibility()
                end,
            },
            {
                type = "dropdown",
                name = GetString(HR_MENU_VISIBILITY),
                tooltip = GetString(HR_MENU_VISIBILITY_TT),
                default = list.svDefault.enabled,
                choices = {
                    GetString(HR_VISIBILITY_SHOW_NEVER),
                    GetString(HR_VISIBILITY_SHOW_ALWAYS),
                    GetString(HR_VISIBILITY_SHOW_OUT_OF_COMBAT),
                    GetString(HR_VISIBILITY_SHOW_NON_BOSSFIGHTS),
                },
                choicesValues = {
                    0, 1, 2, 3
                },
                getFunc = function() return list.sw.enabled end,
                setFunc = function(value)
                    list.sw.enabled = value
                    list:RefreshVisibility()
                    list:UpdateDebounced(true) -- force an update to clear potentially old data still being in the list because they where never redrawn when hidden
                end,
                width = "full",
            },
            {
                type = "divider",
                isAdvancedSetting = true,
            },
            {
                type = "slider",
                name = GetString(HR_MENU_LIST_WIDTH),
                tooltip = GetString(HR_MENU_LIST_WIDTH_TT),
                min = list.svDefault.windowWidth,
                max = list.svDefault.windowWidth + 150,
                step = 1,
                decimals = 0,
                default = list.svDefault.windowWidth,
                clampInput = true,
                getFunc = function() return list.sw.windowWidth end,
                setFunc = function(value)
                    list.sw.windowWidth = value
                    list.window:SetWidth(list.sw.windowWidth)
                end,
                isAdvancedSetting = true,
            },
            {
                type = "slider",
                name = GetString(HR_MENU_SCALE),
                tooltip = GetString(HR_MENU_SCALE_TT),
                min = 60,
                max = 160,
                step = 1,
                decimals = 0,
                default = list.svDefault.windowScale * 100,
                clampInput = true,
                getFunc = function() return list.sw.windowScale * 100 end,
                setFunc = function(value)
                    list.sw.windowScale = value / 100
                    list.window:SetScale(list.sw.windowScale)
                end,
                isAdvancedSetting = true,
            },
            {
                type = "dropdown",
                name = "Name Font",
                tooltip = "set the font for the player names in the list.",
                default = list.svDefault.nameFont,
                choices = fontChoices,
                choicesValues = fontValues,
                getFunc = function() return list.sw.nameFont end,
                setFunc = function(value)
                    list.sw.nameFont = value
                    list:RefreshVisibility()
                    list:UpdateDebounced(true) -- force an update to clear potentially old data still being in the list because they where never redrawn when hidden
                end,
                isAdvancedSetting = true,
                width = "full",
            },
        }
    end


    local options = {}
    local hpsList = GetComonListOptions(GetString(HR_MODULES_HPS_MENU_HEADER), self.hpsList)
    local hpsListSpecificOptions = {
        {
            type = "divider",
        },
        {
            type = "checkbox",
            name = GetString(HR_MODULES_HPS_MENU_ONLY_SHOW_HEALERS),
            tooltip = GetString(HR_MODULES_HPS_MENU_ONLY_SHOW_HEALERS_TT),
            default = self.hpsList.svDefault.onlyShowHealers,
            getFunc = function() return self.hpsList.sw.onlyShowHealers end,
            setFunc = function(value)
                self.hpsList.sw.onlyShowHealers = value
                self.hpsList:Update()
            end,
        },
        {
            type = "divider",
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "HPS Color",
            tooltip = "",
            default = ZO_ColorDef:New(util.Hex2RGB(self.hpsList.svDefault.colorHPS)),
            getFunc = function() return util.Hex2RGB(self.hpsList.sw.colorHPS) end,
            setFunc = function(r, g, b)
                self.hpsList.sw.colorHPS = util.RGB2Hex(r, g, b)
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "Overheal Color",
            tooltip = "",
            default = ZO_ColorDef:New(util.Hex2RGB(self.hpsList.svDefault.colorOverheal)),
            getFunc = function() return util.Hex2RGB(self.hpsList.sw.colorOverheal) end,
            setFunc = function(r, g, b)
                self.hpsList.sw.colorOverheal = util.RGB2Hex(r, g, b)
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "divider",
            isAdvancedSetting = true,
        },
        {
            type = "checkbox",
            name = "Highlight Player Row",
            tooltip = "enable or disable highlighting of the player's row in the damage list.",
            default = self.hpsList.svDefault.listPlayerHighlight,
            getFunc = function() return self.hpsList.sw.listPlayerHighlight end,
            setFunc = function(value)
                self.hpsList.sw.listPlayerHighlight = value
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "player row highlight color",
            tooltip = "highlight color for the player's row in the hps list.",
            default = ZO_ColorDef:New(unpack(self.hpsList.svDefault.listPlayerHighlightColor)),
            getFunc = function() return unpack(self.hpsList.sw.listPlayerHighlightColor) end,
            setFunc = function(r, g, b, o)
                self.hpsList.sw.listPlayerHighlightColor = {r, g, b, o}
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "divider",
            isAdvancedSetting = true,
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
            default = self.hpsList.svDefault.listHeaderOpacity,
            getFunc = function() return self.hpsList.sw.listHeaderOpacity end,
            setFunc = function(value)
                self.hpsList.sw.listHeaderOpacity = value
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
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
            default = self.hpsList.svDefault.listRowEvenOpacity,
            getFunc = function() return self.hpsList.sw.listRowEvenOpacity end,
            setFunc = function(value)
                self.hpsList.sw.listRowEvenOpacity = value
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
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
            default = self.hpsList.svDefault.listRowOddOpacity,
            getFunc = function() return self.hpsList.sw.listRowOddOpacity end,
            setFunc = function(value)
                self.hpsList.sw.listRowOddOpacity = value
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "divider",
            isAdvancedSetting = true,
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
            default = self.hpsList.svDefault.timerUpdateInterval,
            getFunc = function() return self.hpsList.sw.timerUpdateInterval end,
            setFunc = function(value)
                self.hpsList.sw.timerUpdateInterval = value
            end,
            requiresReload = true,
            isAdvancedSetting = true,
        },
    }

    core.MergeOptions(hpsListSpecificOptions, hpsList)
    core.MergeOptions(hpsList, options)

    return options
end