HodorReflexes.modules.exitinstance = {
    name = "HodorReflexes_ExitInstance",
    version = "1.0.0",

    default = {
        enabled = true,
    },

    sv = nil, -- saved variables
}

local HR = HodorReflexes
local M = HR.modules.exitinstance
local LGB = LibGroupBroadcast
local LAM = LibAddonMenu2
local EVENT_ID_EXITINSTANCEREQUEST = 3
local EVENT_EXIT_INSTANCE_REQUEST_NAME = "ExitInstanceRequest"
local _sendExitInstanceRequest
local localPlayer = "player"
local localEM = ZO_CallbackObject:New()


function M.SendExitInstanceRequest()
    if not IsUnitGroupLeader(localPlayer) then return end

    _sendExitInstanceRequest()
end

function M.ExitInstance()
    if CanExitInstanceImmediately() then
        if HR.sv.confirmExitInstance and not ZO_Dialogs_IsShowingDialog() then
            LAM.util.ShowConfirmationDialog(GetString(HR_EXIT_INSTANCE), GetString(HR_EXIT_INSTANCE_CONFIRM), ExitInstanceImmediately)
        else
            ExitInstanceImmediately()
        end
    end
end

local function onExitInstanceRequestEventReceived(unitTag)
    if not IsUnitGroupLeader(unitTag) then return end

    if CanExitInstanceImmediately() then
        if HR.sv.confirmExitInstance and not ZO_Dialogs_IsShowingDialog() then
            LAM.util.ShowConfirmationDialog(GetString(HR_BINDING_SEND_EXIT_INSTANCE), GetString(HR_SEND_EXIT_INSTANCE_CONFIRM), ExitInstanceImmediately)
        else
            ExitInstanceImmediately()
        end
    end
end


local sendExitInstanceRequestButton = {
    name = GetString(HR_SEND_EXIT_INSTANCE),
    keybind = 'HR_SEND_EXIT_INSTANCE',
    callback = function() M.SendExitInstanceRequest() end,
    alignment = KEYBIND_STRIP_ALIGN_CENTER,
}

function M.DeclareLGBProtocols(handler)
    _sendExitInstanceRequest = handler:DeclareCustomEvent(EVENT_ID_EXITINSTANCEREQUEST, EVENT_EXIT_INSTANCE_REQUEST_NAME)
    local success = LGB:RegisterForCustomEvent(EVENT_EXIT_INSTANCE_REQUEST_NAME, onExitInstanceRequestEventReceived)
    if not success then
        d("error registering for EXIT_INSTANCE_EVENT")
    end
end

function M.Initialize()
    -- Retrieve savedVariables
    M.sv = ZO_SavedVars:NewAccountWide(HR.svName, HR.svVersion, 'exitinstance', M.default)

    -- Bindings
    ZO_CreateStringId('SI_BINDING_NAME_HR_SEND_EXIT_INSTANCE', GetString(HR_BINDING_SEND_EXIT_INSTANCE))
    ZO_CreateStringId('SI_BINDING_NAME_HR_EXIT_INSTANCE', GetString(HR_BINDING_EXIT_INSTANCE))

    -- Add hotkey to group window
    local function OnStateChanged(_, newState)
        if newState == SCENE_FRAGMENT_SHOWING and IsUnitGroupLeader('player') then
            KEYBIND_STRIP:AddKeybindButton(sendExitInstanceRequestButton)
        elseif newState == SCENE_FRAGMENT_HIDING then
            KEYBIND_STRIP:RemoveKeybindButton(sendExitInstanceRequestButton)
        end
    end
    KEYBOARD_GROUP_MENU_SCENE:RegisterCallback('StateChange', OnStateChanged)
    GAMEPAD_GROUP_SCENE:RegisterCallback('StateChange', OnStateChanged)
end
