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
