-- SPDX-FileCopyrightText: 2025 m00nyONE andy.s
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/util")

local localPlayer = "player"

local util = {}
addon.util = util

-- generate classIcons table
local classIcons = {
    [0] = {
        texturePath = "esoui/art/campaign/campaignbrowser_guestcampaign.dds",
        left = 0,
        right = 1,
        top = 0,
        bottom = 1,
    },
}
for i = 1, GetNumClasses() do
    local realClassId, _, _, _, _, _, icon, _, _, _ = GetClassInfo(i)
    classIcons[realClassId] = {
        texturePath = icon,
        left = 0,
        right = 1,
        top = 0,
        bottom = 1,
    }
end

--[[ doc.lua begin ]]

--- calculate the distance between two units.
--- @param unitTag1 string unit tag of the first unit
--- @param unitTag2 string unit tag of the second unit
--- @return number|nil distance in meters, or nil if units are in different zones
function util.GetUnitDistanceToUnit(unitTag1, unitTag2)
    local zone1, x1, y1, z1 = GetUnitWorldPosition(unitTag1)
    local zone2, x2, y2, z2 = GetUnitWorldPosition(unitTag2)
    if zone1 == zone2 then
        return zo_distance3D(x1, y1, z1, x2, y2, z2) / 100
    end
end
--- calculate the distance between the local player and another unit.
--- @param unitTag string unit tag of the unit to measure distance to
--- @return number|nil distance in meters, or nil if units are in different zones
function util.GetPlayerDistanceToUnit(unitTag)
    return util.GetUnitDistanceToUnit(localPlayer, unitTag)
end
--- check if a unit is within a certain range of the player.
--- @param unitTag string unit tag of the unit to check
--- @param range number range in meters
--- @return boolean true if the unit is within range, false otherwise
function util.IsUnitInPlayersRange(unitTag, range)
    local distance = util.GetPlayerDistanceToUnit(unitTag)
    if distance and distance <= range then
        return true
    end
    return false
end
--- check if two units are within a certain range of each other.
--- @param unitTag1 string unit tag of the first unit
--- @param unitTag2 string unit tag of the second unit
--- @param range number range in meters
--- @return boolean true if the units are within range, false otherwise
function util.IsUnitInUnitsRange(unitTag1, unitTag2, range)
    local distance = util.GetUnitDistanceToUnit(unitTag1, unitTag2)
    if distance and distance <= range then
        return true
    end
    return false
end

--- Convert FFFFFF to 1, 1, 1
--- @param hex string hex color code without #, e.g. FFFFFF
--- @return number r red value between 0 and 1
--- @return number g green value between 0 and 1
--- @return number b blue value between 0 and 1
function util.Hex2RGB(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)) / 255, tonumber("0x" .. hex:sub(3, 4)) / 255, tonumber("0x" .. hex:sub(5, 6)) / 255
end

--- Convert 1, 1, 1 to FFFFFF
--- @param r number red value between 0 and 1
--- @param g number green value between 0 and 1
--- @param b number blue value between 0 and 1
--- @return string hex color code without #, e.g. FFFFFF
function util.RGB2Hex(r, g, b)
    return string.format("%.2x%.2x%.2x", zo_round(r * 255), zo_round(g * 255), zo_round(b * 255))
end

--- color code string
--- @param hex string hex color code with or without #, e.g. FFFFFF
--- @param str string string to color code
--- @return string color coded string
function util.ColorCode(hex, str)
    hex = hex:gsub("#", "")
    return string.format("|c%s%s|r", hex, str)
end

--- Remove duplicate values from a table.
--- Only works for simple tables like: 1=>'a', 2=>'b', 3=>'b'
--- @param t table
--- @return table
function util.TableUnique(t)
    local hash = {}
    local res = {}
    for _, v in ipairs(t) do
        if not hash[v] then
            res[#res+1] = v
            hash[v] = true
        end
    end
    return res
end

--- Check if the input is a string is valid (not nil and not empty).
--- @param s any
--- @return boolean
function util.IsValidString(s)
    return type(s) == 'string' and s ~= ''
end

--- Sorted pairs iterator for tables.
--- Usage:
--- for k, v in core.spairs(t, function(t, a, b) return t[a] > t[b] end) do
---     print(k, v)
--- end
--- @param t table
--- @param sortFunction function|nil optional sorting function
--- @return function iterator
function util.Spairs(t, sortFunction)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    if sortFunction then
        table.sort(keys, function(a,b) return sortFunction(t, a, b) end)
    else
        table.sort(keys)
    end
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

--- Get a unique reference string for a table.
--- @param t table
--- @return string reference string
function util.GetTableReference(t)
    return string.match(tostring(t), "0%x+")
end

--- sorts a table of modules/extensions by their priority field, and by name if priorities are equal
--- @param t table table of modules
--- @param a string key of the first module to compare
--- @param b string key of the second module to compare
--- @return boolean true if a should come before b, false otherwise
function util.SortByPriority(t, a, b)
    if t[a].priority == t[b].priority then
        return a < b
    end
    return t[a].priority < t[b].priority
end

-- user related functions

--- overwrite class icons with new ones.
--- This is used for some events. For example on christmas, class icons get overwritten by their christmas version.
--- @param newClassIcons table<number, string> {classId: number, texturePath: string}
--- @return void
function util.overwriteClassIcons(newClassIcons)
    for classId, classIconProperties in pairs(newClassIcons) do
        classIcons[classId] = classIconProperties
    end
end

--- get class icon for classId.
--- @param classId number
--- @return string, number, number, number, number texturePath, textureCoordsLeft, textureCoordsRight, textureCoordsTop, textureCoordsBottom
function util.GetClassIcon(userId, classId)
    local classIcon = classIcons[classId] or classIcons[0] -- fallback to to default icon if ID is not registered
    return classIcon.texturePath, classIcon.left, classIcon.right, classIcon.top, classIcon.bottom
end

--- get alias for userId.
--- @param userId string
--- @param pretty boolean if true, will return a colored name if available
--- @return string alias
function util.GetUserName(userId, pretty)
    return userId and UndecorateDisplayName(userId) or ''
end

--- get icon for userId.
--- @param userId string
--- @param classId number
--- @return string, number, number, number, number texturePath, textureCoordsLeft, textureCoordsRight, textureCoordsTop, textureCoordsBottom
function util.GetUserIcon(userId, classId)
    return util.GetClassIcon(userId, classId) -- returns texturePath, left, right, top, bottom
end

--- get font string for use in UI controls. -- see https://wiki.esoui.com/Fonts
--- @param fontStyle string|nil font style, e.g. "MEDIUM_FONT" or "BOLD_FONT"
--- @param fontSize number|nil font size, e.g. 18
--- @param fontWeight string|nil font weight, e.g. "outline" or "soft-shadow-thick"
--- @return string font string
function util.GetFontString(fontStyle, fontSize, fontWeight)
    return ZO_CachedStrFormat("$(<<1>>)|$(KB_<<2>>)|<<3>>", fontStyle or "BOLD_FONT", fontSize or 18, fontWeight or "outline")
end

function util.GetFontOptions(size)
    return {
        { name = "Default", data = util.GetFontString("BOLD_FONT", size, "outline")},
        { name = "Default Small", data = util.GetFontString("GAMEPAD_BOLD_FONT", size, "outline")},
        { name = "OldSchool", data = util.GetFontString("MEDIUM_FONT", size, "soft-shadow-thick")},
        { name = "OldSchool Small", data = util.GetFontString("GAMEPAD_MEDIUM_FONT", size, "soft-shadow-thick")},
    }
end

--[[ doc.lua end ]]