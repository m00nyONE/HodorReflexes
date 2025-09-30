-- SPDX-FileCopyrightText: 2025 andy.s m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local extension = {
    name = "util",
    version = "1.0.0",
}
local extension_name = extension.name
local extension_version = extension.version

addon[extension_name] = extension

local strformat = string.format

-- Returns map distance, not meters
function extension.GetDistance(x1, y1, x2, y2)

	return zo_sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)

end

-- Convert FFFFFF to 1, 1, 1
function extension.Hex2RGB(hex)

    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)) / 255, tonumber("0x" .. hex:sub(3, 4)) / 255, tonumber("0x" .. hex:sub(5, 6)) / 255

end

-- Convert 1, 1, 1 to FFFFFF
function extension.RGB2Hex(r, g, b)

	return strformat("%.2x%.2x%.2x", zo_round(r * 255), zo_round(g * 255), zo_round(b * 255))

end

-- color code string
function extension.ColorCode(hex, str)
	return "|c" .. hex .. str .. "|r"
end

-- Remove duplicate values from a table.
-- Only works for simple tables like: 1=>'a', 2=>'b', 3=>'b'
function extension.TableUnique(t)

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

function extension.IsValidString(s)
	return type(s) == 'string' and s ~= ''
end


function extension.spairs(t, sortFunction) -- thanks @Solinur <3

    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if sortFunction given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if sortFunction then
        table.sort(keys, function(a,b) return sortFunction(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end