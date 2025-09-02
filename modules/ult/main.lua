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
    showHornRawValue = 0.0,
    styleHornHeaderOpacity = 0.0,

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
local CreateOrUpdatePlayerData = group.CreateOrUpdatePlayerData
local playersData = group.playersData

local EVENT_GROUP_ULT_UPDATE = LGCS.EVENT_GROUP_ULT_UPDATE
local EVENT_PLAYER_ULT_UPDATE = LGCS.EVENT_PLAYER_ULT_UPDATE

local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED
local HR_EVENT_LOCKUI = addon.HR_EVENT_LOCKUI
local HR_EVENT_UNLOCKUI = addon.HR_EVENT_UNLOCKUI
local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED
local HR_EVENT_PLAYERSDATA_CLEANED = addon.HR_EVENT_PLAYERSDATA_CLEANED

local nextTypeId = 1
local MISC_LIST_HEADER_TYPE = 1
local MISC_LIST_PLAYERROW_TYPE = 2
local HORN_LIST_HEADER_TYPE = 1
local HORN_LIST_PLAYERROW_TYPE = 2

local MISC_LIST_DEFAULT_PLAYERROW_TEMPLATE = "HodorReflexes_Ult_MiscList_PlayerRow"
local MISC_LIST_DEFAULT_HEADER_TEMPLATE = "HodorReflexes_Ult_MiscList_Header"
local HORN_LIST_DEFAULT_PLAYERROW_TEMPLATE = "HodorReflexes_Ult_HornList_PlayerRow"
local HORN_LIST_DEFAULT_HEADER_TEMPLATE = "HodorReflexes_Ult_HornList_Header"

local MISC_FRAGMENT, HORN_FRAGMENT -- HUD Fragment

local miscListWindowName = addon_name .. module_name .. "_Misc"
local miscListWindow = {}
local miscListControlName = miscListWindowName .. "_List"
local miscListControl = {}
local hornListWindowName = addon_name .. module_name .. "_Horn"
local hornListWindow = {}
local hornListControlName = hornListWindowName .. "_List"
local hornListControl = {}
local hornListHeaderHornDurationControl = nil
local hornListHeaderForceDurationControl = nil

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
    return true
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
    local abilityIDs = {40223,	38563, 40220}
    for _, id in pairs(abilityIDs) do
        if abilityId == id then return true end
    end
    return false
end
local function isColos(abilityId)
    local abilityIDs = {122388, 122395, 122174}
    for _, id in pairs(abilityIDs) do
        if abilityId == id then return true end
    end
    return false
end
local function isAtro(abilityId)
    local abilityIDs = {23492,	23634, 23495}
    for _, id in pairs(abilityIDs) do
        if abilityId == id then return true end
    end
    return false
end
local function HasUnitHorn(data)
    if isHorn(data.ult1ID) then return true, data.ult1Cost end
    if isHorn(data.ult2ID) then return true, data.ult2Cost end

    if data.ultActivatedSetID == 1 then	return true, 250 end

    return false, 0
end
local function HasUnitColos(data)
    if isColos(data.ult1ID) then return true, data.ult1Cost end
    if isColos(data.ult2ID) then return true, data.ult2Cost end

    return false, 0
end
local function HasUnitAtro(data)
    if isAtro(data.ult1ID) then return true, data.ult1Cost end
    if isAtro(data.ult2ID) then return true, data.ult2Cost end

    return false, 0
end

local function HasUnitBarrier(data)
    local abilityIDs = {40237,	40239, 38573}
    for _, id in ipairs(abilityIDs) do
        if data.ult1ID == id then return true, data.ult1Cost end
        if data.ult2ID == id then return true, data.ult2Cost end
    end

    return false, 0
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
                lowestPossibleHornCost = zo_max(zo_min(playerData.ult1Cost, playerData.ult2Cost))
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

    ZO_ScrollList_Commit(hornListControl)
end

--- updates the damageList
local function updateUltimateLists()
    updateMiscUltimateList()
    updateHornUltimateList()
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
end

local function UnlockUI()
    uiLocked = false
    refreshVisibility()
    hud.UnlockControls(miscListWindow, hornListWindow)
end

local function LockUI()
    uiLocked = true
    refreshVisibility()
    hud.LockControls(miscListWindow, hornListWindow)
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

    MISC_FRAGMENT = hud.AddSimpleFragment(miscListWindow, MiscFragmentCondition)
    HORN_FRAGMENT = hud.AddSimpleFragment(hornListWindow, HornFragmentCondition)
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

local function defaultHornHeaderRowCreationFunc(rowControl, data, scrollList)
    rowControl:GetNamedChild("_BG"):SetAlpha(sw.styleHornHeaderOpacity)
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

    if sw.enableAnimIcons and anim.IsValidUser(userId) then
        if not anim.IsUserRegistered(userId) then
            anim.RegisterUser(userId)
        end

        anim.RegisterUserControl(userId, iconControl)
        anim.RunUserAnimations(userId)
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

    if sw.enableAnimIcons and anim.IsValidUser(userId) then
        if not anim.IsUserRegistered(userId) then
            anim.RegisterUser(userId)
        end

        anim.RegisterUserControl(userId, iconControl)
        anim.RunUserAnimations(userId)
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

    themeTable.MISC_LIST_HEADER_TYPE = nextTypeId
    themeTable.HORN_LIST_HEADER_TYPE = nextTypeId
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
            sw.miscListHeaderHeight,
            hornListHeaderRowCreationWrapper(themeTable.HornListHeaderRowCreationFunc or defaultTheme.HornListHeaderRowCreationFunc)
    )
    ZO_ScrollList_SetTypeCategoryHeader(hornListControl, themeTable.HORN_LIST_HEADER_TYPE, true)


    themeTable.MISC_LIST_PLAYERROW_TYPE = nextTypeId
    themeTable.HORN_LIST_PLAYERROW_TYPE = nextTypeId
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
            sw.miscListRowHeight,
            playerRowCreationWrapper(themeTable.HornListPlayerRowCreationFunc or defaultTheme.HornListPlayerRowCreationFunc)
    )

    -- register Theme
    themes[themeName] = themeTable
    table.insert(LAMThemeChoices, themeName)
end

local function startTest() -- TODO
    isTestRunning = true

    local randomUltPool = {
        40239,
        32948,
        85127,
        15957, 16536, 17874, 17878, 21752, 21755, 21758, 22138, 22139,
        22144, 22223, 22226, 22229, 23492, 23495, 23634, 24785, 24804,
        24806, 25091, 25411, 27706, 28341, 28348, 28988, 29012, 32455,
        32624, 32715, 32719, 32947, 32958, 33398, 35460, 35508, 35713,
        36485, 83600, 83619, 83642, 83850, 84434, 85132, 85179, 85187,
        85257, 85451, 85532, 85804, 85807, 85982, 85986, 85990, 86109,
        86113, 86117, 103478, 103557, 103564, 115001, 115410,118279,
        118367, 118379, 118664, 122174, 122388, 122395, 183676, 183709,
        189791, 189837, 189867, 192372, 192380, 193558,
    }

    for name, playerData in pairs(playersData) do
        local ultValue = zo_random(1, 500)
        local ult1ID = randomUltPool[zo_random(1, #randomUltPool)]
        local ult2ID = randomUltPool[zo_random(1, #randomUltPool)]
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
            ultActivatedSetID = zo_random(0, 2),
        })
    end

    updateUltimateLists()
end

local function stopTest()
    isTestRunning = false
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
    createSceneFragments()
    refreshVisibility()

    module:RegisterTheme("default", defaultTheme)
    validateSelectedTheme()
    applyTheme(sw.selectedTheme)

    local eventRegisterName = addon_name .. module_name .. "PlayerActivated"
    EM:UnregisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED)
    EM:RegisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED, onPlayerActivated)
end

addon:RegisterModule(module_name, module)
