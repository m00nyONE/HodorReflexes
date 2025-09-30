local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local extension = {
    name = "anim",
    version = "1.0.0",
}
local extension_name = extension.name
local extension_version = extension.version

addon[extension_name] = extension

local LCI = LibCustomIcons
local animations = {}

local function getAnimationNamespace(namespace)
    local n = animations[namespace]
    if not n then
        n = {}
        animations[namespace] = n
    end
    return n
end

-- Returns true if a user is in HR.anim.users table.
function extension.IsValidUser(userId)
    return LCI.HasAnimated(userId)
end

-- get first frame. - returns the texture, left, right, top, bottom for SetTextureCoords(left, right, top, bottom)
function extension.GetFirstFrame(userId)
    local a = LCI.GetAnimated(userId)
    if a then
        return a[1], 0, 1/a[2], 0 , 1/a[3]
    end
end

function extension.RegisterNamespacedUser(namespace, userId)
    local n = getAnimationNamespace(namespace)
    local userAnim = LCI.GetAnimated(userId)
    if userAnim then
        if n[userId] then extension.UnregisterNamespacedUser(namespace, userId) end
        n[userId] = {
            timeline = ANIMATION_MANAGER:CreateTimeline(),
            texture = userAnim[1],
            width = userAnim[2],
            height = userAnim[3],
            frameRate = userAnim[4],
            isRunning = false,
        }
        return true
    end
    return false
end
function extension.UnregisterNamespacedUserControls(namespace, userId)
    local n = getAnimationNamespace(namespace)
    local a = n[userId]
    if a then
        a.timeline:SetEnabled(false)
        a.timeline = ANIMATION_MANAGER:CreateTimeline()
    end
end
function extension.IsUserRegisteredInNamespace(namespace, userId)
    local n = getAnimationNamespace(namespace)
    return n[userId] ~= nil
end
function extension.RegisterNamespacedUserControl(namespace, userId, control)
    local n = getAnimationNamespace(namespace)
    local a = n[userId]
    if a then
        if a.animationObject then
            a.animationObject:SetAnimatedControl(control)
        else
            a.animationObject = a.timeline:InsertAnimation(ANIMATION_TEXTURE, control)
        end

        a.animationObject:SetImageData(a.width, a.height)
        a.animationObject:SetFramerate(a.frameRate)
        control:SetTexture(a.texture)
    end
end
function extension.RunNamespacedUserAnimations(namespace, userId)
    local n = getAnimationNamespace(namespace)
    local a = n[userId]
    if a then
        if not a.timeline:IsPlaying() then
            a.timeline:SetEnabled(true)
            a.timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
            a.timeline:PlayFromStart()
        end
        return true
    end
    return false
end

function extension.StopNamespacedUserAnimations(namespace, userId)
    local n = getAnimationNamespace(namespace)
    local a = n[userId]
    if a then
        a.timeline:SetEnabled(false)
        a.animationObject:SetAnimatedControl(nil)
    end
end

function extension.UnregisterNamespacedUser(namespace, userId)
    extension.StopNamespacedUserAnimations(namespace, userId)
    local n = getAnimationNamespace(namespace)
    n[userId] = nil
end

function extension.UnregisterNamespacedUsers(namespace)
    extension.StopNamespacedAnimations(namespace)
    animations[namespace] = {}
end

function extension.StopNamespacedAnimations(namespace)
    local n = getAnimationNamespace(namespace)
    for userId, _ in pairs(n) do
        extension.StopNamespacedUserAnimations(namespace, userId)
    end
end

function extension.RunNamespacedAnimations(namespace)
    local n = getAnimationNamespace(namespace)
    for userId, _ in pairs(n) do
        extension.RunNamespacedUserAnimations(namespace, userId)
    end
end

function extension.UnregisterUserFromAllNamespaces(userId)
    for namespace, _ in pairs(animations) do
        extension.UnregisterNamespacedUser(namespace, userId)
    end
end

-- Register and start animation for a user in a namespace.
-- If the user is not registered, it will be registered.
-- If the user is already registered, the control will be added and the animation started.
-- Returns true if the animation was started, false otherwise.
function extension.AnimateUserIcon(namespace, userId, iconControl)
    if not LCI then return false end
    if not extension.IsUserRegisteredInNamespace(namespace, userId) then
        if not extension.RegisterNamespacedUser(namespace, userId) then
            return false
        end
    end
    extension.RegisterNamespacedUserControl(namespace, userId, iconControl)
    extension.RunNamespacedUserAnimations(namespace, userId)
    return true
end

-- override functions if LibCustomIcons is not available
if not LCI then
    extension.IsValidUser = function(user)
        return false
    end
    extension.RegisterNamespacedUser = function(namespace, userId)
        return false
    end
end


---------------------------------- OLD --------------------------------
local anims = {}

-- Initialize a user.
function extension.RegisterUser(user)
    local userAnim = LCI.GetAnimated(user)
    if userAnim then
        if anims[user] then extension.UnregisterUser(user) end
        anims[user] = {
            timeline = ANIMATION_MANAGER:CreateTimeline(),
            texture = userAnim[1],
            width = userAnim[2],
            height = userAnim[3],
            frameRate = userAnim[4],
            isRunning = false,
        }
        return true
    end
    return false
end

function extension.IsUserRegistered(user)
    return anims[user] ~= nil
end

-- Delete all user animations.
function extension.UnregisterUser(user)
    extension.StopUserAnimations(user)
    anims[user] = nil
end

-- Clear all users.
function extension.UnregisterUsers()
    extension.StopAnimations()
    anims = {}
end

-- Register a texture control to update.
function extension.RegisterUserControl(user, control)
    local a = anims[user]
    if a then
        local animation = a.timeline:InsertAnimation(ANIMATION_TEXTURE, control)
        animation:SetImageData(a.width, a.height)
        animation:SetFramerate(a.frameRate)
        control:SetTexture(a.texture)
        control.animation = animation
    end
end

-- Unregister all controls.
function extension.UnregisterUserControls(user)
    local a = anims[user]
    if a then
        a.timeline:SetEnabled(false)
        a.timeline = ANIMATION_MANAGER:CreateTimeline()
    end
end

-- Start all animations for a user.
function extension.RunUserAnimations(user)
    local a = anims[user]
    if a and not a.timeline:IsPlaying() then
        --if a then
        a.timeline:SetEnabled(true)
        a.timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
        a.timeline:PlayFromStart()
        a.isRunning = true
        return true
    end
    return false
end

-- Stop all animations for a user.
function extension.StopUserAnimations(user)
    local a = anims[user]
    if a then
        a.timeline:SetEnabled(false)
        a.isRunning = false
    end
end

-- Play all animations.
function extension.RunAnimations()
    for name, _ in pairs(anims) do
        extension.RunUserAnimations(name)
    end
end

-- Stop all animations.
function extension.StopAnimations()
    for name, _ in pairs(anims) do
        extension.StopUserAnimations(name)
    end
end

-- override functions if LibCustomIcons is not available
if not LCI then
    extension.RegisterUser = function(user)
        return false
    end
    extension.IsValidUser = function(user)
        return false
    end
end
----------------------------------------------------------------------------------