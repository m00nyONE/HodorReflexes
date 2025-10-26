-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
core.mainMenuOptions = {}
core.subMenuOptions = {}

-- function is platform specific
function core.CreateSectionHeader(name)
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

-- function needs to be implemented platform specific
function core.BuildMenu()
    local options = core.GetCoreMenuOptions()
    for _, data in ipairs(core.mainMenuOptions) do
        table.insert(options, core.CreateSectionHeader(data.header))
        for _, option in ipairs(data.options) do
            table.insert(options, option)
        end
    end
    core.CreateNewMenu(nil, options)

    for _, data in ipairs(core.subMenuOptions) do
        core.CreateNewMenu(data.header, data.options)
    end
end


function core.RegisterMainMenuOptions(header, options)
    table.insert(core.mainMenuOptions, { header = header, options = options })
end

function core.RegisterSubMenuOptions(header, options)
    table.insert(core.subMenuOptions, { header = header, options = options })
end
