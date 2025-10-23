-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local localPlayer = "player"

local moduleDefinition = {
    name = "autoinvite",
    friendlyName = "Auto Invite",
    description = "Allows you to set up auto-invite chat commands ",
    version = "0.1.0",
    priority = 30,
    enabled = false,
    svVersion = 1,
    svDefault = {
        inviteString = "+hr",
        stopWhenGroupFull = true, -- stop inviting when group is full
        restartWhenGroupNotFull = false, -- restart inviting when group is not full
        autoAcceptInvites = false, -- auto accept invites where we sent a "^%+%S*$" invite to
    },

    active = false,

    displayName = GetUnitDisplayName(localPlayer),
    characterName = GetUnitName(localPlayer),
}

local module = internal.moduleClass:New(moduleDefinition)

function module:Activate()
    self.logger:Debug("activated AutoInvite module")

    core.RegisterSubCommand("ai", "setup autoinvite", function(str)
        if not str or str == "" then
            self.logger.Info("toggling auto-invite")
            self.active = not self.active
            return
        elseif str == "help" then
            d("AutoInvite commands:")
            d("/hodor ai - toggles auto-invite on/off")
            d("/hodor ai +[STRING] - sets the invite string to [STRING]")
            d("/hodor ai regroup - kicks everyone and re-invites until the group is full")
            d("/hodor ai start - starts auto-invite")
            d("/hodor ai stop - stops auto-invite")
            d("/hodor ai help - shows this help message")
            return
        elseif str == "start" then
            self.logger.Info("starting auto-invite")
            self.active = true
            return
        elseif str == "stop" then
            self.logger.Info("stopping auto-invite")
            self.active = false
            return
        elseif str == "regroup" then
            self.logger:Info("regrouping")
            return
        end

        -- The auto invite string MUST start with a +. If not, ignore.
        if string.match(str, "^%+%S*$") then
            self.sv.inviteString = string.sub(str, 2)
            self.logger:Info("setting invite string to '%s'", self.sv.inviteString)
        else
            self.logger:Warn("invite string must start with a +")
        end

    end)
end

function module:startListening()
    -- Listen for chat messages
end
function module:stopListening()
    -- Stop listening for chat messages
end