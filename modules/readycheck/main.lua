local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local module = {
    name = "readycheck",
    friendlyName = "Ready Check",
    description = "This module enhances the group ready check",
    version = "1.0.0",
    priority = 99,
    enabled = false,
}

local module_name = module.name
local module_version = module.version

local sv = nil
local svName = addon.svName
local svVersion = addon.svVersion
local svDefault = {
    enableChatMessages = true,
    readycheckWindowPosLeft = 200,
    readycheckWindowPosTop = 200,
}

local EM = EVENT_MANAGER
local WM = WINDOW_MANAGER
local localPlayer = "player"

local hud = addon.hud
local group = addon.group

local playersData = group.playersData

local HR_EVENT_LOCKUI = addon.HR_EVENT_LOCKUI
local HR_EVENT_UNLOCKUI = addon.HR_EVENT_UNLOCKUI
local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED

local READYCHECK_FRAGMENT
local readycheckWindow = {}
local readycheckWindowName = addon_name .. module_name
local readycheckTitle = {}
local readycheckList = {}

local uiLocked = true
local isPollActive = false

local strformat = string.format
local tinsert = table.insert
local tconcat = table.concat

local function refreshVisibility()
    READYCHECK_FRAGMENT:Refresh()
end

local function lockUI()
    uiLocked = true
    hud.LockControls(readycheckWindow)
    refreshVisibility()
end

local function unlockUI()
    uiLocked = false
    hud.UnlockControls(readycheckWindow)
    refreshVisibility()
end

local function createReadyCheckUI()
    readycheckWindow = WM:CreateTopLevelWindow(readycheckWindowName)
    readycheckWindow:SetClampedToScreen(true)
    readycheckWindow:SetResizeToFitDescendents(true)
    readycheckWindow:SetHidden(true)
    readycheckWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sv.readycheckWindowPosLeft, sv.readycheckWindowPosTop)
    readycheckWindow:SetHandler("OnMoveStop", function()
        sv.readycheckWindowPosLeft = readycheckWindow:GetLeft()
        sv.readycheckWindowPosTop = readycheckWindow:GetTop()
    end)

    readycheckTitle = WM:CreateControl(readycheckWindowName .. "_Title", readycheckWindow, CT_LABEL)
    readycheckTitle:SetFont("ZoFontWinH1")
    readycheckTitle:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    readycheckTitle:SetMouseEnabled(false)
    readycheckTitle:SetAnchor(TOP, readycheckWindow, TOP, 0, 0)
    readycheckTitle:SetText(GetString(HR_READY_CHECK))
    readycheckTitle:SetWidth(600)

    readycheckList = WM:CreateControl(readycheckWindowName .. "_List", readycheckWindow, CT_LABEL)
    readycheckList:SetFont("ZoFontWinH2")
    readycheckList:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    readycheckList:SetMouseEnabled(false)
    readycheckList:SetAnchor(TOP, readycheckTitle, BOTTOM, 0, 0)
    readycheckList:SetText("Player1, Player2, Player3, Player4, Player5, Player6, Player7, Player8, Player9, Player10, Player11, Player12")
    readycheckList:SetWidth(600)
end
local function createSceneFragment()
    local function readycheckFragmentCondition()
        return isPollActive or not uiLocked
    end

    READYCHECK_FRAGMENT = hud.AddFadeFragment(readycheckWindow, readycheckFragmentCondition)
end

local function stopElection()
    isPollActive = false
    refreshVisibility()
    EM:UnregisterForUpdate("HR_ReadyCheck_Update")
end

local function updateElection()
    local electionType, timeRemainingSeconds, _, _ = GetGroupElectionInfo()
    if electionType ~= GROUP_ELECTION_TYPE_GENERIC_UNANIMOUS then stopElection() return end
    local title = zo_strformat("<<1>> [<<2>>]", GetString(HR_READY_CHECK), ZO_FormatCountdownTimer(timeRemainingSeconds))
    readycheckTitle:SetText(title)

    local names = {}
    for i = 1, GetGroupSize() do
        local unitTag = GetGroupUnitTagByIndex(i)
        if unitTag == nil or unitTag == "nil" then return end
        if IsUnitOnline(unitTag) then
            local choice = GetGroupElectionVoteByUnitTag(unitTag)
            local userId = GetUnitDisplayName(unitTag)
            local color = "FFFFFF"
            if choice == GROUP_VOTE_CHOICE_FOR then
                color = "00FF00"
            elseif choice == GROUP_VOTE_CHOICE_AGAINST then
                color = "FF0000"
            end
            tinsert(names, strformat("|c%s%s|r", color, userId))
        end
    end
    readycheckList:SetText(tconcat(names, ", "))
end

local function startElection(id, descriptor)
    d(id, descriptor)
    --if descriptor ~= ZO_READY_CHECK then return end
    if isPollActive then return end
    isPollActive = true
    refreshVisibility()
    EM:RegisterForUpdate("HR_ReadyCheck_Update", 200, updateElection)
end

local function groupElectionResult(_, electionResult, _)
    if isPollActive then
        if electionResult == GROUP_ELECTION_RESULT_ELECTION_WON then
            readycheckTitle:SetText(GetString(HR_READY_CHECK_READY))
            if sv.enableChatMessages then d(strformat("|c00FF00%s", GetString(HR_READY_CHECK_READY))) end
        else
            if sv.enableChatMessages then
                local g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12 = GetGroupElectionUnreadyUnitTags()
                local unreadyPlayers = { g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12 }
                for _, unitTag in pairs(unreadyPlayers) do
                    if IsUnitOnline(unitTag) then
                        CHAT_ROUTER:AddSystemMessage(zo_strformat('|cFF0000<<1>> <<2>>|r', GetUnitDisplayName(unitTag), GetString(HR_VOTE_NOT_READY_CHAT)))
                    else
                        CHAT_ROUTER:AddSystemMessage(zo_strformat("|cFFA500<<1>> (OFFLINE)|r", GetUnitDisplayName(unitTag)))
                    end
                end
            end
        end
    end
    zo_callLater(function() stopElection() end, 3500)
end

local function groupElectionFailed(_, failureReason, descriptor)
    if failureReason == GROUP_ELECTION_FAILURE_NONE then return end
    if failureReason == GROUP_ELECTION_FAILURE_ANOTHER_IN_PROGRESS then return end
    zo_callLater(function() stopElection() end, 2000)
end

local function startTest()
    local names = {}

    for _, data in pairs(playersData) do
        local color = "00FF00"
        local vote = zo_random(0, 100)
        if vote < 20 then
            color = "FF0000"
        end
        tinsert(names, strformat("|c%s%s|r", color, data.userId))
    end

    readycheckList:SetText(tconcat(names, ", "))
end
local function stopTest()
    readycheckList:SetText("")
end

-- initialization functions

function module:MainMenuOptions()
    return {
        {
            type = "checkbox",
            name = GetString(HR_MENU_GENERAL_UI_LOCKED),
            tooltip = GetString(HR_MENU_GENERAL_UI_LOCKED_TT),
            getFunc = function() return uiLocked end,
            setFunc = function(value)
                if not value then unlockUI() else lockUI() end
            end
        },
        {
            type = "checkbox",
            name = GetString(HR_MENU_VOTE_CHAT),
            tooltip = GetString(HR_MENU_VOTE_CHAT_TT),
            default = svDefault.enableChatMessages,
            getFunc = function() return sv.enableChatMessages end,
            setFunc = function(value) sv.enableChatMessages = value end,
        },
    }
end

function module:Initialize()
    sv = ZO_SavedVars:NewAccountWide(svName, svVersion, module_name, svDefault)

    addon.RegisterCallback(HR_EVENT_LOCKUI, lockUI)
    addon.RegisterCallback(HR_EVENT_UNLOCKUI, unlockUI)
    addon.RegisterCallback(HR_EVENT_TEST_STARTED, startTest)
    addon.RegisterCallback(HR_EVENT_TEST_STOPPED, stopTest)

    createReadyCheckUI()
    createSceneFragment()

    refreshVisibility()

    local eventName = addon_name .. module_name
    EM:RegisterForEvent(eventName, EVENT_GROUP_ELECTION_REQUESTED, startElection ) -- when player starts the vote
    EM:RegisterForEvent(eventName, EVENT_GROUP_ELECTION_NOTIFICATION_ADDED, startElection) -- when someone else start vote
    EM:RegisterForEvent(eventName, EVENT_GROUP_ELECTION_RESULT, groupElectionResult) -- when vote ended/finished
    EM:RegisterForEvent(eventName, EVENT_GROUP_ELECTION_FAILED, groupElectionFailed) -- when vote failed for some reason "group dispand" for example

    EM:RegisterForEvent(eventName, EVENT_PLAYER_ACTIVATED, refreshVisibility)
end

addon:RegisterModule(module_name, module)