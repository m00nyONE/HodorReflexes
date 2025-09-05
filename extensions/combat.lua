local addon_name = "HodorReflexes"
local addon = _G[addon_name]

-- A lightweight extension to access LibCombat data.
local extension = {
    name = "combat",
    version = "1.0.0",
}
local extension_name = extension.name
local extension_version = extension.version

addon[extension_name] = extension

local LC = LibCombat
local combatData

local function InitData()
	combatData = {
		dpstime = 0,
		hpstime = 0,
	}
end

local function FightRecapCallback(_, data)
	combatData.dpstime = data.dpstime
	combatData.hpstime = data.hpstime
end

function extension.Register()
	InitData()
	LC:RegisterCallbackType(LIBCOMBAT_EVENT_FIGHTRECAP, FightRecapCallback, addon_name .. extension_name)
end

function extension.Unregister()
	InitData()
	LC:UnregisterCallbackType(LIBCOMBAT_EVENT_FIGHTRECAP, FightRecapCallback, addon_name .. extension_name)
end

function extension.Reset()
	InitData()
end


function extension.GetCombatTime()
	return zo_roundToNearest(zo_max(combatData.dpstime, combatData.hpstime), 0.1)
end

InitData()