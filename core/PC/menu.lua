-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.initSubLogger("menu")

local util = addon.util
local LAM = LibAddonMenu2

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

function core.CreateSectionHeader(name)
    return {
        type = "header",
        name = string.format("|cFFFACD%s|r", name)
    }
end

function core.CreateMenu(subName, options)
    local panel = core.GetPanelConfig(subName)
    local menuReference = addon_name .. "_menu"
    if subName then
        menuReference = string.format("%s_module_%s_menu", addon_name, subName)
    end

    LAM:RegisterAddonPanel(menuReference, panel)
    LAM:RegisterOptionControls(menuReference, options)
end

function core.GetCoreMenuOptions()
    local options = core.CreateSectionHeader("General")
    local general = {
        {
            type = "checkbox",
            name = "account wide settings",
            tooltip = "enable/disable account-wide settings.",
            default = true,
            getFunc = function() return core.sw.accountWide end,
            setFunc = function(value)
                core.sw.accountWide = value
            end,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "Lock UI",
            tooltip = "lock/unlock the addon UI for repositioning.",
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
    for _, option in ipairs(general) do
        table.insert(options, option)
    end

    table.insert(options, core.CreateSectionHeader("Modules"))
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
            width = "half",
            requiresReload = true,
        })
    end
    table.insert(options, core.CreateSectionHeader("Extensions"))
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
            width = "half",
            requiresReload = true,
        })
    end

    return options
end
