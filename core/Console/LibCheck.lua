local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

-- no need to check for LCN or LCI here, as those do not exist on Console
function core.OptionalLibrariesCheck() end