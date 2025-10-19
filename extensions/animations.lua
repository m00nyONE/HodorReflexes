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
    description = "Provides animated user icon support for lists.",
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
    local _getUserIcon = util.GetUserIcon
    function util.GetUserIcon(userId)
        if LCI.HasAnimated(userId) then
            return nil
        end
        return _getUserIcon(userId)
    end

    local lists = {
        addon.modules.dps.damageList,
        addon.modules.ult.hornList,
        addon.modules.ult.colosList,
        addon.modules.ult.atroList,
        addon.modules.ult.miscList,
        addon.modules.ult.compactList,
    }
    for _, list in pairs(lists) do
        self:AttachToList(list)
    end

    -- register for character removed to clean up animations when they are no longer needed
    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED, function(data) self:_removeAnimationsForUser(data.userId) end)
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
--- @param iconControlName string name of the icon control in the list row template
--- @return void
function extension:_listUpdatePostHook(list, iconControlName)
    local contents = list.listControl:GetNamedChild("Contents")
    for childId = 1, contents:GetNumChildren() do
        local rowControl = contents:GetChild(childId)
        local entryData = ZO_ScrollList_GetData(rowControl)
        if entryData and entryData.userId and LCI.HasAnimated(entryData.userId) then
            self:_createAnimationForUser(entryData.userId)
            self:_attachAnimationToControl(entryData.userId, list.name, rowControl:GetNamedChild(iconControlName))
        end
    end
end

--- NOT for manual use.
--- creates an animation entry and timeline for a user if it does not already exist
--- @param userId string the user id
--- @return void
function extension:_createAnimationForUser(userId)
    if self.animations[userId] then
        return -- animation already exists for this user
    end

    local userAnim = LCI.GetAnimated(userId)
    if userAnim == nil then
        self.logger:Warn("no animated icon found for user '%s'", userId)
        return
    end
    self.animations[userId] = {
        timeline = AM:CreateTimeline(),
        animationObjects = {},
        texture = userAnim[1],
        width = userAnim[2],
        height = userAnim[3],
        frameRate = userAnim[4],
        attachedControls = {},
    }
    self.logger:Debug("created animation for user '%s'", userId)
end

--- NOT for manual use.
--- attaches the animation for a user to a specific icon control in a list
--- @param userId string the user id
--- @param listName string the name of the list
--- @param iconControl table the icon control to attach the animation to
--- @return void
function extension:_attachAnimationToControl(userId, listName, iconControl)
    local a =  self.animations[userId]

    if a.attachedControls[listName] == iconControl then
        return -- already attached to this control
    end

    iconControl:SetTexture(a.texture)

    if a.animationObjects[listName] then
        a.animationObjects[listName]:SetAnimatedControl(iconControl)
    else
        a.animationObjects[listName] = a.timeline:InsertAnimation(ANIMATION_TEXTURE, iconControl)
        a.animationObjects[listName]:SetImageData(a.width, a.height)
        a.animationObjects[listName]:SetFramerate(a.frameRate)
        self.logger:Debug("create animationObject user '%s'", userId)
    end

    if not a.timeline:IsPlaying() then
        a.timeline:SetEnabled(true)
        a.timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
        a.timeline:PlayFromStart()
    end

    a.attachedControls[listName] = iconControl
end

--- NOT for manual use.
--- removes and stops all animations for a user
--- @param userId string the user id
--- @return void
function extension:_removeAnimationsForUser(userId)
    local a = self.animations[userId]
    if a then
        self.logger:Debug("removing animations for user '%s'", userId)
        for listName, _ in pairs(self.registeredLists) do
            if a.animationObjects[listName] then -- it is somewhat possible that the animationObject is still nil here. better be safe than sorry
                a.animationObjects[listName]:SetAnimatedControl(nil)
            end
            a.timeline:SetEnabled(false)
            self.animations[userId] = nil
        end
    end
end
