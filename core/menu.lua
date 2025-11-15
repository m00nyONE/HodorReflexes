-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/menu")
core.mainMenuOptions = {}
core.subMenuOptions = {}

-- function is platform specific
function core.CreateSectionHeader(name, isAdvancedSetting)
end
-- function is platform specific
function core.GetCoreMenuOptions()
end
-- function is platform specific
function core.GetPanelConfig(subName)
end
-- function is platform specific
function core.CreateNewMenu(subName, options)
end
-- function is platform specific
function core.ColorOption(option)
    return option
end

function core.MergeOptions(source, destination)
    for _, option in ipairs(source) do
        table.insert(destination, option)
    end
end

function core.FilterOptions(options)
    local filteredOptions = {}
    for _, option in ipairs(options) do
        option = core.ColorOption(option)

        if not option.isAdvancedSetting or core.sw.advancedSettings then
            table.insert(filteredOptions, option)
        end
    end
    return filteredOptions
end

--- builds the main menu and submenus
--- @return void
function core.BuildMenu()
    local options = core.GetCoreMenuOptions()
    for _, data in ipairs(core.mainMenuOptions) do
        table.insert(options, core.CreateSectionHeader(data.header))
        for _, option in ipairs(data.options) do
            table.insert(options, option)
        end
    end
    core.CreateNewMenu(nil, core.FilterOptions(options))

    for _, data in ipairs(core.subMenuOptions) do
        core.CreateNewMenu(data.header, core.FilterOptions(data.options))
    end
end

--- registers main menu options
--- @param header string
--- @param options table[]
--- @return void
function core.RegisterMainMenuOptions(header, options)
    table.insert(core.mainMenuOptions, { header = header, options = options })
end

--- registers submenu options
--- @param header string
--- @param options table[]
--- @return void
function core.RegisterSubMenuOptions(header, options)
    table.insert(core.subMenuOptions, { header = header, options = options })
end
