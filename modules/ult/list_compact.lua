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
local HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED = addon.HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED
local HR_EVENT_MAJOR_BERSERK_BUFF_GAINED = addon.HR_EVENT_MAJOR_BERSERK_BUFF_GAINED
local HR_EVENT_MAJOR_SLAYER_BUFF_GAINED = addon.HR_EVENT_MAJOR_SLAYER_BUFF_GAINED
local HR_EVENT_PILLAGER_BUFF_COOLDOWN = addon.HR_EVENT_PILLAGER_BUFF_COOLDOWN


local svVersion = 1
local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowPosLeft = 860,
    windowPosTop = 50,
    windowWidth = 262,

    showPercentValue = 1.0,
    showGainValue = 1.0,

    showHorn = true,
    showColos = true,
    showAtro = true,
    showSlayer = true,
    showPillager = true,
    showCryptCannon = true,

    headerOpacity = 0.0,
    zeroTimerOpacity = 0.7,
}

function module:CreateCompactList()
    local listDefinition = {
        name = "compact",
        svVersion = svVersion,
        svDefault = svDefault,
        Update = function() self:UpdateCompactList() end,

        listHeaderHeight = 60,
        listRowHeight = 24,

        colorCooldowns = {1, 0, 0}, -- red
        colorDurations = {1, 1, 0}, -- yellow
        colorHornBG = {1, 1, 0}, -- yellow
        --colorHornBG = { util.Hex2RGB("fa5b26") }, -- orange
        colorColosBG = {0, 0, 1}, -- blue
        colorAtroBG = {0, 1, 1}, -- cyan
        colorSlayerBG = {1, 0, 0}, -- red
        colorPillagerBG = {0, 1, 0}, -- green
        colorCryptCannonBG = {1, 0, 1}, -- purple
        backgroundAlpha = 0.2,
    }
    self.compactList = addon.listClass:New(listDefinition)

    self.compactList.HEADER_TYPE = 1 -- type id for header
    self.compactList.ROW_TYPE_HORN = 2 -- type id for horn rows
    self.compactList.ROW_TYPE_COLOS = 3 -- type id for colos rows
    self.compactList.ROW_TYPE_ATRO = 4 -- type id for atro rows
    self.compactList.ROW_TYPE_SLAYER = 5 -- type id for slayer rows
    self.compactList.ROW_TYPE_PILLAGER = 6 -- type id for pillager rows
    self.compactList.ROW_TYPE_CRYPTCANNON = 7 -- type id for cryptcannon rows
    self.compactList.HEADER_TEMPLATE = "HodorReflexes_Ult_CompactList_Header"
    self.compactList.ROW_TEMPLATE = "HodorReflexes_Ult_CompactList_PlayerRow"

    local function headerRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            wrappedFunction(self, rowControl, data, scrollList)
        end
    end

    local function playerRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            if (self.isTestRunning or IsUnitOnline(data.tag)) then
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
    self.compactList.logger:Debug("added header row type '%d' with template '%s'", self.compactList.HEADER_TYPE, self.compactList.HEADER_TEMPLATE)

    ZO_ScrollList_AddDataType(
            self.compactList.listControl,
            self.compactList.ROW_TYPE_HORN,
            self.compactList.ROW_TEMPLATE,
            self.compactList.listRowHeight,
            playerRowCreationWrapper(self.compactListHornRowCreationFunction)
    )
    self.compactList.logger:Debug("added horn player row type '%d' with template '%s'", self.compactList.ROW_TYPE_HORN, self.compactList.ROW_TEMPLATE)
    ZO_ScrollList_AddDataType(
            self.compactList.listControl,
            self.compactList.ROW_TYPE_COLOS,
            self.compactList.ROW_TEMPLATE,
            self.compactList.listRowHeight,
            playerRowCreationWrapper(self.compactListColosRowCreationFunction)
    )
    self.compactList.logger:Debug("added colos player row type '%d' with template '%s'", self.compactList.ROW_TYPE_COLOS, self.compactList.ROW_TEMPLATE)
    ZO_ScrollList_AddDataType(
            self.compactList.listControl,
            self.compactList.ROW_TYPE_ATRO,
            self.compactList.ROW_TEMPLATE,
            self.compactList.listRowHeight,
            playerRowCreationWrapper(self.compactListAtroRowCreationFunction)
    )
    self.compactList.logger:Debug("added atro player row type '%d' with template '%s'", self.compactList.ROW_TYPE_ATRO, self.compactList.ROW_TEMPLATE)
    ZO_ScrollList_AddDataType(
            self.compactList.listControl,
            self.compactList.ROW_TYPE_SLAYER,
            self.compactList.ROW_TEMPLATE,
            self.compactList.listRowHeight,
            playerRowCreationWrapper(self.compactListSlayerRowCreationFunction)
    )
    self.compactList.logger:Debug("added slayer player row type '%d' with template '%s'", self.compactList.ROW_TYPE_SLAYER, self.compactList.ROW_TEMPLATE)
    ZO_ScrollList_AddDataType(
            self.compactList.listControl,
            self.compactList.ROW_TYPE_PILLAGER,
            self.compactList.ROW_TEMPLATE,
            self.compactList.listRowHeight,
            playerRowCreationWrapper(self.compactListPillagerRowCreationFunction)
    )
    self.compactList.logger:Debug("added pillager player row type '%d' with template '%s'", self.compactList.ROW_TYPE_PILLAGER, self.compactList.ROW_TEMPLATE)
    ZO_ScrollList_AddDataType(
            self.compactList.listControl,
            self.compactList.ROW_TYPE_CRYPTCANNON,
            self.compactList.ROW_TEMPLATE,
            self.compactList.listRowHeight,
            playerRowCreationWrapper(self.compactListCryptCannonRowCreationFunction)
    )
    self.compactList.logger:Debug("added cryptcannon player row type '%d' with template '%s'", self.compactList.ROW_TYPE_CRYPTCANNON, self.compactList.ROW_TEMPLATE)

    -- register cooldown end time tracker for pillager cooldown
    local function setPillagerCooldownEndTime(_, duration)
        self.pillagerCooldownEndTime = GetGameTimeMilliseconds() + duration
    end
    addon.RegisterCallback(HR_EVENT_PILLAGER_BUFF_COOLDOWN, setPillagerCooldownEndTime)
end

function module:compactListHeaderRowCreationFunction(rowControl, data, scrollList)
    if not rowControl._initialized then
        rowControl:GetNamedChild("_BG"):SetAlpha(self.compactList.sw.headerOpacity)

        rowControl:GetNamedChild("_HornIcon"):SetTexture(self.hornIcon)
        rowControl:GetNamedChild("_HornDuration"):SetColor(unpack(self.compactList.colorDurations))
        rowControl:GetNamedChild("_HornDuration"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_HornDuration"),
                HR_EVENT_HORN_BUFF_GAINED,
                self.compactList.sw.zeroTimerOpacity
        )

        rowControl:GetNamedChild("_ForceIcon"):SetTexture(self.forceIcon)
        rowControl:GetNamedChild("_ForceDuration"):SetColor(unpack(self.compactList.colorDurations))
        rowControl:GetNamedChild("_ForceDuration"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_ForceDuration"),
                HR_EVENT_MAJOR_FORCE_BUFF_GAINED,
                self.compactList.sw.zeroTimerOpacity
        )

        rowControl:GetNamedChild("_ColosIcon"):SetTexture(self.vulnIcon)
        rowControl:GetNamedChild("_VulnDuration"):SetColor(unpack(self.compactList.colorDurations))
        rowControl:GetNamedChild("_VulnDuration"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_VulnDuration"),
                HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED,
                self.compactList.sw.zeroTimerOpacity
        )

        rowControl:GetNamedChild("_AtroIcon"):SetTexture(self.berserkIcon)
        rowControl:GetNamedChild("_BerserkDuration"):SetColor(unpack(self.compactList.colorDurations))
        rowControl:GetNamedChild("_BerserkDuration"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_BerserkDuration"),
                HR_EVENT_MAJOR_BERSERK_BUFF_GAINED,
                self.compactList.sw.zeroTimerOpacity
        )

        rowControl:GetNamedChild("_SlayerIcon"):SetTexture(self.slayerIcon)
        rowControl:GetNamedChild("_SlayerDuration"):SetColor(unpack(self.compactList.colorDurations))
        rowControl:GetNamedChild("_SlayerDuration"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_SlayerDuration"),
                HR_EVENT_MAJOR_SLAYER_BUFF_GAINED,
                self.compactList.sw.zeroTimerOpacity
        )

        rowControl:GetNamedChild("_PillagerIcon"):SetTexture(self.pillagerIcon)
        rowControl:GetNamedChild("_PillagerCooldown"):SetColor(unpack(self.compactList.colorCooldowns))
        rowControl:GetNamedChild("_PillagerCooldown"):SetAlpha(self.compactList.sw.zeroTimerOpacity)
        self.compactList:CreateCountdownOnControl(
                rowControl:GetNamedChild("_PillagerCooldown"),
                HR_EVENT_PILLAGER_BUFF_COOLDOWN,
                self.compactList.sw.zeroTimerOpacity
        )

        rowControl._initialized = true
    end
end

function module:applyUserStyles(rowControl, data, scrollList)
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
    rawValueControl:SetScale(self.compactList.sw.showGainValue)
end

function module:applyValues(rowControl, data, scrollList, percentage, gain, gainUnit)
    local percentageColor = self:getUltPercentageColor(percentage, 'FFFFFF')
    rowControl:GetNamedChild("_PctValue"):SetText(string.format('|c%s%d%%|r', percentageColor, percentage))
    local gainString = "-"
    if gain ~= nil then gainString = string.format('%d%s', gain, gainUnit or "|u0:2:: |u") end
    rowControl:GetNamedChild("_RawValue"):SetText(gainString)
end

function module:compactListHornRowCreationFunction(rowControl, data, scrollList)
    self:applyUserStyles(rowControl, data, scrollList)
    rowControl:GetNamedChild('_BG'):SetColor(unpack(self.compactList.colorHornBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(self.compactList.backgroundAlpha)
    rowControl:GetNamedChild("_UltIcon"):SetTexture(self.hornIcon)

    local hornPercentage = 0
    local gainSeconds = nil
    if self:isHorn(data.ult1ID) then hornPercentage = data.ult1Percentage end
    if self:isHorn(data.ult2ID) then hornPercentage = data.ult2Percentage end
    if data.hasSaxhleel then
        hornPercentage = zo_min(data.ult1Percentage, data.ult2Percentage) -- we use the cheapest ult because saxhleel can be thrown at any time
        gainSeconds = zo_floor(data.ultValue / 15) -- 1s per 15 points of ult
    end

    self:applyValues(rowControl, data, scrollList, hornPercentage, gainSeconds, "s")
end

function module:compactListColosRowCreationFunction(rowControl, data, scrollList)
    self:applyUserStyles(rowControl, data, scrollList)
    rowControl:GetNamedChild('_BG'):SetColor(unpack(self.compactList.colorColosBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(self.compactList.backgroundAlpha)
    rowControl:GetNamedChild("_UltIcon"):SetTexture(self.colosIcon)

    local colosPercentage = 0
    if self:isColos(data.ult1ID) then colosPercentage = data.ult1Percentage end
    if self:isColos(data.ult2ID) then colosPercentage = data.ult2Percentage end

    self:applyValues(rowControl, data, scrollList, colosPercentage, nil, nil)
end

function module:compactListAtroRowCreationFunction(rowControl, data, scrollList)
    self:applyUserStyles(rowControl, data, scrollList)
    rowControl:GetNamedChild('_BG'):SetColor(unpack(self.compactList.colorAtroBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(self.compactList.backgroundAlpha)
    rowControl:GetNamedChild("_UltIcon"):SetTexture(self.atroIcon)

    local atroPercentage = 0
    if self:isAtro(data.ult1ID) then atroPercentage = data.ult1Percentage end
    if self:isAtro(data.ult2ID) then atroPercentage = data.ult2Percentage end

    self:applyValues(rowControl, data, scrollList, atroPercentage, nil, nil)
end

function module:compactListSlayerRowCreationFunction(rowControl, data, scrollList)
    self:applyUserStyles(rowControl, data, scrollList)
    rowControl:GetNamedChild('_BG'):SetColor(unpack(self.compactList.colorSlayerBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(self.compactList.backgroundAlpha)
    rowControl:GetNamedChild("_UltIcon"):SetTexture(self.slayerIcon)

    local slayerPercentage = zo_min(data.ult1Percentage, data.ult2Percentage)
    local gainSeconds = zo_floor(data.ultValue / 10) -- 1s per 10 points of ult

    self:applyValues(rowControl, data, scrollList, slayerPercentage, gainSeconds, "s")
end

function module:compactListPillagerRowCreationFunction(rowControl, data, scrollList)
    self:applyUserStyles(rowControl, data, scrollList)
    rowControl:GetNamedChild('_BG'):SetColor(unpack(self.compactList.colorPillagerBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(self.compactList.backgroundAlpha)
    rowControl:GetNamedChild("_UltIcon"):SetTexture(self.pillagerIcon)

    local pillagerPercentage = zo_min(data.ult1Percentage, data.ult2Percentage)
    local gainUltimate = zo_floor(data.ultValue * 0.02) * 5 -- 2% of ult spent gets transferred per tick ( 5 ticks in total )

    self:applyValues(rowControl, data, scrollList, pillagerPercentage, gainUltimate, nil)
    if self.pillagerCooldownEndTime > GetGameTimeMilliseconds() then
        rowControl:GetNamedChild("_PctValue"):SetText(string.format("|c%s%d%%", "FF0000", pillagerPercentage)) -- red
    end
end

function module:compactListCryptCannonRowCreationFunction(rowControl, data, scrollList)
    self:applyUserStyles(rowControl, data, scrollList)
    rowControl:GetNamedChild('_BG'):SetColor(unpack(self.compactList.colorCryptCannonBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(self.compactList.backgroundAlpha)
    rowControl:GetNamedChild("_UltIcon"):SetTexture(self.cryptCannonIcon)

    local groupSize = GetGroupSize()
    if groupSize == 0 then -- when in test mode, we use the number of players in the data table so we do not divide by 0 while calculating the shared ult
        for _, _ in pairs(addon.playersData) do
            groupSize = groupSize + 1
        end
    end

    local cryptCannonPercentage = zo_min(data.ult1Percentage, data.ult2Percentage)
    local gainUltimate = zo_floor(data.ultValue / groupSize) -- ult gets transferred equally amongst living group members / we ignore the living part here

    self:applyValues(rowControl, data, scrollList, cryptCannonPercentage, gainUltimate, nil)
end

function module:UpdateCompactList()
    local listControl = self.compactList.listControl

    ZO_ScrollList_Clear(listControl)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    local hornList = {}
    local colosList = {}
    local atroList = {}
    local slayerList = {}
    local pillagerList = {}
    local cryptCannonList = {}

    for _, playerData in pairs(addon.playersData) do
        if self.compactList.sw.showHorn and playerData.hasHorn or playerData.hasSaxhleel then
            table.insert(hornList, playerData)
        end
        if self.compactList.sw.showColos and playerData.hasColos then
            table.insert(colosList, playerData)
        end
        if self.compactList.sw.showAtro and playerData.hasAtro then
            table.insert(atroList, playerData)
        end
        if self.compactList.sw.showSlayer and playerData.hasMAorWM then
            table.insert(slayerList, playerData)
        end
        if self.compactList.sw.showPillager and playerData.hasPillager then
            table.insert(pillagerList, playerData)
        end
        if self.compactList.sw.showCryptCannon and playerData.hasCryptCannon then
            table.insert(cryptCannonList, playerData)
        end
    end
    table.sort(hornList, self.sortByUltPercentage)
    table.sort(colosList, self.sortByUltPercentage)
    table.sort(atroList, self.sortByUltPercentage)
    table.sort(slayerList, self.sortByUltPercentage)
    table.sort(pillagerList, self.sortByUltPercentage)
    table.sort(cryptCannonList, self.sortByUltPercentage)


    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.compactList.HEADER_TYPE, {}))

    local entryCount = 0
    for i, playerData in ipairs(hornList) do
        entryCount = entryCount + 1
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.compactList.ROW_TYPE_HORN, playerData))
    end
    for i, playerData in ipairs(colosList) do
        entryCount = entryCount + 1
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.compactList.ROW_TYPE_COLOS, playerData))
    end
    for i, playerData in ipairs(atroList) do
        entryCount = entryCount + 1
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.compactList.ROW_TYPE_ATRO, playerData))
    end
    for i, playerData in ipairs(slayerList) do
        entryCount = entryCount + 1
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.compactList.ROW_TYPE_SLAYER, playerData))
    end
    for i, playerData in ipairs(pillagerList) do
        entryCount = entryCount + 1
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.compactList.ROW_TYPE_PILLAGER, playerData))
    end
    for i, playerData in ipairs(cryptCannonList) do
        entryCount = entryCount + 1
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(self.compactList.ROW_TYPE_CRYPTCANNON, playerData))
    end

    self.compactList.window:SetHeight(
        self.compactList.listHeaderHeight +
        (entryCount * self.compactList.listRowHeight)
    )

    ZO_ScrollList_Commit(listControl)
end