-- A lightweight extension to access LibCombat data.
HodorReflexes.combat = {
	name = "HodorReflexes_Combat",
}

local HR = HodorReflexes
local LC = LibCombat
local combat = HR.combat

local combatData

local function InitData()
	combatData = {DPSOut = 0, dpstime = 0, hpstime = 0, bossfight = false, units = {}}
end

local function UnitsCallback(_, units)
	combatData.units = units
end

local function FightRecapCallback(_, data)
	combatData.DPSOut = data.DPSOut
	combatData.dpstime = data.dpstime
	combatData.hpstime = data.hpstime
	combatData.bossfight = data.bossfight
end

function combat.Register()

	InitData()

	LC:RegisterCallbackType(LIBCOMBAT_EVENT_UNITS, UnitsCallback, combat.name)
	LC:RegisterCallbackType(LIBCOMBAT_EVENT_FIGHTRECAP, FightRecapCallback, combat.name)

end

function combat.Unregister()

	InitData()

	LC:UnregisterCallbackType(LIBCOMBAT_EVENT_UNITS, UnitsCallback, combat.name)
	LC:UnregisterCallbackType(LIBCOMBAT_EVENT_FIGHTRECAP, FightRecapCallback, combat.name)

end

function combat.Reset()
	InitData()
end

function combat.GetData()
	return combatData
end

function combat.GetCombatTime()
	return zo_roundToNearest(zo_max(combatData.dpstime, combatData.hpstime), 0.1)
end

-- Returns total damage done to all enemy units in the current fight.
function combat.GetFullDamage()
	local damage = 0
	for _, unit in pairs(combatData.units) do	
		local totalUnitDamage = unit.damageOutTotal
		if not unit.isFriendly and totalUnitDamage > 0 then
			damage = damage + totalUnitDamage
		end
	end
	return damage
end

-- Returns total damage done to all bosses in the current fight.
function combat.GetBossTargetDamage()
	if not combatData.bossfight then return 0, 0, 0 end

	local bossUnits, totalBossDamage = 0, 0
	local starttime, endtime

	for _, unit in pairs(combatData.units) do
		local totalUnitDamage = unit.damageOutTotal
		if unit.bossId ~= nil and totalUnitDamage > 0 then 
			totalBossDamage = totalBossDamage + totalUnitDamage
			bossUnits = bossUnits + 1
			starttime = zo_min(starttime or unit.dpsstart or 0, unit.dpsstart or 0)
			endtime = zo_max(endtime or unit.dpsend or 0, unit.dpsend or 0)
		end
	end

	if bossUnits == 0 then return 0, 0, 0 end

	local bossTime = (endtime - starttime) / 1000
	bossTime = bossTime > 0 and bossTime or combatData.dpstime

	return bossUnits, totalBossDamage, bossTime
end

InitData()