-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local addon_extensions = addon.extensions
local internal_modules = internal.modules

local module_name = "ult"
local module = addon_modules[module_name]

local util = addon.util

local HR_EVENT_HORN_BUFF_GAINED = addon.HR_EVENT_HORN_BUFF_GAINED
local HR_EVENT_MAJOR_FORCE_BUFF_GAINED = addon.HR_EVENT_MAJOR_FORCE_BUFF_GAINED


local svVersion = 1
local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowPosLeft = 240,
    windowPosTop = 50,
    windowWidth = 262,

    showPercentValue = 1.0,
    showRawValue = 0.0,

    headerOpacity = 0.0,
    zeroTimerOpacity = 0.35,

    colorHorn = {0, 1, 1}, -- cyan
    colorForce = {1, 1, 0}, -- yellow
    highlightSaxhleel = true,
    highlightSaxhleelColor = {0.7058823529411765, 0.7372549019607844, 0.6901960784313725, 0.2},
}

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

    local function headerRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            wrappedFunction(self, rowControl, data, scrollList)
        end
    end

    local function playerRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            if data.ultValue > 0 and (self.isTestRunning or IsUnitOnline(data.tag)) then
                wrappedFunction(self, rowControl, data, scrollList)
            end
        end
    end

    ZO_ScrollList_AddDataType(
            list.listControl,
            list.HEADER_TYPE,
            list.HEADER_TEMPLATE,
            list.listHeaderHeight,
            headerRowCreationWrapper(self.hornListHeaderRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(list.listControl, list.HEADER_TYPE, true)
    list.logger:Debug("added header row type '%d' with template '%s'", list.HEADER_TYPE, list.HEADER_TEMPLATE)

    ZO_ScrollList_AddDataType(
            list.listControl,
            list.ROW_TYPE,
            list.ROW_TEMPLATE,
            list.listRowHeight,
            playerRowCreationWrapper(self.hornListRowCreationFunction)
    )
    list.logger:Debug("added player row type '%d' with template '%s'", list.ROW_TYPE, list.ROW_TEMPLATE)
end

function module:hornListHeaderRowCreationFunction(rowControl, data, scrollList)
    if not rowControl._initialized or self.hornList._redrawHeaders then
        rowControl:GetNamedChild("_BG"):SetAlpha(self.hornList.sw.headerOpacity)
        rowControl:GetNamedChild("_HornIcon"):SetTexture(self.hornIcon)
        rowControl:GetNamedChild("_HornDuration"):SetColor(unpack(self.hornList.sw.colorHorn))
        rowControl:GetNamedChild("_HornDuration"):SetAlpha(self.hornList.sw.zeroTimerOpacity)
        rowControl:GetNamedChild("_ForceIcon"):SetTexture(self.forceIcon)
        rowControl:GetNamedChild("_ForceDuration"):SetColor(unpack(self.hornList.sw.colorForce))
        rowControl:GetNamedChild("_ForceDuration"):SetAlpha(self.hornList.sw.zeroTimerOpacity)

        self.hornList:CreateCountdownOnControl(
            rowControl:GetNamedChild("_HornDuration"),
            HR_EVENT_HORN_BUFF_GAINED
            --self.hornList.sw.zeroTimerOpacity -- we want the Function itself to set this value. That way we can update it in the menu
        )
        self.hornList:CreateCountdownOnControl(
            rowControl:GetNamedChild("_ForceDuration"),
            HR_EVENT_MAJOR_FORCE_BUFF_GAINED
            --self.hornList.sw.zeroTimerOpacity -- we want the Function itself to set this value. That way we can update it in the menu
        )

        self.hornList._redrawHeaders = false
        rowControl._initialized = true
    end
end

function module:hornListRowCreationFunction(rowControl, data, scrollList)
    local userName = util.GetUserName(data.userId, true)
    if userName then
        local nameControl = rowControl:GetNamedChild('_Name')
        nameControl:SetText(userName)
        nameControl:SetColor(1, 1, 1)
    end

    local userIcon, tcLeft, tcRight, tcTop, tcBottom = util.GetUserIcon(data.userId, data.classId)
    if userIcon then
        local iconControl = rowControl:GetNamedChild('_Icon')
        iconControl:SetTexture(userIcon)
        iconControl:SetTextureCoords(tcLeft, tcRight, tcTop, tcBottom)
    end

    if self.hornList.sw.highlightSaxhleel then
        local _BG = rowControl:GetNamedChild("_BG")
        if data.hasSaxhleel then
            _BG:SetColor(unpack(self.hornList.sw.highlightSaxhleelColor))
        else
            _BG:SetColor(1, 1, 1, 0)
        end
    end

    local percentageColor = self:getUltPercentageColor(data.hornPercentage, 'FFFFFF')
    local percentageControl = rowControl:GetNamedChild("_PctValue")
    percentageControl:SetText(string.format('|c%s%d%%|r', percentageColor, zo_min(200, data.hornPercentage)))
    percentageControl:SetScale(self.hornList.sw.showPercentValue)
    local rawValueControl = rowControl:GetNamedChild("_RawValue")
    rawValueControl:SetText(string.format('%s', data.ultValue))
    rawValueControl:SetScale(self.hornList.sw.showRawValue)
end

function module:UpdateHornList()
    local listControl = self.hornList.listControl

    ZO_ScrollList_Clear(listControl)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    local playersDataList = {}
    for _, playerData in pairs(addon.playersData) do
        if playerData.ultValue > 0 and playerData.hasHorn or playerData.hasSaxhleel then
            local lowestPossibleHornCost = 0
            if playerData.hasSaxhleel then
                lowestPossibleHornCost = zo_max(zo_min(playerData.ult1Cost, playerData.ult2Cost), 250)
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
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.hornList.HEADER_TYPE, {
    }))

    -- insert playerRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.hornList.ROW_TYPE, playerData))
    end

    self.hornList.window:SetHeight(
            self.hornList.listHeaderHeight +
            (#playersDataList * self.hornList.listRowHeight)
    )

    ZO_ScrollList_Commit(listControl)
end