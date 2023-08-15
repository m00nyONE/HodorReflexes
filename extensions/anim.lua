HodorReflexes.anim = {
	name = "HodorReflexes_Anim",
	users = {},
}

local HR = HodorReflexes
local M = HR.anim
--local EM = EVENT_MANAGER
local anims = {}

-- Format: {"icon_path", columns, rows, frame_rate}
-- Don't add anything here! Use files in HodorReflexes/users/
local u = HR.anim.users
u["pikadab"] = {"HodorReflexes/users/animated/pikadab.dds", 7, 7, 20}
u["pikahi"] = {"HodorReflexes/users/animated/pikahi.dds", 69, 1, 33}
u["catjam"] = {"HodorReflexes/users/animated/catjam.dds", 79, 2, 25}
u["dancingcat"] = {"HodorReflexes/users/animated/dancingcat.dds", 6, 6, 20}

-- Initialize a user.
function M.RegisterUser(user)
	if u[user] then
		if anims[user] then M.UnregisterUser(user) end
		anims[user] = {
			timeline = ANIMATION_MANAGER:CreateTimeline(),
			width = u[user][2],
			height = u[user][3],
			frameRate = u[user][4],
		}
		return true
	end
	return false
end

-- Delete all user animations.
function M.UnregisterUser(user)
	if u[user] then
		M.StopUserAnimations(user)
		anims[user] = nil
	end
end

-- Clear all users.
function M.UnregisterUsers()
	M.StopAnimations()
	anims = {}
end

-- Returns true if a user is in HR.anim.users table.
function M.IsValidUser(user)
	return u[user] ~= nil
end

-- Register a texture control to update.
function M.RegisterUserControl(user, control)
	local a = anims[user]
	if a then
		local animation = a.timeline:InsertAnimation(ANIMATION_TEXTURE, control)
		animation:SetImageData(a.width, a.height)
		animation:SetFramerate(a.frameRate)
		control:SetTexture(u[user][1])
	end
end

-- Unregister all controls.
function M.UnregisterUserControls(user)
	local a = anims[user]
	if a then
		a.timeline:SetEnabled(false)
		a.timeline = ANIMATION_MANAGER:CreateTimeline()
	end
end

-- Start all animations for a user.
function M.RunUserAnimations(user)
	local a = anims[user]
	if a then
		a.timeline:SetEnabled(true)
		a.timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
		a.timeline:PlayFromStart()
	end
end

-- Stop all animations for a user.
function M.StopUserAnimations(user)
	local a = anims[user]
	if a then
		a.timeline:SetEnabled(false)
	end
end

-- Play all animations.
function M.RunAnimations()
	for name, _ in pairs(anims) do
		M.RunUserAnimations(name)
	end
end

-- Stop all animations.
function M.StopAnimations()
	for name, _ in pairs(anims) do
		M.StopUserAnimations(name)
	end
end

-- get first frame. - returns the texture, left, right, top, bottom for SetTextureCoords(left, right, top, bottom)
function M.GetFirstFrame(user)
	local a = u[user]
	if a then
		return a[1], 0, 1/a[2], 0 , 1/a[3]
	end
end