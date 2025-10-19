-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal

local LCI = LibCustomIcons
local util = addon.util

local extensionDefinition = {
    name = "icons",
    version = "1.0.0",
    description = "Extension to provide user icons via LibCustomIcons.",
    svVersion = 1,
    svDefault = {},
}

--- @class iconsExtension : extensionClass
local extension = internal.extensionClass:New(extensionDefinition)

--- get icon for userId.
--- This function overwrites the util.GetUserIcon() function if LCI is present.
--- @param userId string
--- @param classId number
--- @return string, number, number, number, number texturePath, textureCoordsLeft, textureCoordsRight, textureCoordsTop, textureCoordsBottom
local function LCI_GetUserIcon(userId, classId)
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

--- Module activation function.
--- NOT for manual use. This function gets called once when the extension is loaded and then deleted afterwards.
--- @return void
function extension:Activate()
    if not LCI then
        self.enabled = false
        return
    end

    util.GetUserIcon = LCI_GetUserIcon
end

