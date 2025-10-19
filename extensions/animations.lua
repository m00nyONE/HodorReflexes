-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_extensions = addon.extensions
local internal_extensions = internal.extensions

local LCI = LibCustomIcons

local HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED = addon.HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED -- function(data)

local extensionDefinition = {
    name = "animations",
    description = "Provides animated user icon support for lists.",
    version = "0.1.0",
    svVersion = 1,
    svDefault = {},

    animations = {},
}

--- @class animExtension
local extension = internal.extensionClass:New(extensionDefinition)


function extension:Activate()
    if not LCI then
        self.enabled = false
        return
    end


    -- extends listClass to add animation support
    addon.listClass.animations = {}


    -- register for character removed to clean up animations when they are no longer needed
    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED, function(...) self:RemoveAllAnimationsForUser(...) end)
end



function extension:RemoveAllAnimationsForUser(data)
   -- for all lists, remove animation for characterName
   -- for _, list in pairs(self.animations) do
   --     self:RemoveAnimationFromList(list, data.name)
   -- end
end


