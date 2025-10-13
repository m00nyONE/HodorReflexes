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

-- buff/debuff/cast trackers
-- TODO: barrier
function module:registerHornBuffTracker()
    local eventName = addon_name .. module_name .. "_HornBuff"
    for i, hornId in ipairs(self.hornBuffIds) do
        EM:UnregisterForEvent(eventName .. i, EVENT_EFFECT_CHANGED)
        EM:RegisterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, function(...) self:onHornBuff(...) end)
        EM:AddFilterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, hornId)
        EM:AddFilterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
    end
end
function module:registerMajorForceBuffTracker()
    local eventName = addon_name .. module_name .. "_MajorForceBuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, function(...) self:onMajorForceBuff(...) end)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.majorForceId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
end
function module:registerMajorBerserkBuffTracker()
    local eventName = addon_name .. module_name .. "_MajorBerserkBuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, function(...) self:onMajorBerserkBuff(...) end)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.majorBerserkId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
end
function module:registerMajorSlayerBuffTracker()
    local eventName = addon_name .. module_name .. "_MajorSlayerBuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, function(...) self:onMajorSlayerBuff(...) end)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.majorSlayerId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
end
function module:registerPillagerBuffTracker()
    local eventName = addon_name .. module_name .. "_PillagerBuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, function(...) self:onPillagerBuff(...) end)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.pillagerBuffId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
end
function module:registerMajorVulnerabilityDebuffTracker()
    local eventName = addon_name .. module_name .. "_MajorVulnerabilityDebuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, function(...) self:onMajorVulnerabilityDebuff(...) end)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.majorVulnerabilityId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_OTHER) -- only on enemies
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_TARGET_DUMMY) -- only on targetDummies
end
function module:registerAtroCastTracker()
    local eventName = addon_name .. module_name .. "_AtroCast"
    for i, atroId in ipairs(self.atroAbilityIds) do
        EM:UnregisterForEvent(eventName .. i, EVENT_COMBAT_EVENT)
        EM:RegisterForEvent(eventName .. i, EVENT_COMBAT_EVENT, function(...) self:onAtroCast(...) end)
        EM:AddFilterForEvent(eventName .. i, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, atroId)
        EM:AddFilterForEvent(eventName .. i, EVENT_COMBAT_EVENT, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
    end
end
-- onEvent handlers
-- TODO: barrier
function module:onHornBuff(eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, deprecatedBuffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED then
        local duration = (endTime - beginTime) * 1000
        CM:FireCallbacks(HR_EVENT_HORN_BUFF_GAINED, unitTag, duration)
    end
end
function module:onMajorForceBuff(eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, deprecatedBuffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED then
        local duration = (endTime - beginTime) * 1000
        CM:FireCallbacks(HR_EVENT_MAJOR_FORCE_BUFF_GAINED, unitTag, duration)
    end
end
function module:onMajorBerserkBuff(eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, deprecatedBuffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED then
        local duration = (endTime - beginTime) * 1000
        CM:FireCallbacks(HR_EVENT_MAJOR_BERSERK_BUFF_GAINED, unitTag, duration)
    end
end
function module:onMajorSlayerBuff(eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, deprecatedBuffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED then
        local duration = (endTime - beginTime) * 1000
        CM:FireCallbacks(HR_EVENT_MAJOR_SLAYER_BUFF_GAINED, unitTag, duration)
    end
end
function module:onPillagerBuff(eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, deprecatedBuffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED then
        local duration = (endTime - beginTime) * 1000
        CM:FireCallbacks(HR_EVENT_PILLAGER_BUFF_GAINED, unitTag, duration)
    end
end
function module:onMajorVulnerabilityDebuff(eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, deprecatedBuffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED then
        local duration = (endTime - beginTime) * 1000
        CM:FireCallbacks(HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED, unitTag, duration)
    end
end
function module:onAtroCast(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _)
    local duration = 15000 -- TODO: read duration from ability?
    CM:FireCallbacks(HR_EVENT_ATRO_CAST_STARTED, duration)
end