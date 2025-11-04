-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal

local LCN = LibCustomNames
local util = addon.util

local extensionDefinition = {
    name = "names",
    friendlyName = GetString(HR_EXTENSIONS_NAMES_FRIENDLYNAME),
    version = "1.0.0",
    description = GetString(HR_EXTENSIONS_NAMES_DESCRIPTION),
    priority = 1,
    svVersion = 1,
    svDefault = {},
}

--- @class namesExtension : extensionClass
local extension = internal.extensionClass:New(extensionDefinition)

--- get alias for userId.
--- This function overwrites util.GetUserName if LCN is present.
--- @param userId string
--- @param pretty boolean if true, will return a colored name if available
--- @return string alias
local function LCN_GetUserName(userId, pretty)
    local user = LCN.Get(userId, pretty)
    if user then return user end

    return userId and UndecorateDisplayName(userId) or '' -- just remove @
end

--- Module activation function.
--- NOT for manual use. This function gets called once when the extension is loaded and then deleted afterwards.
--- @return void
function extension:Activate()
    if not LCN then
        self.enabled = false
        return
    end

    util.GetUserName = LCN_GetUserName
    self.logger:Debug("Overwrote util.GetUserName with LCN_GetUserName.")
end

