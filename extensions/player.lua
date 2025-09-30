-- SPDX-FileCopyrightText: 2025 andy.s m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]

-- Some shortcuts to create HUD fragments.
local extension = {
    name = "player",
    version = "1.0.0",
}
local extension_name = extension.name
local extension_version = extension.version

addon[extension_name] = extension

local util = addon.util
local localPlayer = "player"

local LCI = LibCustomIcons
local LCN = LibCustomNames

local currentZoneId = 0
local currentHouseId = 0

function extension.Initialize()

	currentZoneId = GetZoneId(GetUnitZoneIndex(localPlayer))
	currentHouseId = GetCurrentZoneHouseId()

end

-- Returns map distance, not meters
function extension.GetDistanceToPlayer(unitTag)

	--local x2, y2, h2, m2 = GetMapPlayerPosition(unitTag)
	local x2, y2, _, m2 = GetMapPlayerPosition(unitTag)
	if not m2 then return nil end -- not on the same map
	local x1, y1 = GetMapPlayerPosition(localPlayer)
	return util.GetDistance(x1, y1, x2, y2)

end

-- Returns distance to player in meters or false if players are in different zones.
function extension.GetDistanceToPlayerM(unitTag)

	local zone1, x1, y1, z1 = GetUnitWorldPosition(localPlayer)
	local zone2, x2, y2, z2 = GetUnitWorldPosition(unitTag)

	if zone1 == zone2 then
		return zo_sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2) / 100
	end
end

-- Checks map distance, not meters (using "radius" param)
function extension.IsCloseToPlayer(unitTag, radius)

	local d = extension.GetDistanceToPlayer(unitTag)
	return d and radius - d >= 0 or false

end

-- Returns map distance, not meters
function extension.GetDistanceToPoint(x2, y2)

	local x1, y1 = GetMapPlayerPosition(localPlayer)
	return util.GetDistance(x1, y1, x2, y2)

end

function extension.GetCurrentZoneId()
	return currentZoneId
end

function extension.GetCurrentHouseId()
	return currentHouseId
end

function extension.GetAliasForUserId(id, pretty)
	if not LCN then return id and UndecorateDisplayName(id) or '' end

	local user = LCN.Get(id, pretty)
	if user then return user end

	return id and UndecorateDisplayName(id) or '' -- just remove @

end

function extension.GetIconForUserId(id)
	if not LCI then return nil end

	return LCI.GetStatic(id)
end
