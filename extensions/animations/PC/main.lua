-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_extensions = addon.extensions
local internal_extensions = internal.extensions

local util = addon.util

local LCI = LibCustomIcons
local AM = GetAnimationManager()

local HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED = addon.HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED -- function(data)

local extensionDefinition = {
    name = "animations",
    version = "0.1.0",
    friendlyName = "Animations",
    description = "Provides animated user icon support for lists via LibCustomIcons.",
    priority = 3,
    svVersion = 1,
    svDefault = {},

    animations = {},
    registeredLists = {},
}

--- @class animExtension
local extension = internal.extensionClass:New(extensionDefinition)

--- Activate the extension
--- @return void
function extension:Activate()
    if not LCI then
        self.enabled = false
        return
    end

    -- hook util.GetUserIcon to return nil when an animation is found so the static icon does not get attached to any controls
    -- This is to prevent flickering between static and animated icons while updating the list
    local originalGetUserIcon = util.GetUserIcon
    util.GetUserIcon = function(userId, classId)
        if LCI.HasAnimated(userId) then
            return nil, 0, 1, 0, 1
        end
        return originalGetUserIcon(userId, classId)
    end

    for _, list in pairs(internal.registeredLists) do
        self:AttachToList(list)
    end

    -- register for character removed to clean up animations when they are no longer needed
    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED, function(data) self:_removeAllAnimationsForUser(data.userId) end)
end

--- Hook a list to add animation support
--- @param list listClass
--- @param iconControlName string optional name of the icon control in the list row template (defaults to "_Icon")
--- @return void
function extension:AttachToList(list, iconControlName)
    if self.registeredLists[list.name] then
        self.logger:Warn("List '%s' is already registered for animations. Skipping", list.name)
        return
    end

    self.logger:Debug("Attaching to list '%s'", list.name)

    -- hook into list update function
    local listUpdate = list.Update
    list.Update = function()
        listUpdate()
        self:_listUpdatePostHook(list, iconControlName and iconControlName or "_Icon")
    end

    self.registeredLists[list.name] = true
end

--- NOT for manual use.
--- post hook for list update to attach animations to icon controls
--- @param list listClass
--- @param iconControlName string name of the icon control child in the list row template. (e.g. "_Icon")
--- @return void
function extension:_listUpdatePostHook(list, iconControlName)
    local usersWithAnimation = {}
    local contents = list.listControl:GetNamedChild("Contents")
    for childId = 1, contents:GetNumChildren() do
        local rowControl = contents:GetChild(childId)
        local entryData = ZO_ScrollList_GetData(rowControl)
        if entryData and entryData.userId and LCI.HasAnimated(entryData.userId) then -- only process player rows and only users with animated icons
            local iconControl = rowControl:GetNamedChild(iconControlName)
            if iconControl == nil then -- icon control not found! This can only happen when someone creates a list with a custom template that does not have the expected icon control or when the template of a standard list got overwritten by a theme that did no follow the guidelines in the README.md of the theme extension.
                self.logger:Warn("icon control '%s' not found in list '%s' row template", iconControlName, list.name)
                return -- exit out of the update hook because there is nothing we can do here
            end

            self:_createAnimationForUser(list.name, entryData.userId) -- create animation timeline for the user in the list if it does not already exist
            self:_attachAnimationToControl(list.name, entryData.userId, iconControl) -- attach the animation to the icon control
            usersWithAnimation[entryData.userId] = true
        end
    end
    for userId, _ in pairs(self.animations[list.name] or {}) do
        if not usersWithAnimation[userId] then
            self.logger:Debug("user '%s' no longer in list '%s', removing animation", userId, list.name)
            self:_removeAnimationForUser(list.name, userId)
        end
    end
end

--- NOT for manual use.
--- creates an animation entry and timeline for a user for a list if it does not already exist
--- @param listName string the name of the list
--- @param userId string the user id
--- @return void
function extension:_createAnimationForUser(listName, userId)
    local animations = self.animations[listName] or {} -- create a list entry if it does not exist
    self.animations[listName] = animations

    if animations[userId] then
        return -- animation already exists for this user in this list
    end

    local userAnim = LCI.GetAnimated(userId)
    if userAnim == nil then -- sanity check (should not happen because we check for HasAnimated in the _listUpdatePostHook function)
        self.logger:Warn("no animated icon found for user '%s'", userId)
        return
    end

    animations[userId] = {
        timeline = AM:CreateTimeline(),
        animationObject = nil,
        attachedControl = nil,
        texture = userAnim[1],
        --textureCoords = {0, 1, 0, 1},
        width = userAnim[2],
        height = userAnim[3],
        frameRate = userAnim[4],
    }

    self.logger:Debug("created animation for user '%s' on list '%s'", userId, listName)
end

--- NOT for manual use.
--- attaches the animation for a user to a specific icon control in a list
--- @param listName string the name of the list
--- @param userId string the user id
--- @param iconControl TextureControl the icon control to attach the animation to
--- @return void
function extension:_attachAnimationToControl(listName, userId, iconControl)
    local animations = self.animations[listName]
    if animations == nil then
        self.logger:Warn("no animations found for list '%s'", listName) -- sanity check (should never happen because we always create the animation entry before attaching it in _listUpdatePostHook)
        return
    end

    local a = animations[userId]
    if a == nil then
        self.logger:Warn("no animation found for user '%s' in list '%s'", userId, listName) -- sanity check (should never happen because we always create the animation entry before attaching it in _listUpdatePostHook)
        return
    end

    if a.attachedControl == iconControl then
        return -- already attached to this control
    end

    iconControl:SetTexture(a.texture)
    --iconControl:SetTextureCoords(a.textureCoords)

    if a.animationObject then
        a.animationObject:SetAnimatedControl(iconControl) -- attach to the new control
    else
        a.animationObject = a.timeline:InsertAnimation(ANIMATION_TEXTURE, iconControl)
        a.animationObject:SetImageData(a.width, a.height)
        a.animationObject:SetFramerate(a.frameRate)
        self.logger:Debug("create animationObject user '%s'", userId)
    end

    if not a.timeline:IsPlaying() then
        a.timeline:SetEnabled(true)
        a.timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
        a.timeline:PlayFromStart()
    end

    a.attachedControl = iconControl -- set the attached control to the current icon control (for future reference)
end

--- NOT for manual use.
--- removes and stops all animations for a user
--- @param userId string the user id
--- @return void
function extension:_removeAllAnimationsForUser(userId)
    for listName, _ in pairs(self.animations) do
        self.logger:Debug("removing animations for user '%s'", userId)
        self:_removeAnimationForUser(listName, userId)
    end
end

function extension:_removeAnimationForUser(listName, userId)
    if self.animations[listName] == nil then
        return
    end

    if self.animations[listName][userId] == nil then return end
    if self.animations[listName][userId].animationObject then -- it is somewhat possible that the animationObject is still nil here. better be safe than sorry
        self.animations[listName][userId].animationObject:SetAnimatedControl(nil)
    end

    self.animations[listName][userId].timeline:SetEnabled(false)
    self.animations[listName][userId] = nil
    self.logger:Debug("removed animation for user '%s' on list '%s'", userId, listName)
end