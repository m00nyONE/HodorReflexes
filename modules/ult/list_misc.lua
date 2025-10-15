-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "ult"
local module = addon_modules[module_name]

local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,
    windowPosLeft = 550,
    windowPosTop = 200,
    windowWidth = 262,
    listHeaderHeight = 22,
    listRowHeight = 22,
}

function module:CreateMiscList()
    local listDefinition = {
        name = "misc",
        svDefault = svDefault,
        Update = function() self:UpdateMiscList() end,
    }
    self.miscList = internal.listClass:New(listDefinition)
end

function module:UpdateMiscList()
    --ZO_ScrollList_Commit(self.miscList.listControl)
end