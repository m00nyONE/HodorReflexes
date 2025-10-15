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
local custom = addon_extensions.custom

local LGCS = LibGroupCombatStats
local DAMAGE_UNKNOWN = LGCS.DAMAGE_UNKNOWN

local HR_EVENT_COMBAT_START = addon.HR_EVENT_COMBAT_START
local HR_EVENT_COMBAT_END = addon.HR_EVENT_COMBAT_END

local EM = GetEventManager()

local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowPosLeft = 10,
    windowPosTop = 50,
    windowWidth = 227,

    listHeaderHeight = 22,
    listRowHeight = 22,

    listHeaderOpacity = 0.8,
    listRowEvenOpacity = 0.65,
    listRowOddOpacity = 0.45,
    listPlayerHighlightColor = {0, 1, 0, 0.36}, -- green

    colorDamageTotal = "faffb2", -- light yellow
    colorDamageBoss = "b2ffb2", -- light green

    timerUpdateInterval = 100, -- ms
}

function module:CreateDamageList()
    local listDefinition = {
        name = "damage",
        svDefault = svDefault,
        Update = function() self:UpdateDamageList() end,
    }
    self.damageList = internal.listClass:New(listDefinition)

    self.damageList.HEADER_TYPE = 1 -- type id for header
    self.damageList.ROW_TYPE = 2    -- type id for rows
    self.damageList.SUMMARY_TYPE = 3 -- type id for summary
    self.damageList.HEADER_TEMPLATE = "HodorReflexes_Dps_DamageList_Header"
    self.damageList.ROW_TEMPLATE = "HodorReflexes_Dps_DamageList_DamageRow"
    self.damageList.SUMMARY_TEMPLATE = "HodorReflexes_Dps_DamageList_Summary"

    local function headerRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            wrappedFunction(self, rowControl, data, scrollList)
        end
    end

    local function damageRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            -- only create rows if conditions are met
            if data.dmg > 0 and (self.isTestRunning or IsUnitOnline(data.tag)) then
                wrappedFunction(self, rowControl, data, scrollList)
            end
        end
    end

    local function summaryRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            if data.groupDPS > 0 then
                wrappedFunction(self, rowControl, data, scrollList)
            end
        end
    end

    ZO_ScrollList_AddDataType(
            self.damageList.listControl,
            self.damageList.HEADER_TYPE,
            self.damageList.HEADER_TEMPLATE,
            self.damageList.sw.listHeaderHeight,
            headerRowCreationWrapper(self.headerRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(self.damageList.listControl, self.damageList.HEADER_TYPE, true)

    ZO_ScrollList_AddDataType(
            self.damageList.listControl,
            self.damageList.ROW_TYPE,
            self.damageList.ROW_TEMPLATE,
            self.damageList.sw.listRowHeight,
            damageRowCreationWrapper(self.damageRowCreationFunction)
    )

    ZO_ScrollList_AddDataType(
            self.damageList.listControl,
            self.damageList.SUMMARY_TYPE,
            self.damageList.SUMMARY_TEMPLATE,
            self.damageList.sw.listRowHeight,
            summaryRowCreationWrapper(self.summaryRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(self.damageList.listControl, self.damageList.SUMMARY_TYPE, true)
end

--- renders the current fight time to the control passed as argument.
--- @param control LabelControl
--- @return void
function module.RenderFightTimeToControl(control)
    local t = combat:GetCombatTime()
    control:SetText(t > 0 and string.format("%d:%04.1f|u0:2::|u", t / 60, t % 60) or "")
end

function module:headerRowCreationFunction(rowControl, data, scrollList)
    rowControl:GetNamedChild("_Title"):SetText(self.getDamageHeaderFormat(data.dmgType, self.damageList.sw.colorDamageBoss, self.damageList.sw.colorDamageTotal))
    rowControl:GetNamedChild("_BG"):SetAlpha(self.damageList.sw.listHeaderOpacity)
    local timeControl = rowControl:GetNamedChild("_Time")
    local function onCombatStop()
        self.RenderFightTimeToControl(timeControl)
        EM:UnregisterForUpdate(self.damageList._eventId .. "TimerUpdate")
    end
    local function onCombatStart()
        onCombatStop()
        EM:RegisterForUpdate(self.damageList._eventId .. "TimerUpdate", self.damageList.sv.timerUpdateInterval, function() self.RenderFightTimeToControl(timeControl) end)
    end

    addon.RegisterCallback(HR_EVENT_COMBAT_START, onCombatStart)
    addon.RegisterCallback(HR_EVENT_COMBAT_END, onCombatStop)
end

function module:damageRowCreationFunction(rowControl, data, scrollList)
    local userName = custom.GetAliasForUserId(data.userId, true)
    local userIcon = custom.GetIconForUserId(data.userId)
    local defaultIcon = custom.GetClassIcon(data.classId)

    local nameControl = rowControl:GetNamedChild('_Name')
    nameControl:SetText(userName)
    nameControl:SetColor(1, 1, 1)
    local iconControl = rowControl:GetNamedChild('_Icon')
    iconControl:SetTextureCoords(0, 1, 0, 1)
    iconControl:SetTexture(defaultIcon)

    local valueControl = rowControl:GetNamedChild("_Value")
    valueControl:SetText(self.getDamageRowFormat(data.dmgType, data.dmg, data.dps, self.damageList.sw.colorDamageBoss, self.damageList.sw.colorDamageTotal))
    valueControl:SetFont("$(GAMEPAD_MEDIUM_FONT)|$(KB_19)|outline")

    local customColor = false
    if data.isPlayer then
        local r, g, b, o = unpack(self.damageList.sw.listPlayerHighlightColor)
        if o ~= 0 then
            customColor = true
            rowControl:GetNamedChild('_BG'):SetColor(r, g, b, o or 0.5)
        end
    end
    if not customColor then
        rowControl:GetNamedChild('_BG'):SetColor(0, 0, 0, zo_mod(data.orderIndex, 2) == 0 and self.damageList.sw.listRowEvenOpacity or self.damageList.sw.listRowOddOpacity)
    end
end

function module:summaryRowCreationFunction(rowControl, data, scrollList)
    rowControl:GetNamedChild("_Title"):SetText("Group Total:")
    local str = string.format("%0.1fK (%0.1fK/10s)", data.groupDPS / 1000, data.groupDPS10sec / 1000)
    rowControl:GetNamedChild("_Value"):SetText(str)
end

function module:UpdateDamageList()
    local listControl = self.damageList.listControl

    local dmgType = DAMAGE_UNKNOWN

    ZO_ScrollList_Clear(listControl)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    local playersDataList = {}
    for _, playerData in pairs(addon.playersData) do
        if playerData.dmg > 0 then
            dmgType = playerData.dmgType
            table.insert(playersDataList, playerData)
        end
    end
    table.sort(playersDataList, self.sortByDamageType)

    -- insert header row
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.damageList.HEADER_TYPE, {
        dmgType = dmgType,
    }))

    -- insert damageRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.damageList.ROW_TYPE, playerData))
    end

    if #playersDataList > 0 then
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.damageList.SUMMARY_TYPE, {
            groupDPS = combat:GetGroupDPSOut(),
            groupDPS10sec = combat:GetGroupDPSOverTime(10),
        }))
    end

    self.damageList.window:SetHeight(
            self.damageList.sw.listHeaderHeight +
            (#playersDataList * self.damageList.sw.listRowHeight) +
            (#playersDataList > 0 and self.damageList.sw.listRowHeight or 0) -- summary row
    )
    ZO_ScrollList_Commit(listControl)
end