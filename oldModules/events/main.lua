HodorReflexes.modules.events = {
    name = "HodorReflexes_Events",
    version = "0.1.0",

    date = os.date("%d%m"),

    subModules = {},

    default = {
        enabled = true,
    },

    sv = nil, -- saved variables
}

local HR = HodorReflexes
local M = HR.modules.events
local MS = HR.modules.share

function M.IsEnabled()
    return M.sv.enabled
end

function M.RegisterEvent(func)
    if type(func) ~= "function" then return end

    table.insert(M.subModules, func)
end

function M.Initialize()
    -- Retrieve savedVariables
    M.sv = ZO_SavedVars:NewAccountWide(HR.svName, HR.svVersion, 'events', M.default)

    -- build menu
    M.BuildMenu()

    -- This module relies on the "share" module
    if not MS then return end

    if M.IsEnabled() then
        for _, subModule in pairs(M.subModules) do
            subModule()
        end
    end
end
