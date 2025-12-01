-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules

local module_name = "dps"
local module = addon_modules[module_name]

local combat = addon.combat

local LGCS = LibGroupCombatStats
local DAMAGE_UNKNOWN = LGCS.DAMAGE_UNKNOWN
local DAMAGE_BOSS = LGCS.DAMAGE_BOSS
local DAMAGE_TOTAL = LGCS.DAMAGE_TOTAL

local localBoss1 = "boss1"

local svVersion = 1
local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowScale = 1.0,
    windowPosLeft = 10,
    windowPosTop = 260,
    windowWidth = 237,
    backgroundOpacity = 0.0,

    listHeaderOpacity = 0.8,
    listRowEvenOpacity = 0.65,
    listRowOddOpacity = 0.45,

    listPlayerHighlight = true,
    listPlayerHighlightColor = {0, 1, 0, 0.36}, -- green

    colorDamageTotal = "FAFFB2", -- light yellow
    colorDamageBoss = "B2FFB2", -- light green

    timerUpdateInterval = 100, -- ms

    showSummary = false,
    burstWindowSeconds = 10,

    colorGroupDPS = "F4D17B", -- light orange
    colorBurstDPS = "BDFF7B", -- light green

    nameFont = "$(BOLD_FONT)|$(KB_18)|outline",
}

--- initializes the damage list
--- @return void
function module:CreateDamageList()
    local listDefinition = {
        name = "damage",
        svVersion = svVersion,
        svDefault = svDefault,
        Update = function() self:UpdateDamageList() end,
        listHeaderHeight = 22,
        listRowHeight = 22,
    }
    self.damageList = addon.listClass:New(listDefinition)
    local list = self.damageList

    list.HEADER_TYPE = list:GetNextDataTypeId() -- type id for header
    list.ROW_TYPE = list:GetNextDataTypeId()   -- type id for rows
    list.SUMMARY_TYPE = list:GetNextDataTypeId() -- type id for summary
    list.HEADER_TEMPLATE = "HodorReflexes_Dps_DamageList_Header"
    list.ROW_TEMPLATE = "HodorReflexes_Dps_DamageList_DamageRow"
    list.SUMMARY_TEMPLATE = "HodorReflexes_Dps_DamageList_Summary"

    local function rowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            wrappedFunction(self, rowControl, data, scrollList)
        end
    end

    ZO_ScrollList_AddDataType(
            list.listControl,
            list.HEADER_TYPE,
            list.HEADER_TEMPLATE,
            list.listHeaderHeight,
            rowCreationWrapper(self.headerRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(list.listControl, list.HEADER_TYPE, true)
    list.logger:Debug("added header row type '%d' with template '%s'", list.HEADER_TYPE, list.HEADER_TEMPLATE)

    ZO_ScrollList_AddDataType(
            list.listControl,
            list.ROW_TYPE,
            list.ROW_TEMPLATE,
            list.listRowHeight,
            rowCreationWrapper(self.damageRowCreationFunction)
    )
    list.logger:Debug("added player row type '%d' with template '%s'", list.ROW_TYPE, list.ROW_TEMPLATE)

    ZO_ScrollList_AddDataType(
            list.listControl,
            list.SUMMARY_TYPE,
            list.SUMMARY_TEMPLATE,
            list.listRowHeight,
            rowCreationWrapper(self.summaryRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(list.listControl, list.SUMMARY_TYPE, true)
    list.logger:Debug("added summary row type '%d' with template '%s'", list.SUMMARY_TYPE, list.SUMMARY_TEMPLATE)
end

--- creation function for the header row. This can be overwritten if using a custom theme
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:headerRowCreationFunction(rowControl, data, scrollList)
    local sw = self.damageList.sw
    rowControl:GetNamedChild("_Title"):SetText(self.getDamageHeaderFormat(data.dmgType, sw.colorDamageBoss, sw.colorDamageTotal))

    if rowControl._initialized and not self.damageList._redrawHeaders then
        return
    end

    rowControl:GetNamedChild("_BG"):SetAlpha(sw.listHeaderOpacity)
    local timeControl = rowControl:GetNamedChild("_Time")
    self.damageList:CreateFightTimeUpdaterOnControl(timeControl)

    rowControl._initialized = true
end

--- creation function for the damage rows. This can be overwritten if using a custom theme
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:damageRowCreationFunction(rowControl, data, scrollList)
    local list = self.damageList
    local sw = list.sw

    list:ApplyUserNameToControl(rowControl:GetNamedChild('_Name'), data.userId)
    list:ApplyUserIconToControl(rowControl:GetNamedChild('_Icon'), data.userId, data.classId)
    list:ApplyNameFontToControl(rowControl:GetNamedChild('_Name'))

    local valueControl = rowControl:GetNamedChild("_Value")
    valueControl:SetText(self.getDamageRowFormat(data.dmgType, data.dmg, data.dps, sw.colorDamageBoss, sw.colorDamageTotal))

    local customColor = false
    if data.isPlayer and sw.listPlayerHighlight then
        local r, g, b, o = unpack(sw.listPlayerHighlightColor)
        if o ~= 0 then
            customColor = true
            rowControl:GetNamedChild('_BG'):SetColor(r, g, b, o or 0.5)
        end
    end
    if not customColor then
        rowControl:GetNamedChild('_BG'):SetColor(0, 0, 0, zo_mod(data.orderIndex, 2) == 0 and sw.listRowEvenOpacity or sw.listRowOddOpacity)
    end
end

local cachedTitle = "Group Total: "
local cachedValue = ""
--- creation function for the summary row. This can be overwritten if using a custom theme
--- @param rowControl any
--- @param data table
--- @param scrollList any
--- @return void
function module:summaryRowCreationFunction(rowControl, data, scrollList)
    local sw = self.damageList.sw

    cachedTitle = GetString(HR_MODULES_DPS_SUMMARY_GROUP_TOTAL)
    cachedValue = ""
    if data.dmgType == DAMAGE_BOSS then
        --title = string.format("dps (10sBurst) [ttk]:")
        --value = string.format("%0.1fK (%0.1fK) [%0.1s]", data.groupDPS / 1000, data.groupDPSBurst / 1000, data.timeToKillMainBoss and data.timeToKillMainBoss > 0 and data.timeToKillMainBoss or "-")
        cachedTitle = string.format("|c%sGroup DPS|r |c%s(%ds)|r", sw.colorGroupDPS, sw.colorBurstDPS, sw.burstWindowSeconds)
        cachedValue = string.format("|c%s%0.2fM|r |c%s(%0.2fM)|r", sw.colorGroupDPS, data.groupDPS / 1000000, sw.colorBurstDPS, data.groupDPSBurst / 1000000 or "-")
        --title = "Group Total: "
        --value = self.getDamageRowFormat(data.dmgType, (data.damageOutTotalGroup / 100) / data.fightTime, data.groupDPS / 1000, sw.colorDamageBoss, sw.colorDamageTotal)
    else
        cachedTitle = GetString(HR_MODULES_DPS_SUMMARY_GROUP_TOTAL)
        cachedValue = self.getDamageRowFormat(data.dmgType, data.damageOutTotalGroup / 10000, data.groupDPS / 1000, sw.colorDamageBoss, sw.colorDamageTotal)
    end

    rowControl:GetNamedChild("_Title"):SetText(cachedTitle)
    rowControl:GetNamedChild("_Value"):SetText(cachedValue)
end

local summaryData = {}
local dmgType = {
    dmgType = DAMAGE_UNKNOWN
}
--- update function to refresh the damage list. This should usually not be overwritten by a custom theme unless absolutely necessary.
--- @return void
function module:UpdateDamageList()
    local listControl = self.damageList.listControl
    local list = self.damageList
    local sw = list.sw

    dmgType.dmgType = DAMAGE_UNKNOWN

    ZO_ScrollList_Clear(listControl)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    local playersDataList = {}
    for _, playerData in pairs(addon.playersData) do
        if not playerData.hideDamage and playerData.dmg > 0 then
            dmgType.dmgType = playerData.dmgType
            table.insert(playersDataList, playerData)
        end
    end
    table.sort(playersDataList, self.sortByDamageType)

    -- insert header row
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(list.HEADER_TYPE, dmgType))

    -- insert damageRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(list.ROW_TYPE, playerData))
    end

    if sw.showSummary and #playersDataList > 0 then
        summaryData.dmgType = dmgType.dmgType
        summaryData.fightTime = combat:GetCombatTime()
        summaryData.groupDPS = combat:GetGroupDPSOut()
        summaryData.groupDPSBurst = combat:GetGroupDPSOverTime(sw.burstWindowSeconds)
        summaryData.damageOutTotalGroup = combat:GetDamageOutTotalGroup()
        --summaryData.timeToKillMainBoss = combat:GetTimeToKill(localBoss1)

        table.insert(dataList, ZO_ScrollList_CreateDataEntry(list.SUMMARY_TYPE, summaryData))
    end

    ZO_ScrollList_Commit(listControl)

    -- cleanup
    playersDataList = nil
end