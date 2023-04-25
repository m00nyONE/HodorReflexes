HodorReflexes.util = {}

local HR = HodorReflexes
local util = HR.util

local strformat = string.format

-- Returns map distance, not meters
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

	return strformat("%.2x%.2x%.2x", zo_round(r * 255), zo_round(g * 255), zo_round(b * 255))

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