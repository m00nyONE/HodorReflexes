-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/menu")

local util = addon.util
local LAM = LibAddonMenu2

--- @param subName string|nil
--- @return table
function core.GetPanelConfig(subName)
    local name = addon.friendlyName
    local displayName = string.format('|cFFFACD%s|r', addon.friendlyName)
    if subName then
        name = string.format("%s - %s", addon.friendlyName, subName)
        displayName = string.format('|cFFFACD%s - %s|r', addon.friendlyName, subName)
    end

    return {
        type = "panel",
        name = name,
        displayName = displayName,
        author = addon.author,
        version = addon.version,
        website = "https://www.esoui.com/downloads/info2311-HodorReflexes-DPSULTtracker.html#donate",
        donation = addon.Donate,
        registerForRefresh = true,
        registerForDefaults = true,
    }
end

function core.ColorOption(option)
    if option.isAdvancedSetting and option.name then
        option.name = string.format("|cff9900%s|r", option.name)
    end

    return option
end

--- @param name string
--- @return table
function core.CreateSectionHeader(name, isAdvancedSetting)
    return {
        type = "header",
        name = string.format("|cFFFACD%s|r", name),
        isAdvancedSetting = isAdvancedSetting or false,
    }
end

--- @param subName string|nil
--- @param options table
--- @return void
function core.CreateNewMenu(subName, options)
    local panel = core.GetPanelConfig(subName)
    local menuReference = addon_name .. "_menu"
    if subName then
        menuReference = string.format("%s_module_%s_menu", addon_name, subName)
    end

    LAM:RegisterAddonPanel(menuReference, panel)
    LAM:RegisterOptionControls(menuReference, options)
end

--- @return table
function core.GetCoreMenuOptions()
    local options = {
        core.CreateSectionHeader(GetString(HR_MENU_GENERAL)),
        {
            type = "checkbox",
            name = GetString(HR_MENU_ACCOUNTWIDE),
            tooltip = GetString(HR_MENU_ACCOUNTWIDE_TT),
            default = true,
            getFunc = function() return core.sw.accountWide end,
            setFunc = function(value) core.sw.accountWide = value end,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = string.format("|cff9900%s|r", GetString(HR_MENU_ADVANCED_SETTINGS)),
            tooltip = GetString(HR_MENU_ADVANCED_SETTINGS_TT),
            default = false,
            getFunc = function() return core.sw.advancedSettings end,
            setFunc = function(value)
                core.sw.advancedSettings = value
            end,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = GetString(HR_MENU_LOCKUI),
            tooltip = GetString(HR_MENU_LOCKUI_TT),
            default = true,
            getFunc = core.hud.IsUILocked,
            setFunc = function(value)
                if value then
                    core.CM:FireCallbacks(addon.HR_EVENT_LOCKUI)
                else
                    core.CM:FireCallbacks(addon.HR_EVENT_UNLOCKUI)
                end
            end,
        }
    }
    table.insert(options, core.CreateSectionHeader(GetString(HR_MENU_MODULES), true))
    for moduleName, module in util.Spairs(addon.modules, util.SortByPriority) do
        table.insert(options, {
            type = "checkbox",
            name = module.friendlyName or moduleName,
            tooltip = module.description or "",
            default = true,
            getFunc = function() return core.sw.modules[moduleName] end,
            setFunc = function(value)
                core.sw.modules[moduleName] = value
            end,
            requiresReload = true,
            isAdvancedSetting = true,
        })
    end
    table.insert(options, core.CreateSectionHeader(GetString(HR_MENU_EXTENSIONS), true))
    for extensionName, extension in util.Spairs(addon.extensions, util.SortByPriority) do
        table.insert(options, {
            type = "checkbox",
            name = extension.friendlyName or extensionName,
            tooltip = extension.description or "",
            default = true,
            getFunc = function() return core.sw.extensions[extensionName] end,
            setFunc = function(value)
                core.sw.extensions[extensionName] = value
            end,
            requiresReload = true,
            isAdvancedSetting = true,
        })
    end

    return options
end
