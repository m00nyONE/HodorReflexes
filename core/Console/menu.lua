-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/menu")

local util = addon.util
local LHAS = LibHarvensAddonSettings

--- @param subName string|nil
--- @return table
function core.GetPanelConfig(subName)
    local name = addon.friendlyName
    if subName then
        name = string.format("%s - %s", addon.friendlyName, subName)
    end

    return LHAS:AddAddon(name, {
        allowDefaults = true,
        allowRefresh = true,
        defaultsFunction = function()
            d(GetString(HR_MENU_RESET_MESSAGE))
        end
    })
end

function core.ColorOption(option)
    if option.isAdvancedSetting and option.label then
        option.label = string.format("|cff9900%s|r", option.label)
    end
    if option.requiresReload and option.label then
        option.label = string.format("|cffff00%s|r", option.label)
    end

    return option
end

--- @param name string
--- @return table
function core.CreateSectionHeader(name, isAdvancedSetting)
    return {
        type = LHAS.ST_SECTION,
        label = string.format("|cFFFACD%s|r", name),
        isAdvancedSetting = isAdvancedSetting or false,
    }
end

--- @param subName string|nil
--- @param options table[]
function core.CreateNewMenu(subName, options)
    local panel = core.GetPanelConfig(subName)

    panel:AddSetting(core.ColorOption({
        type = LHAS.ST_LABEL,
        label = GetString(HR_MENU_RELOAD_HIGHLIGHT),
    }))
    panel:AddSetting(core.ColorOption({
        type = LHAS.ST_BUTTON,
        label = GetString(HR_MENU_TESTMODE),
        buttonText = GetString(HR_MENU_TESTMODE),
        tooltip = GetString(HR_MENU_TESTMODE_TT),
        clickHandler = function(control)
            SLASH_COMMANDS[string.format("/%s", addon.slashCmd)]("test")
        end
    }))
    panel:AddSetting(core.ColorOption({
        type = LHAS.ST_BUTTON,
        label = GetString(HR_MENU_RELOAD),
        buttonText = GetString(HR_MENU_RELOAD),
        tooltip = GetString(HR_MENU_RELOAD_TT),
        clickHandler = function(control)
            ReloadUI()
        end
    }))

    for _, option in ipairs(options) do
        panel:AddSetting(option)
    end
end

--- @return table
function core.GetCoreMenuOptions()
    local options = {
        core.CreateSectionHeader(GetString(HR_MENU_GENERAL)),
        {
            type = LHAS.ST_CHECKBOX,
            label = GetString(HR_MENU_ACCOUNTWIDE),
            tooltip = GetString(HR_MENU_ACCOUNTWIDE_TT),
            default = true,
            getFunction = function() return core.sw.accountWide end,
            setFunction = function(value) core.sw.accountWide = value end,
            default = true,
            requiresReload = true,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = GetString(HR_MENU_ADVANCED_SETTINGS),
            tooltip = GetString(HR_MENU_ADVANCED_SETTINGS_TT),
            default = false,
            getFunction = function() return core.sw.advancedSettings end,
            setFunction = function(value)
                core.sw.advancedSettings = value
            end,
            requiresReload = true,
        },
    }

    table.insert(options, core.CreateSectionHeader(GetString(HR_MENU_MODULES), true))
    for moduleName, module in util.Spairs(addon.modules, util.SortByPriority) do
        table.insert(options, {
            type = LHAS.ST_CHECKBOX,
            label = module.friendlyName or moduleName,
            tooltip = module.description or "",
            default = true,
            getFunction = function() return core.sw.modules[moduleName] end,
            setFunction = function(value)
                core.sw.modules[moduleName] = value
            end,
            requiresReload = true,
            isAdvancedSetting = true,
        })
    end

    table.insert(options, core.CreateSectionHeader(GetString(HR_MENU_EXTENSIONS), true))
    for extensionName, extension in util.Spairs(addon.extensions, util.SortByPriority) do
        table.insert(options, {
            type = LHAS.ST_CHECKBOX,
            label = extension.friendlyName or extensionName,
            tooltip = extension.description or "",
            default = true,
            getFunction = function() return core.sw.extensions[extensionName] end,
            setFunction = function(value)
                core.sw.extensions[extensionName] = value
            end,
            requiresReload = true,
            isAdvancedSetting = true,
        })
    end

    return options
end