-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local group = core.group

local localPlayer = "player"

local HR_EVENT_PLAYER_ACTIVATED = addon.HR_EVENT_PLAYER_ACTIVATED
local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED

local moduleDefinition = {
    name = "hideme",
    friendlyName = GetString(HR_MODULES_HIDEME_FRIENDLYNAME),
    description = GetString(HR_MODULES_HIDEME_DESCRIPTION), -- of course only if they also have the module enabled.
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
            label = GetString(HR_MODULES_HIDEME_HIDEDAMAGE_LABEL),
            description = GetString(HR_MODULES_HIDEME_HIDEDAMAGE_DESCRIPTION),
        },
        [2] = {
            name = "hideHorn",
            label = GetString(HR_MODULES_HIDEME_HIDEHORN_LABEL),
            description = GetString(HR_MODULES_HIDEME_HIDEHORN_DESCRIPTION),
        },
        [3] = {
            name = "hideColos",
            label = GetString(HR_MODULES_HIDEME_HIDECOLOS_LABEL),
            description = GetString(HR_MODULES_HIDEME_HIDECOLOS_DESCRIPTION),
        },
        [4] = {
            name = "hideAtro",
            label = GetString(HR_MODULES_HIDEME_HIDEATRO_LABEL),
            description = GetString(HR_MODULES_HIDEME_HIDEATRO_DESCRIPTION),
        },
        [5] = {
            name = "hideSaxhleel",
            label = GetString(HR_MODULES_HIDEME_HIDESAXHLEEL_LABEL),
            description = GetString(HR_MODULES_HIDEME_HIDESAXHLEEL_DESCRIPTION),
        },
        [6] = {
            name = "hideBarrier",
            label = GetString(HR_MODULES_HIDEME_HIDEBARRIER_LABEL),
            description = GetString(HR_MODULES_HIDEME_HIDEBARRIER_DESCRIPTION),
        },
    }
}

local module = internal.moduleClass:New(moduleDefinition)

--- Activate the Hide Me module
--- @return void
function module:Activate()
    -- generate data fields
    local fields = {}
    for _, hide in ipairs(self.hideIds) do
        fields[hide.name] = false
    end
    group.RegisterPlayersDataFields(fields)

    self:RunOnce("RegisterEvents")
end

--- Registers event listeners
--- @return void
function module:RegisterEvents()
    addon.RegisterCallback(HR_EVENT_PLAYER_ACTIVATED, function(...) self:SendHideMeMessageDebounced(true) end)
    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, function(...) self:SendHideMeMessageDebounced() end)
end
