-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.logger.main

local util = {}
core.util = util

function util.GetDistance(x1, y1, x2, y2)
    return zo_sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

-- Convert FFFFFF to 1, 1, 1
function util.Hex2RGB(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)) / 255, tonumber("0x" .. hex:sub(3, 4)) / 255, tonumber("0x" .. hex:sub(5, 6)) / 255
end

-- Convert 1, 1, 1 to FFFFFF
function util.RGB2Hex(r, g, b)
    return string.format("%.2x%.2x%.2x", zo_round(r * 255), zo_round(g * 255), zo_round(b * 255))
end

-- color code string
function util.ColorCode(hex, str)
    return "|c" .. hex .. str .. "|r"
end

-- Remove duplicate values from a table.
-- Only works for simple tables like: 1=>'a', 2=>'b', 3=>'b'
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

-- Check if a string is valid (not nil and not empty).
function util.IsValidString(s)
    return type(s) == 'string' and s ~= ''
end

-- Sorted pairs iterator for tables.
-- Usage:
-- for k, v in core.spairs(t, function(t, a, b) return t[a] > t[b] end) do
--     print(k, v)
-- end
function util.spairs(t, sortFunction)
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

-- TODO: move to ListClass later
--- returns true if a list should be visible based on settings
--- @param listEnabledSV number setting value
--- @return boolean
function util.IsListVisible(listEnabledSV)
    if listEnabledSV == 1 then -- always show
        return true
    elseif listEnabledSV == 2 then -- show out of combat
        return not IsUnitInCombat(localPlayer)
    elseif listEnabledSV == 3 then -- show non bossfights
        return not IsUnitInCombat(localPlayer) or not DoesUnitExist(localBoss1) and not DoesUnitExist(localBoss2)
    else -- off
        return false
    end
end