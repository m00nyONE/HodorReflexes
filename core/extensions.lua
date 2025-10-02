local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local addon_version = addon.version
local internal = addon.internal

-- TODO: create extension class
local extension = {}
extension.__index = extension

function internal.InitializeExtensions() end