-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules
local hud = core.hud

local HR_EVENT_LOCKUI = addon.HR_EVENT_LOCKUI
local HR_EVENT_UNLOCKUI = addon.HR_EVENT_UNLOCKUI
local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED
local HR_EVENT_PLAYER_ACTIVATED = addon.HR_EVENT_PLAYER_ACTIVATED
local HR_EVENT_COMBAT_START = addon.HR_EVENT_COMBAT_START
local HR_EVENT_COMBAT_END = addon.HR_EVENT_COMBAT_END

local localPlayer = "player"

local EM = GetEventManager()
local WM = GetWindowManager()

local strformat = string.format
local tinsert = table.insert
local tconcat = table.concat

local player1to12 = "Player1, Player2, Player3, Player4, Player5, Player6, Player7, Player8, Player9, Player10, Player11, Player12"

local moduleDefinition = {
    name = "readycheck",
    friendlyName = GetString(HR_MODULES_READYCHECK_FRIENDLYNAME),
    description = GetString(HR_MODULES_READYCHECK_DESCRIPTION),
    version = "1.0.0",
    priority = 12,
    enabled = false,
    svVersion = 1,
    svDefault = {
        enableUI = true,
        enableChatMessages = true,
        windowCenterX = GuiRoot:GetWidth() / 2,
        windowCenterY = GuiRoot:GetHeight() / 5,
    },

    uiLocked = true,
    isPollActive = false,

    electionUpdateInterval = 200, -- ms

    colorUndecided = "FFFFFF",
    colorAgainst = "FF0000",
    colorFor = "00FF00",
    colorOffline = "FFA500",
}

local module = internal.moduleClass:New(moduleDefinition)

--- Activate the Ready Check module
--- @return void
function module:Activate()
    self.logger:Debug("activated readycheck module")

    self:CreateReadyCheckUI()
    self:refreshVisibility()

    addon.RegisterCallback(HR_EVENT_LOCKUI, function(...) self:lockUI(...) end)
    addon.RegisterCallback(HR_EVENT_UNLOCKUI, function(...) self:unlockUI(...) end)
    addon.RegisterCallback(HR_EVENT_TEST_STARTED, function(...) self:startTest(...) end)
    addon.RegisterCallback(HR_EVENT_TEST_STOPPED, function(...) self:stopTest(...) end)
    addon.RegisterCallback(HR_EVENT_COMBAT_START, function(...) self:refreshVisibility(...) end)
    addon.RegisterCallback(HR_EVENT_COMBAT_END, function(...) self:refreshVisibility(...) end)

    local eventName = addon_name .. self.name
    EM:RegisterForEvent(eventName, EVENT_GROUP_ELECTION_REQUESTED, function(...) self:startElection(...) end) -- when player starts the vote
    EM:RegisterForEvent(eventName, EVENT_GROUP_ELECTION_NOTIFICATION_ADDED, function(...) self:startElection(...) end) -- when someone else start vote
    EM:RegisterForEvent(eventName, EVENT_GROUP_ELECTION_RESULT, function(...) self:groupElectionResult(...) end) -- when vote ended/finished
    EM:RegisterForEvent(eventName, EVENT_GROUP_ELECTION_FAILED, function(...) self:groupElectionFailed(...) end) -- when vote failed for some reason "group dispand" for example

    addon.RegisterCallback(HR_EVENT_PLAYER_ACTIVATED, function(...) self:refreshVisibility(...) end)
end

--- Create the Ready Check UI
--- @return void
function module:CreateReadyCheckUI()
    local readycheckWindowName = addon_name .. self.name

    local readycheckWindow = WM:CreateTopLevelWindow(readycheckWindowName)
    readycheckWindow:SetClampedToScreen(true)
    readycheckWindow:SetResizeToFitDescendents(true)
    readycheckWindow:SetHidden(true)
    readycheckWindow:SetAnchor(CENTER, GuiRoot, TOPLEFT, self.sw.windowCenterX, self.sw.windowCenterY)
    readycheckWindow:SetHandler("OnMoveStop", function()
        self.sw.windowCenterX, self.sw.windowCenterY = readycheckWindow:GetCenter()
        readycheckWindow:ClearAnchors()
        readycheckWindow:SetAnchor(CENTER, GuiRoot, TOPLEFT, self.sw.windowCenterX, self.sw.windowCenterY)
    end)

    local readycheckTitle = WM:CreateControl(readycheckWindowName .. "_Title", readycheckWindow, CT_LABEL)
    readycheckTitle:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    readycheckTitle:SetMouseEnabled(false)
    readycheckTitle:SetAnchor(TOP, readycheckWindow, TOP, 0, 0)
    readycheckTitle:SetText(GetString(HR_MODULES_READYCHECK_TITLE))
    readycheckTitle:SetWidth(600)

    local readycheckList = WM:CreateControl(readycheckWindowName .. "_List", readycheckWindow, CT_LABEL)
    readycheckList:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    readycheckList:SetMouseEnabled(false)
    readycheckList:SetAnchor(TOP, readycheckTitle, BOTTOM, 0, 0)
    readycheckList:SetText(player1to12)
    readycheckList:SetWidth(600)

    if IsConsoleUI() then
        readycheckTitle:SetFont("ZoFontGamepad34")
        readycheckList:SetFont("ZoFontGamepad25")
    else
        readycheckTitle:SetFont("ZoFontWinH1")
        readycheckList:SetFont("ZoFontWinH2")
    end

    self.readycheckWindow = readycheckWindow

    local function readycheckFragmentCondition()
        return self.sw.enableUI and (self.isPollActive or not self.uiLocked) and not IsUnitInCombat(localPlayer)
    end

    self.READYCHECK_FRAGMENT = hud.AddFadeFragment(readycheckWindow, readycheckFragmentCondition)
end

--- Refresh the visibility of the Ready Check UI
--- @return void
function module:refreshVisibility()
    self.READYCHECK_FRAGMENT:Refresh()
end

--- Start a test ready check
--- @return void
function module:startTest()
    local names = {}

    for _, data in pairs(addon.playersData) do
        local color = self.colorUndecided
        local vote = zo_random(0, 100)
        if vote < 20 then
            color = self.colorAgainst
        elseif vote < 80 then
            color = self.colorFor
        end
        tinsert(names, strformat("|c%s%s|r", color, data.userId))
    end

    self.readycheckWindow:GetNamedChild("_List"):SetText(tconcat(names, ", "))
end
--- Stop the test ready check
--- @return void
function module:stopTest()
    self.readycheckWindow:GetNamedChild("_List"):SetText(player1to12)
end
--- Lock the Ready Check UI
--- @return void
function module:lockUI()
    self.uiLocked = true
    hud.LockControls(self.readycheckWindow)
    self:refreshVisibility()
end
--- Unlock the Ready Check UI
--- @return void
function module:unlockUI()
    self.uiLocked = false
    hud.UnlockControls(self.readycheckWindow)
    self:refreshVisibility()
end

--- Start the election ready check
--- @param id number
--- @param descriptor string
--- @return void
function module:startElection(id, descriptor)
    if self.isPollActive then return end

    self.isPollActive = true
    self:refreshVisibility()
    EM:RegisterForUpdate(addon_name .. self.name .. "Update", self.electionUpdateInterval, function(...) self:updateElection(...) end)
end
--- Stop the election ready check
--- @return void
function module:stopElection()
    self.isPollActive = false
    self:refreshVisibility()
    EM:UnregisterForUpdate(addon_name .. self.name .. "Update")
end
--- Update the election ready check UI
--- @return void
function module:updateElection()
    local electionType, timeRemainingSeconds, _, _ = GetGroupElectionInfo()
    if electionType ~= GROUP_ELECTION_TYPE_GENERIC_UNANIMOUS then
        self:stopElection()
        return
    end
    local title = zo_strformat("<<1>> [<<2>>]", GetString(HR_MODULES_READYCHECK_TITLE), ZO_FormatCountdownTimer(timeRemainingSeconds))
    self.readycheckWindow:GetNamedChild("_Title"):SetText(title)

    local names = {}
    for i = 1, GetGroupSize() do
        local unitTag = GetGroupUnitTagByIndex(i)
        if unitTag == nil or unitTag == "nil" then
            return
        end
        if IsUnitOnline(unitTag) then
            local choice = GetGroupElectionVoteByUnitTag(unitTag)
            local userId = GetUnitDisplayName(unitTag)
            local color = self.colorUndecided
            if choice == GROUP_VOTE_CHOICE_FOR then
                color = self.colorFor
            elseif choice == GROUP_VOTE_CHOICE_AGAINST then
                color = self.colorAgainst
            end
            tinsert(names, strformat("|c%s%s|r", color, userId))
        end
    end
    self.readycheckWindow:GetNamedChild("_List"):SetText(tconcat(names, ", "))
end
--- Handle group election failed event
--- @param _ number
--- @param failureReason number
--- @param _ number
--- @return void
function module:groupElectionFailed(_, failureReason, _)
    if failureReason == GROUP_ELECTION_FAILURE_NONE then return end
    if failureReason == GROUP_ELECTION_FAILURE_ANOTHER_IN_PROGRESS then return end
    zo_callLater(function() self:stopElection() end, 2000)
end
--- Handle group election result event
--- @param _ number
--- @param electionResult number
--- @param _ number
--- @return void
function module:groupElectionResult(_, electionResult, _)
    if self.isPollActive then
        if electionResult == GROUP_ELECTION_RESULT_ELECTION_WON then
            self.readycheckWindow:GetNamedChild("_Title"):SetText(GetString(HR_MODULES_READYCHECK_READY))
            if self.sw.enableChatMessages then
                df("|c00FF00%s", GetString(HR_MODULES_READYCHECK_READY))
            end
        else
            self.readycheckWindow:GetNamedChild("_Title"):SetText(GetString(HR_MODULES_READYCHECK_NOT_READY))
            if self.sw.enableChatMessages then
                local g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12 = GetGroupElectionUnreadyUnitTags()
                local unreadyPlayers = { g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12 }
                for _, unitTag in pairs(unreadyPlayers) do
                    if IsUnitOnline(unitTag) then
                        df('|c%s%s %s|r', self.colorAgainst, GetUnitDisplayName(unitTag), GetString(HR_MODULES_READYCHECK_NOT_READY))
                    else
                        df('|c%s%s (OFFLINE)|r', self.colorOffline, GetUnitDisplayName(unitTag))
                    end
                end
            end
        end
    end
    zo_callLater(function() self:stopElection() end, 3500)
end