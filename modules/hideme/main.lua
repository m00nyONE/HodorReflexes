-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local group = internal.group

local localPlayer = "player"

local moduleDefinition = {
    name = "hideme",
    friendlyName = "Hide Me",
    description = "allows you to hide some of your stats from other group members lists.", -- of course only if they also have the module enabled.
    version = "0.1.0",
    priority = 15,
    enabled = false,
    svVersion = 1,
    svDefault = {
        hideDamage = false,
        hideHorn = false,
        hideColos = false,
        hideAtro = false,
        hideSaxhleel = false,
    },
}

local module = internal.moduleClass:New(moduleDefinition)

function module:Activate()
    self.logger:Debug("activated Hide Me module")

    group.RegisterPlayersDataFields({
        hideDamage = false,
        hideHorn = false,
        hideColos = false,
        hideAtro = false,
        hideSaxhleel = false,
    })
end

