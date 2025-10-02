-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

--[[ doc.lua begin ]]
--- @class HodorReflexes
local addon = {
    name = "HodorReflexes2",
    slashCmd = "hodor2",
    version = "dev",
    author = "|cFFFF00@andy.s|r, |c76c3f4@m00nyONE|r",

    modules = {},
    internal = {
        sv = nil, -- saved variables
    },
}
local addon_debug = false
local addon_name = addon.name
local internal = addon.internal
_G[addon_name] = addon

local svName = "HodorReflexesSavedVars"
local svVersion =  1
local svDefault = {}

local EM = GetEventManager()
local CM = ZO_CallbackObject:New()
internal.CM = CM -- make the callback manager available to other modules


-- initialize addon
local function initialize()
    internal.sv = ZO_SavedVars:NewAccountWide(svName, svVersion, nil, svDefault)

    internal.RegisterLGBHandler()
    internal.RegisterBaseCommands()
    internal.InitializeExtensions()
    internal.InitializeModules()
    internal.BuildMenu()

    internal.OptionalLibrariesCheck()

    addon.internal = nil
end

EM:RegisterForEvent(addon_name, EVENT_ADD_ON_LOADED, function(_, name)
    if name ~= addon_name then return end

    EM:UnregisterForEvent(addon_name, EVENT_ADD_ON_LOADED)
    initialize()

end)

--[[ doc.lua end ]]