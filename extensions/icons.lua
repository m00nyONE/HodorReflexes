-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_extensions = addon.extensions
local internal_extensions = internal.extensions

local LCI = LibCustomIcons

local extensionDefinition = {
    name = "icons",
    version = "1.0.0",
    svDefault = {
        enabled = true,
    },

    classIcons = {},
}

local extension = internal.extensionClass:New(extensionDefinition)

--- get class icon for classId.
--- @param classId number
--- @return string, number, number, number, number texturePath (falls back to "campaignbrowser_guestcampaign.dds" if the icon is not found), textureCoordsLeft, textureCoordsRight, textureCoordsTop, textureCoordsBottom
function extension.GetClassIcon(classId)
    local texturePath = extension.classIcons[classId]
    if not texturePath then
        texturePath = "esoui/art/campaign/campaignbrowser_guestcampaign.dds"
    end
    return texturePath, 0, 1, 0, 1
end

--- overwrite class icons with new ones.
--- This is used for some events. For example on christmas, class icons get overwritten by their christmas version.
--- @param newClassIcons table<number, string> {classId: number, texturePath: string}
--- @return void
function extension.overwriteClassIcons(newClassIcons)
    for classId, icon in pairs(newClassIcons) do
        extension.classIcons[classId] = icon
    end
end

--- get icon for userId.
--- This function overwrites the Get() function if LCI is present.
--- @param userId string
--- @param classId number
--- @return string, number, number, number, number texturePath, textureCoordsLeft, textureCoordsRight, textureCoordsTop, textureCoordsBottom
local function LCI_Get(userId, classId)
    -- get static icon first because this is what is asked for
    local static = LCI.GetStatic(userId)
    if static then
        return static, 0, 1, 0, 1
    end
    -- then try animated icon and return the first frame
    local animation, width, height, _ = LCI.GetAnimated(userId)
    if animation then
        return animation, 0, 1/width, 0, 1/height
    end
    -- as a last resort, return class icon
    return extension.GetClassIcon(classId)
end

--- get icon for userId.
--- @param userId string
--- @param classId number
--- @return string, number, number, number, number texturePath, textureCoordsLeft, textureCoordsRight, textureCoordsTop, textureCoordsBottom
function extension.Get(userId, classId)
    return extension.GetClassIcon(classId), 0, 1, 0, 1
end

--- Module activation function.
--- NOT for manual use. This function gets called once when the extension is loaded and then deleted afterwards.
--- @return void
function extension:Activate()
    for i = 1, GetNumClasses() do
        local classId, _, _, _, _, _, icon, _, _, _ = GetClassInfo(i)
        self.classIcons[classId] = icon
    end

    if LCI and self.sw.enabled then
        self.Get = LCI_Get
    end
end

