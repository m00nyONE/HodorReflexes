-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.initSubLogger("menu")

local util = addon.util
local LHAS = LibHarvensAddonSettings

-- function is platform specific
function core.GetPanelConfig(subName)
    local name = addon.friendlyName
    if subName then
        name = string.format("%s - %s", addon.friendlyName, subName)
    end

    return LHAS:AddAddon(name, {
        allowDefaults = true,
        allowRefresh = true,
        defaultsFunction = function()
            d("Reset complete! Some changes might require a /reloadui to take effect.")
        end
    })
end

-- function is platform specific
function core.CreateSectionHeader(name)
    return {
        type = LHAS.ST_SECTION,
        label = string.format("|cFFFACD%s|r", name),
    }
end

-- function is platform specific
function core.CreateNewMenu(subName, options)
    local panel = core.GetPanelConfig(subName)
    panel:AddSetting({
        type = LHAS.ST_LABEL,
        label = "Settings highlighted in |cffff00yellow|r require a reload.",
    })
    panel:AddSetting({
        type = LHAS.ST_BUTTON,
        label = "Reload UI",
        buttonText = "Reload UI",
        tooltip = "Reloads the UI",
        clickHandler = function(control)
            ReloadUI()
        end
    })
    for _, option in ipairs(options) do
        panel:AddSetting(option)
    end
end

-- function is platform specific
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
        core.CreateSectionHeader("General"),
        {
            type = LHAS.ST_CHECKBOX,
            label = "account wide settings",
            tooltip = "enable/disable account-wide settings.",
            default = true,
            getFunction = function() return core.sw.accountWide end,
            setFunction = function(value) core.sw.accountWide = value end,
            default = true,
            requiresReload = true,
        },
        -- we do not need ui lock/unlock on console. They have no mouse anyway :D
    }
    mergeOptions(generalOptions, options)

    local moduleOptions = {
        core.CreateSectionHeader("Modules"),
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
        core.CreateSectionHeader("Extensions"),
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