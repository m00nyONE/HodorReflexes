-- SPDX-FileCopyrightText: 2025 andy.s m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

HodorReflexes.player = {}

local HR = HodorReflexes
local player = HR.player
local util = HR.util

local LCI = LibCustomIcons
local LCN = LibCustomNames

local currentZoneId = 0
local currentHouseId = 0

function player.Initialize()

	currentZoneId = GetZoneId(GetUnitZoneIndex('player'))
	currentHouseId = GetCurrentZoneHouseId()

end

-- Returns map distance, not meters
function player.GetDistanceToPlayer(unitTag)

	--local x2, y2, h2, m2 = GetMapPlayerPosition(unitTag)
	local x2, y2, _, m2 = GetMapPlayerPosition(unitTag)
	if not m2 then return nil end -- not on the same map
	local x1, y1 = GetMapPlayerPosition('player')
	return util.GetDistance(x1, y1, x2, y2)

end

-- Returns distance to player in meters or false if players are in different zones.
function player.GetDistanceToPlayerM(unitTag)

	local zone1, x1, y1, z1 = GetUnitWorldPosition('player')
	local zone2, x2, y2, z2 = GetUnitWorldPosition(unitTag)

	if zone1 == zone2 then
		return zo_sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2) / 100
	end
end

-- Checks map distance, not meters (using "radius" param)
function player.IsCloseToPlayer(unitTag, radius)

	local d = player.GetDistanceToPlayer(unitTag)
	return d and radius - d >= 0 or false

end

-- Returns map distance, not meters
function player.GetDistanceToPoint(x2, y2)

	local x1, y1 = GetMapPlayerPosition('player')	
	return util.GetDistance(x1, y1, x2, y2)

end

function player.GetCurrentZoneId()
	return currentZoneId
end

function player.GetCurrentHouseId()
	return currentHouseId
end

function player.GetAliasForUserId(id, pretty)
	if not LCN then return id and UndecorateDisplayName(id) or '' end

	local user = LCN.Get(id, pretty)
	if user then return user end

	return id and UndecorateDisplayName(id) or '' -- just remove @

end

function player.GetIconForUserId(id)
	if not LCI then return nil end

	return LCI.GetStatic(id)
end
