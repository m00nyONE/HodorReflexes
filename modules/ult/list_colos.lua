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

local HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED = addon.HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED


local svVersion = 1
local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowPosLeft = 550,
    windowPosTop = 50,
    windowWidth = 262,

    showPercentValue = 1.0,
    showRawValue = 1.0,

    headerOpacity = 0.0,
    zeroTimerOpacity = 0.7,

    colorVuln = {1, 1, 0}, -- yellow
}

function module:CreateColosList()
    local listDefinition = {
        name = "colos",
        svVersion = svVersion,
        svDefault = svDefault,
        Update = function() self:UpdateColosList() end,
        listHeaderHeight = 28,
        listRowHeight = 24,
    }
    self.colosList = addon.listClass:New(listDefinition)

    self.colosList.HEADER_TYPE = 1 -- type id for header
    self.colosList.ROW_TYPE = 2 -- type id for rows
    self.colosList.HEADER_TEMPLATE = "HodorReflexes_Ult_ColosList_Header"
    self.colosList.ROW_TEMPLATE = "HodorReflexes_Ult_ColosList_PlayerRow"

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
            self.colosList.listControl,
            self.colosList.HEADER_TYPE,
            self.colosList.HEADER_TEMPLATE,
            self.colosList.listHeaderHeight,
            headerRowCreationWrapper(self.colosListHeaderRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(self.colosList.listControl, self.colosList.HEADER_TYPE, true)
    self.colosList.logger:Debug("added header row type '%d' with template '%s'", self.colosList.HEADER_TYPE, self.colosList.HEADER_TEMPLATE)

    ZO_ScrollList_AddDataType(
            self.colosList.listControl,
            self.colosList.ROW_TYPE,
            self.colosList.ROW_TEMPLATE,
            self.colosList.listRowHeight,
            playerRowCreationWrapper(self.colosListRowCreationFunction)
    )
    self.colosList.logger:Debug("added player row type '%d' with template '%s'", self.colosList.ROW_TYPE, self.colosList.ROW_TEMPLATE)
end

function module:colosListHeaderRowCreationFunction(rowControl, data, scrollList)
    if not rowControl._initialized then
        rowControl:GetNamedChild("_BG"):SetAlpha(self.colosList.sw.headerOpacity)
        rowControl:GetNamedChild("_Duration"):SetColor(unpack(self.colosList.sw.colorVuln))
        rowControl:GetNamedChild("_Duration"):SetAlpha(self.colosList.sw.zeroTimerOpacity)

        self.colosList:CreateCountdownOnControl(
            rowControl:GetNamedChild("_Duration"),
            HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED,
            self.colosList.sw.zeroTimerOpacity
        )

        rowControl._initialized = true
    end
end

function module:colosListRowCreationFunction(rowControl, data, scrollList)
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

    local percentageColor = self:getUltPercentageColor(data.colosPercentage, 'FFFFFF')
    local percentageControl = rowControl:GetNamedChild("_PctValue")
    percentageControl:SetText(string.format('|c%s%d%%|r', percentageColor, zo_min(200, data.colosPercentage)))
    percentageControl:SetScale(self.colosList.sw.showPercentValue)
    local rawValueControl = rowControl:GetNamedChild("_RawValue")
    rawValueControl:SetText(string.format('%s', data.ultValue))
    rawValueControl:SetScale(self.colosList.sw.showRawValue)
end

function module:UpdateColosList()
    local listControl = self.colosList.listControl

    ZO_ScrollList_Clear(listControl)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    local playersDataList = {}
    for _, playerData in pairs(addon.playersData) do
        if playerData.ultValue > 0 and playerData.hasColos then
            local lowestPossibleColosCost = 0
            if self:isColos(playerData.ult1ID) then lowestPossibleColosCost = playerData.ult1Cost end
            if self:isColos(playerData.ult2ID) then lowestPossibleColosCost = playerData.ult2Cost end
            playerData.colosPercentage = self:getUltPercentage(playerData.ultValue, lowestPossibleColosCost)
            table.insert(playersDataList, playerData)
        end
    end
    table.sort(playersDataList, self.sortByUltPercentage)

    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.colosList.HEADER_TYPE, {
    }))

    -- insert playerRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.colosList.ROW_TYPE, playerData))
    end

    self.colosList.window:SetHeight(
        self.colosList.listHeaderHeight +
        (#playersDataList * self.colosList.listRowHeight)
    )

    ZO_ScrollList_Commit(listControl)
end