-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules

local module_name = "ult"
local module = addon_modules[module_name]

local HR_EVENT_HORN_BUFF_GAINED = addon.HR_EVENT_HORN_BUFF_GAINED
local HR_EVENT_MAJOR_FORCE_BUFF_GAINED = addon.HR_EVENT_MAJOR_FORCE_BUFF_GAINED

local blankTable = {}

local svVersion = 1
local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowScale = 1.0,
    windowPosLeft = 10,
    windowPosTop = 570,
    windowWidth = 272,
    backgroundOpacity = 0.0,

    showPercentValue = 1.0,
    showRawValue = 0.0,

    headerOpacity = 0.0,
    zeroTimerOpacity = 0.35,

    supportRangeOnly = false,

    colorHorn = {0, 1, 1}, -- cyan
    colorForce = {1, 1, 0}, -- yellow
    highlightSaxhleel = true,
    highlightSaxhleelColor = {0.7058823529411765, 0.7372549019607844, 0.6901960784313725, 0.2},

    nameFont = "$(BOLD_FONT)|$(KB_19)|outline",
}

--- Create the horn ult list.
--- @return void
function module:CreateHornList()
    local listDefinition = {
        name = "horn",
        svVersion = svVersion,
        svDefault = svDefault,
        Update = function() self:UpdateHornList() end,
        listHeaderHeight = 28,
        listRowHeight = 24,
    }
    self.hornList = addon.listClass:New(listDefinition)
    local list = self.hornList

    list.HEADER_TYPE = list:GetNextDataTypeId() -- type id for header
    list.ROW_TYPE = list:GetNextDataTypeId() -- type id for rows
    list.HEADER_TEMPLATE = "HodorReflexes_Ult_HornList_Header"
    list.ROW_TEMPLATE = "HodorReflexes_Ult_HornList_PlayerRow"

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
            rowCreationWrapper(self.hornListHeaderRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(list.listControl, list.HEADER_TYPE, true)
    list.logger:Debug("added header row type '%d' with template '%s'", list.HEADER_TYPE, list.HEADER_TEMPLATE)

    ZO_ScrollList_AddDataType(
            list.listControl,
            list.ROW_TYPE,
            list.ROW_TEMPLATE,
            list.listRowHeight,
            rowCreationWrapper(self.hornListRowCreationFunction)
    )
    list.logger:Debug("added player row type '%d' with template '%s'", list.ROW_TYPE, list.ROW_TEMPLATE)
end

--- horn list header row creation function
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:hornListHeaderRowCreationFunction(rowControl, data, scrollList)
    if rowControl._initialized and not self.hornList._redrawHeaders then
        return
    end

    local hornList = self.hornList
    local sw = hornList.sw

    local hornIcon = rowControl:GetNamedChild("_HornIcon")
    local hornDuration = rowControl:GetNamedChild("_HornDuration")
    local forceIcon = rowControl:GetNamedChild("_ForceIcon")
    local forceDuration = rowControl:GetNamedChild("_ForceDuration")

    rowControl:GetNamedChild("_BG"):SetAlpha(sw.headerOpacity)
    hornIcon:SetTexture(self.hornIcon)
    hornDuration:SetColor(unpack(sw.colorHorn))
    hornDuration:SetAlpha(sw.zeroTimerOpacity)
    forceIcon:SetTexture(self.forceIcon)
    forceDuration:SetColor(unpack(sw.colorForce))
    forceDuration:SetAlpha(sw.zeroTimerOpacity)

    hornList:CreateCountdownOnControl(hornDuration, HR_EVENT_HORN_BUFF_GAINED)
    hornList:CreateCountdownOnControl(forceDuration, HR_EVENT_MAJOR_FORCE_BUFF_GAINED)

    hornList._redrawHeaders = false
    rowControl._initialized = true
end

--- horn list player row creation function
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:hornListRowCreationFunction(rowControl, data, scrollList)
    local list = self.hornList
    local sw = list.sw

    list:ApplySupportRangeStyle(rowControl, data.tag)
    list:ApplyUserNameToControl(rowControl:GetNamedChild('_Name'), data.userId)
    list:ApplyUserIconToControl(rowControl:GetNamedChild('_Icon'), data.userId, data.classId)
    list:ApplyNameFontToControl(rowControl:GetNamedChild('_Name'))

    local _BG = rowControl:GetNamedChild("_BG")
    if sw.highlightSaxhleel then
        if data.hasSaxhleel then
            _BG:SetColor(unpack(sw.highlightSaxhleelColor))
        end
    else
        _BG:SetColor(1, 1, 1, 0)
    end

    local percentageColor = self:getUltPercentageColor(data.hornPercentage, 'FFFFFF')
    local percentageControl = rowControl:GetNamedChild("_PctValue")
    percentageControl:SetText(string.format('|c%s%d%%|r', percentageColor, zo_clamp(data.hornPercentage, 0, 200)))
    percentageControl:SetScale(sw.showPercentValue)
    local rawValueControl = rowControl:GetNamedChild("_RawValue")
    rawValueControl:SetText(string.format('%s', data.ultValue))
    rawValueControl:SetScale(sw.showRawValue)
end

--- Update the horn ult list.
--- @return void
function module:UpdateHornList()
    local listControl = self.hornList.listControl

    ZO_ScrollList_Clear(listControl)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    local playersDataList = {}
    for _, playerData in pairs(addon.playersData) do
        if playerData.ultValue > 0 and ((not playerData.hideHorn and playerData.hasHorn) or (not playerData.hideSaxhleel and playerData.hasSaxhleel)) then
            local lowestPossibleHornCost = 0
            if not playerData.hideSaxhleel and playerData.hasSaxhleel then
                lowestPossibleHornCost = zo_clamp(zo_min(playerData.ult1Cost, playerData.ult2Cost), 250, 500)
            else
                if self:isHorn(playerData.ult1ID) then lowestPossibleHornCost = playerData.ult1Cost end
                if self:isHorn(playerData.ult2ID) then lowestPossibleHornCost = playerData.ult2Cost end
            end
            playerData.hornPercentage = self:getUltPercentage(playerData.ultValue, lowestPossibleHornCost)
            table.insert(playersDataList, playerData)
        end
    end
    table.sort(playersDataList, self.sortByUltPercentage)

    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.hornList.HEADER_TYPE, blankTable))

    -- insert playerRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.hornList.ROW_TYPE, playerData))
    end

    ZO_ScrollList_Commit(listControl)
end