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
        core = {
            sv = nil, -- saved variables
        },
    },
}
local addon_debug = false
local addon_name = addon.name
local internal = addon.internal
local core = internal.core
_G[addon_name] = addon

local svName = "HodorReflexesSavedVars"
local svVersion =  1
local svDefault = {
    libraryPopupDisabled = false,
}

local EM = GetEventManager()
local CM = ZO_CallbackObject:New()
core.CM = CM -- make the callback manager available to other parts of the addon


-- initialize addon
local function initialize()
    core.sv = ZO_SavedVars:NewAccountWide(svName, svVersion, nil, svDefault)

    core.RegisterLGBHandler()
    core.RegisterBaseCommands()
    core.InitializeExtensions()
    core.InitializeModules()
    core.BuildMenu()

    core.OptionalLibrariesCheck()

    addon.internal = nil
end

EM:RegisterForEvent(addon_name, EVENT_ADD_ON_LOADED, function(_, name)
    if name ~= addon_name then return end

    EM:UnregisterForEvent(addon_name, EVENT_ADD_ON_LOADED)
    initialize()

end)

--[[ doc.lua end ]]