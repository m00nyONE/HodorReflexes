local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local module = {
    name = "ult",
    friendlyName = "Ultimates",
    description = "Shows group ultimates",
    version = "1.0.0",
    priority = 1,
    enabled = false,
}

local module_name = module.name
local module_version = module.version

local sw = nil
local sv = nil
local svName = addon.svName
local svVersion = addon.svVersion
local svDefault = {
    enabled = true,
    disablePvP = true,

    enableColoredNames = true,
    enableAnimIcons = true,
    enableIcons = true,

    enableMiscList = 1, -- 0=disabled, 1=always, 2=out of combat, 3=out of combat & no boss
    miscListPosLeft = 0,
    miscListPosTop = 0,
    miscListHeaderHeight = 28,
    miscListRowHeight = 24,
    miscListWidth = 262,
    showMiscPercentValue = 1.0,
    showMiscRawValue = 1.0,
    styleMiscHeaderOpacity = 0.0,

    enableHornList = 1,
    hornListPosLeft = 0,
    hornListPosTop = 0,
    hornListHeaderHeight = 28,
    hornListRowHeight = 24,
    hornListWidth = 262,
    showHornPercentValue = 1.0,
    showHornRawValue = 1.0,
    styleHornHeaderOpacity = 0.0,
    styleHornColor =  {0, 1, 1},
    styleForceColor = {1, 1, 0},
    styleHighlightSaxhleel = false,
    styleSaxhleelBGColor = {1, 1, 0, 0.15},

    enableColosList = 1,
    colosListPosLeft = 0,
    colosListPosTop = 0,
    colosListHeaderHeight = 28,
    colosListRowHeight = 24,
    colosListWidth = 262,
    showColosPercentValue = 1.0,
    showColosRawValue = 1.0,
    styleColosHeaderOpacity = 0.0,
    styleColosColor = {1, 1, 0},

    enableAtroList = 1,
    atroListPosLeft = 0,
    atroListPosTop = 0,
    atroListHeaderHeight = 28,
    atroListRowHeight = 24,
    atroListWidth = 262,
    showAtroPercentValue = 1.0,
    showAtroRawValue = 1.0,
    styleAtroHeaderOpacity = 0.0,
    styleAtroColor = {0, 1, 1},
    styleBerserkColor = {1, 1, 0},

    styleZeroTimerOpacity = 0.7,
    styleTimerBlink = true,

    selectedTheme = "default",
}

local EM = GetEventManager()
local WM = GetWindowManager()
local LGCS = LibGroupCombatStats
local localPlayer = "player"
local strformat = string.format

local lgcs = {}
local group = addon.group
local hud = addon.hud
local combat = addon.combat
local player = addon.player
local anim = addon.anim
local util = addon.util
local timer = addon.timer
local CreateOrUpdatePlayerData = group.CreateOrUpdatePlayerData
local playersData = group.playersData

local EVENT_GROUP_ULT_UPDATE = LGCS.EVENT_GROUP_ULT_UPDATE
local EVENT_PLAYER_ULT_UPDATE = LGCS.EVENT_PLAYER_ULT_UPDATE

local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED
local HR_EVENT_LOCKUI = addon.HR_EVENT_LOCKUI
local HR_EVENT_UNLOCKUI = addon.HR_EVENT_UNLOCKUI
local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED
local HR_EVENT_TEST_TICK = addon.HR_EVENT_TEST_TICK
local HR_EVENT_PLAYERSDATA_CLEANED = addon.HR_EVENT_PLAYERSDATA_CLEANED

local nextTypeId = 1
local MISC_LIST_HEADER_TYPE = 1
local MISC_LIST_PLAYERROW_TYPE = 2
local HORN_LIST_HEADER_TYPE = 1
local HORN_LIST_PLAYERROW_TYPE = 2
local COLOS_LIST_HEADER_TYPE = 1
local COLOS_LIST_PLAYERROW_TYPE = 2
local ATRO_LIST_HEADER_TYPE = 1
local ATRO_LIST_PLAYERROW_TYPE = 2

local MISC_LIST_DEFAULT_PLAYERROW_TEMPLATE = "HodorReflexes_Ult_MiscList_PlayerRow"
local MISC_LIST_DEFAULT_HEADER_TEMPLATE = "HodorReflexes_Ult_MiscList_Header"
local HORN_LIST_DEFAULT_PLAYERROW_TEMPLATE = "HodorReflexes_Ult_HornList_PlayerRow"
local HORN_LIST_DEFAULT_HEADER_TEMPLATE = "HodorReflexes_Ult_HornList_Header"
local COLOS_LIST_DEFAULT_PLAYERROW_TEMPLATE = "HodorReflexes_Ult_ColosList_PlayerRow"
local COLOS_LIST_DEFAULT_HEADER_TEMPLATE = "HodorReflexes_Ult_ColosList_Header"
local ATRO_LIST_DEFAULT_PLAYERROW_TEMPLATE = "HodorReflexes_Ult_AtroList_PlayerRow"
local ATRO_LIST_DEFAULT_HEADER_TEMPLATE = "HodorReflexes_Ult_AtroList_Header"

local majorForceId = 61747
local majorVulnerabilityId = 106754
local majorBerserkId = 61745
local hornBuffIds = {38564, 40221, 40224} -- horn buffs

local hornAbilityIds = {40223,	38563, 40220}
local colosAbilityIds = {122388, 122395, 122174}
local atroAbilityIds = {23634, 23492, 23495} -- atronach cast abilities
--local colosCastAbilityIds = {122380, 122391, 122398} -- colossus ability cast
--local hornIds  = {38564, 40221, 40224, majorForceId} -- TODO: remove - it's just here for reference

local MISC_FRAGMENT, HORN_FRAGMENT, COLOS_FRAGMENT, ATRO_FRAGMENT -- HUD Fragment

local miscListWindowName = addon_name .. module_name .. "_Misc"
local miscListWindow = {}
local miscListControlName = miscListWindowName .. "_List"
local miscListControl = {}
local hornListWindowName = addon_name .. module_name .. "_Horn"
local hornListWindow = {}
local hornListControlName = hornListWindowName .. "_List"
local hornListControl = {}
local hornListHeaderHornDurationControl = nil
local hornListHornTimer = nil
local hornListHeaderForceDurationControl = nil
local hornListForceTimer = nil
local colosListWindowName = addon_name .. module_name .. "_Colos"
local colosListWindow = {}
local colosListControlName = colosListWindowName .. "_List"
local colosListControl = {}
local colosListHeaderVulnDurationControl = nil
local colosListVulnTimer = nil
local atroListWindowName = addon_name .. module_name .. "_Atro"
local atroListWindow = {}
local atroListControlName = atroListWindowName .. "_List"
local atroListControl = {}
local atroListHeaderAtroDurationControl = nil
local atroListAtroTimer = nil
local atroListHeaderBerserkDurationControl = nil
local atroListBerserkTimer = nil


local controlsVisible = false
local uiLocked = true
local isTestRunning = false

local themes = {}
local LAMThemeChoices = {}

local classIcons = {}
for i = 1, GetNumClasses() do
    local id, _, _, _, _, _, icon, _, _, _ = GetClassInfo(i)
    classIcons[id] = icon
end

function addon.OverwriteClassIcons(ci)
    classIcons = ci
end

--- applies the selected theme by updating the data types used in the damage ScrollList
local function applyTheme(themeName)
    MISC_LIST_HEADER_TYPE = themes[themeName].MISC_LIST_HEADER_TYPE
    MISC_LIST_PLAYERROW_TYPE = themes[themeName].MISC_LIST_PLAYERROW_TYPE
    HORN_LIST_HEADER_TYPE = themes[themeName].HORN_LIST_HEADER_TYPE
    HORN_LIST_PLAYERROW_TYPE = themes[themeName].HORN_LIST_PLAYERROW_TYPE
    COLOS_LIST_HEADER_TYPE = themes[themeName].COLOS_LIST_HEADER_TYPE
    COLOS_LIST_PLAYERROW_TYPE = themes[themeName].COLOS_LIST_PLAYERROW_TYPE
    ATRO_LIST_HEADER_TYPE = themes[themeName].ATRO_LIST_HEADER_TYPE
    ATRO_LIST_PLAYERROW_TYPE = themes[themeName].ATRO_LIST_PLAYERROW_TYPE
end

--- validates the selected theme and sets it to "default" if not valid
local function validateSelectedTheme()
    if sw.selectedTheme == nil then sw.selectedTheme = "default" end
    if themes[sw.selectedTheme] == nil then sw.selectedTheme = "default" end
end

--- checks if damageList should be enabled at all
local function isEnabled()
    return sw.enabled and (not sw.disablePvP or not IsPlayerInAvAWorld() and not IsActiveWorldBattleground())
end

-- return the ultimate in percent from 0-100. from 100-200 its scaled acordingly.
local function getUltPercentage(ultValue, abilityCost)
    if ultValue <= abilityCost then
        return zo_floor((ultValue / abilityCost) * 100)
    end

    return zo_min(200, 100 + zo_floor(100 * (ultValue - abilityCost) / (500 - abilityCost)))
end

-- return a color code depending on the ult percentage
local function getUltPercentageColor(percentage, defaultColor)
    if percentage >= 100 then return '00FF00' end -- green
    if percentage >= 80 then return 'FFFF00' end -- yellow
    return defaultColor or 'FFFFFF' -- white
end

--- Returns true if the damage list should be shown, false otherwise.
local function isMiscListVisible()
    if sv.enableMiscList == 1 then
        return true
    elseif sv.enableMiscList == 2 then
        return not IsUnitInCombat(localPlayer)
    elseif sv.enableMiscList == 3 then
        return not IsUnitInCombat(localPlayer) or not DoesUnitExist('boss1') and not DoesUnitExist('boss2')
    else
        return false
    end
end
local function isHornListVisible()
    if sw.enableHornList == 1 then
        return true
    end
    return false
end
local function isColosListVisible()
    if sw.enableColosList == 1 then
        return true
    end
    return false
end
local function isAtroListVisible()
    if sw.enableAtroList == 1 then
        return true
    end
    return false
end

local function sortByUltValue(a, b)
    if a.ultValue == b.ultValue then
        return a.name > b.name
    end
    return a.ultValue > b.ultValue
end
local function sortByUltPercentage(a, b)
    a.lowestUltPercentage = zo_min(a.ult1Percentage, a.ult2Percentage)
    b.lowestUltPercentage = zo_min(b.ult1Percentage, b.ult2Percentage)
    if a.lowestUltPercentage == b.lowestUltPercentage then
        return sortByUltValue(a, b)
    end
    return a.lowestUltPercentage > b.lowestUltPercentage
end

local function isHorn(abilityId)
    for _, id in pairs(hornAbilityIds) do
        if abilityId == id then return true end
    end
    return false
end
local function isColos(abilityId)
    for _, id in pairs(colosAbilityIds) do
        if abilityId == id then return true end
    end
    return false
end
local function isAtro(abilityId)
    for _, id in pairs(atroAbilityIds) do
        if abilityId == id then return true end
    end
    return false
end
local function HasUnitHorn(data)
    if isHorn(data.ult1ID) or isHorn(data.ult2ID) then return true end

    if data.ultActivatedSetID == 1 then	return true end

    return false
end
local function HasUnitColos(data)
    if isColos(data.ult1ID) or isColos(data.ult2ID) then return true end

    return false
end
local function HasUnitAtro(data)
    if isAtro(data.ult1ID) or isAtro(data.ult2ID) then return true end

    return false
end

local function HasUnitBarrier(data)
    local abilityIDs = {40237,	40239, 38573}
    for _, id in ipairs(abilityIDs) do
        if data.ult1ID == id then return true end
        if data.ult2ID == id then return true end
    end

    return false
end

local function updateMiscUltimateList()
    if not isMiscListVisible then return end

    ZO_ScrollList_Clear(miscListControl)
    local dataList = ZO_ScrollList_GetDataList(miscListControl)

    local playersDataList = {}
    for _, playerData in pairs(playersData) do
        if playerData.ultValue > 0 and not HasUnitHorn(playerData) and not HasUnitAtro(playerData) and not HasUnitColos(playerData) then
            table.insert(playersDataList, playerData)
        end
    end
    table.sort(playersDataList, sortByUltPercentage)

    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(MISC_LIST_HEADER_TYPE, {
        title = "Ultimates",
    }))

    -- insert playerRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(MISC_LIST_PLAYERROW_TYPE, playerData))
    end

    miscListWindow:SetHeight((sw.miscListRowHeight * (#dataList - 1)) + sw.miscListHeaderHeight) -- TODO: temporary height adjustments

    ZO_ScrollList_Commit(miscListControl)
end
local function updateHornUltimateList()
    if not isHornListVisible() then return end

    ZO_ScrollList_Clear(hornListControl)
    local dataList = ZO_ScrollList_GetDataList(hornListControl)

    local playersDataList = {}
    for _, playerData in pairs(playersData) do
        if playerData.ultValue > 0 and HasUnitHorn(playerData) then
            local lowestPossibleHornCost = 0
            if playerData.ultActivatedSetID == 1 then
                lowestPossibleHornCost = zo_max(zo_min(playerData.ult1Cost, playerData.ult2Cost), 250)
                playerData.hasSaxhleel = true
            else
                if isHorn(playerData.ult1ID) then lowestPossibleHornCost = playerData.ult1Cost end
                if isHorn(playerData.ult2ID) then lowestPossibleHornCost = playerData.ult2Cost end
                playerData.hasSaxhleel = false
            end
            playerData.hornPercentage = getUltPercentage(playerData.ultValue, lowestPossibleHornCost)
            table.insert(playersDataList, playerData)
        end
    end
    table.sort(playersDataList, sortByUltPercentage)

    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(HORN_LIST_HEADER_TYPE, {
    }))

    -- insert playerRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(HORN_LIST_PLAYERROW_TYPE, playerData))
    end

    hornListWindow:SetHeight((sw.hornListRowHeight * (#dataList - 1)) + sw.hornListHeaderHeight) -- TODO: temporary height adjustments

    ZO_ScrollList_Commit(hornListControl)
end
local function updateColosUltimateList()
    if not isColosListVisible() then return end

    ZO_ScrollList_Clear(colosListControl)
    local dataList = ZO_ScrollList_GetDataList(colosListControl)

    local playersDataList = {}
    for _, playerData in pairs(playersData) do
        if playerData.ultValue > 0 and HasUnitColos(playerData) then
            local lowestPossibleColosCost = 0
            if isColos(playerData.ult1ID) then lowestPossibleColosCost = playerData.ult1Cost end
            if isColos(playerData.ult2ID) then lowestPossibleColosCost = playerData.ult2Cost end
            playerData.colosPercentage = getUltPercentage(playerData.ultValue, lowestPossibleColosCost)
            table.insert(playersDataList, playerData)
        end
    end
    table.sort(playersDataList, sortByUltPercentage)

    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(COLOS_LIST_HEADER_TYPE, {
    }))

    -- insert playerRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(COLOS_LIST_PLAYERROW_TYPE, playerData))
    end

    colosListWindow:SetHeight((sw.colosListRowHeight * (#dataList - 1)) + sw.colosListHeaderHeight) -- TODO: temporary height adjustments


    ZO_ScrollList_Commit(colosListControl)
end
local function updateAtroUltimateList()
    if not isAtroListVisible() then return end

    ZO_ScrollList_Clear(atroListControl)
    local dataList = ZO_ScrollList_GetDataList(atroListControl)

    local playersDataList = {}
    for _, playerData in pairs(playersData) do
        if playerData.ultValue > 0 and HasUnitAtro(playerData) then
            local lowestPossibleAtroCost = 0
            if isAtro(playerData.ult1ID) then lowestPossibleAtroCost = playerData.ult1Cost end
            if isAtro(playerData.ult2ID) then lowestPossibleAtroCost = playerData.ult2Cost end
            playerData.atroPercentage = getUltPercentage(playerData.ultValue, lowestPossibleAtroCost)
            table.insert(playersDataList, playerData)
        end
    end
    table.sort(playersDataList, sortByUltPercentage)

    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(ATRO_LIST_HEADER_TYPE, {
    }))

    -- insert playerRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(ATRO_LIST_PLAYERROW_TYPE, playerData))
    end

    atroListWindow:SetHeight((sw.atroListRowHeight * (#dataList - 1)) + sw.atroListHeaderHeight) -- TODO: temporary height adjustments

    ZO_ScrollList_Commit(atroListControl)
end

--- updates the damageList
local function updateUltimateLists()
    updateMiscUltimateList()
    updateHornUltimateList()
    updateColosUltimateList()
    updateAtroUltimateList()
end

--- processes incoming dps data messages and creates/updates the player's entry inside the playersData table
local function onULTDataReceived(tag, data)
    if not IsUnitGrouped(tag) then return end

    local ultValue = data.ultValue
    local ult1Cost = data.ult1Cost
    local ult2Cost = data.ult2Cost
    local ult1Percentage = getUltPercentage(ultValue, ult1Cost)
    local ult2Percentage = getUltPercentage(ultValue, ult2Cost)
    local lowestUltPercentage = zo_min(ult1Percentage, ult2Percentage)

    CreateOrUpdatePlayerData({
        name = GetUnitName(tag),
        tag  = tag,
        ultValue = ultValue,
        ult1ID = data.ult1ID,
        ult2ID = data.ult2ID,
        ult1Cost = ult1Cost,
        ult2Cost = ult2Cost,
        ult1Percentage = ult1Percentage,
        ult2Percentage = ult2Percentage,
        lowestUltPercentage = lowestUltPercentage,
        ultActivatedSetID = data.ultActivatedSetID,
    })

    updateUltimateLists()
end

local function refreshVisibility()
    controlsVisible = not uiLocked or isEnabled() and IsUnitGrouped(localPlayer)

    MISC_FRAGMENT:Refresh()
    HORN_FRAGMENT:Refresh()
    COLOS_FRAGMENT:Refresh()
    ATRO_FRAGMENT:Refresh()
end

local function UnlockUI()
    uiLocked = false
    refreshVisibility()
    hud.UnlockControls(miscListWindow, hornListWindow, colosListWindow, atroListWindow)
end

local function LockUI()
    uiLocked = true
    refreshVisibility()
    hud.LockControls(miscListWindow, hornListWindow, colosListWindow, atroListWindow)
end

local function onGroupChange()
    refreshVisibility()
end

local function createSceneFragments()
    local function MiscFragmentCondition()
        return isMiscListVisible() and controlsVisible
    end
    local function HornFragmentCondition()
        return isHornListVisible() and controlsVisible
    end
    local function ColosFragmentCondition()
        return isColosListVisible() and controlsVisible
    end
    local function AtroFragementCondition()
        return isAtroListVisible() and controlsVisible
    end

    MISC_FRAGMENT = hud.AddSimpleFragment(miscListWindow, MiscFragmentCondition)
    HORN_FRAGMENT = hud.AddSimpleFragment(hornListWindow, HornFragmentCondition)
    COLOS_FRAGMENT = hud.AddSimpleFragment(colosListWindow, ColosFragmentCondition)
    ATRO_FRAGMENT = hud.AddSimpleFragment(atroListWindow, AtroFragementCondition)
end

local function createMiscListWindow()
    miscListWindow = WM:CreateTopLevelWindow(miscListWindowName)
    miscListWindow:SetClampedToScreen(true)
    miscListWindow:SetResizeToFitDescendents(true)
    miscListWindow:SetHidden(true)
    miscListWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sv.miscListPosLeft, sv.miscListPosTop)
    miscListWindow:SetWidth(sw.miscListWidth)
    miscListWindow:SetHeight(sw.miscListHeaderHeight + (sw.miscListRowHeight * 12))
    miscListWindow:SetHandler( "OnMoveStop", function()
        sv.miscListPosLeft = miscListWindow:GetLeft()
        sv.miscListPosTop = miscListWindow:GetTop()
    end)

    miscListControl = WM:CreateControlFromVirtual(miscListControlName, miscListWindow, "ZO_ScrollList")
    miscListControl:SetAnchor(TOPLEFT, miscListWindow, TOPLEFT, 0, 0, ANCHOR_CONSTRAINS_XY)
    miscListControl:SetAnchor(TOPRIGHT, miscListWindow, TOPRIGHT, ZO_SCROLL_BAR_WIDTH, 0, ANCHOR_CONSTRAINS_X)
    miscListControl:SetHeight(sw.miscListHeaderHeight + (sw.miscListRowHeight * 12))
    miscListControl:SetMouseEnabled(false)
    miscListControl:GetNamedChild("Contents"):SetMouseEnabled(false)

    ZO_ScrollList_SetHideScrollbarOnDisable(miscListControl, true)
    ZO_ScrollList_SetUseScrollbar(miscListControl, false)
    ZO_ScrollList_SetScrollbarEthereal(miscListControl, true)
end
local function createHornListWindow()
    hornListWindow = WM:CreateTopLevelWindow(hornListWindowName)
    hornListWindow:SetClampedToScreen(true)
    hornListWindow:SetResizeToFitDescendents(true)
    hornListWindow:SetHidden(true)
    hornListWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sv.hornListPosLeft, sv.hornListPosTop)
    hornListWindow:SetWidth(sw.hornListWidth)
    hornListWindow:SetHeight(sw.hornListHeaderHeight + (sw.hornListRowHeight * 12))
    hornListWindow:SetHandler( "OnMoveStop", function()
        sv.hornListPosLeft = hornListWindow:GetLeft()
        sv.hornListPosTop = hornListWindow:GetTop()
    end)

    hornListControl = WM:CreateControlFromVirtual(hornListControlName, hornListWindow, "ZO_ScrollList")
    hornListControl:SetAnchor(TOPLEFT, hornListWindow, TOPLEFT, 0, 0, ANCHOR_CONSTRAINS_XY)
    hornListControl:SetAnchor(TOPRIGHT, hornListWindow, TOPRIGHT, ZO_SCROLL_BAR_WIDTH, 0, ANCHOR_CONSTRAINS_X)
    hornListControl:SetHeight(sw.hornListHeaderHeight + (sw.hornListRowHeight * 12))
    hornListControl:SetMouseEnabled(false)
    hornListControl:GetNamedChild("Contents"):SetMouseEnabled(false)

    ZO_ScrollList_SetHideScrollbarOnDisable(hornListControl, true)
    ZO_ScrollList_SetUseScrollbar(hornListControl, false)
    ZO_ScrollList_SetScrollbarEthereal(hornListControl, true)
end
local function createColosListWindow()
    colosListWindow = WM:CreateTopLevelWindow(colosListWindowName)
    colosListWindow:SetClampedToScreen(true)
    colosListWindow:SetResizeToFitDescendents(true)
    colosListWindow:SetHidden(true)
    colosListWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sv.colosListPosLeft, sv.colosListPosTop)
    colosListWindow:SetWidth(sw.colosListWidth)
    colosListWindow:SetHeight(sw.colosListHeaderHeight + (sw.colosListRowHeight * 12))
    colosListWindow:SetHandler( "OnMoveStop", function()
        sv.colosListPosLeft = colosListWindow:GetLeft()
        sv.colosListPosTop = colosListWindow:GetTop()
    end)

    colosListControl = WM:CreateControlFromVirtual(colosListControlName, colosListWindow, "ZO_ScrollList")
    colosListControl:SetAnchor(TOPLEFT, colosListWindow, TOPLEFT, 0, 0, ANCHOR_CONSTRAINS_XY)
    colosListControl:SetAnchor(TOPRIGHT, colosListWindow, TOPRIGHT, ZO_SCROLL_BAR_WIDTH, 0, ANCHOR_CONSTRAINS_X)
    colosListControl:SetHeight(sw.colosListHeaderHeight + (sw.colosListRowHeight * 12))
    colosListControl:SetMouseEnabled(false)
    colosListControl:GetNamedChild("Contents"):SetMouseEnabled(false)

    ZO_ScrollList_SetHideScrollbarOnDisable(colosListControl, true)
    ZO_ScrollList_SetUseScrollbar(colosListControl, false)
    ZO_ScrollList_SetScrollbarEthereal(colosListControl, true)
end
local function createAtroListWindow()
    atroListWindow = WM:CreateTopLevelWindow(atroListWindowName)
    atroListWindow:SetClampedToScreen(true)
    atroListWindow:SetResizeToFitDescendents(true)
    atroListWindow:SetHidden(true)
    atroListWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sv.atroListPosLeft, sv.atroListPosTop)
    atroListWindow:SetWidth(sw.atroListWidth)
    atroListWindow:SetHeight(sw.atroListHeaderHeight + (sw.atroListRowHeight * 12))
    atroListWindow:SetHandler( "OnMoveStop", function()
        sv.atroListPosLeft = atroListWindow:GetLeft()
        sv.atroListPosTop = atroListWindow:GetTop()
    end)

    atroListControl = WM:CreateControlFromVirtual(atroListControlName, atroListWindow, "ZO_ScrollList")
    atroListControl:SetAnchor(TOPLEFT, atroListWindow, TOPLEFT, 0, 0, ANCHOR_CONSTRAINS_XY)
    atroListControl:SetAnchor(TOPRIGHT, atroListWindow, TOPRIGHT, ZO_SCROLL_BAR_WIDTH, 0, ANCHOR_CONSTRAINS_X)
    atroListControl:SetHeight(sw.atroListHeaderHeight + (sw.atroListRowHeight * 12))
    atroListControl:SetMouseEnabled(false)
    atroListControl:GetNamedChild("Contents"):SetMouseEnabled(false)

    ZO_ScrollList_SetHideScrollbarOnDisable(atroListControl, true)
    ZO_ScrollList_SetUseScrollbar(atroListControl, false)
    ZO_ScrollList_SetScrollbarEthereal(atroListControl, true)
end
------------------------------------------------------------------------------------------------------------------------

local function onHornBuff(eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, deprecatedBuffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED then
        if hornListHeaderHornDurationControl and hornListHornTimer then
            if sw.selfishMode and unitTag ~= localPlayer then
                return
            end
            local duration = (endTime - beginTime) * 1000
            hornListHornTimer:StartCountdown(duration)
        end
    end
end
local function onForceBuff(eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, deprecatedBuffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED then
        if hornListHeaderForceDurationControl and hornListForceTimer then
            if sw.selfishMode and unitTag ~= localPlayer then
                return
            end
            local duration = (endTime - beginTime) * 1000
            hornListForceTimer:StartCountdown(duration)
        end
    end
end
local function onMajorVulnerabilityDebuff(eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, deprecatedBuffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED then
        if colosListHeaderVulnDurationControl and colosListVulnTimer then
            local duration = (endTime - beginTime) * 1000
            colosListVulnTimer:StartCountdown(duration)
        end
    end
end
local function onMajorBerserkBuff(eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, deprecatedBuffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED then
        if atroListHeaderBerserkDurationControl and atroListBerserkTimer then
            if sw.selfishMode and unitTag ~= localPlayer then
                return
            end
            local duration = (endTime - beginTime) * 1000
            atroListBerserkTimer:StartCountdown(duration)
        end
    end
end

local function onAtroCast(_, _, _, _, _, _, displayName, sourceType, _, _, _, _, _, _, _, _)
    if atroListHeaderAtroDurationControl and atroListAtroTimer then
        if sourceType == COMBAT_UNIT_TYPE_GROUP then
            local duration = 15000 -- TODO: read duration from ability?
            atroListAtroTimer:StartCountdown(duration)
        end
    end
end


local function registerHornBuffTracker()
    local eventName = addon_name .. module_name .. "_HornBuff"
    for i, hornId in ipairs(hornBuffIds) do
        EM:UnregisterForEvent(eventName .. i, EVENT_EFFECT_CHANGED)
        EM:RegisterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, onHornBuff)
        EM:AddFilterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, hornId)
        EM:AddFilterForEvent(eventName .. i, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
    end
end
local function registerMajorForceBuffTracker()
    local eventName = addon_name .. module_name .. "_MajorForceBuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, onForceBuff)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, majorForceId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
end
local function registerMajorVulnerabilityDebuffTracker()
    local eventName = addon_name .. module_name .. "_MajorVulnerabilityDebuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, onMajorVulnerabilityDebuff)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, majorVulnerabilityId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_OTHER) -- only on enemies
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_TARGET_DUMMY) -- only on targetDummies
end
local function registerMajorBerserkBuffTracker()
    local eventName = addon_name .. module_name .. "_MajorBerserkBuff"
    EM:UnregisterForEvent(eventName, EVENT_EFFECT_CHANGED)
    EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, onMajorBerserkBuff)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, majorBerserkId)
    EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_GROUP)
end
local function registerAtroCastTracker()
    local eventName = addon_name .. module_name .. "_AtroCast"
    for i, atroId in ipairs(atroAbilityIds) do
        EM:UnregisterForEvent(eventName .. i, EVENT_COMBAT_EVENT)
        EM:RegisterForEvent(eventName .. i, EVENT_COMBAT_EVENT, onAtroCast)
        EM:AddFilterForEvent(eventName .. i, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, atroId)
        EM:AddFilterForEvent(eventName .. i, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED)
    end
end

---------------------------------------------------------------------------------------------------------------------------

local function defaultAtroHeaderRowCreationFunc(rowControl, data, scrollList)
    rowControl:GetNamedChild("_BG"):SetAlpha(sw.styleAtroHeaderOpacity)
    --rowControl:GetNamedChild("_AtroIcon"):SetAlpha(sw.styleZeroTimerOpacity)
    rowControl:GetNamedChild("_AtroDuration"):SetColor(unpack(sw.styleAtroColor))
    rowControl:GetNamedChild("_AtroDuration"):SetAlpha(sw.styleZeroTimerOpacity)
    --rowControl:GetNamedChild("_BerserkIcon"):SetAlpha(sw.styleZeroTimerOpacity)
    rowControl:GetNamedChild("_BerserkDuration"):SetColor(unpack(sw.styleBerserkColor))
    rowControl:GetNamedChild("_BerserkDuration"):SetAlpha(sw.styleZeroTimerOpacity)
end
local function defaultAtroPlayerRowCreationFunc(rowControl, data, scrollList)
    local userId = data.userId
    local userIcon = player.GetIconForUserId(userId)
    local userName = player.GetAliasForUserId(userId, sw.enableColoredNames)

    local classId = data.classId
    local defaultIcon = classIcons[classId] and classIcons[classId] or 'esoui/art/campaign/campaignbrowser_guestcampaign.dds'

    local nameControl = rowControl:GetNamedChild('_Name')
    nameControl:SetText(userName)
    nameControl:SetColor(1, 1, 1)
    local iconControl = rowControl:GetNamedChild('_Icon')
    iconControl:SetTextureCoords(0, 1, 0, 1)
    iconControl:SetTexture(sw.enableIcons and userIcon or defaultIcon)

    if sw.enableAnimIcons then
        anim.AnimateUserIcon("atro_list", userId, iconControl)
    end

    local percentageColor = getUltPercentageColor(data.atroPercentage, 'FFFFFF')
    local percentageControl = rowControl:GetNamedChild("_PctValue")
    percentageControl:SetText(strformat('|c%s%d%%|r', percentageColor, zo_min(200, data.atroPercentage)))
    percentageControl:SetScale(sv.showAtroPercentValue)
    local rawValueControl = rowControl:GetNamedChild("_RawValue")
    rawValueControl:SetText(strformat('%s', data.ultValue))
    rawValueControl:SetScale(sv.showAtroRawValue)
end

local function defaultColosHeaderRowCreationFunc(rowControl, data, scrollList)
    rowControl:GetNamedChild("_BG"):SetAlpha(sw.styleColosHeaderOpacity)
    --rowControl:GetNamedChild("_Icon"):SetAlpha(sw.styleZeroTimerOpacity)
    rowControl:GetNamedChild("_Duration"):SetColor(unpack(sw.styleColosColor))
    rowControl:GetNamedChild("_Duration"):SetAlpha(sw.styleZeroTimerOpacity)
end
local function defaultColosPlayerRowCreationFunc(rowControl, data, scrollList)
    local userId = data.userId
    local userIcon = player.GetIconForUserId(userId)
    local userName = player.GetAliasForUserId(userId, sw.enableColoredNames)

    local classId = data.classId
    local defaultIcon = classIcons[classId] and classIcons[classId] or 'esoui/art/campaign/campaignbrowser_guestcampaign.dds'

    local nameControl = rowControl:GetNamedChild('_Name')
    nameControl:SetText(userName)
    nameControl:SetColor(1, 1, 1)
    local iconControl = rowControl:GetNamedChild('_Icon')
    iconControl:SetTextureCoords(0, 1, 0, 1)
    iconControl:SetTexture(sw.enableIcons and userIcon or defaultIcon)

    if sw.enableAnimIcons then
        anim.AnimateUserIcon("colos_list", userId, iconControl)
    end

    local percentageColor = getUltPercentageColor(data.colosPercentage, 'FFFFFF')
    local percentageControl = rowControl:GetNamedChild("_PctValue")
    percentageControl:SetText(strformat('|c%s%d%%|r', percentageColor, zo_min(200, data.colosPercentage)))
    percentageControl:SetScale(sv.showColosPercentValue)
    local rawValueControl = rowControl:GetNamedChild("_RawValue")
    rawValueControl:SetText(strformat('%s', data.ultValue))
    rawValueControl:SetScale(sv.showColosRawValue)
end

local function defaultHornHeaderRowCreationFunc(rowControl, data, scrollList)
    rowControl:GetNamedChild("_BG"):SetAlpha(sw.styleHornHeaderOpacity)
    --rowControl:GetNamedChild("_HornIcon"):SetAlpha(sw.styleZeroTimerOpacity)
    rowControl:GetNamedChild("_HornDuration"):SetColor(unpack(sw.styleHornColor))
    rowControl:GetNamedChild("_HornDuration"):SetAlpha(sw.styleZeroTimerOpacity)
    --rowControl:GetNamedChild("_ForceIcon"):SetAlpha(sw.styleZeroTimerOpacity)
    rowControl:GetNamedChild("_ForceDuration"):SetColor(unpack(sw.styleForceColor))
    rowControl:GetNamedChild("_ForceDuration"):SetAlpha(sw.styleZeroTimerOpacity)
end
local function defaultHornPlayerRowCreationFunc(rowControl, data, scrollList)
    local userId = data.userId
    local userIcon = player.GetIconForUserId(userId)
    local userName = player.GetAliasForUserId(userId, sw.enableColoredNames)

    local classId = data.classId
    local defaultIcon = classIcons[classId] and classIcons[classId] or 'esoui/art/campaign/campaignbrowser_guestcampaign.dds'

    local nameControl = rowControl:GetNamedChild('_Name')
    nameControl:SetText(userName)
    nameControl:SetColor(1, 1, 1)
    local iconControl = rowControl:GetNamedChild('_Icon')
    iconControl:SetTextureCoords(0, 1, 0, 1)
    iconControl:SetTexture(sw.enableIcons and userIcon or defaultIcon)

    if sw.enableAnimIcons then
        anim.AnimateUserIcon("horn_list", userId, iconControl)
    end

    if sw.styleHighlightSaxhleel then
        local _BG = rowControl:GetNamedChild("_BG")
        if data.hasSaxhleel then
            _BG:SetColor(unpack(sw.styleSaxhleelBGColor))
        else
            _BG:SetColor(1, 1, 1, 0)
        end
    end

    local percentageColor = getUltPercentageColor(data.hornPercentage, 'FFFFFF')
    local percentageControl = rowControl:GetNamedChild("_PctValue")
    percentageControl:SetText(strformat('|c%s%d%%|r', percentageColor, zo_min(200, data.hornPercentage)))
    percentageControl:SetScale(sv.showHornPercentValue)
    local rawValueControl = rowControl:GetNamedChild("_RawValue")
    rawValueControl:SetText(strformat('%s', data.ultValue))
    rawValueControl:SetScale(sv.showHornRawValue)
end

local function defaultMiscHeaderRowCreationFunc(rowControl, data, scrollList)
    rowControl:GetNamedChild("_Text"):SetText(data.title)
    rowControl:GetNamedChild("_BG"):SetAlpha(sw.styleMiscHeaderOpacity)
end
local function defaultMiscPlayerRowCreationFunc(rowControl, data, scrollList)
    local userId = data.userId
    local userIcon = player.GetIconForUserId(userId)
    local userName = player.GetAliasForUserId(userId, sw.enableColoredNames)


    local classId = data.classId
    local defaultIcon = classIcons[classId] and classIcons[classId] or 'esoui/art/campaign/campaignbrowser_guestcampaign.dds'

    local nameControl = rowControl:GetNamedChild('_Name')
    nameControl:SetText(userName)
    nameControl:SetColor(1, 1, 1)
    local iconControl = rowControl:GetNamedChild('_Icon')
    iconControl:SetTextureCoords(0, 1, 0, 1)
    iconControl:SetTexture(sw.enableIcons and userIcon or defaultIcon)

    if sw.enableAnimIcons then
        anim.AnimateUserIcon("misc_list", userId, iconControl)
    end

    local percentageColor = getUltPercentageColor(data.lowestUltPercentage, 'FFFFFF')
    local percentageControl = rowControl:GetNamedChild("_PctValue")
    percentageControl:SetText(strformat('|c%s%d%%|r', percentageColor, zo_min(200, data.lowestUltPercentage)))
    percentageControl:SetScale(sv.showMiscPercentValue)
    local rawValueControl = rowControl:GetNamedChild("_RawValue")
    rawValueControl:SetText(strformat('%s', data.ultValue))
    rawValueControl:SetScale(sv.showMiscRawValue)
    rowControl:GetNamedChild('_UltIconFrontbar'):SetTexture(GetAbilityIcon(data.ult1ID))
    rowControl:GetNamedChild('_UltIconBackbar'):SetTexture(GetAbilityIcon(data.ult2ID))
end

local function CreateDurationHandler(getControlFn, blinkConfig)
    local blinkTimer

    if blinkConfig then
        -- create a blinker for this control
        local counter = 0

        local function onTick()
            local control = getControlFn()
            if not control then return end
            control:SetAlpha(counter % 4 < 2 and 0 or sv.styleZeroTimerOpacity)
            counter = counter + 1
        end

        local function onStop()
            local control = getControlFn()
            if not control then return end
            counter = 0
            control:SetAlpha(sv.styleZeroTimerOpacity)
        end

        blinkTimer = timer.New()
        blinkTimer:SetTickInterval(blinkConfig.tickInterval or 100)
        blinkTimer:SetHandler(timer.ON_TICK, onTick)
        blinkTimer:SetHandler(timer.ON_STOP, onStop)

        function blinkTimer:StartBlink()
            self:Stop()
            counter = 0
            self:StartCountdown(blinkConfig.duration or 2000)
        end
    end

    return function(event, startTime, endTime, durationMS, remainingMS)
        local control = getControlFn()
        if not control then return nil end

        if event == timer.ON_TICK then
            if blinkTimer then blinkTimer:Stop() end
            control:SetAlpha(1)
            control:SetText(strformat('%5.1f', remainingMS / 1000))
            return
        end

        if event == timer.ON_START then
            if blinkTimer then blinkTimer:Stop() end
            control:SetAlpha(1)
            return
        end

        if event == timer.ON_STOP then
            control:SetAlpha(sw.styleZeroTimerOpacity)
            if blinkTimer then blinkTimer:StartBlink() end
            return
        end
    end
end

local function AttachDurationHandlers(timerObject, getControlFn, blinkConfig)
    local handler = CreateDurationHandler(getControlFn, blinkConfig)
    timerObject:SetHandler(timer.ON_START, handler)
    timerObject:SetHandler(timer.ON_TICK, handler)
    timerObject:SetHandler(timer.ON_STOP, handler)
end

local function setupTimers()
    hornListHornTimer = timer.New()
    AttachDurationHandlers(hornListHornTimer, function() return hornListHeaderHornDurationControl end, { tickInterval = 100, duration = 2000 })

    hornListForceTimer = timer.New()
    AttachDurationHandlers(hornListForceTimer, function() return hornListHeaderForceDurationControl end, { tickInterval = 100, duration = 2000 })

    colosListVulnTimer = timer.New()
    AttachDurationHandlers(colosListVulnTimer, function() return colosListHeaderVulnDurationControl end, { tickInterval = 100, duration = 2000 })

    atroListAtroTimer = timer.New()
    AttachDurationHandlers(atroListAtroTimer, function() return atroListHeaderAtroDurationControl end, { tickInterval = 100, duration = 2000 })

    atroListBerserkTimer = timer.New()
    AttachDurationHandlers(atroListBerserkTimer, function() return atroListHeaderBerserkDurationControl end, { tickInterval = 100, duration = 2000 })
end

local defaultTheme = {
    author = "@m00nyONE",
    version = "1.0.0",
    description = "The Default Theme of HodorReflexes Ultimates Module - Misc Ultimates List",

    MiscListHeaderRowTemplate = MISC_LIST_DEFAULT_HEADER_TEMPLATE,
    MiscListHeaderRowCreationFunc = defaultMiscHeaderRowCreationFunc,
    MiscListPlayerRowTemplate = MISC_LIST_DEFAULT_PLAYERROW_TEMPLATE,
    MiscListPlayerRowCreationFunc = defaultMiscPlayerRowCreationFunc,

    HornListHeaderRowTemplate = HORN_LIST_DEFAULT_HEADER_TEMPLATE,
    HornListHeaderRowCreationFunc = defaultHornHeaderRowCreationFunc,
    HornListPlayerRowTemplate = HORN_LIST_DEFAULT_PLAYERROW_TEMPLATE,
    HornListPlayerRowCreationFunc = defaultHornPlayerRowCreationFunc,

    ColosListHeaderRowTemplate = COLOS_LIST_DEFAULT_HEADER_TEMPLATE,
    ColosListHeaderRowCreationFunc = defaultColosHeaderRowCreationFunc,
    ColosListPlayerRowTemplate = COLOS_LIST_DEFAULT_PLAYERROW_TEMPLATE,
    ColosListPlayerRowCreationFunc = defaultColosPlayerRowCreationFunc,

    AtroListHeaderRowTemplate = ATRO_LIST_DEFAULT_HEADER_TEMPLATE,
    AtroListHeaderRowCreationFunc = defaultAtroHeaderRowCreationFunc,
    AtroListPlayerRowTemplate = ATRO_LIST_DEFAULT_PLAYERROW_TEMPLATE,
    AtroListPlayerRowCreationFunc = defaultAtroPlayerRowCreationFunc,

    settings = {

    },
}

function module:RegisterTheme(themeName, themeTable)
    -- check parameters
    assert(type(themeName) == 'string' and themeName ~= '', 'invalid theme name')
    assert(type(themeTable) == 'table', 'invalid theme table')
    assert(themes[themeName] == nil, strformat('theme with name "%s" already exists', themeName))

    -- validate meta data
    assert(type(themeTable.author) == 'string', 'theme is missing required field "author" of type "string"')
    assert(type(themeTable.version) == 'string', 'theme is missing required field "version" of type "string"')
    assert(type(themeTable.description) == 'string', 'theme is missing required field "description" of type "string"')
    assert(type(themeTable.settings) == 'table', 'theme is missing required field "settings" of type "table"')

    local function playerRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            if data.ultValue > 0 and (isTestRunning or IsUnitOnline(data.tag)) then
                wrappedFunction(rowControl, data, scrollList)
            end
        end
    end

    local function hornListHeaderRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            hornListHeaderHornDurationControl = rowControl:GetNamedChild("_HornDuration")
            hornListHeaderForceDurationControl = rowControl:GetNamedChild("_ForceDuration")
            wrappedFunction(rowControl, data, scrollList)
        end
    end
    local function colosListHeaderRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            colosListHeaderVulnDurationControl = rowControl:GetNamedChild("_Duration")
            wrappedFunction(rowControl, data, scrollList)
        end
    end
    local function atroListHeaderRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            atroListHeaderAtroDurationControl = rowControl:GetNamedChild("_AtroDuration")
            atroListHeaderBerserkDurationControl = rowControl:GetNamedChild("_BerserkDuration")
            wrappedFunction(rowControl, data, scrollList)
        end
    end

    themeTable.MISC_LIST_HEADER_TYPE = nextTypeId
    themeTable.HORN_LIST_HEADER_TYPE = nextTypeId
    themeTable.COLOS_LIST_HEADER_TYPE = nextTypeId
    themeTable.ATRO_LIST_HEADER_TYPE = nextTypeId
    nextTypeId = nextTypeId + 1

    ZO_ScrollList_AddDataType(
            miscListControl,
            themeTable.MISC_LIST_HEADER_TYPE,
            themeTable.MiscListHeaderRowTemplate or defaultTheme.MiscListHeaderRowTemplate,
            sw.miscListHeaderHeight,
            themeTable.MiscListHeaderRowCreationFunc or defaultTheme.MiscListHeaderRowCreationFunc
    )
    ZO_ScrollList_SetTypeCategoryHeader(miscListControl, themeTable.MISC_LIST_HEADER_TYPE, true)
    ZO_ScrollList_AddDataType(
            hornListControl,
            themeTable.HORN_LIST_HEADER_TYPE,
            themeTable.HornListHeaderRowTemplate or defaultTheme.HornListHeaderRowTemplate,
            sw.hornListHeaderHeight,
            hornListHeaderRowCreationWrapper(themeTable.HornListHeaderRowCreationFunc or defaultTheme.HornListHeaderRowCreationFunc)
    )
    ZO_ScrollList_SetTypeCategoryHeader(hornListControl, themeTable.HORN_LIST_HEADER_TYPE, true)
    ZO_ScrollList_AddDataType(
            colosListControl,
            themeTable.COLOS_LIST_HEADER_TYPE,
            themeTable.ColosListHeaderRowTemplate or defaultTheme.ColosListHeaderRowTemplate,
            sw.colosListHeaderHeight,
            colosListHeaderRowCreationWrapper(themeTable.ColosListHeaderRowCreationFunc or defaultTheme.ColosListHeaderRowCreationFunc)
    )
    ZO_ScrollList_SetTypeCategoryHeader(colosListControl, themeTable.COLOS_LIST_HEADER_TYPE, true)
    ZO_ScrollList_AddDataType(
            atroListControl,
            themeTable.ATRO_LIST_HEADER_TYPE,
            themeTable.AtroListHeaderRowTemplate or defaultTheme.AtroListHeaderRowTemplate,
            sw.atroListHeaderHeight,
            atroListHeaderRowCreationWrapper(themeTable.AtroListHeaderRowCreationFunc or defaultTheme.AtroListHeaderRowCreationFunc)
    )
    ZO_ScrollList_SetTypeCategoryHeader(atroListControl, themeTable.ATRO_LIST_HEADER_TYPE, true)


    themeTable.MISC_LIST_PLAYERROW_TYPE = nextTypeId
    themeTable.HORN_LIST_PLAYERROW_TYPE = nextTypeId
    themeTable.COLOS_LIST_PLAYERROW_TYPE = nextTypeId
    themeTable.ATRO_LIST_PLAYERROW_TYPE = nextTypeId
    nextTypeId = nextTypeId + 1

    ZO_ScrollList_AddDataType(
            miscListControl,
            themeTable.MISC_LIST_PLAYERROW_TYPE,
            themeTable.MiscListPlayerRowTemplate or defaultTheme.MiscListPlayerRowTemplate,
            sw.miscListRowHeight,
            playerRowCreationWrapper(themeTable.MiscListPlayerRowCreationFunc or defaultTheme.MiscListPlayerRowCreationFunc)
    )
    ZO_ScrollList_AddDataType(
            hornListControl,
            themeTable.HORN_LIST_PLAYERROW_TYPE,
            themeTable.HornListPlayerRowTemplate or defaultTheme.HornListPlayerRowTemplate,
            sw.hornListRowHeight,
            playerRowCreationWrapper(themeTable.HornListPlayerRowCreationFunc or defaultTheme.HornListPlayerRowCreationFunc)
    )
    ZO_ScrollList_AddDataType(
            colosListControl,
            themeTable.COLOS_LIST_PLAYERROW_TYPE,
            themeTable.ColosListPlayerRowTemplate or defaultTheme.ColosListPlayerRowTemplate,
            sw.colosListRowHeight,
            playerRowCreationWrapper(themeTable.ColosListPlayerRowCreationFunc or defaultTheme.ColosListPlayerRowCreationFunc)
    )
    ZO_ScrollList_AddDataType(
            atroListControl,
            themeTable.ATRO_LIST_PLAYERROW_TYPE,
            themeTable.AtroListPlayerRowTemplate or defaultTheme.AtroListPlayerRowTemplate,
            sw.atroListRowHeight,
            playerRowCreationWrapper(themeTable.AtroListPlayerRowCreationFunc or defaultTheme.AtroListPlayerRowCreationFunc)
    )

    -- register Theme
    themes[themeName] = themeTable
    table.insert(LAMThemeChoices, themeName)
end

local function updateTest()
    if not isTestRunning then return end

    for name, playerData in pairs(playersData) do
        local ultValue = playerData.ultValue + zo_random(2, 5)
        if ultValue > 500 then ultValue = 0 end
        if ultValue < 0 then ultValue = 0 end
        local ult1Percentage = getUltPercentage(ultValue, playerData.ult1Cost)
        local ult2Percentage = getUltPercentage(ultValue, playerData.ult2Cost)

        CreateOrUpdatePlayerData({
            name = name, -- required
            tag = name, -- required
            ultValue = ultValue,
            ult1Percentage = ult1Percentage,
            ult2Percentage = ult2Percentage,
            lowestUltPercentage = zo_min(ult1Percentage, ult2Percentage),
        })
    end

    updateUltimateLists()
end

local function startTest() -- TODO
    isTestRunning = true

    hornListHornTimer:StartCountdown(30000)
    hornListForceTimer:StartCountdown(10000)

    colosListVulnTimer:StartCountdown(12000)

    atroListAtroTimer:StartCountdown(15000)
    atroListBerserkTimer:StartCountdown(10000)


    local ultPool = {}

    for skillType = 1, GetNumSkillTypes() do
        for skillLineIndex = 1, GetNumSkillLines(skillType) do
            for skillIndex = 1, GetNumSkillAbilities(skillType, skillLineIndex) do
                if IsSkillAbilityUltimate(skillType, skillLineIndex, skillIndex) then
                    local _tempIds = {} -- create temporary table for all sill Ids of each morph
                    for morph = 0, 2 do -- there is only 1 base rank and 2 morphs
                        local abilityId, _ = GetSpecificSkillAbilityInfo(skillType, skillLineIndex, skillIndex, morph, 0)
                        table.insert(_tempIds, abilityId)
                        if abilityId == 0 then _tempIds = {} end -- if the ability Id is 0, clear all previously collected Ids from the temporary table because there is no ultimate without 2 morphs
                    end
                    -- iterate over temporary Id table and write it to our final destination
                    for _, _abilityId in ipairs(_tempIds) do
                        table.insert(ultPool, _abilityId)
                    end
                end
            end
        end
    end

    for name, playerData in pairs(playersData) do
        local ultValue = zo_random(1, 500)
        local ult1ID = ultPool[zo_random(1, #ultPool)]
        local ult2ID = ultPool[zo_random(1, #ultPool)]
        if playerData.classId == 5 then
            ult1ID = 122395
            ult2ID = 40223
        end
        if playerData.classId == 2 then
            ult1ID = 23492
        end
        local ult1Cost = GetAbilityCost(ult2ID)
        local ult2Cost = GetAbilityCost(ult2ID)
        local ult1Percentage = getUltPercentage(ultValue, ult1Cost)
        local ult2Percentage = getUltPercentage(ultValue, ult2Cost)
        local lowestUltPercentage = zo_min(ult1Percentage, ult2Percentage)

        CreateOrUpdatePlayerData({
            name = name, -- required
            tag = name, -- required
            ultValue = ultValue,
            ult1ID = ult1ID,
            ult2ID = ult2ID,
            ult1Cost = ult1Cost,
            ult2Cost = ult2Cost,
            ult1Percentage = ult1Percentage,
            ult2Percentage = ult2Percentage,
            lowestUltPercentage = lowestUltPercentage,
            ultActivatedSetID = zo_random(0, 2),
        })
    end

    updateUltimateLists()
end

local function stopTest()
    isTestRunning = false

    hornListHornTimer:Stop()
    hornListForceTimer:Stop()

    colosListVulnTimer:Stop()

    atroListAtroTimer:Stop()
    atroListBerserkTimer:Stop()
end

-- initialization functions

local function onPlayerActivated()

end

function module:MainMenuOptions()
    return {
        {
            type = "dropdown",
            name = GetString(HR_MENU_MISCULTIMATES_SHOW),
            tooltip = GetString(HR_MENU_MISCULTIMATES_SHOW_TT),
            default = svDefault.enableMiscList,
            getFunc = function() return sv.enableMiscList end,
            setFunc = function(value) sv.enableMiscList = value or false end,
            choices = {
                GetString(HR_MENU_DAMAGE_SHOW_NEVER),
                GetString(HR_MENU_DAMAGE_SHOW_ALWAYS),
                GetString(HR_MENU_DAMAGE_SHOW_OUT),
                GetString(HR_MENU_DAMAGE_SHOW_NONBOSS),
            },
            choicesValues = {
                0, 1, 2, 3,
            },
            width = 'full',
        },
        {
            type = "checkbox",
            name = GetString(HR_MENU_MISCULTIMATES_SHOW_PERCENT),
            tooltip = GetString(HR_MENU_MISCULTIMATES_SHOW_PERCENT_TT),
            default = function() if svDefault.showMiscPercentValue == 1 then return true end return false end,
            getFunc = function() if sv.showMiscPercentValue == 1 then return true end return false end,
            setFunc = function(value) if value then sv.showMiscPercentValue = 1 return end sv.showMiscPercentValue = 0 end,
            width = 'half',
        },
        {
            type = "checkbox",
            name = GetString(HR_MENU_MISCULTIMATES_SHOW_RAW),
            tooltip = GetString(HR_MENU_MISCULTIMATES_SHOW_RAW_TT),
            default = function() if svDefault.showMiscRawValue == 1 then return true end return false end,
            getFunc = function() if sv.showMiscRawValue == 1 then return true end return false end,
            setFunc = function(value) if value then sv.showMiscRawValue = 1 return end sv.showMiscRawValue = 0 end,
            width = 'half',
        },
        {
            type = "slider",
            name = "header height",
            min = 28,
            max = 44,
            step = 1,
            decimals = 0,
            default = svDefault.miscListHeaderHeight,
            clampInput = true,
            getFunc = function() return sw.miscListHeaderHeight end,
            setFunc = function(value)
                sw.miscListHeaderHeight = value
            end,
        },
        {
            type = "slider",
            name = "row height",
            min = 22,
            max = 44,
            step = 1,
            decimals = 0,
            default = svDefault.miscListRowHeight,
            clampInput = true,
            getFunc = function() return sw.miscListRowHeight end,
            setFunc = function(value)
                sw.miscListRowHeight = value
            end,
        },
        {
            type = "slider",
            name = "List width",
            min = 262,
            max = 450,
            step = 1,
            decimals = 0,
            default = svDefault.miscListWidth,
            clampInput = true,
            getFunc = function() return sw.miscListWidth end,
            setFunc = function(value)
                sw.miscListWidth = value
                miscListWindow:SetWidth(sw.miscListWidth)
            end,
        },
        {
            type = "divider",
        },
        {
            type = "dropdown",
            name = "Theme",
            tooltip = "Theme to use for the damage list",
            default = svDefault.selectedTheme,
            getFunc = function() return sw.selectedTheme end,
            setFunc = function(value)
                sw.selectedTheme = value
                validateSelectedTheme()
                applyTheme(sw.selectedTheme)
                updateUltimateLists()
            end,
            choices = LAMThemeChoices,
            width = 'full',
        },
        {
            type = "divider",
        },
        {
            type = "checkbox",
            name = "colored names",
            tooltip = "colored player names instead of userIds",
            default = svDefault.enableColoredNames,
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return sw.enableColoredNames end,
            setFunc = function(value) sw.enableColoredNames = value or false end,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "Player icons",
            tooltip = "Player icons instead of class icons",
            default = svDefault.enablIcons,
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return sw.enableIcons end,
            setFunc = function(value) sw.enableIcons = value or false end,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "Animated icons",
            tooltip = "Animated player icons (requires Player Icons to be enabled)",
            default = svDefault.enableAnimIcons,
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return sw.enableAnimIcons end,
            setFunc = function(value) sw.enableAnimIcons = value or false end,
            requiresReload = true,
        },
        {
            type = "slider",
            name = "Misc Header opacity",
            min = 0,
            max = 1,
            step = 0.05,
            decimals = 2,
            clampInput = true,
            default = svDefault.styleMiscHeaderOpacity,
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return sw.styleMiscHeaderOpacity end,
            setFunc = function(value)
                sw.styleMiscHeaderOpacity = value
                updateUltimateLists()
            end,
        },
    }
end

function module:Initialize()
    lgcs = LGCS.RegisterAddon(addon_name .. module_name, {"ULT"})
    if not lgcs then
        d("Failed to register addon with LibGroupCombatStats.")
        return
    end
    lgcs:RegisterForEvent(EVENT_GROUP_ULT_UPDATE, onULTDataReceived)
    lgcs:RegisterForEvent(EVENT_PLAYER_ULT_UPDATE, onULTDataReceived)

    -- register callbacks to events from main addon.
    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, onGroupChange) -- triggers a group cleanup

    addon.RegisterCallback(HR_EVENT_LOCKUI, LockUI)
    addon.RegisterCallback(HR_EVENT_UNLOCKUI, UnlockUI)

    addon.RegisterCallback(HR_EVENT_TEST_STARTED, startTest)
    addon.RegisterCallback(HR_EVENT_TEST_STOPPED, stopTest)
    addon.RegisterCallback(HR_EVENT_TEST_TICK, updateTest)
    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_CLEANED, updateUltimateLists)

    group.RegisterPlayersDataFields({
        ultValue = 0,
        ult1ID = 0,
        ult2ID = 0,
        ult1Cost = 0,
        ult2Cost = 0,
        ult1Percentage = 0,
        ult2Percentage = 0,
        ultActivatedSetID = 0,
        lowestUltPercentage = 0,
    })

    -- we use a combination of accountWide saved variables and cper character saved variables. This little swappi swappi allows us to switch between them without defining new variables
    sw = ZO_SavedVars:NewAccountWide(svName, svVersion, module_name, svDefault)
    if not sw.accountWide then
        sv = ZO_SavedVars:NewCharacterIdSettings(svName, svVersion, module_name, svDefault)
        sv.accountWide = false
    else
        sv = sw
    end

    createMiscListWindow()
    createHornListWindow()
    createColosListWindow()
    createAtroListWindow()
    createSceneFragments()
    refreshVisibility()

    setupTimers()

    registerHornBuffTracker()
    registerMajorForceBuffTracker()
    registerMajorVulnerabilityDebuffTracker()
    registerMajorBerserkBuffTracker()
    registerAtroCastTracker()

    module:RegisterTheme("default", defaultTheme)
    validateSelectedTheme()
    applyTheme(sw.selectedTheme)

    local eventRegisterName = addon_name .. module_name .. "PlayerActivated"
    EM:UnregisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED)
    EM:RegisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED, onPlayerActivated)
end

addon:RegisterModule(module_name, module)


SLASH_COMMANDS["/hodor.test"] = function(str)
    if str == "cooldown" then
        hornListForceTimer:StartCountdown(5000)
    end
end
