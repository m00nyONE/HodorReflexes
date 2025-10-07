-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

--[[ doc.lua begin ]]
--- @class HodorReflexes
local addon = {
    name = "HodorReflexes2",
    slashCmd = "hodor2",
    version = "dev",
    author = "|cFFFF00@andy.s|r, |c76c3f4@m00nyONE|r",

    debug = false,

    extensions = {},
    modules = {},
    internal = {
        core = {
            svName = "HodorReflexesSavedVars",
            svVersion = 1,
            sw = nil, -- global accountwide saved variables
            svDefault = {
                modules = {
                    ["pull"] = true,
                    ["readycheck"] = true,
                    ["skilllines"] = true,
                },
                libraryPopupDisabled = false,
            }
        },
    },
}
local addon_name = addon.name
local internal = addon.internal
local core = internal.core
_G[addon_name] = addon

local EM = GetEventManager()
local CM = ZO_CallbackObject:New()
core.CM = CM -- make the callback manager available to other parts of the addon


-- initialize addon
local function initialize()
    core.sw = ZO_SavedVars:NewAccountWide(core.svName, core.svVersion, nil, core.svDefault)

    core.RegisterLGBHandler()
    core.RegisterCoreEvents()
    core.RegisterCoreCommands()
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