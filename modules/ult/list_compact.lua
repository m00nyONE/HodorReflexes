-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local addon_extensions = addon.extensions
local internal_modules = internal.modules

local module_name = "ult"
local module = addon_modules[module_name]

local util = addon.util

local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowPosLeft = 750,
    windowPosTop = 50,
    windowWidth = 262,

    listHeaderHeight = 84,
    listRowHeight = 24,

    showPercentValue = 1.0,
    showRawValue = 1.0,

    headerOpacity = 0.0,
    zeroTimerOpacity = 0.7,
}

function module:CreateCompactList()
    local listDefinition = {
        name = "compact",
        svDefault = svDefault,
        Update = function() self:UpdateCompactList() end,
    }
    self.compactList = addon.listClass:New(listDefinition)

    self.compactList.HEADER_TYPE = 1 -- type id for header
    self.compactList.ROW_TYPE = 2 -- type id for rows
    self.compactList.HEADER_TEMPLATE = "HodorReflexes_Ult_CompactList_Header"
    self.compactList.ROW_TEMPLATE = "HodorReflexes_Ult_CompactList_PlayerRow"

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
            self.compactList.listControl,
            self.compactList.HEADER_TYPE,
            self.compactList.HEADER_TEMPLATE,
            self.compactList.sw.listHeaderHeight,
            headerRowCreationWrapper(self.compactListHeaderRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(self.compactList.listControl, self.compactList.HEADER_TYPE, true)

    ZO_ScrollList_AddDataType(
            self.compactList.listControl,
            self.compactList.ROW_TYPE,
            self.compactList.ROW_TEMPLATE,
            self.compactList.sw.listRowHeight,
            playerRowCreationWrapper(self.compactListRowCreationFunction)
    )
end

function module:compactListHeaderRowCreationFunction(rowControl, data, scrollList)
    rowControl:GetNamedChild("_BG"):SetAlpha(self.compactList.sw.headerOpacity)

    -- TODO: create event listeners for duration timers
end

function module:compactListRowCreationFunction(rowControl, data, scrollList)
    local userName = util.GetUserName(data.userId, true)
    local userIcon, tcLeft, tcRight, tcTop, tcBottom = util.GetUserIcon(data.userId, data.classId)

    local nameControl = rowControl:GetNamedChild('_Name')
    nameControl:SetText(userName)
    nameControl:SetColor(1, 1, 1)
    local iconControl = rowControl:GetNamedChild('_Icon')
    iconControl:SetTextureCoords(tcLeft, tcRight, tcTop, tcBottom)
    iconControl:SetTexture(userIcon)

    local percentageColor = self:getUltPercentageColor(data.lowestUltPercentage, 'FFFFFF')
    local percentageControl = rowControl:GetNamedChild("_PctValue")
    percentageControl:SetText(string.format('|c%s%d%%|r', percentageColor, zo_min(200, data.lowestUltPercentage)))
    percentageControl:SetScale(self.compactList.sw.showPercentValue)
    local rawValueControl = rowControl:GetNamedChild("_RawValue")
    rawValueControl:SetText(string.format('%s', data.ultValue))
    rawValueControl:SetScale(self.compactList.sw.showRawValue)
end

function module:UpdateCompactList()
    local listControl = self.compactList.listControl

    ZO_ScrollList_Clear(listControl)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    local playersDataList = {}
    for _, playerData in pairs(addon.playersData) do
        if playerData.ultValue > 0 then
            table.insert(playersDataList, playerData)
        end
    end
    table.sort(playersDataList, self.sortByUltPriority)

    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.compactList.HEADER_TYPE, {
    }))

    -- insert playerRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.compactList.ROW_TYPE, playerData))
    end

    self.compactList.window:SetHeight(
        self.compactList.sw.listHeaderHeight +
        (#playersDataList * self.compactList.sw.listRowHeight)
    )

    ZO_ScrollList_Commit(listControl)
end