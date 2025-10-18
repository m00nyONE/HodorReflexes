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

local HR_EVENT_HORN_BUFF_GAINED = addon.HR_EVENT_HORN_BUFF_GAINED
local HR_EVENT_MAJOR_FORCE_BUFF_GAINED = addon.HR_EVENT_MAJOR_FORCE_BUFF_GAINED
local HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED = addon.HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED
local HR_EVENT_ATRO_CAST_STARTED = addon.HR_EVENT_ATRO_CAST_STARTED
local HR_EVENT_MAJOR_BERSERK_BUFF_GAINED = addon.HR_EVENT_MAJOR_BERSERK_BUFF_GAINED
local HR_EVENT_MAJOR_SLAYER_BUFF_GAINED = addon.HR_EVENT_MAJOR_SLAYER_BUFF_GAINED
local HR_EVENT_PILLAGER_BUFF_COOLDOWN = addon.HR_EVENT_PILLAGER_BUFF_COOLDOWN



local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowPosLeft = 860,
    windowPosTop = 50,
    windowWidth = 262,

    showPercentValue = 1.0,
    showRawValue = 1.0,

    headerOpacity = 0.0,
    zeroTimerOpacity = 0.7,

    colorHorn = {0, 1, 1}, -- cyan
    colorForce = {1, 1, 0}, -- yellow
    colorVuln = {1, 1, 0}, -- yellow
    colorAtro = {0, 1, 1}, -- cyan
    colorBerserk = {1, 1, 0}, -- yellow
    colorSlayerSeconds = {1, 0.5, 0}, -- orange
    colorSlayer = {1, 1, 0}, -- yellow
    colorPillagerUlt = {1, 0.5, 0}, -- orange
    colorPillagerCooldown = {1, 0, 0}, -- red
}

function module:CreateCompactList()
    local listDefinition = {
        name = "compact",
        svDefault = svDefault,
        Update = function() self:UpdateCompactList() end,
        listHeaderHeight = 58,
        listRowHeight = 24,
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
            self.compactList.listHeaderHeight,
            headerRowCreationWrapper(self.compactListHeaderRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(self.compactList.listControl, self.compactList.HEADER_TYPE, true)

    --ZO_ScrollList_AddDataType(
    --        self.compactList.listControl,
    --        self.compactList.ROW_TYPE,
    --        self.compactList.ROW_TEMPLATE,
    --        self.compactList.sw.listRowHeight,
    --        playerRowCreationWrapper(self.compactListRowCreationFunction)
    --)

    local hornType = 3
    ZO_ScrollList_AddDataType(
            self.compactList.listControl,
            hornType,
            self.compactList.ROW_TEMPLATE,
            self.compactList.listRowHeight,
            playerRowCreationWrapper(self.compactListHornRowCreationFunction)
    )
    local colosType = 4
    ZO_ScrollList_AddDataType(
            self.compactList.listControl,
            colosType,
            self.compactList.ROW_TEMPLATE,
            self.compactList.listRowHeight,
            playerRowCreationWrapper(self.compactListColosRowCreationFunction)
    )
    local atroType = 5
    ZO_ScrollList_AddDataType(
            self.compactList.listControl,
            atroType,
            self.compactList.ROW_TEMPLATE,
            self.compactList.listRowHeight,
            playerRowCreationWrapper(self.compactListAtroRowCreationFunction)
    )
    local slayerType = 6
    ZO_ScrollList_AddDataType(
            self.compactList.listControl,
            slayerType,
            self.compactList.ROW_TEMPLATE,
            self.compactList.listRowHeight,
            playerRowCreationWrapper(self.compactListSlayerRowCreationFunction)
    )
    local pillagerType = 7
    ZO_ScrollList_AddDataType(
            self.compactList.listControl,
            pillagerType,
            self.compactList.ROW_TEMPLATE,
            self.compactList.listRowHeight,
            playerRowCreationWrapper(self.compactListPillagerRowCreationFunction)
    )

end

function module:compactListHeaderRowCreationFunction(rowControl, data, scrollList)
    if not rowControl._initialized then
        rowControl:GetNamedChild("_BG"):SetAlpha(self.compactList.sw.headerOpacity)
        rowControl:GetNamedChild("_HornDuration"):SetColor(unpack(self.compactList.sw.colorHorn))
        rowControl:GetNamedChild("_HornDuration"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        rowControl:GetNamedChild("_ForceDuration"):SetColor(unpack(self.compactList.sw.colorForce))
        rowControl:GetNamedChild("_ForceDuration"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_HornDuration"),
                HR_EVENT_HORN_BUFF_GAINED,
                self.compactList.sw.zeroTimerOpacity
        )
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_ForceDuration"),
                HR_EVENT_MAJOR_FORCE_BUFF_GAINED,
                self.compactList.sw.zeroTimerOpacity
        )

        rowControl:GetNamedChild("_VulnDuration"):SetColor(unpack(self.compactList.sw.colorVuln))
        rowControl:GetNamedChild("_VulnDuration"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_VulnDuration"),
                HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED,
                self.compactList.sw.zeroTimerOpacity
        )

        rowControl:GetNamedChild("_AtroDuration"):SetColor(unpack(self.compactList.sw.colorAtro))
        rowControl:GetNamedChild("_AtroDuration"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        rowControl:GetNamedChild("_BerserkDuration"):SetColor(unpack(self.compactList.sw.colorBerserk))
        rowControl:GetNamedChild("_BerserkDuration"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_AtroDuration"),
                HR_EVENT_ATRO_CAST_STARTED,
                self.compactList.sw.zeroTimerOpacity
        )
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_BerserkDuration"),
                HR_EVENT_MAJOR_BERSERK_BUFF_GAINED,
                self.compactList.sw.zeroTimerOpacity
        )

        rowControl:GetNamedChild("_SlayerSeconds"):SetColor(unpack(self.compactList.sw.colorSlayerSeconds))
        rowControl:GetNamedChild("_SlayerSeconds"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        rowControl:GetNamedChild("_SlayerDuration"):SetColor(unpack(self.compactList.sw.colorSlayer))
        rowControl:GetNamedChild("_SlayerDuration"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_SlayerDuration"),
                addon.HR_EVENT_MAJOR_SLAYER_BUFF_GAINED,
                self.compactList.sw.zeroTimerOpacity
        )

        rowControl:GetNamedChild("_PillagerGain"):SetColor(unpack(self.compactList.sw.colorPillagerUlt))
        rowControl:GetNamedChild("_PillagerGain"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        rowControl:GetNamedChild("_PillagerCooldown"):SetColor(unpack(self.compactList.sw.colorPillagerCooldown))
        rowControl:GetNamedChild("_PillagerCooldown"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_PillagerCooldown"),
                addon.HR_EVENT_PILLAGER_BUFF_COOLDOWN,
                self.compactList.sw.zeroTimerOpacity
        )

        rowControl._initialized = true
    end

    rowControl:GetNamedChild("_SlayerSeconds"):SetText(string.format('%ds', data.slayerSeconds))
    rowControl:GetNamedChild("_PillagerGain"):SetText(string.format('%du', data.pillagerGain))

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

function module:compactListHornRowCreationFunction(rowControl, data, scrollList)
    self:compactListRowCreationFunction(rowControl, data, scrollList)
    local bgControl = rowControl:GetNamedChild('_BG')
    bgControl:SetColor(1, 1, 0, 0.2) -- yellow
end

function module:compactListColosRowCreationFunction(rowControl, data, scrollList)
    self:compactListRowCreationFunction(rowControl, data, scrollList)
    local bgControl = rowControl:GetNamedChild('_BG')
    bgControl:SetColor(0, 0, 1, 0.2) -- blue
end

function module:compactListAtroRowCreationFunction(rowControl, data, scrollList)
    self:compactListRowCreationFunction(rowControl, data, scrollList)
    local bgControl = rowControl:GetNamedChild('_BG')
    bgControl:SetColor(0, 1, 1, 0.2) -- cyan
end

function module:compactListSlayerRowCreationFunction(rowControl, data, scrollList)
    self:compactListRowCreationFunction(rowControl, data, scrollList)
    local bgControl = rowControl:GetNamedChild('_BG')
    bgControl:SetColor(1, 0, 0, 0.2) -- red
end

function module:compactListPillagerRowCreationFunction(rowControl, data, scrollList)
    self:compactListRowCreationFunction(rowControl, data, scrollList)
    local bgControl = rowControl:GetNamedChild('_BG')
    bgControl:SetColor(1, 0.5, 0, 0.2) -- orange
end

function module:UpdateCompactList()
    local listControl = self.compactList.listControl

    ZO_ScrollList_Clear(listControl)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    local highestSlayerPoints = 0
    local highestPillagerPoints = 0

    local hornList = {}
    local colosList = {}
    local atroList = {}
    local slayerList = {}
    local pillagerList = {}

    for _, playerData in pairs(addon.playersData) do
        if playerData.ultValue > 0 then
            if playerData.hasHorn or playerData.hasSaxhleel then
                table.insert(hornList, playerData)
            end
            if playerData.hasColos then
                table.insert(colosList, playerData)
            end
            if playerData.hasAtro then
                table.insert(atroList, playerData)
            end
            if playerData.hasMAorWM then
                table.insert(slayerList, playerData)
                if playerData.ultValue > highestSlayerPoints then
                    highestSlayerPoints = playerData.ultValue
                end
            end
            if playerData.hasPillager then
                table.insert(pillagerList, playerData)
                if playerData.ultValue > highestPillagerPoints then
                    highestPillagerPoints = playerData.ultValue
                end
            end
        end
    end
    table.sort(hornList, self.sortByUltPercentage)
    table.sort(colosList, self.sortByUltPercentage)
    table.sort(atroList, self.sortByUltPercentage)
    table.sort(slayerList, self.sortByUltPercentage)
    table.sort(pillagerList, self.sortByUltPercentage)


    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.compactList.HEADER_TYPE, {
        slayerSeconds = zo_floor(highestSlayerPoints / 10), -- 10 points per second
        pillagerGain = zo_floor(highestPillagerPoints * 0.02), -- 2% of ult spent gets transferred
    }))

    local entryCount = 0
    for i, playerData in ipairs(hornList) do
        entryCount = entryCount + 1
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(3, playerData))
    end
    for i, playerData in ipairs(colosList) do
        entryCount = entryCount + 1
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(4, playerData))
    end
    for i, playerData in ipairs(atroList) do
        entryCount = entryCount + 1
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(5, playerData))
    end
    for i, playerData in ipairs(slayerList) do
        entryCount = entryCount + 1
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(6, playerData))
    end
    for i, playerData in ipairs(pillagerList) do
        entryCount = entryCount + 1
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(7, playerData))
    end

    self.compactList.window:SetHeight(
        self.compactList.listHeaderHeight +
        (entryCount * self.compactList.listRowHeight)
    )

    ZO_ScrollList_Commit(listControl)
end