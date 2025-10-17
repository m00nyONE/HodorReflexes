-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules
local addon_extensions = addon.extensions

local module_name = "dps"
local module = addon_modules[module_name]

local combat = addon_extensions.combat

local LGCS = LibGroupCombatStats
local EM = GetEventManager()

local DAMAGE_UNKNOWN = LGCS.DAMAGE_UNKNOWN
local DAMAGE_TOTAL = LGCS.DAMAGE_TOTAL
local DAMAGE_BOSS = LGCS.DAMAGE_BOSS

local HR_EVENT_COMBAT_START = addon.HR_EVENT_COMBAT_START
local HR_EVENT_COMBAT_END = addon.HR_EVENT_COMBAT_END

-- sorting functions

--- sort by name descending
--- @param a table
--- @param b table
--- @return boolean
function module.sortByName(a, b)
    return a.name > b.name
end
--- sort by damage descending
--- @param a table
--- @param b table
--- @return boolean
function module.sortByDamage(a, b)
    if a.dmg == b.dmg then
        return module.sortByName(a, b)
    end
    return a.dmg > b.dmg
end
--- sort by damageType descending
--- @param a table
--- @param b table
--- @return boolean
function module.sortByDamageType(a, b)
    if a.dmgType == b.dmgType then
        return module.sortByDamage(a, b)
    end
    return a.dmgType > b.dmgType
end


-- formatting functions

--- get header format for damage list.
--- @return string
function module.getDamageHeaderFormat(dmgType, colorDamageBoss, colorDamageTotal)
    if dmgType == DAMAGE_TOTAL then
        return string.format('|c%s%s|r |c%s(DPS)|r', colorDamageBoss, GetString(HR_MODULES_DPS_DAMAGE_TOTAL), colorDamageTotal)
    elseif dmgType == DAMAGE_BOSS then
        return string.format('|c%s%s|r |c%s(%s)|r', colorDamageBoss, GetString(HR_MODULES_DPS_DPS_BOSS), colorDamageTotal, GetString(HR_MODULES_DPS_DPS_TOTAL))
    elseif dmgType == DAMAGE_UNKNOWN then
        return string.format('|c%s%s|r', colorDamageBoss, GetString(HR_MODULES_DPS_DAMAGE))
    end

    return string.format('|c%s%s|r |c%s(DPS)|r', colorDamageBoss, GetString(HR_MODULES_DPS_DAMAGE_MISC), colorDamageTotal)
end
--- get row format for damage list.
--- @return string
function module.getDamageRowFormat(dmgType, dmg, dps, colorDamageBoss, colorDamageTotal)
    if dmgType == DAMAGE_TOTAL then
        return string.format('|c%s%0.2fM|r |c%s(%dK)|r|u0:2::|u', colorDamageBoss, dmg / 100, colorDamageTotal, dps)
    end

    return string.format('|c%s%0.1fK|r |c%s(%dK)|r|u0:2::|u', colorDamageBoss, dmg / 10, colorDamageTotal, dps)
end

--- renders the current fight time to the control passed as argument. can be used by custom themes as well.
--- @param control LabelControl
--- @return void
function module.RenderFightTimeToControl(control)
    -- it would be more expensive here to check if the list is visible and prevent the rendering of the text than just rendering it anyways
    local t = combat:GetCombatTime()
    control:SetText(t > 0 and string.format("%d:%04.1f|u0:2::|u", t / 60, t % 60) or "")
end

--- creates and registers a fight time updater on the control passed as argument. can be used by custom themes as well.
--- @param control LabelControl
--- @return void
function module:CreateFightTimeUpdaterOnControl(list, control)
    -- check if timer is already registered - if so, return
    if control._onCombatStart or control._onCombatStop then return end

    local function renderFightTimeToControl()
        self.RenderFightTimeToControl(control)
    end

    -- reate timer start & stop functions
    control._onCombatStop = function()
        renderFightTimeToControl()
        EM:UnregisterForUpdate(list._eventId .. "TimerUpdate")
    end
    control._onCombatStart = function()
        control._onCombatStop()
        EM:RegisterForUpdate(list._eventId .. "TimerUpdate", list.sv.timerUpdateInterval, renderFightTimeToControl)
    end
    -- register timer update callbacks
    addon.RegisterCallback(HR_EVENT_COMBAT_START, control._onCombatStart)
    addon.RegisterCallback(HR_EVENT_COMBAT_END, control._onCombatStop)
end