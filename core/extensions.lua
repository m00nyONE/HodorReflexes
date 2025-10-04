local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

-- TODO: create extension class
local extension = {}
extension.__index = extension

function core.InitializeExtensions() end