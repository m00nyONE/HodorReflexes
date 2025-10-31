-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/hud")

local hud = {}
core.hud = hud
local CM = core.CM

local uiLocked = true

local HR_EVENT_LOCKUI = "HR_EVENT_LOCKUI"
local HR_EVENT_UNLOCKUI = "HR_EVENT_UNLOCKUI"
addon.HR_EVENT_LOCKUI = HR_EVENT_LOCKUI
addon.HR_EVENT_UNLOCKUI = HR_EVENT_UNLOCKUI

function hud.IsUILocked()
    return uiLocked
end

--- Disable controls movement.
--- @param ... table List of controls to lock
--- @return void
function hud.LockControls(...)
    for _, control in ipairs({...}) do
        logger:Debug("Locking control: %s", control:GetName())
        control:SetMouseEnabled(false)
        control:SetMovable(false)
    end
end

--- Allow controls movement.
--- @param ... table List of controls to unlock
--- @return void
function hud.UnlockControls(...)
    for _, control in ipairs({...}) do
        logger:Debug("Unlocking control: %s", control:GetName())
        control:SetMouseEnabled(true)
        control:SetMovable(true)
    end
end

--- Creates a simple HUD_SCENE/HUD_UI_SCENE fragment with a display condition function.
--- @param control table The control to attach the fragment to
--- @param condition function A function that returns true/false to show/hide the fragment
--- @return table The created fragment
function hud.AddSimpleFragment(control, condition)
    local f = ZO_SimpleSceneFragment:New(control)
    if condition then f:SetConditional(condition) end
    HUD_SCENE:AddFragment(f)
    HUD_UI_SCENE:AddFragment(f)
    return f
end

--- Creates a fading HUD_SCENE/HUD_UI_SCENE fragment with a display condition function.
--- @param control table The control to attach the fragment to
--- @param condition function A function that returns true/false to show/hide the fragment
--- @return table The created fragment
function hud.AddFadeFragment(control, condition)
    local f = ZO_HUDFadeSceneFragment:New(control)
    if condition then f:SetConditional(condition) end
    HUD_SCENE:AddFragment(f)
    HUD_UI_SCENE:AddFragment(f)
    return f
end

--- registers subcommands to lock/unlock the UI
core.RegisterSubCommand("lock", GetString(HR_CORE_HUD_COMMAND_LOCK_HELP), function()
    CM:FireCallbacks(HR_EVENT_LOCKUI)
    logger:Debug("|cFFFF00%s|r %s", addon_name, GetString(HR_CORE_HUD_COMMAND_LOCK_ACTION))
end)
core.RegisterSubCommand("unlock", GetString(HR_CORE_HUD_COMMAND_UNLOCK_HELP), function()
    CM:FireCallbacks(HR_EVENT_UNLOCKUI)
    logger:Debug("|cFFFF00%s|r %s", addon_name, GetString(HR_CORE_HUD_COMMAND_UNLOCK_ACTION))
end)

addon.RegisterCallback(HR_EVENT_LOCKUI, function()
    uiLocked = true
end)
addon.RegisterCallback(HR_EVENT_UNLOCKUI, function()
    uiLocked = false
end)