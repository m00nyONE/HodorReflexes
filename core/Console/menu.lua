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

--- @param name string
--- @return table
function core.CreateSectionHeader(name)
    return {
        type = LHAS.ST_SECTION,
        label = string.format("|cFFFACD%s|r", name),
    }
end

--- @param subName string|nil
--- @param options table[]
function core.CreateNewMenu(subName, options)
    local panel = core.GetPanelConfig(subName)
    panel:AddSetting({
        type = LHAS.ST_LABEL,
        label = GetString(HR_MENU_RELOAD_HIGHLIGHT),
    })
    panel:AddSetting({
        type = LHAS.ST_BUTTON,
        label = GetString(HR_MENU_TESTMODE),
        buttonText = GetString(HR_MENU_TESTMODE),
        tooltip = GetString(HR_MENU_TESTMODE_TT),
        clickHandler = function(control)
            SLASH_COMMANDS[string.format("/%s", addon.slashCmd)]("test")
        end
    })
    panel:AddSetting({
        type = LHAS.ST_BUTTON,
        label = GetString(HR_MENU_RELOAD),
        buttonText = GetString(HR_MENU_RELOAD),
        tooltip = GetString(HR_MENU_RELOAD_TT),
        clickHandler = function(control)
            ReloadUI()
        end
    })
    for _, option in ipairs(options) do
        panel:AddSetting(option)
    end
end

--- @return table
function core.GetCoreMenuOptions()
    local function mergeOptions(source, destination)
        for _, option in ipairs(source) do
            if option.requiresReload then
                option.label = string.format("|cffff00%s|r", option.label)
            end
            table.insert(destination, option)
        end
    end

    local options = {}
    local generalOptions = {
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
    }
    mergeOptions(generalOptions, options)

    local moduleOptions = {
        core.CreateSectionHeader(GetString(HR_MENU_MODULES)),
    }
    for moduleName, module in util.Spairs(addon.modules, util.SortByPriority) do
        table.insert(moduleOptions, {
            type = LHAS.ST_CHECKBOX,
            label = module.friendlyName or moduleName,
            tooltip = module.description or "",
            default = true,
            getFunction = function() return core.sw.modules[moduleName] end,
            setFunction = function(value)
                core.sw.modules[moduleName] = value
            end,
            requiresReload = true,
        })
    end
    mergeOptions(moduleOptions, options)

    local extensionOptions = {
        core.CreateSectionHeader(GetString(HR_MENU_EXTENSIONS)),
    }
    for extensionName, extension in util.Spairs(addon.extensions, util.SortByPriority) do
        table.insert(extensionOptions, {
            type = LHAS.ST_CHECKBOX,
            label = extension.friendlyName or extensionName,
            tooltip = extension.description or "",
            default = true,
            getFunction = function() return core.sw.extensions[extensionName] end,
            setFunction = function(value)
                core.sw.extensions[extensionName] = value
            end,
            requiresReload = true,
        })
    end
    mergeOptions(extensionOptions, options)

    return options
end