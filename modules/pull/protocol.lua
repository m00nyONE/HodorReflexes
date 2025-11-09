-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "pull"
local module = addon_modules[module_name]

local LGB = LibGroupBroadcast
local localPlayer = "player"

local protocolPullCountdown = {}
local MESSAGE_ID_PULLCOUNTDOWN = 31

--- Register LGB protocols for Pull module
--- @param handler LibGroupBroadcastHandler
--- @return void
function module:RegisterLGBProtocols(handler)
    local CreateNumericField = LGB.CreateNumericField
    local protocolOptions = {
        isRelevantInCombat = false
    }

    protocolPullCountdown = handler:DeclareProtocol(MESSAGE_ID_PULLCOUNTDOWN, "PullCountdown")
    protocolPullCountdown:AddField(CreateNumericField("duration", {
        minValue = self.minCountdownDuration,
        maxValue = self.maxCountdownDuration,
    }))
    protocolPullCountdown:OnData(function(...) self:onPullCountdownMessageReceived(...) end)
    protocolPullCountdown:Finalize(protocolOptions)
end

--- Handle received pull countdown message
--- @param unitTag string
--- @param data table
--- @return void
function module:onPullCountdownMessageReceived(unitTag, data)
    if not IsUnitGroupLeader(unitTag) then return end
    if self.isCountdownActive then return end

    local duration = data.duration * 1000

    self.isCountdownActive = true
    zo_callLater(function() self.isCountdownActive = false end, duration)

    self:RenderPullCountdown(duration)
end

--- Send pull countdown message to group members
--- @param duration number|nil Duration in seconds
--- @return void
function module:SendPullCountdown(duration)
    duration = tonumber(duration) or self.sv.countdownDuration
    self.logger:Debug("SendPullCountdown called with duration: %s", tostring(duration))

    if not IsUnitGroupLeader(localPlayer) then
        df('|cFF0000%s|r', GetString(HR_MODULES_PULL_NOT_LEADER))
        return
    end

    if not duration then duration = self.sv.countdownDuration end
    if duration < self.minCountdownDuration then duration = self.minCountdownDuration end
    if duration > self.maxCountdownDuration then duration = self.maxCountdownDuration end

    protocolPullCountdown:Send({
        duration = duration
    })
end
