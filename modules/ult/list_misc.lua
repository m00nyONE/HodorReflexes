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

local svVersion = 1
local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowPosLeft = 550,
    windowPosTop = 200,
    windowWidth = 262,

    showPercentValue = 1.0,
    showRawValue = 1.0,

    headerOpacity = 0.0,
}

function module:CreateMiscList()
    local listDefinition = {
        name = "misc",
        svVersion = svVersion,
        svDefault = svDefault,
        Update = function() self:UpdateMiscList() end,
        listHeaderHeight = 28,
        listRowHeight = 24,
    }
    self.miscList = addon.listClass:New(listDefinition)

    self.miscList.HEADER_TYPE = 1 -- type id for header
    self.miscList.ROW_TYPE = 2 -- type id for rows
    self.miscList.HEADER_TEMPLATE = "HodorReflexes_Ult_MiscList_Header"
    self.miscList.ROW_TEMPLATE = "HodorReflexes_Ult_MiscList_PlayerRow"

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
            self.miscList.listControl,
            self.miscList.HEADER_TYPE,
            self.miscList.HEADER_TEMPLATE,
            self.miscList.listHeaderHeight,
            headerRowCreationWrapper(self.miscListHeaderRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(self.miscList.listControl, self.miscList.HEADER_TYPE, true)

    ZO_ScrollList_AddDataType(
            self.miscList.listControl,
            self.miscList.ROW_TYPE,
            self.miscList.ROW_TEMPLATE,
            self.miscList.listRowHeight,
            playerRowCreationWrapper(self.miscListRowCreationFunction)
    )
end

function module:miscListHeaderRowCreationFunction(rowControl, data, scrollList)
    if not rowControl._initialized then
        rowControl:GetNamedChild("_BG"):SetAlpha(self.miscList.sw.headerOpacity)
        rowControl:GetNamedChild("_Text"):SetText(data.title)

        rowControl._initialized = true
    end
end

function module:miscListRowCreationFunction(rowControl, data, scrollList)
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
    percentageControl:SetScale(self.miscList.sw.showPercentValue)
    local rawValueControl = rowControl:GetNamedChild("_RawValue")
    rawValueControl:SetText(string.format('%s', data.ultValue))
    rawValueControl:SetScale(self.miscList.sw.showRawValue)
    rowControl:GetNamedChild('_UltIconFrontbar'):SetTexture(GetAbilityIcon(data.ult1ID))
    rowControl:GetNamedChild('_UltIconBackbar'):SetTexture(GetAbilityIcon(data.ult2ID))
end

function module:UpdateMiscList()
    local listControl = self.miscList.listControl

    ZO_ScrollList_Clear(listControl)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    local playersDataList = {}
    for _, playerData in pairs(addon.playersData) do
        if playerData.ultValue > 0 and not playerData.hasHorn and not playerData.hasColos and not playerData.hasAtro and not playerData.hasCryptCannon then
            table.insert(playersDataList, playerData)
        end
    end
    table.sort(playersDataList, self.sortByUltPercentage)

    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.miscList.HEADER_TYPE, {
        title = "Ultimates",
    }))

    -- insert playerRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.miscList.ROW_TYPE, playerData))
    end

    self.miscList.window:SetHeight(
        self.miscList.listHeaderHeight +
        (#playersDataList * self.miscList.listRowHeight)
    )

    ZO_ScrollList_Commit(listControl)
end