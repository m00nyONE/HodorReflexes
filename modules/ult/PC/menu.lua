-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "ult"
local module = addon_modules[module_name]

function module:GetSubMenuOptions()
    local function mergeOptions(source, destination)
        for _, option in ipairs(source) do
            table.insert(destination, option)
        end
    end

    local function getGeneralOptions()
        return {
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
    end

    local function GetComonListOptions(listName, list)
        return {
            {
                type = "header",
                name = string.format("|cFFFACD%s|r", listName)
            },
            {
                type = "checkbox",
                name = "Disable in PvP",
                tooltip = "disable the list when in PvP.",
                default = list.svDefault.disableInPvP,
                getFunc = function() return list.sw.disableInPvP end,
                setFunc = function(value)
                    list.sw.disableInPvP = value
                    list:RefreshVisibility()
                end,
            },
            {
                type = "dropdown",
                name = "visibility",
                tooltip = "set the visibility of the list.",
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
                end,
                width = "full",
            },
            {
                type = "slider",
                name = "List width",
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
            },
            {
                type = "divider",
            },
            {
                type = "slider",
                name = "Header Opacity",
                tooltip = "set the opacity of the list header.",
                min = 0,
                max = 1,
                step = 0.05,
                decimals = 2,
                clampInput = true,
                default = list.svDefault.headerOpacity,
                getFunc = function() return list.sw.headerOpacity end,
                setFunc = function(value)
                    list.sw.headerOpacity = value
                    list.damageList:Update()
                end,
            },
            {
                type = "slider",
                name = "Zero Timer Opacity",
                tooltip = "set the opacity of the timers when at zero.",
                min = 0.05,
                max = 1,
                step = 0.05,
                decimals = 2,
                clampInput = true,
                default = list.svDefault.zeroTimerOpacity,
                getFunc = function() return list.sw.zeroTimerOpacity end,
                setFunc = function(value)
                    list.sw.zeroTimerOpacity = value
                    --list.damageList:Update() -- TODO: test if this works during runtime
                end,
                requiresReload = true,
            },
            {
                type = "divider",
            },
            {
                type = "checkbox",
                name = "Show Percent Value",
                tooltip = "show/hide the percent value in the list.",
                default = list.svDefault.showPercentValue == 1.0,
                getFunc = function() return list.sw.showPercentValue == 1.0 end,
                setFunc = function(value)
                    list.sw.showPercentValue = value and 1.0 or 0.0
                    list:Update()
                end,
            },
            {
                type = "checkbox",
                name = "Show Raw Value",
                tooltip = "show/hide the raw value in the list.",
                default = list.svDefault.showRawValue == 1.0,
                getFunc = function() return list.sw.showRawValue == 1.0 end,
                setFunc = function(value)
                    list.sw.showRawValue = value and 1.0 or 0.0
                    list:Update()
                end,
            }
        }
    end

    local hornList = GetComonListOptions("Horn List", self.hornList)
    local colosList = GetComonListOptions("Colos List", self.colosList)
    local atroList = GetComonListOptions("Atro List", self.atroList)
    local compactList = GetComonListOptions("Compact List", self.compactList)
    local miscList = GetComonListOptions("Misc List", self.miscList)


    local options = getGeneralOptions()
    mergeOptions(hornList, options)
    mergeOptions(colosList, options)
    mergeOptions(atroList, options)
    mergeOptions(compactList, options)
    mergeOptions(miscList, options)

    return options
end