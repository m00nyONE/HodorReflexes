--[[
	NOTE: This extension updates units on HR_EVENT_GROUP_CHANGED event,
	which is triggered 1 second after group changes.
	If you access its functions before the group data is rebuilt,
	then they may return nil or old values.
	Use units.RegisterCallback(HR_EVENT_UNITS_UPDATED, callback) to prevent this issue.
]]
HodorReflexes.units = {}

HR_EVENT_UNITS_UPDATED = "UnitsUpdated"

local HR = HodorReflexes
local EM = EVENT_MANAGER
local units = HR.units

local unitList = {}
local idTag = {}
local groupSizeOnline = 0 -- number of online group members
local unitsNum = 0 -- number of units added

local EVENT_GROUP_EFFECT = HR.name .. 'GroupEffect'

function units.AddUnit(id, tag)
	local unit = unitList[tag]
	if unit and not idTag[id] then
		unit.id = id
		idTag[id] = tag
		unitsNum = unitsNum + 1
	end
	if unitsNum >= groupSizeOnline then -- found all ids for group members
		EM:UnregisterForEvent(EVENT_GROUP_EFFECT, EVENT_EFFECT_CHANGED)
	end
end

function units.GetTag(id)
	return idTag[id]
end

function units.GetId(tag)
	local unit = unitList[tag] -- accessing unitList[tag] twice is slower than creating a local variable for it
	return unit and unit.id
end

function units.IsOnline(tag)
	local unit = unitList[tag]
	return unit ~= nil and unit.isOnline
end

function units.IsPlayer(tag)
	local unit = unitList[tag]
	return unit and unit.isPlayer
end

function units.GetClassId(tag)
	local unit = unitList[tag]
	return unit and unit.classId
end

function units.GetName(tag)
	local unit = unitList[tag]
	return unit and unit.name
end

function units.GetDisplayName(tag)
	local unit = unitList[tag]
	return unit and unit.displayName
end

function units.IsGrouped(tag)
	return unitList[tag] ~= nil
end

-- Returns a real group tag for "player".
function units.GetPlayerTag()
	local unit = unitList['player']
	return unit and unit.tag
end

function units.Refresh()
	unitList = {}
	idTag = {}
	unitsNum = 0
	groupSizeOnline = 0
end

function units.Initialize()
	--HR.UnregisterCallback(HR_EVENT_GROUP_CHANGED, units.Register)
	HR.RegisterCallback(HR_EVENT_GROUP_CHANGED, units.Register)

end

function units.Register()
	EM:UnregisterForEvent(EVENT_GROUP_EFFECT, EVENT_EFFECT_CHANGED)
	units.Refresh()

	groupSizeOnline = 0
	for i = 1, GetGroupSize() do
		local tag = GetGroupUnitTagByIndex(i)
		if IsUnitPlayer(tag) then
			local unit = {
				tag = tag,
				id = 0,
				name = GetUnitName(tag),
				displayName = GetUnitDisplayName(tag),
				classId = GetUnitClassId(tag),
				isOnline = IsUnitOnline(tag),
				isPlayer = AreUnitsEqual(tag, 'player'),
			}
			if unit.isOnline then groupSizeOnline = groupSizeOnline + 1 end
			if unit.isPlayer then unitList['player'] = unit end
			unitList[tag] = unit
		end
	end

	EM:RegisterForEvent(EVENT_GROUP_EFFECT,  EVENT_EFFECT_CHANGED, function(_, _, _, _, tag, _, _, _, _, _, _, _, _, _, id) units.AddUnit(id, tag) end)
	EM:AddFilterForEvent(EVENT_GROUP_EFFECT, EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, 'group')

	HR.cm:FireCallbacks(HR_EVENT_UNITS_UPDATED)

end

function units.Unregister()

	HR.UnregisterCallback(HR_EVENT_GROUP_CHANGED, M.GroupChanged)
	EM:UnregisterForEvent(EVENT_GROUP_EFFECT, EVENT_EFFECT_CHANGED)
	units.Refresh()

end