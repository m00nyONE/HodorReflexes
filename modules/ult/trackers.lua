-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
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
local HR_EVENT_PILLAGER_BUFF_COOLDOWN = "HR_EVENT_PILLAGER_BUFF_COOLDOWN"
local HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED = "HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED"
local HR_EVENT_HORN_BUFF_GAINED = "HR_EVENT_HORN_BUFF_GAINED"
local HR_EVENT_ATRO_CAST_STARTED = "HR_EVENT_ATRO_CAST_STARTED"
addon.HR_EVENT_MAJOR_FORCE_BUFF_GAINED = HR_EVENT_MAJOR_FORCE_BUFF_GAINED
addon.HR_EVENT_MAJOR_BERSERK_BUFF_GAINED = HR_EVENT_MAJOR_BERSERK_BUFF_GAINED
addon.HR_EVENT_MAJOR_SLAYER_BUFF_GAINED = HR_EVENT_MAJOR_SLAYER_BUFF_GAINED
addon.HR_EVENT_PILLAGER_BUFF_GAINED = HR_EVENT_PILLAGER_BUFF_GAINED
addon.HR_EVENT_PILLAGER_BUFF_COOLDOWN = HR_EVENT_PILLAGER_BUFF_COOLDOWN
addon.HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED = HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED
addon.HR_EVENT_HORN_BUFF_GAINED = HR_EVENT_HORN_BUFF_GAINED
addon.HR_EVENT_ATRO_CAST_STARTED = HR_EVENT_ATRO_CAST_STARTED


--- when registering for effect changes, we only use the UPDATED result, as this is also fired when an effect is applied.
--- This avoids double triggers when an effect is applied (GAINED and UPDATED are fired in sequence).
--- The register parts are scoped in do ... end blocks to avoid name clashes.
--- The Handlers are generic functions returning the actual handler functions to avoid code duplication.
--- @return void
function module:registerTrackers()
    -- handlers
    local function getEffectChangedHandler(eventToFire)
        return function(eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
            if GetGameTimeSeconds() >= endTime then return end -- effect already expired
            local duration = (endTime - beginTime) * 1000
            CM:FireCallbacks(eventToFire, unitTag, duration)
            self.logger:Debug("fired %s for %s with duration %s", eventToFire, unitTag, tostring(duration))
        end
    end
    local function getCombatEventHandler(eventToFire)
        return function(eventId, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow)
            local duration = GetAbilityDuration(abilityId)
            CM:FireCallbacks(eventToFire, sourceName, duration)
            self.logger:Debug("fired %s for %s with duration %s", eventToFire, sourceName, tostring(duration))
        end
    end

    -- define trackers ( scoped by do ... end to avoid name clashes )
    do -- horn buff tracker
        local eventName = addon_name .. module_name .. "HornBuff"
        for i, hornId in ipairs(self.hornBuffIds) do
            EM:UnregisterForEvent(eventName .. i, EVENT_EFFECT_CHANGED)
            EM:RegisterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, getEffectChangedHandler(HR_EVENT_HORN_BUFF_GAINED))
            EM:AddFilterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, hornId)
            EM:AddFilterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, REGISTER_FILTER_COMBAT_RESULT, EFFECT_RESULT_UPDATED)
            EM:AddFilterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
        end
    end

    do -- major force buff tracker
        local eventName = addon_name .. module_name .. "MajorForceBuff"
        EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
        EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, getEffectChangedHandler(HR_EVENT_MAJOR_FORCE_BUFF_GAINED))
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.majorForceId)
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_COMBAT_RESULT, EFFECT_RESULT_UPDATED)
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
    end

    do -- major berserk buff tracker
        local eventName = addon_name .. module_name .. "MajorBerserkBuff"
        EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
        EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, getEffectChangedHandler(HR_EVENT_MAJOR_BERSERK_BUFF_GAINED))
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.majorBerserkId)
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_COMBAT_RESULT, EFFECT_RESULT_UPDATED)
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
    end

    do -- major slayer buff tracker
        local eventName = addon_name .. module_name .. "MajorSlayerBuff"
        EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
        EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, getEffectChangedHandler(HR_EVENT_MAJOR_SLAYER_BUFF_GAINED))
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.majorSlayerId)
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_COMBAT_RESULT, EFFECT_RESULT_UPDATED)
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
    end

    do -- pillager buff tracker
        local eventName = addon_name .. module_name .. "PillagerBuff"
        EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
        EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, getEffectChangedHandler(HR_EVENT_PILLAGER_BUFF_GAINED))
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.pillagerBuffId)
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_COMBAT_RESULT, EFFECT_RESULT_UPDATED)
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
    end

    addon.RegisterCallback(HR_EVENT_PILLAGER_BUFF_GAINED, function(unitTag, _)
        -- when pillager buff is gained, start cooldown tracker
        CM:FireCallbacks(HR_EVENT_PILLAGER_BUFF_COOLDOWN, unitTag, 45000) -- fixed 45s cooldown
    end)

    do -- major vulnerability debuff tracker
        local eventName = addon_name .. module_name .. "MajorVulnerabilityDebuff"
        EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
        EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, getEffectChangedHandler(HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED))
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, self.majorVulnerabilityId)
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_COMBAT_RESULT, EFFECT_RESULT_UPDATED)
        EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_OTHER, COMBAT_UNIT_TYPE_TARGET_DUMMY) -- only on enemies & target dummies
    end

    do -- atro cast start trackers
        local eventName = addon_name .. module_name .. "AtroCast"
        for i, atroId in ipairs(self.atroAbilityIds) do
            EM:UnregisterForEvent(eventName .. i, EVENT_COMBAT_EVENT)
            EM:RegisterForEvent(eventName .. i, EVENT_COMBAT_EVENT, getCombatEventHandler(HR_EVENT_ATRO_CAST_STARTED))
            EM:AddFilterForEvent(eventName .. i, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, atroId)
        end
    end
end
