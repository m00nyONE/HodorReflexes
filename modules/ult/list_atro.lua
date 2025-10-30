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

local HR_EVENT_ATRO_CAST_STARTED = addon.HR_EVENT_ATRO_CAST_STARTED
local HR_EVENT_MAJOR_BERSERK_BUFF_GAINED = addon.HR_EVENT_MAJOR_BERSERK_BUFF_GAINED


local svVersion = 1
local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowPosLeft = 240,
    windowPosTop = 200,
    windowWidth = 262,
    backgroundOpacity = 0.0,

    showPercentValue = 1.0,
    showRawValue = 0.0,

    headerOpacity = 0.0,
    zeroTimerOpacity = 0.35,

    supportRangeOnly = false,

    colorAtro = {0, 1, 1}, -- cyan
    colorBerserk = {1, 1, 0}, -- yellow
}

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

function module:atroListHeaderRowCreationFunction(rowControl, data, scrollList)
    if not rowControl._initialized or self.atroList._redrawHeaders then
        rowControl:GetNamedChild("_BG"):SetAlpha(self.atroList.sw.headerOpacity)
        rowControl:GetNamedChild("_AtroIcon"):SetTexture(self.atroIcon)
        rowControl:GetNamedChild("_AtroDuration"):SetColor(unpack(self.atroList.sw.colorAtro))
        rowControl:GetNamedChild("_AtroDuration"):SetAlpha(self.atroList.sw.zeroTimerOpacity)
        rowControl:GetNamedChild("_BerserkIcon"):SetTexture(GetAbilityIcon(self.majorBerserkId))
        rowControl:GetNamedChild("_BerserkDuration"):SetColor(unpack(self.atroList.sw.colorBerserk))
        rowControl:GetNamedChild("_BerserkDuration"):SetAlpha(self.atroList.sw.zeroTimerOpacity)

        self.atroList:CreateCountdownOnControl(
            rowControl:GetNamedChild("_AtroDuration"),
            HR_EVENT_ATRO_CAST_STARTED
            --self.atroList.sw.zeroTimerOpacity -- we want the Function itself to set this value. That way we can update it in the menu
        )
        self.atroList:CreateCountdownOnControl(
            rowControl:GetNamedChild("_BerserkDuration"),
            HR_EVENT_MAJOR_BERSERK_BUFF_GAINED
            --self.atroList.sw.zeroTimerOpacity -- we want the Function itself to set this value. That way we can update it in the menu
        )

        self.atroList._redrawHeaders = false
        rowControl._initialized = true
    end
end

function module:atroListRowCreationFunction(rowControl, data, scrollList)
    self.atroList:ApplySupportRangeStyle(rowControl, data.tag)

    local userName = util.GetUserName(data.userId, true)
    if userName then
        local nameControl = rowControl:GetNamedChild('_Name')
        nameControl:SetText(userName)
        nameControl:SetColor(1, 1, 1)
    end

    local userIcon, tcLeft, tcRight, tcTop, tcBottom = util.GetUserIcon(data.userId, data.classId)
    if userIcon then
        local iconControl = rowControl:GetNamedChild('_Icon')
        iconControl:SetTextureReleaseOption(RELEASE_TEXTURE_AT_ZERO_REFERENCES)
        iconControl:SetTexture(userIcon)
        iconControl:SetTextureCoords(tcLeft, tcRight, tcTop, tcBottom)
    end

    local percentageColor = self:getUltPercentageColor(data.atroPercentage, 'FFFFFF')
    local percentageControl = rowControl:GetNamedChild("_PctValue")
    percentageControl:SetText(string.format('|c%s%d%%|r', percentageColor, zo_min(200, data.atroPercentage)))
    percentageControl:SetScale(self.atroList.sw.showPercentValue)
    local rawValueControl = rowControl:GetNamedChild("_RawValue")
    rawValueControl:SetText(string.format('%s', data.ultValue))
    rawValueControl:SetScale(self.atroList.sw.showRawValue)
end

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
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.atroList.HEADER_TYPE, {
    }))

    -- insert playerRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.atroList.ROW_TYPE, playerData))
    end

    ZO_ScrollList_Commit(listControl)
end