-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.logger.main

local hud = {}
core.hud = hud
local CM = core.CM

local HR_EVENT_LOCKUI = "LockUI"
local HR_EVENT_UNLOCKUI = "UnlockUI"
addon.HR_EVENT_LOCKUI = HR_EVENT_LOCKUI
addon.HR_EVENT_UNLOCKUI = HR_EVENT_UNLOCKUI

-- Disable controls movement.
function hud.LockControls(...)
    for _, control in ipairs({...}) do
        logger:Debug("Locking control: %s", control:GetName())
        control:SetMouseEnabled(false)
        control:SetMovable(false)
    end
end

-- Allow controls movement.
function hud.UnlockControls(...)
    for _, control in ipairs({...}) do
        logger:Debug("Unlocking control: %s", control:GetName())
        control:SetMouseEnabled(true)
        control:SetMovable(true)
    end
end

-- Create a simple HUD_SCENE/HUD_UI_SCENE fragment with a display condition function.
function hud.AddSimpleFragment(control, condition)
    local f = ZO_SimpleSceneFragment:New(control)
    if condition then f:SetConditional(condition) end
    HUD_SCENE:AddFragment(f)
    HUD_UI_SCENE:AddFragment(f)
    return f
end

-- Create a fading HUD_SCENE/HUD_UI_SCENE fragment with a display condition function.
function hud.AddFadeFragment(control, condition)
    local f = ZO_HUDFadeSceneFragment:New(control)
    if condition then f:SetConditional(condition) end
    HUD_SCENE:AddFragment(f)
    HUD_UI_SCENE:AddFragment(f)
    return f
end

core.RegisterSubCommand("lock", GetString(HR_CORE_HUD_COMMAND_LOCK_HELP), function()
    CM:FireCallbacks(HR_EVENT_LOCKUI)
    logger:Info("|cFFFF00%s|r %s", addon_name, GetString(HR_CORE_HUD_COMMAND_LOCK_ACTION))
end)
core.RegisterSubCommand("unlock", GetString(HR_CORE_HUD_COMMAND_UNLOCK_HELP), function()
    CM:FireCallbacks(HR_EVENT_UNLOCKUI)
    logger:Info("|cFFFF00%s|r %s", addon_name, GetString(HR_CORE_HUD_COMMAND_UNLOCK_ACTION))
end)