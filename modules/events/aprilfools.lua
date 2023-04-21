local HR = HodorReflexes
local M = HR.modules.events
local MS = HR.modules.share
local u = HR.users
local a = HR.anim.users

local uArray = {}
local aArray = {}

local function getRandomEntry(iTable)
    local randIndex = zo_random(1, #iTable)
    return iTable[randIndex]
end

local function fillArrays()
    -- create indexable array from user animations
    for _, anim in pairs(a) do
        table.insert(aArray, anim)
    end

    -- create indexable array from user icons
    for _, user in pairs(u) do
        if user[3] then
            table.insert(uArray, user[3])
        end
    end
end

local function replaceIconsAndAnimations()
    for user, _ in pairs(u) do
        u[user][3] = getRandomEntry(uArray)
        a[user] = getRandomEntry(aArray)
    end
end

local function overwriteDamageSorting()
     MS.sortByDamage = function(b, a)
        if a[3] == b[3] then return a[2] > b[2] end
        return a[3] > b[3] -- sort by damage type
    end
end


local function Initialize()
    if M.date == "0104"then
        fillArrays()
        replaceIconsAndAnimations()
        overwriteDamageSorting()
    end
end

M.RegisterEvent(Initialize)