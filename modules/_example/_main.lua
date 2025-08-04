local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local module = {
    name = "example",
    version = "1.0.0",
}

local module_name = module.name
local module_version = module.version

local sv = nil
local svName = addon.svName
local svVersion = addon.svVersion
local svDefault = {
    enabled = true,
    exampleSetting = false,
}

local EM = EVENT_MANAGER
local localPlayer = "player"

-- initialization functions

function module:BuildMenu()

end

function module:InjectMenu()

end

function module:DeclareLGBProtocols(handler)
    assert(handler, "no LGB handler found")
end

function module:Initialize()
    sv = ZO_SavedVars:NewAccountWide(svName, svVersion, module_name, svDefault)

    local eventRegisterName = "HodorReflexes_mock_PlayerActivated"
    EM:UnregisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED)
    EM:RegisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED, generateMock)
end

addon:RegisterModule(module_name, module)