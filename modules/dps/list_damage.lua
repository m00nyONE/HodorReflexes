-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "dps"
local module = addon_modules[module_name]

local svDefault = {
    damageListEnabled = 1, -- 0=off, 1=always, 2=out of combat, 3=non bossfights
    damageListWidth = 227,
    damageListPosLeft = 10,
    damageListPosTop = 50,
}

function module:CreateDamageList()
    local damageListDefinition = {
        name = "damage",
        svDefault = svDefault,
        Update = function() self:UpdateDamageList() end,
    }
    self.damageList = internal.listClass:New(damageListDefinition)
end

function module:UpdateDamageList()
    d(self.name)
end