local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local module = {
    name = "dps",
    friendlyName = "Damage",
    description = "Shows group dps statistics",
    version = "1.0.0",
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
    enableDamageListSummary = true,
    enableColoredNames = true,
    enableDamageIcons = true,
    enableAnimIcons = true,
    damageRowColor = {0, 1, 0, 0.36},

    damageListHeaderHeight = 22,
    damageListRowHeight = 22,

    damageListPosLeft = 0,
    damageListPosTop = 0,

    styleDamageHeaderOpacity = 0.8,
    styleDamageRowEvenOpacity = 0.65,
    styleDamageRowOddOpacity = 0.45,
    styleDamageNumFont = 'gamepad',
    styleBossDamageColor = 'b2ffb2',
    styleTotalDamageColor = 'faffb2',

    damageListHeaderUpdateInterval = 1000,
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

local DPS_FRAGMENT -- HUD Fragment
local damageListControlName = addon_name .. module_name
local damageListControl = {}

local controlsVisible = false
local uiLocked = true
local isTestRunning = false

local classIcons = {}
for i = 1, GetNumClasses() do
    local id, _, _, _, _, _, icon, _, _, _ = GetClassInfo(i)
    classIcons[id] = icon
end

function addon.OverwriteClassIcons(ci)
    classIcons = ci
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

function addon.SortByDamage(a, b)
    if a.data.dmgType == b.data.dmgType then
        return a.data.dmg > b.data.dmg
    end
    return a.data.dmgType > b.data.dmgType
end
local SortByDamage = addon.SortByDamage

local function getDamageTypeName(t)
    local names = {
        [DAMAGE_UNKNOWN] = strformat('|c%s%s|r', sw.styleBossDamageColor, GetString(HR_DAMAGE)), -- TODO: translation
        [DAMAGE_TOTAL] = strformat('|c%s%s|r |c%s(DPS)|r', sw.styleBossDamageColor, GetString(HR_TOTAL_DAMAGE), sw.styleTotalDamageColor), -- TODO: translation
        [DAMAGE_BOSS] = strformat('|c%s%s|r |c%s(%s)|r', sw.styleBossDamageColor, GetString(HR_BOSS_DPS), sw.styleTotalDamageColor, GetString(HR_TOTAL_DPS)), -- TODO: translation
    }
    return names[t] and names[t] or strformat('|c%s%s|r |c%s(DPS)|r', sw.styleBossDamageColor, GetString(HR_MISC_DAMAGE), sw.styleTotalDamageColor) -- TODO: translation
end
local function getDmgTypeFromPlayer()
    local playerData = playersData[GetUnitName(localPlayer)]
    if not playerData then return -1 end -- return an invalid dmgType on purpose to set the title back to it's original text

    return playerData.dmgType
end

--- updates the damage list title. This gets triggered when a new message arrives
local function updateDamageListTitle()
    local dmgType = getDmgTypeFromPlayer()

    damageListControl:GetNamedChild("_Title"):SetText(strformat('%s', getDamageTypeName(dmgType == nil and 1 or dmgType)))
end
--- updates the damage list timer. This gets periodically triggered while being in combat and disabled afterwards
local function updateDamageListTimer()
    local t = combat.GetCombatTime()
    damageListControl:GetNamedChild("_Time"):SetText(t > 0 and strformat('%d:%04.1f|u0:2::|u', t / 60, t % 60) or '')
end

--- updates the damageList
local function updateDamageList()
    if not isDamageListVisible then return end

    local damageListBody = damageListControl:GetNamedChild("_Body")

    ZO_ScrollList_Clear(damageListBody)
    local dataList = ZO_ScrollList_GetDataList(damageListBody)
    for _, playerData in pairs(playersData) do
        if playerData.dmg > 0 then
            local entry = ZO_ScrollList_CreateDataEntry(1, playerData)
            table.insert(dataList, entry)
        end
    end
    table.sort(dataList, SortByDamage)

    -- inject even/odd
    for i, entry in ipairs(dataList) do
        entry.data.orderIndex = i
    end

    ZO_ScrollList_Commit(damageListBody)

    updateDamageListTitle()
    --updateDamageListTimer() -- not really needed. Sure it's more accurate because combat can be longer than the event system thinks but this is a very very rare case. Most likely it's the exact opoosite
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
    --refreshVisibility()
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

local function createDamageListHeader()
    local damageListHeaderBackGround = WM:CreateControl(damageListControlName .. "_BG", damageListControl, CT_TEXTURE)
    damageListHeaderBackGround:SetColor(0, 0, 0, 0)
    damageListHeaderBackGround:SetAlpha(0.8)
    damageListHeaderBackGround:SetHidden(false)
    damageListHeaderBackGround:SetDimensions(damageListControl:GetWidth(), sw.damageListHeaderHeight)
    damageListHeaderBackGround:SetAnchor(TOPLEFT, damageListControl, TOPLEFT)
    local damageListHeaderTitle = WM:CreateControl(damageListControlName .. "_Title", damageListControl, CT_LABEL)
    damageListHeaderTitle:SetText("title")
    damageListHeaderTitle:SetFont("$(MEDIUM_FONT)|$(KB_16)|shadow")
    --damageListHeaderTitle:SetHidden(true)
    damageListHeaderTitle:SetAnchor(TOPLEFT, damageListControl, TOPLEFT, 2)
    local damageListHeaderTime = WM:CreateControl(damageListControlName .. "_Time", damageListControl, CT_LABEL)
    damageListHeaderTime:SetText("0:00.0")
    damageListHeaderTime:SetFont("$(MEDIUM_FONT)|$(KB_16)|shadow")
    --damageListHeaderTime:SetHidden(true)
    damageListHeaderTime:SetHorizontalAlignment(RIGHT)
    damageListHeaderTime:SetAnchor(TOPRIGHT, damageListControl, TOPRIGHT)

    -- second row
    local damageListSummaryHeight = sw.damageListHeaderHeight
    if not sv.enableDamageListSummary then damageListSummaryHeight = 0 end
    local damageListHeaderSummaryBackGround = WM:CreateControl(damageListControlName .. "_Summary_BG", damageListControl, CT_TEXTURE)
    damageListHeaderSummaryBackGround:SetColor(0, 0, 0, 0)
    damageListHeaderSummaryBackGround:SetAlpha(0.8)
    damageListHeaderSummaryBackGround:SetHidden(false)
    damageListHeaderSummaryBackGround:SetDimensions(damageListControl:GetWidth(), damageListSummaryHeight)
    damageListHeaderSummaryBackGround:SetAnchor(TOPLEFT, damageListHeaderBackGround, BOTTOMLEFT)

end

local function createDamageListBody()
    local damageListBody = WM:CreateControlFromVirtual(damageListControlName .. "_Body", damageListControl, "ZO_ScrollList")
    damageListBody:SetAnchor(TOPLEFT, damageListControl:GetNamedChild("_Summary_BG"), BOTTOMLEFT)
    damageListBody:SetDimensions(damageListControl:GetWidth() + ZO_SCROLL_BAR_WIDTH, 22 * 12)
    --damageListBody:SetDimensions(damageListControl:GetWidth() + ZO_SCROLL_BAR_WIDTH, sw.damageListRowHeight * 12)
    ZO_ScrollList_SetHideScrollbarOnDisable(damageListBody, true)
    ZO_ScrollList_SetUseScrollbar(damageListBody, false)
    ZO_ScrollList_SetScrollbarEthereal(damageListBody, true)

    local function onRowCreation(rowControl, data, scrollList)
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

    local function onRowReset(scrollList)
        --scrollList:GetNamedChild("Contents")
        --anim.UnregisterUser(userId)
        -- TODO: Reset animation here?
    end

    ZO_ScrollList_AddDataType(
            damageListBody,
            1,
            "HodorReflexes_Dps_DamageRow",
            sw.damageListRowHeight,
            onRowCreation,
            nil,
            nil
            --onRowReset
    )

end

local function createDamageListUI()
    damageListControl = WM:CreateTopLevelWindow(damageListControlName)
    damageListControl:SetClampedToScreen(true)
    damageListControl:SetResizeToFitDescendents(true)
    damageListControl:SetHidden(true)
    --damageListControl:SetMouseEnabled(true) -- TODO: disable after debugging
    --damageListControl:SetMovable(true) -- TODO: disable after debugging
    damageListControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sv.damageListPosLeft, sv.damageListPosTop)
    damageListControl:SetDimensions(227, 22 + (22 * 12))
    --damageListControl:SetDimensions(227, ((sw.damageListHeaderHeight * 2) + (sw.damageListRowHeight * 12)))
    damageListControl:SetHandler( "OnMoveStop", function()
        sv.damageListPosLeft = damageListControl:GetLeft()
        sv.damageListPosTop = damageListControl:GetTop()
    end)

    createDamageListHeader()
    createDamageListBody()
end

local function stopDamageListTimerUpdate()
    EM:UnregisterForUpdate(addon_name .. module_name .. "DamageListTitleUpdate")
end
local function startDamageListTimerUpdate()
    stopDamageListTimerUpdate()
    EM:RegisterForUpdate(addon_name .. module_name .. "DamageListTitleUpdate", sv.damageListHeaderUpdateInterval, updateDamageListTimer)
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
            setFunc = function(value)
                sv.enableDamageList = value or false
            end,
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
            name = "show summary in header",
            tooltip = "show summary in header",
            default = svDefault.enableDamageListSummary,
            getFunc = function() return sv.enableDamageListSummary end,
            setFunc = function(value) sv.enableDamageListSummary = value end,
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
            setFunc = function(value)
                sw.enableColoredNames = value or false
            end,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = GetString(HR_MENU_ICONS_VISIBILITY_DPS),
            tooltip = GetString(HR_MENU_ICONS_VISIBILITY_DPS_TT),
            default = svDefault.enableDamageIcons,
            getFunc = function() return sw.enableDamageIcons end,
            setFunc = function(value)
                sw.enableDamageIcons = value or false
            end,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = GetString(HR_MENU_ICONS_VISIBILITY_ANIM),
            tooltip = GetString(HR_MENU_ICONS_VISIBILITY_ANIM_TT),
            default = svDefault.enableAnimIcons,
            getFunc = function() return sw.enableAnimIcons end,
            setFunc = function(value)
                sw.enableAnimIcons = value or false
            end,
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

    createDamageListUI()
    createSceneFragments()
    refreshVisibility()
    updateDamageListTitle()
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
            classId = zo_random(1, #classIcons), -- 40% chance for necro
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