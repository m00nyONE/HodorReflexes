-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.initSubLogger("menu")

local util = addon.util
local LAM = LibAddonMenu2

local function GetPanelConfig(subName)
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
    }
end

local function createMenu(subName, options)
    local panel = GetPanelConfig(subName)
    local menuReference = addon_name .. "_menu"
    if subName then
        menuReference = string.format("%s_module_%s_menu", addon_name, subName)
    end

    LAM:RegisterAddonPanel(menuReference, panel)
    LAM:RegisterOptionControls(menuReference, options)
end

local function getCoreMenuOptions()
    local options = {
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
    table.insert(options, {
        type = "header",
        name = string.format("|cFFFACD%s|r", "Extensions")
    })
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
    table.insert(options, {
        type = "header",
        name = string.format("|cFFFACD%s|r", "Modules")
    })
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
    logger:Debug("Building menu for PC")
    local options = getCoreMenuOptions()
    for header, mainMenuOptions in pairs(core.mainMenuOptions) do
        table.insert(options, {
            type = "header",
            name = string.format("|cFFFACD%s|r", header)
        })
        for _, option in ipairs(mainMenuOptions) do
            table.insert(options, option)
        end
    end
    createMenu(nil, options)

    for header, subMenuOptions in pairs(core.subMenuOptions) do
        createMenu(header, subMenuOptions)
    end
end