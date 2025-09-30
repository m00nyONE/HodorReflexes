-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local module = {
    name = "dps",
    friendlyName = "Damage",
    description = "Shows group dps statistics",
    version = "1.0.0",
    priority = 2,
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

    enableDamageList = 0,
    damageListPosLeft = 0,
    damageListPosTop = 0,
    damageListHeaderHeight = 22,
    damageListRowHeight = 22,
    damageListWidth = 227,

    selectedTheme = "default",

    enableGroupTotalRow = true,
    enableColoredNames = true,
    enableDamageIcons = true,
    enableAnimIcons = true,
    damageRowColor = {0, 1, 0, 0.36},

    styleDamageHeaderOpacity = 0.8,
    styleDamageRowEvenOpacity = 0.65,
    styleDamageRowOddOpacity = 0.45,
    styleDamageNumFont = "gamepad",
    styleBossDamageColor = "b2ffb2",
    styleTotalDamageColor = "faffb2",

    damageListTimerUpdateInterval = 1000,
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

local EVENT_GROUP_DPS_UPDATE = LGCS.EVENT_GROUP_DPS_UPDATE
local EVENT_PLAYER_DPS_UPDATE = LGCS.EVENT_PLAYER_DPS_UPDATE

local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED
local HR_EVENT_COMBAT_START = addon.HR_EVENT_COMBAT_START
local HR_EVENT_COMBAT_END = addon.HR_EVENT_COMBAT_END
local HR_EVENT_LOCKUI = addon.HR_EVENT_LOCKUI
local HR_EVENT_UNLOCKUI = addon.HR_EVENT_UNLOCKUI
local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED
local HR_EVENT_TEST_TICK = addon.HR_EVENT_TEST_TICK
local HR_EVENT_PLAYERSDATA_CLEANED = addon.HR_EVENT_PLAYERSDATA_CLEANED

local DAMAGE_UNKNOWN = LGCS.DAMAGE_UNKNOWN
local DAMAGE_TOTAL = LGCS.DAMAGE_TOTAL
local DAMAGE_BOSS = LGCS.DAMAGE_BOSS

local nextTypeId = 1
local DAMAGE_LIST_HEADER_TYPE = 1
local DAMAGE_LIST_DAMAGEROW_TYPE = 2
local DAMAGE_LIST_GROUPTOTAL_TYPE = 3
--local DAMAGE_LIST_TIMETOKILL_TYPE = 4

local DAMAGE_LIST_DEFAULT_DAMAGEROW_TEMPLATE = "HodorReflexes_Dps_DamageList_DamageRow"
local DAMAGE_LIST_DEFAULT_HEADER_TEMPLATE = "HodorReflexes_Dps_DamageList_Header"
local DAMAGE_LIST_DEFAULT_GROUPTOTAL_TEMPLATE = "HodorReflexes_Dps_DamageList_GroupTotal"
--local DAMAGE_LIST_TIMETOKILL_TEMPLATE = "HodorReflexes_Dps_TimeToKill"

local DPS_FRAGMENT -- HUD Fragment
local damageListWindowName = addon_name .. module_name
local damageListWindow = {}
local damageListControlName = damageListWindowName .. "_List"
local damageListControl = {}
local damageListHeaderTimeControl = nil

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

function addon.SortByDamage(a, b)
    --sort by dmgType first (TOTAL > BOSS > UNKNOWN)
    if a.dmgType ~= b.dmgType then
        return a.dmgType > b.dmgType
    end
    -- Sort by damage
    return a.dmg > b.dmg
end
local sortByDamage = addon.SortByDamage

--- applies the selected theme by updating the data types used in the damage ScrollList
local function applyTheme(themeName)
    DAMAGE_LIST_DAMAGEROW_TYPE = themes[themeName].DAMAGE_LIST_DAMAGEROW_TYPE
    DAMAGE_LIST_HEADER_TYPE = themes[themeName].DAMAGE_LIST_HEADER_TYPE
    DAMAGE_LIST_GROUPTOTAL_TYPE = themes[themeName].DAMAGE_LIST_GROUPTOTAL_TYPE
end

--- validates the selected theme and sets it to "default" if not valid
local function validateSelectedTheme()
    if sw.selectedTheme == nil then sw.selectedTheme = "default" end
    if themes[sw.selectedTheme] == nil then sw.selectedTheme = "default" end
end

local function getDamageTypeName(t)
    local names = {
        [DAMAGE_UNKNOWN] = strformat('|c%s%s|r', sw.styleBossDamageColor, GetString(HR_DAMAGE)),
        [DAMAGE_TOTAL] = strformat('|c%s%s|r |c%s(DPS)|r', sw.styleBossDamageColor, GetString(HR_TOTAL_DAMAGE), sw.styleTotalDamageColor),
        [DAMAGE_BOSS] = strformat('|c%s%s|r |c%s(%s)|r', sw.styleBossDamageColor, GetString(HR_BOSS_DPS), sw.styleTotalDamageColor, GetString(HR_TOTAL_DPS)),
    }
    return names[t] and names[t] or strformat('|c%s%s|r |c%s(DPS)|r', sw.styleBossDamageColor, GetString(HR_MISC_DAMAGE), sw.styleTotalDamageColor)
end

--- checks if damageList should be enabled at all
local function isEnabled()
    return sw.enabled and (not sw.disablePvP or not IsPlayerInAvAWorld() and not IsActiveWorldBattleground())
end

--- Returns true if the damage list should be shown, false otherwise.
local function isDamageListVisible()
    if sv.enableDamageList == 1 then
        return true
    elseif sv.enableDamageList == 2 then
        return not IsUnitInCombat(localPlayer)
    elseif sv.enableDamageList == 3 then
        return not IsUnitInCombat(localPlayer) or not DoesUnitExist('boss1') and not DoesUnitExist('boss2')
    else
        return false
    end
end

--- updates the damage list timer. This gets periodically triggered while being in combat and disabled afterwards
local function updateDamageListTimer()
    if damageListHeaderTimeControl == nil then return end
    local t = combat.GetCombatTime()
    damageListHeaderTimeControl:SetText(t > 0 and strformat('%d:%04.1f|u0:2::|u', t / 60, t % 60) or '')
end

--- updates the damageList
local function updateDamageList()
    if not isDamageListVisible then return end

    --- prepare data ---
    local overallDmg = 0
    local overallDps = 0
    local dmgType = DAMAGE_UNKNOWN
    local highestGroupDMG = 0
    local highestGroupDPS = 0
    local lowestGroupDMG = 999999
    local lowestGroupDPS = 999999

    ZO_ScrollList_Clear(damageListControl)
    local dataList = ZO_ScrollList_GetDataList(damageListControl)

    local playersDataList = {}
    for _, playerData in pairs(playersData) do
        if playerData.dmg > 0 then
            overallDmg = overallDmg + playerData.dmg
            overallDps = overallDps + playerData.dps
            dmgType = playerData.dmgType
            if playerData.dmg > highestGroupDMG then highestGroupDMG = playerData.dmg end
            if playerData.dps > highestGroupDPS then highestGroupDPS = playerData.dps end
            if playerData.dmg < lowestGroupDMG then lowestGroupDMG = playerData.dmg end
            if playerData.dps < lowestGroupDPS then lowestGroupDPS = playerData.dps end
            table.insert(playersDataList, playerData)
        end
    end
    table.sort(playersDataList, sortByDamage)

    --- fill dataList ---
    -- insert Header
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(DAMAGE_LIST_HEADER_TYPE, {
        dmgType = dmgType,
    }))

    -- insert damageRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        playerData.highestGroupDMG = highestGroupDMG
        playerData.highestGroupDPS = highestGroupDPS
        playerData.lowestGroupDMG = lowestGroupDMG
        playerData.lowestGroupDPS = lowestGroupDPS
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(DAMAGE_LIST_DAMAGEROW_TYPE, playerData))
    end

    if sv.enableGroupTotalRow and #dataList > 1 then
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(DAMAGE_LIST_GROUPTOTAL_TYPE, {
            dmgType = dmgType,
            dmg = overallDmg,
            dps = overallDps,
        }))
    end

    ZO_ScrollList_Commit(damageListControl)
end

--- processes incoming dps data messages and creates/updates the player's entry inside the playersData table
local function onDPSDataReceived(tag, data)
    if not IsUnitGrouped(tag) then return end

    CreateOrUpdatePlayerData({
        name     = GetUnitName(tag),
        tag      = tag,
        dmg      = data.dmg,
        dps      = data.dps,
        dmgType  = data.dmgType,
    })

    updateDamageList()
end

local function refreshVisibility()
    controlsVisible = not uiLocked or isEnabled() and IsUnitGrouped(localPlayer)

    DPS_FRAGMENT:Refresh()
end

local function UnlockUI()
    uiLocked = false
    refreshVisibility()
    hud.UnlockControls(damageListWindow)
end

local function LockUI()
    uiLocked = true
    refreshVisibility()
    hud.LockControls(damageListWindow)
end

local function onGroupChange()
    refreshVisibility()
end

local function createSceneFragments()
    local function DPSFragmentCondition()
        return isDamageListVisible() and controlsVisible
    end

    DPS_FRAGMENT = hud.AddSimpleFragment(damageListWindow, DPSFragmentCondition)
    --DPS_FRAGMENT = ZO_HUDFadeSceneFragment:New( controlMainWindow )
    --DPS_FRAGMENT:SetConditional(DPSFragmentCondition)
    --HUD_UI_SCENE:AddFragment( DPS_FRAGMENT )
    --HUD_SCENE:AddFragment( DPS_FRAGMENT )
end

local function createDamageListWindow()
    damageListWindow = WM:CreateTopLevelWindow(damageListWindowName)
    damageListWindow:SetClampedToScreen(true)
    damageListWindow:SetResizeToFitDescendents(true)
    damageListWindow:SetHidden(true)
    damageListWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sv.damageListPosLeft, sv.damageListPosTop)
    damageListWindow:SetWidth(sw.damageListWidth)
    damageListWindow:SetHeight(sw.damageListHeaderHeight + (sw.damageListRowHeight * 12) + sw.damageListRowHeight)
    damageListWindow:SetHandler( "OnMoveStop", function()
        sv.damageListPosLeft = damageListWindow:GetLeft()
        sv.damageListPosTop = damageListWindow:GetTop()
    end)

    damageListControl = WM:CreateControlFromVirtual(damageListControlName, damageListWindow, "ZO_ScrollList")
    damageListControl:SetAnchor(TOPLEFT, damageListWindow, TOPLEFT, 0, 0, ANCHOR_CONSTRAINS_XY)
    damageListControl:SetAnchor(TOPRIGHT, damageListWindow, TOPRIGHT, ZO_SCROLL_BAR_WIDTH, 0, ANCHOR_CONSTRAINS_X)
    damageListControl:SetHeight(sw.damageListHeaderHeight + (sw.damageListRowHeight * 12) + sw.damageListRowHeight)
    damageListControl:SetMouseEnabled(false)
    damageListControl:GetNamedChild("Contents"):SetMouseEnabled(false)

    ZO_ScrollList_SetHideScrollbarOnDisable(damageListControl, true)
    ZO_ScrollList_SetUseScrollbar(damageListControl, false)
    ZO_ScrollList_SetScrollbarEthereal(damageListControl, true)
end

local function stopDamageListTimerUpdate()
    updateDamageListTimer()
    EM:UnregisterForUpdate(addon_name .. module_name .. "DamageListTitleUpdate")
end
local function startDamageListTimerUpdate()
    stopDamageListTimerUpdate()
    EM:RegisterForUpdate(addon_name .. module_name .. "DamageListTitleUpdate", sv.damageListTimerUpdateInterval, updateDamageListTimer)
end


local function defaultHeaderRowCreationFunc(rowControl, data, scrollList)
    rowControl:GetNamedChild("_Title"):SetText(strformat('%s', getDamageTypeName(data.dmgType == nil and 1 or data.dmgType)))
    rowControl:GetNamedChild("_BG"):SetAlpha(sw.styleDamageHeaderOpacity)
end
local function defaultDamageRowCreationFunc(rowControl, data, scrollList)
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
    iconControl:SetTexture(sw.enableDamageIcons and userIcon or defaultIcon)

    if sw.enableAnimIcons then
        anim.AnimateUserIcon("dps_list", userId, iconControl)
    end

    local valueControl = rowControl:GetNamedChild("_Value")

    local dmgStr = ""
    if data.dmgType == DAMAGE_TOTAL then
        dmgStr = strformat('|c%s%0.2fM|r |c%s(%dK)|r|u0:2::|u', sw.styleBossDamageColor, data.dmg / 100, sw.styleTotalDamageColor, data.dps)
    else
        dmgStr = strformat('|c%s%0.1fK|r |c%s(%dK)|r|u0:2::|u', sw.styleBossDamageColor, data.dmg / 10, sw.styleTotalDamageColor, data.dps)
    end
    valueControl:SetText(dmgStr)

    local font = "$(MEDIUM_FONT)|$(KB_17)|outline"
    if sw.styleDamageNumFont == "gamepad" then
        font = "$(GAMEPAD_MEDIUM_FONT)|$(KB_19)|outline"
    end
    valueControl:SetFont(font)

    local customColor = false
    if data.isPlayer then
        local r, g, b, o = unpack(sw.damageRowColor)
        if o ~= 0 then
            customColor = true
            rowControl:GetNamedChild('_BG'):SetColor(r, g, b, o or 0.5)
        end
    end
    if not customColor then
        rowControl:GetNamedChild('_BG'):SetColor(0, 0, 0, zo_mod(data.orderIndex, 2) == 0 and sw.styleDamageRowEvenOpacity or sw.styleDamageRowOddOpacity)
    end
end
local function defaultGroupTotalRowCreationFunc(rowControl, data, scrollList)

    local dmgStr = ""
    if data.dmgType == DAMAGE_TOTAL then
        dmgStr = strformat('|c%s%0.2fM|r |c%s(%dK)|r|u0:2::|u', sw.styleBossDamageColor, data.dmg / 100, sw.styleTotalDamageColor, data.dps)
    else
        dmgStr = strformat('|c%s%0.1fK|r |c%s(%dK)|r|u0:2::|u', sw.styleBossDamageColor, data.dmg / 10, sw.styleTotalDamageColor, data.dps)
    end

    rowControl:GetNamedChild("_Value"):SetText(dmgStr)
end
local defaultTheme = {
    author = "@m00nyONE",
    version = "1.0.0",
    description = "The Default Theme of HodorReflexes DPS Module",

    HeaderRowTemplate = DAMAGE_LIST_DEFAULT_HEADER_TEMPLATE,
    HeaderRowCreationFunc = defaultHeaderRowCreationFunc,
    DamageRowTemplate = DAMAGE_LIST_DEFAULT_DAMAGEROW_TEMPLATE,
    DamageRowCreationFunc = defaultDamageRowCreationFunc,
    GroupTotalRowTemplate = DAMAGE_LIST_DEFAULT_GROUPTOTAL_TEMPLATE,
    GroupTotalRowCreationFunc = defaultGroupTotalRowCreationFunc,

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


    themeTable.DAMAGE_LIST_HEADER_TYPE = nextTypeId
    nextTypeId = nextTypeId + 1
    themeTable.DAMAGE_LIST_DAMAGEROW_TYPE = nextTypeId
    nextTypeId = nextTypeId + 1
    themeTable.DAMAGE_LIST_GROUPTOTAL_TYPE = nextTypeId
    nextTypeId = nextTypeId + 1


    local function createDamageRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            -- only create rows if conditions are met
            if data.dmg > 0 and (isTestRunning or IsUnitOnline(data.tag)) then
                wrappedFunction(rowControl, data, scrollList)
            end
        end
    end
    local function createHeaderRowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            -- allways set the Control of the Time so we can update it later
            damageListHeaderTimeControl = rowControl:GetNamedChild("_Time")
            wrappedFunction(rowControl, data, scrollList)
        end
    end

    ZO_ScrollList_AddDataType(
            damageListControl,
            themeTable.DAMAGE_LIST_DAMAGEROW_TYPE,
            themeTable.DamageRowTemplate or defaultTheme.DamageRowTemplate,
            sw.damageListRowHeight,
            createDamageRowCreationWrapper(themeTable.DamageRowCreationFunc or defaultTheme.DamageRowCreationFunc)
    )

    ZO_ScrollList_AddDataType(
            damageListControl,
            themeTable.DAMAGE_LIST_HEADER_TYPE,
            themeTable.HeaderRowTemplate or defaultTheme.HeaderRowTemplate,
            sw.damageListHeaderHeight,
            createHeaderRowCreationWrapper(themeTable.HeaderRowCreationFunc or defaultTheme.HeaderRowCreationFunc)
    )
    ZO_ScrollList_SetTypeCategoryHeader(damageListControl, themeTable.DAMAGE_LIST_HEADER_TYPE, true)

    ZO_ScrollList_AddDataType(
            damageListControl,
            themeTable.DAMAGE_LIST_GROUPTOTAL_TYPE,
            themeTable.GroupTotalRowTemplate or defaultTheme.GroupTotalRowTemplate,
            sw.damageListRowHeight,
            themeTable.GroupTotalRowCreationFunc or defaultTheme.GroupTotalRowCreationFunc
    )
    ZO_ScrollList_SetTypeCategoryHeader(damageListControl, themeTable.DAMAGE_LIST_GROUPTOTAL_TYPE, true)

    -- register Theme
    themes[themeName] = themeTable
    table.insert(LAMThemeChoices, themeName)
end

local function updateTest()
    if not isTestRunning then return end

    for name, playerData in pairs(playersData) do
        local dmg = playerData.dmg + zo_random(-15, 15)
        if dmg > 1200 then dmg = 1200 end
        if dmg < 500 then dmg = 500 end

        CreateOrUpdatePlayerData({
            name = name, -- required
            tag = name, -- required
            dmg = dmg,
            dps = dmg * 0.15,
            dmgType = DAMAGE_BOSS,
        })
    end

    updateDamageList()
end

local function startTest()
    isTestRunning = true

    for name, _ in pairs(playersData) do
        local dmg = zo_random(500, 1200)

        CreateOrUpdatePlayerData({
            name = name, -- required
            tag = name, -- required
            dmg = dmg,
            dps = dmg * 0.15,
            dmgType = DAMAGE_BOSS,
        })
    end

    updateDamageList()
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
            name = GetString(HR_MENU_DAMAGE_SHOW),
            tooltip = GetString(HR_MENU_DAMAGE_SHOW_TT),
            default = svDefault.enableDamageList,
            getFunc = function() return sv.enableDamageList end,
            setFunc = function(value) sv.enableDamageList = value or false end,
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
            name = "show total group dps", -- TODO: translation
            tooltip = "show total group dps", -- TODO: translation
            default = svDefault.enableGroupTotalRow,
            getFunc = function() return sv.enableGroupTotalRow end,
            setFunc = function(value) sv.enableGroupTotalRow = value end,
            width = "full",
            requiresReload = true,
        },
        {
            type = "slider",
            name = "Timer update Interval (ms)", -- TODO: translation
            min = 100,
            max = 3000,
            step = 10,
            decimals = 0,
            default = svDefault.damageListTimerUpdateInterval,
            clampInput = true,
            getFunc = function() return sw.damageListTimerUpdateInterval end,
            setFunc = function(value) sw.damageListTimerUpdateInterval = value end,
            width = "full",
            requiresReload = true,
        },
        {
            type = "slider",
            name = "header height",
            min = 22,
            max = 44,
            step = 1,
            decimals = 0,
            default = svDefault.damageListHeaderHeight,
            clampInput = true,
            getFunc = function() return sw.damageListHeaderHeight end,
            setFunc = function(value)
                sw.damageListHeaderHeight = value
            end,
        },
        {
            type = "slider",
            name = "row height",
            min = 22,
            max = 44,
            step = 1,
            decimals = 0,
            default = svDefault.damageListRowHeight,
            clampInput = true,
            getFunc = function() return sw.damageListRowHeight end,
            setFunc = function(value)
                sw.damageListRowHeight = value
            end,
        },
        {
            type = "slider",
            name = "List width",
            min = 227,
            max = 450,
            step = 1,
            decimals = 0,
            default = svDefault.damageListWidth,
            clampInput = true,
            getFunc = function() return sw.damageListWidth end,
            setFunc = function(value)
                sw.damageListWidth = value
                damageListWindow:SetWidth(sw.damageListWidth)
            end,
        },
        {
            type = "divider"
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
                updateDamageList()
            end,
            choices = LAMThemeChoices,
            width = 'full',
        },
        {
            type = "divider"
        },
        {
            type = "checkbox",
            name = GetString(HR_MENU_ICONS_VISIBILITY_COLORS),
            tooltip = GetString(HR_MENU_ICONS_VISIBILITY_COLORS_TT),
            default = svDefault.enableColoredNames,
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return sw.enableColoredNames end,
            setFunc = function(value) sw.enableColoredNames = value or false end,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = GetString(HR_MENU_ICONS_VISIBILITY_DPS),
            tooltip = GetString(HR_MENU_ICONS_VISIBILITY_DPS_TT),
            default = svDefault.enableDamageIcons,
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return sw.enableDamageIcons end,
            setFunc = function(value) sw.enableDamageIcons = value or false end,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = GetString(HR_MENU_ICONS_VISIBILITY_ANIM),
            tooltip = GetString(HR_MENU_ICONS_VISIBILITY_ANIM_TT),
            default = svDefault.enableAnimIcons,
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return sw.enableAnimIcons end,
            setFunc = function(value) sw.enableAnimIcons = value or false end,
            requiresReload = true,
        },
        {
            type = "dropdown",
            name = GetString(HR_MENU_STYLE_DPS_FONT),
            tooltip = "",
            default = svDefault.styleDamageNumFont,
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return sw.styleDamageNumFont end,
            setFunc = function(value)
                sw.styleDamageNumFont = value or 'gamepad'
                updateDamageList()
            end,
            choices = {
                GetString(HR_MENU_STYLE_DPS_FONT_DEFAULT), GetString(HR_MENU_STYLE_DPS_FONT_GAMEPAD),
            },
            choicesValues = {
                'default', 'gamepad',
            },
        },
        {
            type = "colorpicker",
            name = GetString(HR_MENU_STYLE_DPS_BOSS_COLOR),
            tooltip = "",
            default = addon.util.Hex2RGB(svDefault.styleBossDamageColor),
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return util.Hex2RGB(sw.styleBossDamageColor) end,
            setFunc = function(r, g, b)
                sw.styleBossDamageColor = util.RGB2Hex(r, g, b)
                updateDamageList()
            end,
        },
        {
            type = "colorpicker",
            name = GetString(HR_MENU_STYLE_DPS_TOTAL_COLOR),
            tooltip = "",
            default = addon.util.Hex2RGB(svDefault.styleTotalDamageColor),
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return util.Hex2RGB(sw.styleTotalDamageColor) end,
            setFunc = function(r, g, b)
                sw.styleTotalDamageColor = util.RGB2Hex(r, g, b)
                updateDamageList()
            end,
        },
        {
            type = "slider",
            name = GetString(HR_MENU_STYLE_DPS_HEADER_OPACITY),
            min = 0,
            max = 1,
            step = 0.05,
            decimals = 2,
            clampInput = true,
            default = svDefault.styleDamageHeaderOpacity,
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return sw.styleDamageHeaderOpacity end,
            setFunc = function(value)
                sw.styleDamageHeaderOpacity = value
                updateDamageList()
            end,
        },
        {
            type = "slider",
            name = GetString(HR_MENU_STYLE_DPS_EVEN_OPACITY),
            min = 0,
            max = 1,
            step = 0.05,
            decimals = 2,
            clampInput = true,
            default = svDefault.styleDamageRowEvenOpacity,
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return sw.styleDamageRowEvenOpacity end,
            setFunc = function(value)
                sw.styleDamageRowEvenOpacity = value
                updateDamageList()
            end,
        },
        {
            type = "slider",
            name = GetString(HR_MENU_STYLE_DPS_ODD_OPACITY),
            min = 0,
            max = 1,
            step = 0.05,
            decimals = 2,
            clampInput = true,
            default = svDefault.styleDamageRowOddOpacity,
            disabled = function() return sv.selectedTheme ~= "default" end,
            getFunc = function() return sw.styleDamageRowOddOpacity end,
            setFunc = function(value)
                sw.styleDamageRowOddOpacity = value
                updateDamageList()
            end,
        },
        {
            type = "colorpicker",
            name = GetString(HR_MENU_STYLE_DPS_HIGHLIGHT),
            tooltip = GetString(HR_MENU_STYLE_DPS_HIGHLIGHT_TT),
            default = ZO_ColorDef:New(unpack(svDefault.damageRowColor)),
            disabled = function() return sv.selectedTheme ~= "default" end,
            --default = ZO_ColorDef:New(unpack(M.default.damageRowColor)),
            getFunc = function() return unpack(sw.damageRowColor) end,
            setFunc = function(r, g, b, o)
                sw.damageRowColor = {r, g, b, o}
                updateDamageList()
            end,
        },
    }
end

function module:Initialize()
    lgcs = LGCS.RegisterAddon(addon_name .. module_name, {"DPS"})
    if not lgcs then
        d("Failed to register addon with LibGroupCombatStats.")
        return
    end
    lgcs:RegisterForEvent(EVENT_GROUP_DPS_UPDATE, onDPSDataReceived)
    lgcs:RegisterForEvent(EVENT_PLAYER_DPS_UPDATE, onDPSDataReceived)

    -- register callbacks to events from main addon.
    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, onGroupChange) -- triggers a group cleanup
    addon.RegisterCallback(HR_EVENT_COMBAT_START, startDamageListTimerUpdate) -- start updating the time in the DamageListHeader
    addon.RegisterCallback(HR_EVENT_COMBAT_END, stopDamageListTimerUpdate) -- stop updating the time in the DamageListHeader

    addon.RegisterCallback(HR_EVENT_LOCKUI, LockUI)
    addon.RegisterCallback(HR_EVENT_UNLOCKUI, UnlockUI)

    addon.RegisterCallback(HR_EVENT_TEST_STARTED, startTest)
    addon.RegisterCallback(HR_EVENT_TEST_STOPPED, stopTest)
    addon.RegisterCallback(HR_EVENT_TEST_TICK, updateTest)
    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_CLEANED, updateDamageList)

    group.RegisterPlayersDataFields({
        dmg = 0,
        dps = 0,
        dmgType = DAMAGE_UNKNOWN,
    })

    -- we use a combination of accountWide saved variables and cper character saved variables. This little swappi swappi allows us to switch between them without defining new variables
    sw = ZO_SavedVars:NewAccountWide(svName, svVersion, module_name, svDefault)
    if not sw.accountWide then
        sv = ZO_SavedVars:NewCharacterIdSettings(svName, svVersion, module_name, svDefault)
        sv.accountWide = false
    else
        sv = sw
    end

    createDamageListWindow()
    createSceneFragments()
    refreshVisibility()

    module:RegisterTheme("default", defaultTheme)
    validateSelectedTheme()
    applyTheme(sw.selectedTheme)

    updateDamageListTimer()

    local eventRegisterName = addon_name .. module_name .. "PlayerActivated"
    EM:UnregisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED)
    EM:RegisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED, onPlayerActivated)
end

addon:RegisterModule(module_name, module)
