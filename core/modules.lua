local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local addon_version = addon.version
local internal = addon.internal

-- TODO: create module class
local module = {}
module.__index = module

function internal.InitializeModules() end