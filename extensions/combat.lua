-- A lightweight extension to access LibCombat data.
HodorReflexes.combat = {
	name = "HodorReflexes_Combat",
}

local HR = HodorReflexes
local LC = LibCombat
local combat = HR.combat

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

function combat.Register()
	InitData()
	LC:RegisterCallbackType(LIBCOMBAT_EVENT_FIGHTRECAP, FightRecapCallback, combat.name)
end

function combat.Unregister()
	InitData()
	LC:UnregisterCallbackType(LIBCOMBAT_EVENT_FIGHTRECAP, FightRecapCallback, combat.name)
end

function combat.Reset()
	InitData()
end


function combat.GetCombatTime()
	return zo_roundToNearest(zo_max(combatData.dpstime, combatData.hpstime), 0.1)
end

InitData()