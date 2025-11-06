-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

--[[ doc.lua begin ]]
--- @class HodorReflexes
local addon = {
    name = "HodorReflexes",
    friendlyName = "Hodor Reflexes",
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
                accountWide = true,
                enableExperimentalFeatures = false,
                extensions = {
                    ["seasons"] = true,
                    ["names"] = true,
                    ["icons"] = true,
                    ["animations"] = true,
                    ["themes"] = false,
                },
                modules = {
                    ["readycheck"] = true,
                    ["exitinstance"] = true,
                    ["pull"] = true,
                    ["skilllines"] = true,
                    ["dps"] = true,
                    ["ult"] = true,
                    ["hideme"] = true,
                },
                libraryPopupDisabled = false,
                enableTestTick = true, -- this is not toggleable via the settings atm. only for dev purposes
            }
        },
        registeredLists = {}, -- list of all registered lists
        extensionClass = {}, -- will be set later
        moduleClass = {}, -- will be set later
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
    core.logger.main:Debug("version: %s", addon.version)
    core.logger.main:Debug("svVersion: %d", core.svVersion)
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

    EM:RegisterForEvent(addon_name .. "_LIB_CHECK", EVENT_PLAYER_ACTIVATED, function()
        EM:UnregisterForEvent(addon_name .. "_LIB_CHECK", EVENT_PLAYER_ACTIVATED)
        core.OptionalLibrariesCheck()
    end)

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