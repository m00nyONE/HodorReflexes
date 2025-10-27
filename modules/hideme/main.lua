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

local HR_EVENT_PLAYER_ACTIVATED = addon.HR_EVENT_PLAYER_ACTIVATED
local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED

local moduleDefinition = {
    name = "hideme",
    friendlyName = "Hide Me",
    description = "allows you to hide some of your stats from other group members lists.", -- of course only if they also have the module enabled.
    version = "0.1.0",
    priority = 15,
    enabled = false,
    svVersion = 1,
    svDefault = {
        preferences = {}, -- will look something like this: [1] = true, [2] = false, ...
    },

    updateDebounceInterval = 1500, -- ms

    hideIds = {
        [1] = {
            name = "hideDamage",
            label = "Hide Damage",
            description = "Hide your damage numbers from other group members dps list.",
        },
        [2] = {
            name = "hideHorn",
            label = "Hide Horn",
            description = "Hide your horn from from horn and compact list.",
        },
        [3] = {
            name = "hideColos",
            label = "Hide Colossus",
            description = "Hide your colossus from colos & compact list.",
        },
        [4] = {
            name = "hideAtro",
            label = "Hide Atro",
            description = "Hide your atronach from atro and compact list.",
        },
        [5] = {
            name = "hideSaxhleel",
            label = "Hide Saxhleel",
            description = "Hide your saxhleel from horn and compact list.",
        },
    }
}

local module = internal.moduleClass:New(moduleDefinition)

function module:Activate()
    -- generate data fields
    local fields = {}
    for _, hide in ipairs(self.hideIds) do
        fields[hide.name] = false
    end
    group.RegisterPlayersDataFields(fields)

    self:RunOnce("RegisterEvents")
end

function module:RegisterEvents()
    addon.RegisterCallback(HR_EVENT_PLAYER_ACTIVATED, function(...) self:SendHideMeMessageDebounced(true) end)
    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, function(...) self:SendHideMeMessageDebounced() end)
end
