local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local module = {
    name = "example",
    friendlyName = "Example",
    description = "example_description",
    version = "1.0.0",
    priority = 99,
    enabled = false,
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
local LAM = LibAddonMenu2
local localPlayer = "player"

local function onPlayerActivated()

end

-- initialization functions

function module:BuildMenu(panelConfig)
    local options = {

    }

    LAM:RegisterAddonPanel(addon_name .. "IconsMenu", panelConfig)
    LAM:RegisterOptionControls(addon_name .. "IconsMenu", options)
end

function module:MainMenuOptions()
    return {
    }
end

function module:RegisterLGBProtocols(handler)
    assert(handler, "no LGB handler found")
end

function module:Initialize()
    sv = ZO_SavedVars:NewAccountWide(svName, svVersion, module_name, svDefault)

    local eventRegisterName = "HodorReflexes_mock_PlayerActivated"
    EM:UnregisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED)
    EM:RegisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED, onPlayerActivated)
end

addon:RegisterModule(module_name, module)