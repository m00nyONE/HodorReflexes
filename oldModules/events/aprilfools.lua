local HR = HodorReflexes
local M = HR.modules.events
local MS = HR.modules.share

local function overwriteDamageSorting()
     MS.sortByDamage = function(b, a)
        if a[3] == b[3] then return a[2] > b[2] end
        return a[3] > b[3] -- sort by damage type
    end
end


local function Initialize()
    if M.date == "0104"then
        overwriteDamageSorting()
    end
end

M.RegisterEvent(Initialize)