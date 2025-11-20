-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "exitinstance"
local module = addon_modules[module_name]

local LGB = LibGroupBroadcast
local localPlayer = "player"

local _sendExitInstanceRequest = {}
local EVENT_EXIT_INSTANCE_REQUEST_NAME = "ExitInstanceRequest"
local EVENT_ID_EXITINSTANCEREQUEST = 3

--- Register LGB protocols for Exit Instance module
--- @param handler table
--- @return void
function module:RegisterLGBProtocols(handler)
    _sendExitInstanceRequest = handler:DeclareCustomEvent(EVENT_ID_EXITINSTANCEREQUEST, EVENT_EXIT_INSTANCE_REQUEST_NAME)
    local success = LGB:RegisterForCustomEvent(EVENT_EXIT_INSTANCE_REQUEST_NAME, function(...) self:onExitInstanceRequestEventReceived(...) end)
    if not success then
        self.logger.Error("error registering for EXIT_INSTANCE_EVENT")
    end
end

--- Send exit instance request to group members
--- @return void
function module:_sendExitInstanceRequestEvent()
    if not IsUnitGroupLeader(localPlayer) then
        df('|cFF0000%s|r', GetString(HR_MODULES_EXITINSTANCE_NOT_LEADER))
        return
    end
    _sendExitInstanceRequest()
end

--- Send exit instance request to group members, showing a confirmation dialog if needed
--- @return void
function module:SendExitInstanceRequest()
    if not IsUnitGroupLeader(localPlayer) then
        df('|cFF0000%s|r', GetString(HR_MODULES_EXITINSTANCE_NOT_LEADER))
        return
    end

    if not ZO_Dialogs_IsShowingDialog() then
        ZO_Dialogs_ShowPlatformDialog(self.dialogSendExitInstance)
        return
    end
end

--- Handle received exit instance request event
--- @param unitTag string
--- @param _ table
--- @return void
function module:onExitInstanceRequestEventReceived(unitTag, _)
    if not IsUnitGroupLeader(unitTag) then return end
    if self.sv.ignoreExitInstanceRequests then return end

    self:ExitInstance()
end