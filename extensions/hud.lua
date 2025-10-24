-- SPDX-FileCopyrightText: 2025 andy.s m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

-- Some shortcuts to create HUD fragments.
HodorReflexes.hud = {}

local HR = HodorReflexes
local hud = HR.hud

-- Disable controls movement.
function hud.LockControls(...)
	for _, control in ipairs({...}) do
		control:SetMouseEnabled(false)
		control:SetMovable(false)
	end
end

-- Allow controls movement.
function hud.UnlockControls(...)
	for _, control in ipairs({...}) do
		control:SetMouseEnabled(true)
		control:SetMovable(true)
	end
end

-- Create a simple HUD_SCENE/HUD_UI_SCENE fragment with a display condition function.
function hud.AddSimpleFragment(control, condition)

	local f = ZO_SimpleSceneFragment:New(control)
	if condition then f:SetConditional(condition) end
	
	-- Add to available HUD scenes
	if HUD_SCENE then HUD_SCENE:AddFragment(f) end
	if HUD_UI_SCENE then HUD_UI_SCENE:AddFragment(f) end
	if GAMEPAD_HUD_SCENE then GAMEPAD_HUD_SCENE:AddFragment(f) end
	if GAMEPAD_HUD_UI_SCENE then GAMEPAD_HUD_UI_SCENE:AddFragment(f) end
	
	return f

end

-- Create a fading HUD_SCENE/HUD_UI_SCENE fragment with a display condition function.
function hud.AddFadeFragment(control, condition)

	local f = ZO_HUDFadeSceneFragment:New(control)
	if condition then f:SetConditional(condition) end
	
	-- Add to available HUD scenes
	if HUD_SCENE then HUD_SCENE:AddFragment(f) end
	if HUD_UI_SCENE then HUD_UI_SCENE:AddFragment(f) end
	if GAMEPAD_HUD_SCENE then GAMEPAD_HUD_SCENE:AddFragment(f) end
	if GAMEPAD_HUD_UI_SCENE then GAMEPAD_HUD_UI_SCENE:AddFragment(f) end
	
	return f

end
