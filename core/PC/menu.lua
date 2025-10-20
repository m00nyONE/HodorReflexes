-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.initSubLogger("menu")

local util = addon.util

local LAM = LibAddonMenu2

function core.GetCoreOptions()
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
            getFunc = function() return core.sw.accountwide end,
            setFunc = function(value)
                core.sw.accountwide = value
            end,
            requiresReload = true,
        },
    }
end

function core.GetExtensionOptions()
    local options = {
        {
            type = "header",
            name = string.format("|cFFFACD%s|r", "Extensions")
        }
    }
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
        })
    end

    return options
end

function core.GetModuleOptions()
    local options = {
        {
            type = "header",
            name = string.format("|cFFFACD%s|r", "Modules")
        }
    }
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
        })
    end

    return options
end

--- build the menu for PC platform
--- @return void
function core.BuildMenu()
    logger:Info("Building menu for PC")
    local panel = {
        type = "panel",
        name = addon.friendlyName,
        displayName = string.format('|cFFFACD%s|r', addon.friendlyName),
        author = addon.author,
        version = addon.version,
        website = "https://www.esoui.com/downloads/info2311-HodorReflexes-DPSULTtracker.html#donate",
        donation = addon.Donate,
        registerForRefresh = true,
    }
    local options = {}
    for _, opt in ipairs(core.GetCoreOptions()) do
        table.insert(options, opt)
    end
    for _, opt in ipairs(core.GetExtensionOptions()) do
        table.insert(options, opt)
    end
    for _, opt in ipairs(core.GetModuleOptions()) do
        table.insert(options, opt)
    end

    LAM:RegisterAddonPanel(addon_name .. "_Menu", panel)
    LAM:RegisterOptionControls(addon_name .. "_Menu", options)
end