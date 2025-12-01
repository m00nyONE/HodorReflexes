-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules

local module_name = "ult"
local module = addon_modules[module_name]

local util = addon.util

local HR_EVENT_HORN_BUFF_GAINED = addon.HR_EVENT_HORN_BUFF_GAINED
local HR_EVENT_MAJOR_FORCE_BUFF_GAINED = addon.HR_EVENT_MAJOR_FORCE_BUFF_GAINED
local HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED = addon.HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED
local HR_EVENT_MAJOR_BERSERK_BUFF_GAINED = addon.HR_EVENT_MAJOR_BERSERK_BUFF_GAINED
local HR_EVENT_MAJOR_SLAYER_BUFF_GAINED = addon.HR_EVENT_MAJOR_SLAYER_BUFF_GAINED
local HR_EVENT_PILLAGER_BUFF_COOLDOWN = addon.HR_EVENT_PILLAGER_BUFF_COOLDOWN

local blankTable = {}

local svVersion = 1
local svDefault = {
    enabled =  1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowScale = 1.0,
    windowPosLeft = 250,
    windowPosTop = 260,
    windowWidth = 272,
    backgroundOpacity = 0.0,

    showPercentValue = 1.0,
    showRawValue = 1.0,

    headerOpacity = 0.0,
    zeroTimerOpacity = 0.35,

    supportRangeOnly = false,

    showHorn = true,
    showColos = true,
    showAtro = true,
    showBarrier = true,
    showSlayer = true,
    showPillager = true,
    showCryptCannon = true,

    showHornCountdown = true,
    showForceCountdown = true,
    showVulnCountdown = true,
    showBerserkCountdown = true,
    showSlayerCountdown = true,
    showPillagerCooldown = true,

    colorCooldowns = {1, 0, 0}, -- red
    colorDurations = {1, 1, 0}, -- yellow

    backgroundAlpha = 0.2,
    colorHornBG = {1, 1, 0}, -- yellow
    colorColosBG = {0, 0, 1}, -- blue
    colorAtroBG = {0, 1, 1}, -- cyan
    colorSlayerBG = {1, 0, 0}, -- red
    colorPillagerBG = {0, 1, 0}, -- green
    colorCryptCannonBG = {1, 0, 1}, -- purple
    colorBarrierBG = {1, 0.5, 0}, -- orange

    markOnCooldown = true,
    markOnCooldownColor = {1, 0, 0}, -- red

    nameFont = "$(BOLD_FONT)|$(KB_19)|outline",
}

--- Create the compact ult list.
--- @return void
function module:CreateCompactList()
    local listDefinition = {
        name = "compact",
        svVersion = svVersion,
        svDefault = svDefault,
        Update = function() self:UpdateCompactList() end,

        listHeaderHeight = 60,
        listRowHeight = 24,
    }
    self.compactList = addon.listClass:New(listDefinition)
    local list = self.compactList

    list.HEADER_TYPE = list:GetNextDataTypeId() -- type id for header
    list.ROW_TYPE_HORN = list:GetNextDataTypeId() -- type id for horn rows
    list.ROW_TYPE_BARRIER = list:GetNextDataTypeId() -- type id for barrier rows
    list.ROW_TYPE_COLOS = list:GetNextDataTypeId() -- type id for colos rows
    list.ROW_TYPE_ATRO = list:GetNextDataTypeId() -- type id for atro rows
    list.ROW_TYPE_SLAYER = list:GetNextDataTypeId() -- type id for slayer rows
    list.ROW_TYPE_PILLAGER = list:GetNextDataTypeId() -- type id for pillager rows
    list.ROW_TYPE_CRYPTCANNON = list:GetNextDataTypeId() -- type id for cryptcannon rows
    list.HEADER_TEMPLATE = "HodorReflexes_Ult_CompactList_Header"
    list.ROW_TEMPLATE = "HodorReflexes_Ult_CompactList_PlayerRow"

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
            rowCreationWrapper(self.compactListHeaderRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(list.listControl, list.HEADER_TYPE, true)
    list.logger:Debug("added header row type '%d' with template '%s'", list.HEADER_TYPE, list.HEADER_TEMPLATE)

    ZO_ScrollList_AddDataType(
            list.listControl,
            list.ROW_TYPE_HORN,
            list.ROW_TEMPLATE,
            list.listRowHeight,
            rowCreationWrapper(self.compactListHornRowCreationFunction)
    )
    list.logger:Debug("added horn player row type '%d' with template '%s'", list.ROW_TYPE_HORN, list.ROW_TEMPLATE)
    ZO_ScrollList_AddDataType(
            list.listControl,
            list.ROW_TYPE_COLOS,
            list.ROW_TEMPLATE,
            list.listRowHeight,
            rowCreationWrapper(self.compactListColosRowCreationFunction)
    )
    list.logger:Debug("added colos player row type '%d' with template '%s'", list.ROW_TYPE_COLOS, list.ROW_TEMPLATE)
    ZO_ScrollList_AddDataType(
            list.listControl,
            list.ROW_TYPE_ATRO,
            list.ROW_TEMPLATE,
            list.listRowHeight,
            rowCreationWrapper(self.compactListAtroRowCreationFunction)
    )
    list.logger:Debug("added atro player row type '%d' with template '%s'", list.ROW_TYPE_ATRO, list.ROW_TEMPLATE)
    ZO_ScrollList_AddDataType(
            list.listControl,
            list.ROW_TYPE_SLAYER,
            list.ROW_TEMPLATE,
            list.listRowHeight,
            rowCreationWrapper(self.compactListSlayerRowCreationFunction)
    )
    list.logger:Debug("added slayer player row type '%d' with template '%s'", list.ROW_TYPE_SLAYER, list.ROW_TEMPLATE)
    ZO_ScrollList_AddDataType(
            list.listControl,
            list.ROW_TYPE_PILLAGER,
            list.ROW_TEMPLATE,
            list.listRowHeight,
            rowCreationWrapper(self.compactListPillagerRowCreationFunction)
    )
    list.logger:Debug("added pillager player row type '%d' with template '%s'", list.ROW_TYPE_PILLAGER, list.ROW_TEMPLATE)
    ZO_ScrollList_AddDataType(
            list.listControl,
            list.ROW_TYPE_CRYPTCANNON,
            list.ROW_TEMPLATE,
            list.listRowHeight,
            rowCreationWrapper(self.compactListCryptCannonRowCreationFunction)
    )
    list.logger:Debug("added cryptcannon player row type '%d' with template '%s'", list.ROW_TYPE_CRYPTCANNON, list.ROW_TEMPLATE)
    ZO_ScrollList_AddDataType(
        list.listControl,
        list.ROW_TYPE_BARRIER,
        list.ROW_TEMPLATE,
        list.listRowHeight,
        rowCreationWrapper(self.compactListBarrierRowCreationFunction)
    )
    list.logger:Debug("added barrier player row type '%d' with template '%s'", list.ROW_TYPE_BARRIER, list.ROW_TEMPLATE)

    -- register cooldown end time tracker for pillager cooldown
    local function setPillagerCooldownEndTime(_, duration)
        self.pillagerCooldownEndTime = GetGameTimeMilliseconds() + duration
    end
    addon.RegisterCallback(HR_EVENT_PILLAGER_BUFF_COOLDOWN, setPillagerCooldownEndTime)
end

--- Header row creation function for compact ult list.
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:compactListHeaderRowCreationFunction(rowControl, data, scrollList)
    if rowControl._initialized and not self.compactList._redrawHeaders then -- we can skip everything if already initialized and no redraw is needed
        return
    end

    local list = self.compactList
    local sw = list.sw

    rowControl:GetNamedChild("_BG"):SetAlpha(sw.headerOpacity)

    local container, icon, duration

    container = rowControl:GetNamedChild("_Horn")
    if not sw.showHornCountdown then
        container:SetScale(0)
    else
        icon = container:GetNamedChild("_Icon")
        duration = container:GetNamedChild("_Duration")

        container:SetScale(1)
        icon:SetTexture(self.hornIcon)
        duration:SetColor(unpack(sw.colorDurations))
        duration:SetAlpha(sw.zeroTimerOpacity)
        list:CreateCountdownOnControl(duration, HR_EVENT_HORN_BUFF_GAINED)
    end

    container = rowControl:GetNamedChild("_Force")
    if not sw.showForceCountdown then
        container:SetScale(0)
    else
        icon = container:GetNamedChild("_Icon")
        duration = container:GetNamedChild("_Duration")

        container:SetScale(1)
        icon:SetTexture(self.forceIcon)
        duration:SetColor(unpack(sw.colorDurations))
        duration:SetAlpha(sw.zeroTimerOpacity)
        list:CreateCountdownOnControl(duration, HR_EVENT_MAJOR_FORCE_BUFF_GAINED)
    end

    container = rowControl:GetNamedChild("_Vuln")
    if not sw.showVulnCountdown then
        container:SetScale(0)
    else
        icon = container:GetNamedChild("_Icon")
        duration = container:GetNamedChild("_Duration")

        container:SetScale(1)
        icon:SetTexture(self.vulnIcon)
        duration:SetColor(unpack(sw.colorDurations))
        duration:SetAlpha(sw.zeroTimerOpacity)
        list:CreateCountdownOnControl(duration, HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED)
    end

    container = rowControl:GetNamedChild("_Berserk")
    if not sw.showBerserkCountdown then
        container:SetScale(0)
    else
        icon = container:GetNamedChild("_Icon")
        duration = container:GetNamedChild("_Duration")

        container:SetScale(1)
        icon:SetTexture(self.berserkIcon)
        duration:SetColor(unpack(sw.colorDurations))
        duration:SetAlpha(sw.zeroTimerOpacity)
        list:CreateCountdownOnControl(duration, HR_EVENT_MAJOR_BERSERK_BUFF_GAINED)
    end

    container = rowControl:GetNamedChild("_Slayer")
    if not sw.showSlayerCountdown then
        container:SetScale(0)
    else
        icon = container:GetNamedChild("_Icon")
        duration = container:GetNamedChild("_Duration")

        container:SetScale(1)
        icon:SetTexture(self.slayerIcon)
        duration:SetColor(unpack(sw.colorDurations))
        duration:SetAlpha(sw.zeroTimerOpacity)
        list:CreateCountdownOnControl(duration, HR_EVENT_MAJOR_SLAYER_BUFF_GAINED)

    end

    container = rowControl:GetNamedChild("_Pillager")
    if not sw.showPillagerCooldown then
        container:SetScale(0)
    else
        icon = container:GetNamedChild("_Icon")
        duration = container:GetNamedChild("_Duration")

        container:SetScale(1)
        icon:SetTexture(self.pillagerIcon)
        duration:SetColor(unpack(sw.colorCooldowns))
        duration:SetAlpha(sw.zeroTimerOpacity)
        list:CreateCountdownOnControl(duration, HR_EVENT_PILLAGER_BUFF_COOLDOWN)
    end

    list._redrawHeaders = false
    rowControl._initialized = true
end

--- Apply ult percentage and gain values to compact list row.
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @param percentage number
--- @param gain number|nil
--- @param gainUnit string|nil
--- @return void
function module:applyCompactListValues(rowControl, data, scrollList, percentage, gain, gainUnit)
    local percentageColor = self:getUltPercentageColor(percentage, 'FFFFFF')
    local sw = self.compactList.sw
    rowControl:GetNamedChild("_PctValue"):SetText(string.format('|c%s%d%%|r', percentageColor, percentage))
    rowControl:GetNamedChild("_PctValue"):SetScale(sw.showPercentValue)
    local gainString = "-"
    if gain ~= nil then gainString = string.format('%d%s', gain, gainUnit or "|u0:2:: |u") end
    rowControl:GetNamedChild("_RawValue"):SetText(gainString)
    rowControl:GetNamedChild("_RawValue"):SetScale(sw.showRawValue)
end

--- Horn row creation function for compact ult list.
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:compactListHornRowCreationFunction(rowControl, data, scrollList)
    local list = self.compactList
    local sw = list.sw

    list:ApplySupportRangeStyle(rowControl, data.tag)
    list:ApplyUserNameToControl(rowControl:GetNamedChild('_Name'), data.userId)
    list:ApplyUserIconToControl(rowControl:GetNamedChild('_Icon'), data.userId, data.classId)
    list:ApplyNameFontToControl(rowControl:GetNamedChild('_Name'))

    rowControl:GetNamedChild('_BG'):SetColor(unpack(sw.colorHornBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(sw.backgroundAlpha)
    if data.hasHorn then
        rowControl:GetNamedChild("_UltIcon"):SetTexture(self.hornIcon)
    elseif data.hasSaxhleel then
        rowControl:GetNamedChild("_UltIcon"):SetTexture(self.forceIcon)
    end

    local hornPercentage = 0
    local gainSeconds = nil
    if self:isHorn(data.ult1ID) then hornPercentage = data.ult1Percentage end
    if self:isHorn(data.ult2ID) then hornPercentage = data.ult2Percentage end
    if not data.hideSaxhleel and data.hasSaxhleel then
        hornPercentage = zo_min(data.ult1Percentage, data.ult2Percentage) -- we use the cheapest ult because saxhleel can be thrown at any time
        gainSeconds = zo_floor(data.ultValue / 15) -- 1s per 15 points of ult
    end

    self:applyCompactListValues(rowControl, data, scrollList, hornPercentage, gainSeconds, "s")
end

--- Horn row creation function for compact ult list.
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:compactListColosRowCreationFunction(rowControl, data, scrollList)
    local list = self.compactList
    local sw = list.sw

    list:ApplySupportRangeStyle(rowControl, data.tag)
    list:ApplyUserNameToControl(rowControl:GetNamedChild('_Name'), data.userId)
    list:ApplyUserIconToControl(rowControl:GetNamedChild('_Icon'), data.userId, data.classId)
    list:ApplyNameFontToControl(rowControl:GetNamedChild('_Name'))

    rowControl:GetNamedChild('_BG'):SetColor(unpack(sw.colorColosBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(sw.backgroundAlpha)
    rowControl:GetNamedChild("_UltIcon"):SetTexture(self.colosIcon)

    local colosPercentage = 0
    if self:isColos(data.ult1ID) then colosPercentage = data.ult1Percentage end
    if self:isColos(data.ult2ID) then colosPercentage = data.ult2Percentage end

    self:applyCompactListValues(rowControl, data, scrollList, colosPercentage, nil, nil)
end

--- Colos row creation function for compact ult list.
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:compactListAtroRowCreationFunction(rowControl, data, scrollList)
    local list = self.compactList
    local sw = list.sw

    list:ApplySupportRangeStyle(rowControl, data.tag)
    list:ApplyUserNameToControl(rowControl:GetNamedChild('_Name'), data.userId)
    list:ApplyUserIconToControl(rowControl:GetNamedChild('_Icon'), data.userId, data.classId)
    list:ApplyNameFontToControl(rowControl:GetNamedChild('_Name'))

    rowControl:GetNamedChild('_BG'):SetColor(unpack(sw.colorAtroBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(sw.backgroundAlpha)
    rowControl:GetNamedChild("_UltIcon"):SetTexture(self.atroIcon)

    local atroPercentage = 0
    if self:isAtro(data.ult1ID) then atroPercentage = data.ult1Percentage end
    if self:isAtro(data.ult2ID) then atroPercentage = data.ult2Percentage end

    self:applyCompactListValues(rowControl, data, scrollList, atroPercentage, nil, nil)
end

--- Atro row creation function for compact ult list.
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:compactListSlayerRowCreationFunction(rowControl, data, scrollList)
    local list = self.compactList
    local sw = list.sw

    list:ApplySupportRangeStyle(rowControl, data.tag)
    list:ApplyUserNameToControl(rowControl:GetNamedChild('_Name'), data.userId)
    list:ApplyUserIconToControl(rowControl:GetNamedChild('_Icon'), data.userId, data.classId)
    list:ApplyNameFontToControl(rowControl:GetNamedChild('_Name'))

    rowControl:GetNamedChild('_BG'):SetColor(unpack(sw.colorSlayerBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(sw.backgroundAlpha)
    rowControl:GetNamedChild("_UltIcon"):SetTexture(self.slayerIcon)

    local slayerPercentage = zo_min(data.ult1Percentage, data.ult2Percentage)
    local gainSeconds = zo_floor(data.ultValue / 10) -- 1s per 10 points of ult

    self:applyCompactListValues(rowControl, data, scrollList, slayerPercentage, gainSeconds, "s")
end

--- Barrier row creation function for compact ult list.
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:compactListBarrierRowCreationFunction(rowControl, data, scrollList)
    local list = self.compactList
    local sw = list.sw

    list:ApplySupportRangeStyle(rowControl, data.tag)
    list:ApplyUserNameToControl(rowControl:GetNamedChild('_Name'), data.userId)
    list:ApplyUserIconToControl(rowControl:GetNamedChild('_Icon'), data.userId, data.classId)
    list:ApplyNameFontToControl(rowControl:GetNamedChild('_Name'))

    rowControl:GetNamedChild('_BG'):SetColor(unpack(sw.colorBarrierBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(sw.backgroundAlpha)
    rowControl:GetNamedChild("_UltIcon"):SetTexture(self.barrierIcon)

    local barrierPercentage = 0
    if self:isBarrier(data.ult1ID) then barrierPercentage = data.ult1Percentage end
    if self:isBarrier(data.ult2ID) then barrierPercentage = data.ult2Percentage end

    self:applyCompactListValues(rowControl, data, scrollList, barrierPercentage, nil, nil)
end


--- Slayer row creation function for compact ult list.
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:compactListPillagerRowCreationFunction(rowControl, data, scrollList)
    local list = self.compactList
    local sw = list.sw

    list:ApplySupportRangeStyle(rowControl, data.tag)
    list:ApplyUserNameToControl(rowControl:GetNamedChild('_Name'), data.userId)
    list:ApplyUserIconToControl(rowControl:GetNamedChild('_Icon'), data.userId, data.classId)
    list:ApplyNameFontToControl(rowControl:GetNamedChild('_Name'))

    rowControl:GetNamedChild('_BG'):SetColor(unpack(sw.colorPillagerBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(sw.backgroundAlpha)
    rowControl:GetNamedChild("_UltIcon"):SetTexture(self.pillagerIcon)

    local pillagerPercentage = zo_min(data.ult1Percentage, data.ult2Percentage)
    local gainUltimate = zo_floor(data.ultValue * 0.02) * 5 -- 2% of ult spent gets transferred per tick ( 5 ticks in total )

    self:applyCompactListValues(rowControl, data, scrollList, pillagerPercentage, gainUltimate, nil)
    if sw.markOnCooldown and self.pillagerCooldownEndTime > GetGameTimeMilliseconds() then
        rowControl:GetNamedChild("_PctValue"):SetText(string.format("|c%s%d%%", util.RGB2Hex(unpack(sw.markOnCooldownColor)), pillagerPercentage)) -- red
    end
end

--- Pillager row creation function for compact ult list.
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:compactListCryptCannonRowCreationFunction(rowControl, data, scrollList)
    local list = self.compactList
    local sw = list.sw

    list:ApplySupportRangeStyle(rowControl, data.tag)
    list:ApplyUserNameToControl(rowControl:GetNamedChild('_Name'), data.userId)
    list:ApplyUserIconToControl(rowControl:GetNamedChild('_Icon'), data.userId, data.classId)
    list:ApplyNameFontToControl(rowControl:GetNamedChild('_Name'))

    rowControl:GetNamedChild('_BG'):SetColor(unpack(sw.colorCryptCannonBG))
    rowControl:GetNamedChild('_BG'):SetAlpha(sw.backgroundAlpha)
    rowControl:GetNamedChild("_UltIcon"):SetTexture(self.cryptCannonIcon)

    local groupSize = zo_max(GetGroupSize() - 1, 0) -- ultimate is transferred to everyone except the wearer
    if groupSize == 0 then -- when in test mode, we use the number of players in the data table so we do not divide by 0 while calculating the shared ult
        for _, _ in pairs(addon.playersData) do
            groupSize = groupSize + 1
        end
    end

    local cryptCannonPercentage = zo_min(data.ult1Percentage, data.ult2Percentage)
    local gainUltimate = zo_floor(data.ultValue / groupSize) -- ult gets transferred equally amongst living group members / we ignore the living part here

    self:applyCompactListValues(rowControl, data, scrollList, cryptCannonPercentage, gainUltimate, nil)
end

--- Update the compact ult list.
--- @return void
function module:UpdateCompactList()
    local compactList = self.compactList
    local listControl = compactList.listControl

    ZO_ScrollList_Clear(listControl)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    local hornList = {}
    local colosList = {}
    local atroList = {}
    local slayerList = {}
    local pillagerList = {}
    local cryptCannonList = {}
    local barrierList = {}

    local sw = compactList.sw
    for _, playerData in pairs(addon.playersData) do
        if sw.showHorn and ((not playerData.hideHorn and playerData.hasHorn) or (not playerData.hideSaxhleel and playerData.hasSaxhleel)) then
            table.insert(hornList, playerData)
        end
        if sw.showColos and not playerData.hideColos and playerData.hasColos then
            table.insert(colosList, playerData)
        end
        if sw.showAtro and not playerData.hideAtro and playerData.hasAtro then
            table.insert(atroList, playerData)
        end
        if sw.showSlayer and playerData.hasSlayer then
            table.insert(slayerList, playerData)
        end
        if sw.showPillager and playerData.hasPillager then
            table.insert(pillagerList, playerData)
        end
        if sw.showCryptCannon and playerData.hasCryptCannon then
            table.insert(cryptCannonList, playerData)
        end
        if sw.showBarrier and not playerData.hideBarrier and playerData.hasBarrier then
            table.insert(barrierList, playerData)
        end
    end
    local sortByUltPercentage = self.sortByUltPercentage
    table.sort(hornList, sortByUltPercentage)
    table.sort(colosList, sortByUltPercentage)
    table.sort(atroList, sortByUltPercentage)
    table.sort(slayerList, sortByUltPercentage)
    table.sort(pillagerList, sortByUltPercentage)
    table.sort(cryptCannonList, sortByUltPercentage)
    table.sort(barrierList, sortByUltPercentage)

    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(compactList.HEADER_TYPE, blankTable))

    for _, playerData in ipairs(hornList) do
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(compactList.ROW_TYPE_HORN, playerData))
    end
    for _, playerData in ipairs(colosList) do
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(compactList.ROW_TYPE_COLOS, playerData))
    end
    for _, playerData in ipairs(atroList) do
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(compactList.ROW_TYPE_ATRO, playerData))
    end
    for _, playerData in ipairs(slayerList) do
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(compactList.ROW_TYPE_SLAYER, playerData))
    end
    for _, playerData in ipairs(pillagerList) do
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(compactList.ROW_TYPE_PILLAGER, playerData))
    end
    for _, playerData in ipairs(cryptCannonList) do
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(compactList.ROW_TYPE_CRYPTCANNON, playerData))
    end
    for _, playerData in ipairs(barrierList) do
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(compactList.ROW_TYPE_BARRIER, playerData))
    end

    ZO_ScrollList_Commit(listControl)
end