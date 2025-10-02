local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal

local LGB = LibGroupBroadcast

function internal.RegisterLGBHandler()
    local handler = LGB:RegisterHandler(addon_name)
    handler:SetDisplayName("Hodor Reflexes")
    handler:SetDescription("provides various group tools like pull countdowns and exit instance requests")

    internal.LGBHandler = handler
end