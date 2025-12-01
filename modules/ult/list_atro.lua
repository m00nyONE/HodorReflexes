-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules

local module_name = "ult"
local module = addon_modules[module_name]

local HR_EVENT_ATRO_CAST_STARTED = addon.HR_EVENT_ATRO_CAST_STARTED
local HR_EVENT_MAJOR_BERSERK_BUFF_GAINED = addon.HR_EVENT_MAJOR_BERSERK_BUFF_GAINED

local blankTable = {}

local svVersion = 1
local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowScale = 1.0,
    windowPosLeft = 10,
    windowPosTop = 750,
    windowWidth = 272,
    backgroundOpacity = 0.0,

    showPercentValue = 1.0,
    showRawValue = 0.0,

    headerOpacity = 0.0,
    zeroTimerOpacity = 0.35,

    supportRangeOnly = false,

    colorAtro = {0, 1, 1}, -- cyan
    colorBerserk = {1, 1, 0}, -- yellow

    nameFont = "$(BOLD_FONT)|$(KB_19)|outline",
}

--- Create the Atro Ult List
--- @return void
function module:CreateAtroList()
    local listDefinition = {
        name = "atro",
        svVersion = svVersion,
        svDefault = svDefault,
        Update = function() self:UpdateAtroList() end,
        listHeaderHeight = 28,
        listRowHeight = 24,
    }
    self.atroList = addon.listClass:New(listDefinition)
    local list = self.atroList

    list.HEADER_TYPE = list:GetNextDataTypeId() -- type id for header
    list.ROW_TYPE = list:GetNextDataTypeId() -- type id for rows
    list.HEADER_TEMPLATE = "HodorReflexes_Ult_AtroList_Header"
    list.ROW_TEMPLATE = "HodorReflexes_Ult_AtroList_PlayerRow"

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
            rowCreationWrapper(self.atroListHeaderRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(list.listControl, list.HEADER_TYPE, true)
    list.logger:Debug("added header row type '%d' with template '%s'", list.HEADER_TYPE, list.HEADER_TEMPLATE)

    ZO_ScrollList_AddDataType(
            list.listControl,
            list.ROW_TYPE,
            list.ROW_TEMPLATE,
            list.listRowHeight,
            rowCreationWrapper(self.atroListRowCreationFunction)
    )
    list.logger:Debug("added player row type '%d' with template '%s'", list.ROW_TYPE, list.ROW_TEMPLATE)
end

--- Atro List Header Row Creation Function
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:atroListHeaderRowCreationFunction(rowControl, data, scrollList)
    if rowControl._initialized and not self.atroList._redrawHeaders then
        return
    end

    local atroList = self.atroList
    local sw = atroList.sw

    local atroIcon = rowControl:GetNamedChild("_AtroIcon")
    local atroDuration = rowControl:GetNamedChild("_AtroDuration")
    local berserkIcon = rowControl:GetNamedChild("_BerserkIcon")
    local berserkDuration = rowControl:GetNamedChild("_BerserkDuration")

    rowControl:GetNamedChild("_BG"):SetAlpha(sw.headerOpacity)
    atroIcon:SetTexture(self.atroIcon)
    atroDuration:SetColor(unpack(sw.colorAtro))
    atroDuration:SetAlpha(sw.zeroTimerOpacity)
    berserkIcon:SetTexture(GetAbilityIcon(self.majorBerserkId))
    berserkDuration:SetColor(unpack(sw.colorBerserk))
    berserkDuration:SetAlpha(sw.zeroTimerOpacity)

    atroList:CreateCountdownOnControl(atroDuration, HR_EVENT_ATRO_CAST_STARTED)
    atroList:CreateCountdownOnControl(berserkDuration, HR_EVENT_MAJOR_BERSERK_BUFF_GAINED)

    atroList._redrawHeaders = false
    rowControl._initialized = true
end

--- Atro List Row Creation Function
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:atroListRowCreationFunction(rowControl, data, scrollList)
    local list = self.atroList
    local sw = list.sw

    list:ApplySupportRangeStyle(rowControl, data.tag)
    list:ApplyUserNameToControl(rowControl:GetNamedChild('_Name'), data.userId)
    list:ApplyUserIconToControl(rowControl:GetNamedChild('_Icon'), data.userId, data.classId)
    list:ApplyNameFontToControl(rowControl:GetNamedChild('_Name'))

    local percentageColor = self:getUltPercentageColor(data.atroPercentage, 'FFFFFF')
    local percentageControl = rowControl:GetNamedChild("_PctValue")
    percentageControl:SetText(string.format('|c%s%d%%|r', percentageColor, zo_clamp(data.atroPercentage, 0, 200)))
    percentageControl:SetScale(sw.showPercentValue)
    local rawValueControl = rowControl:GetNamedChild("_RawValue")
    rawValueControl:SetText(string.format('%s', data.ultValue))
    rawValueControl:SetScale(sw.showRawValue)
end

--- Update the Atro Ult List
--- @return void
function module:UpdateAtroList()
    local listControl = self.atroList.listControl

    ZO_ScrollList_Clear(listControl)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    local playersDataList = {}
    for _, playerData in pairs(addon.playersData) do
        if not playerData.hideAtro and playerData.ultValue > 0 and playerData.hasAtro then
            local lowestPossibleAtroCost = 0
            if self:isAtro(playerData.ult1ID) then lowestPossibleAtroCost = playerData.ult1Cost end
            if self:isAtro(playerData.ult2ID) then lowestPossibleAtroCost = playerData.ult2Cost end
            playerData.atroPercentage = self:getUltPercentage(playerData.ultValue, lowestPossibleAtroCost)
            table.insert(playersDataList, playerData)
        end
    end
    table.sort(playersDataList, self.sortByUltPercentage)

    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.atroList.HEADER_TYPE, blankTable))

    -- insert playerRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.atroList.ROW_TYPE, playerData))
    end

    ZO_ScrollList_Commit(listControl)
end