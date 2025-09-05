local addon_name = "HodorReflexes"
local addon = _G[addon_name]

-- Some shortcuts to create HUD fragments.
local extension = {
    name = "hud",
    version = "1.0.0",
}
local extension_name = extension.name
local extension_version = extension.version

addon[extension_name] = extension

-- Disable controls movement.
function extension.LockControls(...)
	for _, control in ipairs({...}) do
		control:SetMouseEnabled(false)
		control:SetMovable(false)
	end
end

-- Allow controls movement.
function extension.UnlockControls(...)
	for _, control in ipairs({...}) do
		control:SetMouseEnabled(true)
		control:SetMovable(true)
	end
end

-- Create a simple HUD_SCENE/HUD_UI_SCENE fragment with a display condition function.
function extension.AddSimpleFragment(control, condition)

	local f = ZO_SimpleSceneFragment:New(control)
	if condition then f:SetConditional(condition) end
	HUD_SCENE:AddFragment(f)
	HUD_UI_SCENE:AddFragment(f)
	return f

end

-- Create a fading HUD_SCENE/HUD_UI_SCENE fragment with a display condition function.
function extension.AddFadeFragment(control, condition)

	local f = ZO_HUDFadeSceneFragment:New(control)
	if condition then f:SetConditional(condition) end
	HUD_SCENE:AddFragment(f)
	HUD_UI_SCENE:AddFragment(f)
	return f

end
