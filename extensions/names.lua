-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_extensions = addon.extensions
local internal_extensions = internal.extensions

local LCN = LibCustomNames

local extensionDefinition = {
    name = "names",
    version = "1.0.0",
    svDefault = {
        enabled = true,
    },
}

local extension = internal.extensionClass:New(extensionDefinition)

--- get alias for userId.
--- This function overwrites extension.GetAliasForUserId if LCN is present.
--- @param userId string
--- @param pretty boolean if true, will return a colored name if available
--- @return string alias
local function LCN_Get(userId, pretty)
    local user = LCN.Get(userId, pretty)
    if user then return user end

    return userId and UndecorateDisplayName(userId) or '' -- just remove @
end

--- get alias for userId.
--- @param userId string
--- @param pretty boolean if true, will return a colored name if available
--- @return string alias
function extension.Get(userId, pretty)
    return userId and UndecorateDisplayName(userId) or ''
end

function extension:Activate()
    if LCN and self.sw.enabled then
        self.Get = LCN_Get
    end
end

