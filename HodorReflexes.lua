-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

--[[ doc.lua begin ]]
--- @class HodorReflexes
local addon = {
    name = "HodorReflexes",
    slashCmd = "hodor",
    version = "dev",
    author = "|cFFFF00@andy.s|r, |c76c3f4@m00nyONE|r",

    debug = false,

    extensions = {},
    modules = {},
    internal = {
        core = {
            svName = "HodorReflexesSavedVars",
            svVersion = 2,
            sv = nil, -- per character saved variables
            sw = nil, -- global accountwide saved variables
            svDefault = {
                accountwide = true,
                extensions = {
                    ["seasons"] = true,
                    ["names"] = true,
                    ["icons"] = true,
                    ["animations"] = true,
                },
                modules = {
                    ["readycheck"] = true,
                    ["exitinstance"] = true,
                    ["pull"] = true,
                    ["skilllines"] = true,
                    ["dps"] = true,
                    ["ult"] = true,
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
    core.logger.main:Info("version: %s", addon.version)
    core.logger.main:Info("svVersion: %d", core.svVersion)
    -- we use a combination of accountWide saved variables and per character saved variables. This little swappi swappi allows us to switch between them without defining new variables
    core.sw = ZO_SavedVars:NewAccountWide(core.svName, core.svVersion, nil, core.svDefault)
    if not core.sw.accountWide then
        core.sv = ZO_SavedVars:NewCharacterIdSettings(core.svName, core.svVersion, nil, core.svDefault)
        core.sw.accountWide = false
    else
        core.sv = core.sw
    end

    core.RegisterLGBHandler()
    core.RegisterCoreEvents()
    core.RegisterCoreCommands()
    core.InitializeCombat()
    core.InitializeModules()
    core.InitializeExtensions()
    core.BuildMenu()

    core.OptionalLibrariesCheck()

    addon.internal = nil
end

EM:RegisterForEvent(addon_name, EVENT_ADD_ON_LOADED, function(_, name)
    if name ~= addon_name then return end

    EM:UnregisterForEvent(addon_name, EVENT_ADD_ON_LOADED)

    local beginTime = GetGameTimeMilliseconds()
    initialize()
    core.logger.main:Debug("initialized in %d ms", GetGameTimeMilliseconds() - beginTime)
end)

--[[ doc.lua end ]]