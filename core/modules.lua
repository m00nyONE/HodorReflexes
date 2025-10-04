local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

-- TODO: create module class
local module = {}
module.__index = module

function core.InitializeModules() end