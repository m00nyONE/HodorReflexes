-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal

local LCI = LibCustomIcons
local util = addon.util

local extensionDefinition = {
    name = "icons",
    friendlyName = GetString(HR_EXTENSIONS_ICONS_FRIENDLYNAME),
    version = "1.0.0",
    description = GetString(HR_EXTENSIONS_ICONS_DESCRIPTION),
    priority = 2,
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
    local static, left, right, top, bottom = LCI.GetStatic(userId)
    if static then
        return static, left or 0, right or 1, top or 0, bottom or 1
    end
    -- then try animated icon and return the first frame
    local animation = LCI.GetAnimated(userId)
    if animation then
        return animation[1], 0, 1/animation[2], 0, 1/animation[3]
    end
    -- as a last resort, return class icon
    return util.GetClassIcon(classId) -- returns texturePath, left, right, top, bottom
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
    self.logger:Debug("Overwrote util.GetUserIcon with LCI_GetUserIcon")
end

