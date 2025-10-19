-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.initSubLogger("util")

local util = {}
addon.util = util

--[[ doc.lua begin ]]

--- calculate the distance between two points
--- @param x1 number x coordinate of point 1
--- @param y1 number y coordinate of point 1
--- @param x2 number x coordinate of point 2
--- @param y2 number y coordinate of point 2
--- @return number distance between point 1 and point 2
function util.GetDistance(x1, y1, x2, y2)
    return zo_sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
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
--- @param hex string hex color code without #, e.g. FFFFFF
--- @param str string string to color code
--- @return string color coded string
function util.ColorCode(hex, str)
    return "|c" .. hex .. str .. "|r"
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
function util.sortByPriority(t, a, b)
    if t[a].priority == t[b].priority then
        return a < b
    end
    return t[a].priority < t[b].priority
end

-- user related functions

local classIcons = nil
--- overwrite class icons with new ones.
--- This is used for some events. For example on christmas, class icons get overwritten by their christmas version.
--- @param newClassIcons table<number, string> {classId: number, texturePath: string}
--- @return void
function util.overwriteClassIcons(newClassIcons)
    for classId, icon in pairs(newClassIcons) do
        classIcons[classId] = icon
    end
end

--- get class icon for classId.
--- @param classId number
--- @return string, number, number, number, number texturePath (falls back to "campaignbrowser_guestcampaign.dds" if the icon is not found), textureCoordsLeft, textureCoordsRight, textureCoordsTop, textureCoordsBottom
function util.GetClassIcon(classId)
    if not classIcons then
        classIcons = {}
        for i = 1, GetNumClasses() do
            local realClassId, _, _, _, _, _, icon, _, _, _ = GetClassInfo(i)
            classIcons[realClassId] = icon
        end
    end

    local texturePath = classIcons[classId]
    if not texturePath then
        texturePath = "esoui/art/campaign/campaignbrowser_guestcampaign.dds"
    end
    return texturePath, 0, 1, 0, 1
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
    return util.GetClassIcon(classId), 0, 1, 0, 1
end

--[[ doc.lua end ]]