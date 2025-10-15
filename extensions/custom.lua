-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_extensions = addon.extensions
local internal_extensions = internal.extensions

local LCN = LibCustomNames
local LCI = LibCustomIcons

local extensionDefinition = {
    name = "custom",
    version = "1.0.0",
    svDefault = {},

    classIcons = {},
}

local extension = internal.extensionClass:New(extensionDefinition)

--- get icon for userId.
--- This function overwrites extension.GetIconForUserId if LCI is present.
--- @param userId string
--- @return string|nil texturePath
local function LCI_getIconForUserId(userId)
    return LCI.GetStatic(userId)
end
--- get alias for userId.
--- This function overwrites extension.GetAliasForUserId if LCN is present.
--- @param userId string
--- @param pretty boolean if true, will return a colored name if available
--- @return string alias
local function LCN_getAliasForUserId(userId, pretty)
    local user = LCN.Get(userId, pretty)
    if user then return user end

    return userId and UndecorateDisplayName(userId) or '' -- just remove @
end

--- get alias for userId.
--- @param userId string
--- @param pretty boolean if true, will return a colored name if available
--- @return string alias
function extension.GetAliasForUserId(userId, pretty)
    return userId and UndecorateDisplayName(userId) or ''
end

--- get icon for userId.
--- @param userId string
--- @return string|nil texturePath
function extension.GetIconForUserId(userId)
    return nil
end
--- get class icon for classId.
--- @param classId number
--- @return string texturePath
function extension.GetClassIcon(classId)
    return extension.classIcons[classId]
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

function extension:Activate()
    for i = 1, GetNumClasses() do
        local classId, _, _, _, _, _, icon, _, _, _ = GetClassInfo(i)
        self.classIcons[classId] = icon
    end

    if LCI then
        self.GetIconForUserId = LCI_getIconForUserId
    end
    if LCN then
        self.GetAliasForUserId = LCN_getAliasForUserId
    end
end

