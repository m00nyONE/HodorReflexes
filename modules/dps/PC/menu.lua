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
--- @return table the submenu options for the DPS module
function module:GetSubMenuOptions()
    local function mergeOptions(source, destination)
        for _, option in ipairs(source) do
            if not option.isAdvancedSetting or self.sw.advancedSettings then
                if option.isAdvancedSetting and option.name then
                    option.name = string.format("|cff9900%s|r", option.name)
                end
                table.insert(destination, option)
            end
        end
    end

    local function GetGeneralOptions()
        return {
            core.CreateSectionHeader(GetString(HR_MENU_GENERAL)),
            {
                type = "checkbox",
                name = GetString(HR_MENU_ACCOUNTWIDE),
                tooltip = GetString(HR_MENU_ACCOUNTWIDE_TT),
                default = true,
                getFunc = function() return self.sw.accountWide end,
                setFunc = function(value)
                    self.sw.accountWide = value
                end,
                requiresReload = true,
            },
            {
                type = "checkbox",
                name = string.format("|cff9900%s|r", GetString(HR_MENU_ADVANCED_SETTINGS)),
                tooltip = GetString(HR_MENU_ADVANCED_SETTINGS_TT),
                default = false,
                getFunc = function() return self.sw.advancedSettings end,
                setFunc = function(value)
                    self.sw.advancedSettings = value
                end,
                requiresReload = true,
            },
        }
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
        }
    end


    local options = GetGeneralOptions()
    local damageList = GetComonListOptions(GetString(HR_MODULES_DPS_MENU_HEADER), self.damageList)
    local damageListSpecificOptions = {
        {
            type = "divider",
        },
        {
            type = "checkbox",
            name = GetString(HR_MODULES_DPS_MENU_SHOW_SUMMARY),
            tooltip = GetString(HR_MODULES_DPS_MENU_SHOW_SUMMARY_TT),
            default = self.damageList.svDefault.showSummary,
            getFunc = function() return self.damageList.sw.showSummary end,
            setFunc = function(value)
                self.damageList.sw.showSummary = value
                self.damageList:Update()
            end,
        },
        {
            type = "slider",
            name = "Burst Window (s)",
            tooltip = "set the time window (in seconds) for calculating burst damage.",
            min = 5,
            max = 60,
            step = 1,
            decimals = 0,
            clampInput = true,
            default = self.damageList.svDefault.burstWindowSeconds,
            getFunc = function() return self.damageList.sw.burstWindowSeconds end,
            setFunc = function(value)
                self.damageList.sw.burstWindowSeconds = value
                self.damageList:Update()
            end,
            disabled = function() return not self.damageList.sw.showSummary end,
        },
        {
            type = "colorpicker",
            name = "Group DPS Color",
            tooltip = "color used to display the group DPS value.",
            default = ZO_ColorDef:New(util.Hex2RGB(self.damageList.svDefault.colorGroupDPS)),
            getFunc = function() return util.Hex2RGB(self.damageList.sw.colorGroupDPS) end,
            setFunc = function(r, g, b)
                self.damageList.sw.colorGroupDPS = util.RGB2Hex(r, g, b)
                self.damageList:Update()
            end,
            disabled = function() return not self.damageList.sw.showSummary end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "Group Burst DPS Color",
            tooltip = "color used to display the group burst DPS value.",
            default = ZO_ColorDef:New(util.Hex2RGB(self.damageList.svDefault.colorBurstDPS)),
            getFunc = function() return util.Hex2RGB(self.damageList.sw.colorBurstDPS) end,
            setFunc = function(r, g, b)
                self.damageList.sw.colorBurstDPS = util.RGB2Hex(r, g, b)
                self.damageList:Update()
            end,
            disabled = function() return not self.damageList.sw.showSummary end,
            isAdvancedSetting = true,
        },
        {
            type = "divider",
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "Total Damage Color",
            tooltip = "",
            default = ZO_ColorDef:New(util.Hex2RGB(self.damageList.svDefault.colorDamageTotal)),
            getFunc = function() return util.Hex2RGB(self.damageList.sw.colorDamageTotal) end,
            setFunc = function(r, g, b)
                self.damageList.sw.colorDamageTotal = util.RGB2Hex(r, g, b)
                self.damageList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "Boss Damage Color",
            tooltip = "",
            default = ZO_ColorDef:New(util.Hex2RGB(self.damageList.svDefault.colorDamageBoss)),
            getFunc = function() return util.Hex2RGB(self.damageList.sw.colorDamageBoss) end,
            setFunc = function(r, g, b)
                self.damageList.sw.colorDamageBoss = util.RGB2Hex(r, g, b)
                self.damageList:Update()
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
            default = self.damageList.svDefault.listPlayerHighlight,
            getFunc = function() return self.damageList.sw.listPlayerHighlight end,
            setFunc = function(value)
                self.damageList.sw.listPlayerHighlight = value
                self.damageList:Update()
            end,
            isAdvancedSetting = true,
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
            default = self.damageList.svDefault.listHeaderOpacity,
            getFunc = function() return self.damageList.sw.listHeaderOpacity end,
            setFunc = function(value)
                self.damageList.sw.listHeaderOpacity = value
                self.damageList:Update()
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
            default = self.damageList.svDefault.listRowEvenOpacity,
            getFunc = function() return self.damageList.sw.listRowEvenOpacity end,
            setFunc = function(value)
                self.damageList.sw.listRowEvenOpacity = value
                self.damageList:Update()
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
            default = self.damageList.svDefault.listRowOddOpacity,
            getFunc = function() return self.damageList.sw.listRowOddOpacity end,
            setFunc = function(value)
                self.damageList.sw.listRowOddOpacity = value
                self.damageList:Update()
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
            default = self.damageList.svDefault.timerUpdateInterval,
            getFunc = function() return self.damageList.sw.timerUpdateInterval end,
            setFunc = function(value)
                self.damageList.sw.timerUpdateInterval = value
            end,
            requiresReload = true,
            isAdvancedSetting = true,
        },
    }

    mergeOptions(damageListSpecificOptions, damageList)
    mergeOptions(damageList, options)

    return options
end