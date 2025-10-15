-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "dps"
local module = addon_modules[module_name]

local LGCS = LibGroupCombatStats
local DAMAGE_UNKNOWN = LGCS.DAMAGE_UNKNOWN

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
}

function module:CreateDamageList()
    local listDefinition = {
        name = "damage",
        svDefault = svDefault,
        Update = function() self:UpdateDamageList() end,
    }
    self.damageList = internal.listClass:New(listDefinition)

    self:RunOnce("SetupDamageList")
end

function module:SetupDamageList()
    self.damageList.HEADER_TYPE = 1 -- type id for header
    self.damageList.ROW_TYPE = 2    -- type id for rows
    self.damageList.HEADER_TEMPLATE = "HodorReflexes_Dps_DamageList_Header"
    self.damageList.ROW_TEMPLATE = "HodorReflexes_Dps_DamageList_DamageRow"

    local function createHeaderRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            -- allways set the Control of the Time so we can update it later
            self.damageList.HeaderTimeControl = rowControl:GetNamedChild("_Time")
            wrappedFunction(self, rowControl, data, scrollList)
        end
    end

    local function createDamageRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            -- only create rows if conditions are met
            if data.dmg > 0 and (self.isTestRunning or IsUnitOnline(data.tag)) then
                wrappedFunction(self, rowControl, data, scrollList)
            end
        end
    end

    ZO_ScrollList_AddDataType(
            self.damageList.listControl,
            self.damageList.HEADER_TYPE,
            self.damageList.HEADER_TEMPLATE,
            self.damageList.sw.listHeaderHeight,
            createHeaderRowCreationWrapper(self.headerRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(self.damageList.listControl, self.damageList.HEADER_TYPE, true)

    ZO_ScrollList_AddDataType(
            self.damageList.listControl,
            self.damageList.ROW_TYPE,
            self.damageList.ROW_TEMPLATE,
            self.damageList.sw.listRowHeight,
            createDamageRowCreationWrapper(self.damageRowCreationFunction)
    )
end

function module:headerRowCreationFunction(rowControl, data, scrollList)
    rowControl:GetNamedChild("_Title"):SetText(self.getDamageHeaderFormat(data.dmgType, self.damageList.sw.colorDamageBoss, self.damageList.sw.colorDamageTotal))
    rowControl:GetNamedChild("_BG"):SetAlpha(self.damageList.sw.listHeaderOpacity)
end

function module:damageRowCreationFunction(rowControl, data, scrollList)
    local userId = data.userId
    local userName = userId
    local classId = data.classId
    local defaultIcon = GetClassIcon(classId)

    local nameControl = rowControl:GetNamedChild('_Name')
    nameControl:SetText(userName)
    nameControl:SetColor(1, 1, 1)
    local iconControl = rowControl:GetNamedChild('_Icon')
    iconControl:SetTextureCoords(0, 1, 0, 1)
    iconControl:SetTexture(defaultIcon)

    local valueControl = rowControl:GetNamedChild("_Value")
    valueControl:SetText(self.getDamageRowFormat(data.dmgType, data.dmg, data.dps, self.damageList.sw.colorDamageBoss, self.damageList.sw.colorDamageTotal))
    valueControl:SetFont("$(GAMEPAD_MEDIUM_FONT)|$(KB_19)|outline")
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

    -- insert damageRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.damageList.ROW_TYPE, playerData))
    end

    table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.damageList.HEADER_TYPE, {
        dmgType = dmgType,
    }))

    ZO_ScrollList_Commit(listControl)
end