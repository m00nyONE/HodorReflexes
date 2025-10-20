-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
core.mainMenuOptions = {}
core.subMenuOptions = {}

-- function needs to be implemented platform specific
function core.BuildMenu() end


function core.RegisterMainMenuOptions(header, mainMenuOptions)
    core.mainMenuOptions[header] = mainMenuOptions
end

function core.RegisterSubMenuOptions(header, subMenuOptions)
    core.subMenuOptions[header] = subMenuOptions
end
