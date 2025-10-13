-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "ult"
local module = addon_modules[module_name]

local EM = GetEventManager()
local CM = core.CM

local HR_EVENT_MAJOR_FORCE_BUFF_GAINED = "HR_EVENT_MAJOR_FORCE_BUFF_GAINED"
local HR_EVENT_MAJOR_BERSERK_BUFF_GAINED = "HR_EVENT_MAJOR_BERSERK_BUFF_GAINED"
local HR_EVENT_MAJOR_SLAYER_BUFF_GAINED = "HR_EVENT_MAJOR_SLAYER_BUFF_GAINED"
local HR_EVENT_PILLAGER_BUFF_GAINED = "HR_EVENT_PILLAGER_BUFF_GAINED"
local HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED = "HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED"
local HR_EVENT_HORN_BUFF_GAINED = "HR_EVENT_HORN_BUFF_GAINED"
local HR_EVENT_ATRO_CAST_STARTED = "HR_EVENT_ATRO_CAST_STARTED"
addon.HR_EVENT_MAJOR_FORCE_BUFF_GAINED = HR_EVENT_MAJOR_FORCE_BUFF_GAINED
addon.HR_EVENT_MAJOR_BERSERK_BUFF_GAINED = HR_EVENT_MAJOR_BERSERK_BUFF_GAINED
addon.HR_EVENT_MAJOR_SLAYER_BUFF_GAINED = HR_EVENT_MAJOR_SLAYER_BUFF_GAINED
addon.HR_EVENT_PILLAGER_BUFF_GAINED = HR_EVENT_PILLAGER_BUFF_GAINED
addon.HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED = HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED
addon.HR_EVENT_HORN_BUFF_GAINED = HR_EVENT_HORN_BUFF_GAINED
addon.HR_EVENT_ATRO_CAST_STARTED = HR_EVENT_ATRO_CAST_STARTED
-- TODO: barrier

function module:registerBuffTrackers()
    self:registerHornBuffTracker()
    self:registerMajorForceBuffTracker()
    self:registerMajorBerserkBuffTracker()
    self:registerMajorSlayerBuffTracker()
    self:registerPillagerBuffTracker()
    self:registerMajorVulnerabilityDebuffTracker()
    self:registerAtroCastTracker()
end

-- onEvent handlers
local function onEffectChangedHandler(eventToFire, eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, deprecatedBuffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if GetGameTimeSeconds() >= endTime then return end -- effect already expired

    local duration = (endTime - beginTime) * 1000
    CM:FireCallbacks(eventToFire, unitTag, duration)
    --d(eventToFire .. " from: " .. unitTag .. " d: " .. tostring(duration) .. " ct: " .. string.format("%0.1f", GetGameTimeSeconds()) .. " bt: " .. string.format("%0.1f", beginTime) .. " et: " .. string.format("%0.1f", endTime))
end
local function onCombatEventHandler(eventToFire, _, _, _, _, _, _, sourceName, _, _, _, _, _, _, _, _, _, abilityId, _)
    local duration = GetAbilityDuration(abilityId)
    CM:FireCallbacks(eventToFire, sourceName, duration)
    --d("fired " .. eventToFire .. " for " .. sourceName .. " with duration " .. tostring(duration))
end

-- buff/debuff/cast trackers
function module:registerHornBuffTracker()
    local eventName = addon_name .. module_name .. "_HornBuff"
    for i, hornId in ipairs(self.hornBuffIds) do
        EM:UnregisterForEvent(eventName .. i, EVENT_EFFECT_CHANGED)
        EM:RegisterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, function(...) onEffectChangedHandler(HR_EVENT_HORN_BUFF_GAINED, ...) end)
        EM:AddFilterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, hornId)
        EM:AddFilterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, REGISTER_FILTER_COMBAT_RESULT, EFFECT_RESULT_UPDATED)
        EM:AddFilterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
    end
end
function module:registerMajorForceBuffTracker()
    local eventName = addon_name .. module_name .. "_MajorForceBuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, function(...) onEffectChangedHandler(HR_EVENT_MAJOR_FORCE_BUFF_GAINED, ...) end)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.majorForceId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_COMBAT_RESULT, EFFECT_RESULT_UPDATED)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
end
function module:registerMajorBerserkBuffTracker()
    local eventName = addon_name .. module_name .. "_MajorBerserkBuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, function(...) onEffectChangedHandler(HR_EVENT_MAJOR_BERSERK_BUFF_GAINED, ...) end)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.majorBerserkId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_COMBAT_RESULT, EFFECT_RESULT_UPDATED)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
end
function module:registerMajorSlayerBuffTracker()
    local eventName = addon_name .. module_name .. "_MajorSlayerBuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, function(...) onEffectChangedHandler(HR_EVENT_MAJOR_SLAYER_BUFF_GAINED, ...) end)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.majorSlayerId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_COMBAT_RESULT, EFFECT_RESULT_UPDATED)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
end
function module:registerPillagerBuffTracker()
    local eventName = addon_name .. module_name .. "_PillagerBuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, function(...) onEffectChangedHandler(HR_EVENT_PILLAGER_BUFF_GAINED, ...) end)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.pillagerBuffId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_COMBAT_RESULT, EFFECT_RESULT_UPDATED)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
end
function module:registerMajorVulnerabilityDebuffTracker()
    local eventName = addon_name .. module_name .. "_MajorVulnerabilityDebuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, function(...) onEffectChangedHandler(HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED, ...) end)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.majorVulnerabilityId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_COMBAT_RESULT, EFFECT_RESULT_UPDATED)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_OTHER, COMBAT_UNIT_TYPE_TARGET_DUMMY) -- only on enemies & target dummies
end
function module:registerAtroCastTracker()
    local eventName = addon_name .. module_name .. "_AtroCast"
    for i, atroId in ipairs(self.atroAbilityIds) do
        EM:UnregisterForEvent(eventName .. i, EVENT_COMBAT_EVENT)
        EM:RegisterForEvent(eventName .. i, EVENT_COMBAT_EVENT, function(...) onCombatEventHandler(HR_EVENT_ATRO_CAST_STARTED, ...) end)
        EM:AddFilterForEvent(eventName .. i, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, atroId)
        EM:AddFilterForEvent(eventName .. i, EVENT_COMBAT_EVENT, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
    end
end
