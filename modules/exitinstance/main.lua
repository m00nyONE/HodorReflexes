local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local module = {
    name = "exitinstance",
    friendlyName = "Exit Instance",
    description = "Allows your group leader to ask you to exit the current instance",
    version = "1.0.0",
}

local module_name = module.name
local module_version = module.version

local sv = nil
local svName = addon.svName
local svVersion = addon.svVersion
local svDefault = {
    enabled = true,
    confirmExitInstance = true,
}

local _LGBHandler = {}
local _LGBProtocols = {}
local _sendExitInstanceRequest

local EM = EVENT_MANAGER
local LGB = LibGroupBroadcast
local LAM = LibAddonMenu2

local EVENT_EXIT_INSTANCE_REQUEST_NAME = "ExitInstanceRequest"
local EVENT_ID_EXITINSTANCEREQUEST = 3

local localPlayer = "player"

function module.SendExitInstanceRequest()
    if not IsUnitGroupLeader(localPlayer) then return end

    _sendExitInstanceRequest()
end

function module.ExitInstance()
    if CanExitInstanceImmediately() then
        if sv.confirmExitInstance and not ZO_Dialogs_IsShowingDialog() then
            LAM.util.ShowConfirmationDialog(GetString(HR_EXIT_INSTANCE), GetString(HR_EXIT_INSTANCE_CONFIRM), ExitInstanceImmediately)
        else
            ExitInstanceImmediately()
        end
    end
end

local function onExitInstanceRequestEventReceived(unitTag)
    if not IsUnitGroupLeader(unitTag) then return end

    if CanExitInstanceImmediately() then
        if sv.confirmExitInstance and not ZO_Dialogs_IsShowingDialog() then
            LAM.util.ShowConfirmationDialog(GetString(HR_BINDING_SEND_EXIT_INSTANCE), GetString(HR_SEND_EXIT_INSTANCE_CONFIRM), ExitInstanceImmediately)
        else
            ExitInstanceImmediately()
        end
    end
end

local sendExitInstanceRequestButton = {
    name = GetString(HR_SEND_EXIT_INSTANCE),
    keybind = 'HR_SEND_EXIT_INSTANCE',
    callback = function() module.SendExitInstanceRequest() end,
    alignment = KEYBIND_STRIP_ALIGN_CENTER,
}

function module:MainMenuOptions()
    return {
        {
            type = "header",
            name = string.format("|cFFFACD%s|r", "Exit Instance")
        },
        {
            type = "description",
            text = "enables exit instance requests"
        },
        {
            type = "checkbox",
            name = "enabled",
            tooltip = "enable/disable exitinstance requests",
            default = true,
            getFunc = function() return sv.enabled end,
            setFunc = function(value) sv.enabled = value end
        },
        {
            type = "checkbox",
            name = "confirm exit",
            tooltip = "enable/disable the need to confirm if leader requests an exit of the instance",
            default = true,
            getFunc = function() return sv.confirmExitInstance end,
            setFunc = function(value) sv.confirmExitInstance = value end
        }
    }
end

function module:RegisterLGBProtocols(handler)
    _LGBHandler = handler

    _sendExitInstanceRequest = handler:DeclareCustomEvent(EVENT_ID_EXITINSTANCEREQUEST, EVENT_EXIT_INSTANCE_REQUEST_NAME)
    local success = LGB:RegisterForCustomEvent(EVENT_EXIT_INSTANCE_REQUEST_NAME, onExitInstanceRequestEventReceived)
    if not success then
        d("error registering for EXIT_INSTANCE_EVENT")
    end
end

function module:Initialize()
    sv = ZO_SavedVars:NewAccountWide(svName, svVersion, module_name, svDefault)

    -- Bindings
    ZO_CreateStringId('SI_BINDING_NAME_HR_SEND_EXIT_INSTANCE', GetString(HR_BINDING_SEND_EXIT_INSTANCE))
    ZO_CreateStringId('SI_BINDING_NAME_HR_EXIT_INSTANCE', GetString(HR_BINDING_EXIT_INSTANCE))

    -- Add hotkey to group window
    local function OnStateChanged(_, newState)
        if newState == SCENE_FRAGMENT_SHOWING and IsUnitGroupLeader(localPlayer) then
            KEYBIND_STRIP:AddKeybindButton(sendExitInstanceRequestButton)
        elseif newState == SCENE_FRAGMENT_HIDING then
            KEYBIND_STRIP:RemoveKeybindButton(sendExitInstanceRequestButton)
        end
    end
    KEYBOARD_GROUP_MENU_SCENE:RegisterCallback('StateChange', OnStateChanged)
    GAMEPAD_GROUP_SCENE:RegisterCallback('StateChange', OnStateChanged)
end

addon:RegisterModule(module_name, module)