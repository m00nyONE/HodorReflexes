-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local group = core.group
local LGCS = LibGroupCombatStats

local EVENT_GROUP_ULT_UPDATE = LGCS.EVENT_GROUP_ULT_UPDATE
local EVENT_PLAYER_ULT_UPDATE = LGCS.EVENT_PLAYER_ULT_UPDATE

local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED
local HR_EVENT_TEST_TICK = addon.HR_EVENT_TEST_TICK

local moduleDefinition = {
    name = "ult",
    friendlyName = GetString(HR_MODULES_ULT_FRIENDLYNAME),
    description = GetString(HR_MODULES_ULT_DESCRIPTION),
    version = "1.0.0",
    priority = 1,
    enabled = false,
    svVersion = 1,
    svDefault = {
        accountWide = true,
    },

    isTestRunning = false,

    majorForceId = 61747,
    majorVulnerabilityId = 106754,
    majorBerserkId = 61745,
    majorSlayerId = 93109,
    hornBuffIds = {38564, 40221, 40224},
    pillagerBuffId = 17055,
    pillagerCooldownId = 172056,

    hornAbilityIds = {40223, 38563, 40220},
    colosAbilityIds = {122388, 122395, 122174},
    atroAbilityIds = {23634, 23492, 23495},
    barrierAbilityIds = {40237,	40239, 38573},
    cryptCannonAbilityIds = {195031},

    hornIcon = GetAbilityIcon(38563),
    forceIcon = GetAbilityIcon(61747),
    colosIcon = GetAbilityIcon(122174),
    vulnIcon = GetAbilityIcon(122174), -- we use colos icon here because nobody knows how the vuln icon looks like
    atroIcon = GetAbilityIcon(23492),
    berserkIcon = GetAbilityIcon(23492), -- we use the atro icon here because nobody knows how the berserk icon looks like
    barrierIcon = GetAbilityIcon(40237),
    slayerIcon = GetAbilityIcon(93109),
    cryptCannonIcon = GetAbilityIcon(195031),
    pillagerIcon = "esoui/art/icons/ability_healer_030.dds",

    pillagerCooldownEndTime = 0,
}

local module = internal.moduleClass:New(moduleDefinition)

--- handle ULT data received from LGCS
--- @param tag string
--- @param data table
--- @return void
function module:onULTDataReceived(tag, data)
    if not IsUnitGrouped(tag) then return end

    local ultValue = data.ultValue
    local ult1Cost = data.ult1Cost
    local ult2Cost = data.ult2Cost
    local ult1Percentage = self:getUltPercentage(ultValue, ult1Cost)
    local ult2Percentage = self:getUltPercentage(ultValue, ult2Cost)
    local lowestUltPercentage = zo_min(ult1Percentage, ult2Percentage)

    group.CreateOrUpdatePlayerData({
        name = GetUnitName(tag),
        tag  = tag,
        ultValue = ultValue,
        ult1ID = data.ult1ID,
        ult2ID = data.ult2ID,
        ult1Cost = ult1Cost,
        ult2Cost = ult2Cost,
        ult1Percentage = ult1Percentage,
        ult2Percentage = ult2Percentage,
        lowestUltPercentage = lowestUltPercentage,
        -- special ults
        hasHorn = self:hasUnitHorn(data),
        hasColos = self:hasUnitColos(data),
        hasAtro = self:hasUnitAtro(data),
        hasBarrier = self:hasUnitBarrier(data),
        hasCryptCannon = self:hasUnitCryptCannon(data),
        -- ult activated sets
        hasSaxhleel = self:hasUnitSaxhleel(data),
        hasMAorWM = self:hasUnitMAorWM(data),
        hasPillager = self:hasUnitPillager(data),
        ultActivatedSetID = data.ultActivatedSetID, -- TODO: remove after reworking LGCS
    })
end

--- module activation function
--- @return void
function module:Activate()
    self.logger:Debug("activated ult module")

    local registerName = addon_name .. module.name

    local lgcs = LGCS.RegisterAddon(registerName, {"ULT"})
    if not lgcs then
        self.logger:Warn("Failed to register %s with LibGroupCombatStats.", registerName)
        return
    end

    lgcs:RegisterForEvent(EVENT_PLAYER_ULT_UPDATE, function(...) self:onULTDataReceived(...) end)
    lgcs:RegisterForEvent(EVENT_GROUP_ULT_UPDATE, function(...) self:onULTDataReceived(...) end)

    addon.RegisterCallback(HR_EVENT_TEST_STARTED, function(...) self:startTest(...) end)
    addon.RegisterCallback(HR_EVENT_TEST_STOPPED, function(...) self:stopTest(...) end)
    addon.RegisterCallback(HR_EVENT_TEST_TICK, function(...) self:updateTest(...) end)

    group.RegisterPlayersDataFields({
        ultValue = 0,
        ult1ID = 0,
        ult2ID = 0,
        ult1Cost = 0,
        ult2Cost = 0,
        ult1Percentage = 0,
        ult2Percentage = 0,
        lowestUltPercentage = 0,
        -- special ults
        hasHorn = false,
        hasColos = false,
        hasAtro = false,
        hasBarrier = false,
        hasCryptCannon = false,
        -- ult activated sets
        hasSaxhleel = false,
        hasMAorWM = false,
        hasPillager = false,
        ultActivatedSetID = 0, -- TODO: remove after reworking LGCS later
    })

    self:RunOnce("registerTrackers")
    self:RunOnce("CreateLists")
end

--- create scrollLists for the module
function module:CreateLists()
    self:RunOnce("CreateHornList")
    self:RunOnce("CreateColosList")
    self:RunOnce("CreateAtroList")
    self:RunOnce("CreateMiscList")
    self:RunOnce("CreateCompactList")
end

