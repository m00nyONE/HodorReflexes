local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local module = {
    name = "dps",
    friendlyName = "Damage",
    description = "Shows group dps statistics",
    version = "1.0.0",
    priority = 2,
    enabled = false,

    playersData = {}
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

    selectedTheme = 'default',

    enableGroupTotalRow = true,
    enableColoredNames = true,
    enableDamageIcons = true,
    enableAnimIcons = true,
    damageRowColor = {0, 1, 0, 0.36},

    styleDamageHeaderOpacity = 0.8,
    styleDamageRowEvenOpacity = 0.65,
    styleDamageRowOddOpacity = 0.45,
    styleDamageNumFont = 'gamepad',
    styleBossDamageColor = 'b2ffb2',
    styleTotalDamageColor = 'faffb2',

    damageListTimerUpdateInterval = 1000,
}

local CM = ZO_CallbackObject:New()
local EM = GetEventManager()
local WM = GetWindowManager()
local LAM = LibAddonMenu2
local LGCS = LibGroupCombatStats
local localPlayer = "player"
local strformat = string.format

local lgcs = {}
local playersData = module.playersData
local hud = addon.hud
local combat = addon.combat
local player = addon.player
local anim = addon.anim
local util = addon.util

local EVENT_GROUP_DPS_UPDATE = LGCS.EVENT_GROUP_DPS_UPDATE
local EVENT_PLAYER_DPS_UPDATE = LGCS.EVENT_PLAYER_DPS_UPDATE

local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED
local HR_EVENT_COMBAT_START = addon.HR_EVENT_COMBAT_START
local HR_EVENT_COMBAT_END = addon.HR_EVENT_COMBAT_END

local DAMAGE_UNKNOWN = LGCS.DAMAGE_UNKNOWN
local DAMAGE_TOTAL = LGCS.DAMAGE_TOTAL
local DAMAGE_BOSS = LGCS.DAMAGE_BOSS

local DAMAGE_LIST_HEADER_TYPE = 1
local DAMAGE_LIST_DAMAGEROW_TYPE = 2
local DAMAGE_LIST_GROUPTOTAL_TYPE = 3
--local DAMAGE_LIST_TIMETOKILL_TYPE = 4

local DAMAGE_LIST_DAMAGEROW_TEMPLATE = "HodorReflexes_Dps_DamageRow"
local DAMAGE_LIST_HEADER_TEMPLATE = "HodorReflexes_Dps_Header"
local DAMAGE_LIST_GROUPTOTAL_TEMPLATE = "HodorReflexes_Dps_GroupTotal"
--local DAMAGE_LIST_TIMETOKILL_TEMPLATE = "HodorReflexes_Dps_TimeToKill"

local DPS_FRAGMENT -- HUD Fragment
local damageListControlName = addon_name .. module_name
local damageListControl = {}
local damageListHeaderTimeControl = nil

local controlsVisible = false
local uiLocked = true
local isTestRunning = false

local themes = {}

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
--
--local function sortDamageList(a, b)
--    -- First: header always on top
--    if a.typeId ~= b.typeId then
--        return a.typeId < b.typeId  -- 1 < 2 so header first
--    end
--    -- At this point both are normal rows (typeId == 2)
--    --return sortByDamage(a, b)
--end

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
    local damageList = damageListControl:GetNamedChild("_List")

    ZO_ScrollList_Clear(damageList)
    local dataList = ZO_ScrollList_GetDataList(damageList)

    local playersDataList = {}
    for _, playerData in pairs(playersData) do
        if playerData.dmg > 0 then
            overallDmg = overallDmg + playerData.dmg
            overallDps = overallDps + playerData.dps
            dmgType = playerData.dmgType
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
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(DAMAGE_LIST_DAMAGEROW_TYPE, playerData))
    end

    if sv.enableGroupTotalRow and #dataList > 1 then
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(DAMAGE_LIST_GROUPTOTAL_TYPE, {
            dmgType = dmgType,
            dmg = overallDmg,
            dps = overallDps,
        }))
    end

    ZO_ScrollList_Commit(damageList)
end

--- creates a player entry inside the playersData table
local function createOrUpdatePlayer(data)
    if not data or not data.name then return end

    local playerData = playersData[data.name]
    if not playerData then
        playerData = {
            name     = data.name,
            userId   = data.userId,
            classId  = data.classId,
            isPlayer = data.isPlayer,
        }
        playersData[data.name] = playerData
    end

    -- Update / overwrite fields
    playerData.tag        = data.tag
    playerData.dmg        = data.dmg
    playerData.dps        = data.dps
    playerData.dmgType    = data.dmgType
    playerData.lastUpdate = GetGameTimeMilliseconds()
end

--- processes incoming dps data messages and creates/updates the player's entry inside the playersData table
local function onDPSDataReceived(tag, data)
    if not IsUnitGrouped(tag) then return end

    createOrUpdatePlayer({
        name     = GetUnitName(tag),
        userId   = GetUnitDisplayName(tag),
        classId  = GetUnitClassId(tag),
        isPlayer = AreUnitsEqual(tag, localPlayer),
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
    hud.UnlockControls(damageListControl)
end

local function LockUI()
    uiLocked = true
    refreshVisibility()
    hud.LockControls(damageListControl)
end


--- cleans group data and deletes all players that are not in the group anymore
local function cleanPlayersData(forceDelete)
    local _existingGroupCharacters = {}
    local _groupSize = GetGroupSize()

    for i = 1, _groupSize do
        local tag = GetGroupUnitTagByIndex(i)
        if IsUnitPlayer(tag) and IsUnitOnline(tag) then
            local characterName = GetUnitName(tag)
            _existingGroupCharacters[characterName] = true
            if playersData[characterName] then
                playersData[characterName].tag = tag
            end
        end
    end
    for name, data in pairs(playersData) do
        if not _existingGroupCharacters[name] or forceDelete then
            anim.UnregisterUser(data.userId)
            playersData[name] = nil
        end
    end

    updateDamageList()
end

--- triggers when a group member joins/leaves/offlines/updates
local function onGroupChange()
    if isTestRunning then
        cleanPlayersData(true)
        isTestRunning = false
        LockUI()
    else
        cleanPlayersData()
    end

    refreshVisibility()
end

local function createSceneFragments()
    local function DPSFragmentCondition()
        return isDamageListVisible() and controlsVisible
    end

    DPS_FRAGMENT = hud.AddSimpleFragment(damageListControl, DPSFragmentCondition)
    --DPS_FRAGMENT = ZO_HUDFadeSceneFragment:New( controlMainWindow )
    --DPS_FRAGMENT:SetConditional(DPSFragmentCondition)
    --HUD_UI_SCENE:AddFragment( DPS_FRAGMENT )
    --HUD_SCENE:AddFragment( DPS_FRAGMENT )
end

local function createDamageList()
    local damageList = WM:CreateControlFromVirtual(damageListControlName .. "_List", damageListControl, "ZO_ScrollList")
    damageList:SetAnchor(TOPLEFT, damageListControl, TOPLEFT, 0, 0, ANCHOR_CONSTRAINS_XY)
    damageList:SetAnchor(TOPRIGHT, damageListControl, TOPRIGHT, ZO_SCROLL_BAR_WIDTH, 0, ANCHOR_CONSTRAINS_X)
    damageList:SetHeight((sw.damageListRowHeight * 12) + (sw.damageListHeaderHeight * 2))
    damageList:SetMouseEnabled(false)
    damageList:GetNamedChild("Contents"):SetMouseEnabled(false)

    ZO_ScrollList_SetHideScrollbarOnDisable(damageList, true)
    ZO_ScrollList_SetUseScrollbar(damageList, false)
    ZO_ScrollList_SetScrollbarEthereal(damageList, true)

    local function onHeaderRowCreation(rowControl, data, scrollList)
        damageListHeaderTimeControl = rowControl:GetNamedChild("_Time")

        rowControl:GetNamedChild("_Title"):SetText(strformat('%s', getDamageTypeName(data.dmgType == nil and 1 or data.dmgType)))
    end

    local function onDamageRowCreation(rowControl, data, scrollList)
        if data.dmg > 0 and (isTestRunning or IsUnitOnline(data.tag)) then
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

            if sw.enableAnimIcons and anim.RegisterUser(userId) then
                if sw.enableDamageIcons then anim.RegisterUserControl(userId, iconControl) end
                anim.RunUserAnimations(userId)
            end

            local dmgStr = ""
            if data.dmgType == DAMAGE_TOTAL then
                dmgStr = strformat('|c%s%0.2fM|r |c%s(%dK)|r|u0:2::|u', sw.styleBossDamageColor, data.dmg / 100, sw.styleTotalDamageColor, data.dps)
            else
                dmgStr = strformat('|c%s%0.1fK|r |c%s(%dK)|r|u0:2::|u', sw.styleBossDamageColor, data.dmg / 10, sw.styleTotalDamageColor, data.dps)
            end

            local customColor = false
            rowControl:GetNamedChild("_Value"):SetText(dmgStr)
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
    end

    local function onGroupTotalRowCreation(rowControl, data, scrollList)

        local dmgStr = ""
        if data.dmgType == DAMAGE_TOTAL then
            dmgStr = strformat('|c%s%0.2fM|r |c%s(%dK)|r|u0:2::|u', sw.styleBossDamageColor, data.dmg / 100, sw.styleTotalDamageColor, data.dps)
        else
            dmgStr = strformat('|c%s%0.1fK|r |c%s(%dK)|r|u0:2::|u', sw.styleBossDamageColor, data.dmg / 10, sw.styleTotalDamageColor, data.dps)
        end

        rowControl:GetNamedChild("_Value"):SetText(dmgStr)
    end

    ZO_ScrollList_AddDataType(
            damageList,
            DAMAGE_LIST_DAMAGEROW_TYPE,
            "HodorReflexes_Dps_DamageRow",
            sw.damageListRowHeight,
            onDamageRowCreation,
            nil,
            nil
    )

    ZO_ScrollList_AddDataType(
            damageList,
            DAMAGE_LIST_HEADER_TYPE,
            "HodorReflexes_Dps_Header",
            sw.damageListHeaderHeight,
            onHeaderRowCreation,
            nil,
            nil
    )
    ZO_ScrollList_SetTypeCategoryHeader(damageList, DAMAGE_LIST_HEADER_TYPE, true)

    ZO_ScrollList_AddDataType(
            damageList,
            DAMAGE_LIST_GROUPTOTAL_TYPE,
            "HodorReflexes_Dps_GroupTotal",
            sw.damageListRowHeight,
            onGroupTotalRowCreation,
            nil,
            nil
    )
    ZO_ScrollList_SetTypeCategoryHeader(damageList, DAMAGE_LIST_GROUPTOTAL_TYPE, true)
end

local function createDamageListWindow()
    damageListControl = WM:CreateTopLevelWindow(damageListControlName)
    damageListControl:SetClampedToScreen(true)
    damageListControl:SetResizeToFitDescendents(true)
    damageListControl:SetHidden(true)
    damageListControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sv.damageListPosLeft, sv.damageListPosTop)
    damageListControl:SetWidth(sw.damageListWidth)
    damageListControl:SetHeight(sw.damageListHeaderHeight + sw.damageListRowHeight + (sw.damageListRowHeight * 12))
    damageListControl:SetHandler( "OnMoveStop", function()
        sv.damageListPosLeft = damageListControl:GetLeft()
        sv.damageListPosTop = damageListControl:GetTop()
    end)

    createDamageList()
end

local function stopDamageListTimerUpdate()
    updateDamageListTimer()
    EM:UnregisterForUpdate(addon_name .. module_name .. "DamageListTitleUpdate")
end
local function startDamageListTimerUpdate()
    stopDamageListTimerUpdate()
    EM:RegisterForUpdate(addon_name .. module_name .. "DamageListTitleUpdate", sv.damageListTimerUpdateInterval, updateDamageListTimer)
end


function module:RegisterTheme(name, themeTable)
    -- check parameters
    assert(type(name) == 'string' and name ~= '', 'invalid theme name')
    assert(type(themeTable) == 'table', 'invalid theme table')
    assert(themes[name] == nil, strformat('theme with name "%s" already exists', name))

    -- check basic fields
    local requiredFields = {
        author = 'string',
        version = 'string',
        description = 'string',

        settings = 'table',

        HeaderTemplate = 'string',
        onHeaderRowCreation = 'function',
        DamageRowTemplate = 'string',
        onDamageRowCreation = 'function',
        GroupTotalTemplate = 'string',
        onGroupTotalRowCreation = 'function',
    }

    -- register Theme
    themes[name] = themeTable
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
            min = 0,
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
            type = "divider"
        },
        {
            type = "checkbox",
            name = GetString(HR_MENU_ICONS_VISIBILITY_COLORS),
            tooltip = GetString(HR_MENU_ICONS_VISIBILITY_COLORS_TT),
            default = svDefault.enableColoredNames,
            getFunc = function() return sw.enableColoredNames end,
            setFunc = function(value) sw.enableColoredNames = value or false end,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = GetString(HR_MENU_ICONS_VISIBILITY_DPS),
            tooltip = GetString(HR_MENU_ICONS_VISIBILITY_DPS_TT),
            default = svDefault.enableDamageIcons,
            getFunc = function() return sw.enableDamageIcons end,
            setFunc = function(value) sw.enableDamageIcons = value or false end,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = GetString(HR_MENU_ICONS_VISIBILITY_ANIM),
            tooltip = GetString(HR_MENU_ICONS_VISIBILITY_ANIM_TT),
            default = svDefault.enableAnimIcons,
            getFunc = function() return sw.enableAnimIcons end,
            setFunc = function(value) sw.enableAnimIcons = value or false end,
            requiresReload = true,
        },
        {
            type = "divider"
        },
        {
            type = "dropdown",
            name = GetString(HR_MENU_STYLE_DPS_FONT),
            tooltip = "",
            --default = M.sw.styleDamageNumFont,
            getFunc = function() return sw.styleDamageNumFont end,
            setFunc = function(value)
                sw.styleDamageNumFont = value or 'gamepad'
                --ApplyStyle()
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
            getFunc = function() return addon.util.Hex2RGB(sw.styleBossDamageColor) end,
            setFunc = function(r, g, b)
                sw.styleBossDamageColor = addon.util.RGB2Hex(r, g, b)
            end,
        },
        {
            type = "colorpicker",
            name = GetString(HR_MENU_STYLE_DPS_TOTAL_COLOR),
            tooltip = "",
            getFunc = function() return addon.util.Hex2RGB(sw.styleTotalDamageColor) end,
            setFunc = function(r, g, b)
                sw.styleTotalDamageColor = addon.util.RGB2Hex(r, g, b)
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
            getFunc = function() return sw.styleDamageHeaderOpacity end,
            setFunc = function(value)
                sw.styleDamageHeaderOpacity = value
                --ApplyStyle()
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
            getFunc = function() return sw.styleDamageRowEvenOpacity end,
            setFunc = function(value)
                sw.styleDamageRowEvenOpacity = value
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
            getFunc = function() return sw.styleDamageRowOddOpacity end,
            setFunc = function(value)
                sw.styleDamageRowOddOpacity = value
            end,
        },
        {
            type = "colorpicker",
            name = GetString(HR_MENU_STYLE_DPS_HIGHLIGHT),
            tooltip = GetString(HR_MENU_STYLE_DPS_HIGHLIGHT_TT),
            --default = ZO_ColorDef:New(unpack(M.default.damageRowColor)),
            getFunc = function() return unpack(sw.damageRowColor) end,
            setFunc = function(r, g, b, o)
                sw.damageRowColor = {r, g, b, o}
            end,
        },
        {
            type = "slider",
            name = "header height",
            min = 22,
            max = 44,
            step = 1,
            decimals = 0,
            default = 22,
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
            default = 22,
            clampInput = true,
            getFunc = function() return sw.damageListRowHeight end,
            setFunc = function(value)
                sw.damageListRowHeight = value
            end,
        },
        {
            type = "slider",
            name = "row width",
            min = 227,
            max = 450,
            step = 1,
            decimals = 0,
            default = 277,
            clampInput = true,
            getFunc = function() return sw.damageListWidth end,
            setFunc = function(value)
                sw.damageListWidth = value
                damageListControl:SetWidth(sw.damageListWidth)
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
    updateDamageListTimer()

    local eventRegisterName = addon_name .. module_name .. "PlayerActivated"
    EM:UnregisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED)
    EM:RegisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED, onPlayerActivated)
end

addon:RegisterModule(module_name, module)


-- Show a random list of players.
local function ToggleTest(players)

    if isTestRunning then
        cleanPlayersData(true)
        isTestRunning = false
        LockUI()
        d(strformat('|cFF0000%s|r', GetString(HR_TEST_STOPPED)))
        return
    else
        d(strformat('|c00FF00%s|r', GetString(HR_TEST_STARTED)))
        isTestRunning = true
    end

    players = players or {
        '@WarfireX',
        '@LikoXie',
        '@andy.s',
        '@Alcast',
        '@NefasQS',
        '@Wheel5',
        '@PK44',
        '@LokiClermeil',
        '@m00nyONE',
        '@skinnycheeks',
        '@seadotarley',
        '@Solinur'
    }


    local function GetRandomPlayerData(name)
        local dmg = zo_random(500, 1200)
        local playerData = {
            tag = name,
            name = name,
            userId = name,
            classId = zo_random(1, GetNumClasses()),
            isPlayer = name == GetUnitDisplayName(localPlayer),
            dmg = dmg,
            dps = dmg * 0.15,
            dmgType = DAMAGE_BOSS,
        }
        return playerData
    end

    for _, name in ipairs(players) do
        createOrUpdatePlayer(GetRandomPlayerData(name))
    end


    updateDamageList()

    UnlockUI()

end

SLASH_COMMANDS["/hodor.dps"] = function(str)
    local players = zo_strmatch(str, "^test%s*(.*)")
    if players then
        if IsUnitGrouped(localPlayer) then
            d(strformat("|cFF0000%s|r", GetString(HR_TEST_LEAVE_GROUP)))
        else
            ToggleTest(util.IsValidString(players) and {zo_strsplit(" ", players)})
        end
    end
end