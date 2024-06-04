HodorReflexes.modules.vote = {
	name = "HodorReflexes_Vote",
	version = "1.0.0",

	uiLocked = true,

	default = {
		enabled = true,
		enableChatMessages = true,
		countdownDuration = 5,
	},

	sv = nil, -- saved variables
}

local HR = HodorReflexes
local M = HR.modules.vote
local EM = EVENT_MANAGER
local share = HR.modules.share

local MAIN_FRAGMENT --= nil

local DATA_ELECTION_REQUEST   = 100
--local DATA_ELECTION_ACCEPT    = 101
--local DATA_ELECTION_DECLINE   = 102
local DATA_ELECTION_COUNTDOWN = 105
local DATA_ELECTION_LEADER    = 106
--local DATA_ELECTION_PULL    = 203 .. 210

local isPollActive = false -- is there an active ready check
local isCountdown = false -- is current/next poll is a countdown
local isCountdownActive = false -- is there an active countdown (5, 4, ..., 1)
local pullCooldown = 0 -- prevent countdown spam

local strformat = string.format
local tinsert = table.insert
local tconcat = table.concat

local units = HR.units

local countdownButton = {
	name = GetString(HR_COUNTDOWN),
	keybind = 'HR_VOTE_PULL',
	callback = function() M.SendPullCountdown() end,
	alignment = KEYBIND_STRIP_ALIGN_CENTER,
}

-- Callback for custom data from share module.
local function HandleCustomData(tag, data)
	local name = units.GetDisplayName(tag)
	if not name then return end
	-- Ready check
	if data == DATA_ELECTION_REQUEST then
		isCountdown = false
		if M.sv.enableChatMessages then
			d(strformat('|c00FFFF%s %s|r', name, GetString(HR_READY_CHECK_INIT_CHAT)))
		end
		-- Countdown
	elseif data == DATA_ELECTION_COUNTDOWN then
		if IsUnitGroupLeader(tag) then
			isCountdown = true
			if M.sv.enableChatMessages then
				d(strformat('|c00FFFF%s %s|r', name, GetString(HR_COUNTDOWN_INIT_CHAT)))
			end
		end
	elseif data == DATA_ELECTION_LEADER then
		if M.sv.enableChatMessages then
			d(strformat('|c00FFFF%s %s|r', name, GetString(HR_VOTE_LEADER_CHAT)))
		end
	elseif data >= 203 and data <= 210 then
		if IsUnitGroupLeader(tag) then
			if M.sv.enableChatMessages then
				d(strformat('|cf76bc1%s: %s|r', GetString(HR_COUNTDOWN_START), data - 200))
			end
			M.StartPullCountdown(data - 200)
		end
	end

end
-- /////////////////////////////////////////////////////////////////////////////
--GROUP_ELECTION_TYPE_GENERIC_SIMPLEMAJORITY = 0,    GROUP_ELECTION_TYPE_GENERIC_SUPERMAJORITY = 1,    GROUP_ELECTION_TYPE_GENERIC_UNANIMOUS = 2,    GROUP_ELECTION_TYPE_KICK_MEMBER = 3,    GROUP_ELECTION_TYPE_NEW_LEADER = 4
local function UpdateElection()
	local electionType, timeRemainingSeconds, electionDescriptor, targetUnitTag = GetGroupElectionInfo()
	local TimerInfo = zo_strformat("<<1>> [<<2>>]", GetString(HR_READY_CHECK), ZO_FormatCountdownTimer(timeRemainingSeconds))
	if targetUnitTag ~= nil then
		if electionType == GROUP_ELECTION_TYPE_KICK_MEMBER then
			TimerInfo = zo_strformat(" Kick Player [<<1>>] [<<2>>]", GetUnitDisplayName(targetUnitTag), ZO_FormatCountdownTimer(timeRemainingSeconds))
		elseif	electionType == GROUP_ELECTION_TYPE_NEW_LEADER then
			TimerInfo = zo_strformat(" New Leader [<<1>>] [<<2>>]", GetUnitDisplayName(targetUnitTag), ZO_FormatCountdownTimer(timeRemainingSeconds))
		end
	end
	HodorReflexes_Vote_Main_Title:SetText(TimerInfo)
	local names = {}
	for GRI = 1, GetGroupSize() do
		local unitTag = GetGroupUnitTagByIndex(GRI)
		if unitTag == nil or unitTag == "nil" then return end
		local choice = GetGroupElectionVoteByUnitTag(unitTag)
		if IsUnitOnline(unitTag) then
			local name = units.GetDisplayName(unitTag)
			local color = 'FFFFFF' -- didn't vote
			if choice == GROUP_VOTE_CHOICE_FOR then
				color = '00FF00'
			elseif choice == GROUP_VOTE_CHOICE_AGAINST then
				color = 'FF0000'
			end
			tinsert(names, strformat('|c%s%s|r', color, HR.player.GetAliasForUserId(name, false)))
		end
	end
	HodorReflexes_Vote_Main_List:SetText(tconcat(names, ', '))
end
-- /////////////////////////////////////////////////////////////////////////////
local bStarted = false
local function StartElection()
	if not bStarted then
		bStarted = true
		if isCountdownActive then M.StopCountdown() end
		isPollActive = true
		HodorReflexes_Vote_Main_Title:SetText(GetString(HR_READY_CHECK))
		M.RefreshVisibility()
		EVENT_MANAGER:RegisterForUpdate(M.name.."UpdateElection", 200, UpdateElection)
	end
end
local function StopElection()
	bStarted = false
	EVENT_MANAGER:UnregisterForUpdate(M.name.."UpdateElection")
	isPollActive = false
	M.RefreshVisibility()
end
-- /////////////////////////////////////////////////////////////////////////////
local function GroupElectionFailed(eventCode, failureReason, descriptor)
	--d("GroupElectionFailed: failureReason["..failureReason.."] descriptor["..descriptor.."]")
	if failureReason == GROUP_ELECTION_FAILURE_NONE then return end
	if failureReason == GROUP_ELECTION_FAILURE_ANOTHER_IN_PROGRESS then return end
	zo_callLater(function() StopElection() end, 2000)
end
-- /////////////////////////////////////////////////////////////////////////////
local function GroupElectionResult(eventCode, electionResult, descriptor)
	if isPollActive then
		if electionResult == GROUP_ELECTION_RESULT_ELECTION_WON then
			HodorReflexes_Vote_Main_Title:SetText(GetString(HR_READY_CHECK_READY))
			if M.sv.enableChatMessages then d(strformat('|c00FF00%s|r', GetString(HR_READY_CHECK_READY))) end
			M.StartCountdown(5, isCountdown)
		else -- electionResult == GROUP_ELECTION_RESULT_ELECTION_LOST then
			M.StartCountdown(5, false)
			if M.sv.enableChatMessages then
				local g1, g2, g3, g4, g5, g6, g7, g8 = GetGroupElectionUnreadyUnitTags()
				local unreadyPlayers = { g1, g2, g3, g4, g5, g6, g7, g8 }
				for id, group_tag in pairs(unreadyPlayers) do
					if IsUnitOnline(group_tag) then
						CHAT_ROUTER:AddSystemMessage(strformat('|cFF0000%s %s|r', units.GetDisplayName(group_tag), GetString(HR_VOTE_NOT_READY_CHAT)))
					else
						CHAT_ROUTER:AddSystemMessage(zo_strformat("|cFFA500<<1>> (OFFLINE)|r", GetUnitDisplayName(group_tag)))
					end
				end
			end
		end
	end
	zo_callLater(function() StopElection() end, 3500) -- new
	isCountdown = false -- make sure next ready check is not a countdown
end
-- /////////////////////////////////////////////////////////////////////////////
function M.Initialize()
	-- This module relies on the "share" module
	if not share then return end

	-- Retrieve savedVariables
	M.sv = ZO_SavedVars:NewAccountWide(HR.svName, HR.svVersion, 'vote', M.default)

	-- Bindings
	ZO_CreateStringId('SI_BINDING_NAME_HR_VOTE_PULL', GetString(HR_BINDING_COUNTDOWN))

	-- Build settings menu
	M.BuildMenu()

	-- Restore control positions
	M.RestorePosition()

	-- Create scene fragment for main control
	MAIN_FRAGMENT = HR.hud.AddFadeFragment(HodorReflexes_Vote_Main)

	local function OnStateChanged(oldState, newState)
		if newState == SCENE_FRAGMENT_SHOWING and IsUnitGroupLeader('player') then
			KEYBIND_STRIP:AddKeybindButton(countdownButton)
		elseif newState == SCENE_FRAGMENT_HIDING then
			KEYBIND_STRIP:RemoveKeybindButton(countdownButton)
		end
	end

	if M.IsEnabled() then
		-- Register callback for custom data
		share.RegisterCustomDataCallback(HandleCustomData)
		-- Election events
		-- when you start vote
		EVENT_MANAGER:RegisterForEvent(M.name, EVENT_GROUP_ELECTION_REQUESTED, function(_, descriptor)
			if share.SendCustomData(isCountdown and DATA_ELECTION_COUNTDOWN or DATA_ELECTION_REQUEST, true) then
				StartElection()
			end
		end)
		-- when someone else start vote
		EVENT_MANAGER:RegisterForEvent(M.name, EVENT_GROUP_ELECTION_NOTIFICATION_ADDED, function(...) StartElection() end)
		-- when voted endet/finished
		EVENT_MANAGER:RegisterForEvent(M.name, EVENT_GROUP_ELECTION_RESULT, GroupElectionResult)
		-- when vote failed for some reason "group dispand" for example
		EVENT_MANAGER:RegisterForEvent(M.name, EVENT_GROUP_ELECTION_FAILED, GroupElectionFailed)

		-- Add hotkey to group window
		KEYBOARD_GROUP_MENU_SCENE:RegisterCallback('StateChange', OnStateChanged)
		GAMEPAD_GROUP_SCENE:RegisterCallback('StateChange', OnStateChanged)
	end
	HR.RegisterCallback(HR_EVENT_PLAYER_ACTIVATED, function() M.RefreshVisibility() end)
end

function M.IsEnabled()
	return HodorReflexes.modules.share.IsEnabled() and M.sv.enabled
end
function M.RefreshVisibility()
	MAIN_FRAGMENT:SetHiddenForReason('hidden', not isPollActive and not isCountdownActive and M.uiLocked)
end
function M.SendReadyCheck()
	isCountdown = false
	ZO_SendReadyCheck()
end
function M.SendCountdown()
	if IsUnitGroupLeader('player') then
		isCountdown = true
		ZO_SendReadyCheck()
	end
end
function M.StartCountdown(count, showCountdown)
	isCountdownActive = true
	M.RefreshVisibility()
	EM:UnregisterForUpdate(M.name .. "Countdown")
	EM:RegisterForUpdate(M.name .. "Countdown", 1000, function()
		if showCountdown then
			HodorReflexes_Vote_Main_Title:SetText(strformat('%s |cFFFF00%d|r', GetString(HR_COUNTDOWN_START), count))
			PlaySound(count == 0 and SOUNDS.DUEL_START or SOUNDS.COUNTDOWN_TICK)
		end
		count = count - 1
		if count < 0 then M.StopCountdown() end
	end)
end
function M.StopCountdown()
	isCountdownActive = false
	EM:UnregisterForUpdate(M.name .. "Countdown")
	M.RefreshVisibility()
end
function M.SendPullCountdown(duration)
	if not IsUnitGroupLeader('player') then
		d(string.format('|cFF0000%s|r', GetString(HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM)))
		return
	end
	if not duration then duration = tonumber(M.sv.countdownDuration) or 5 end
	if duration >= 3 and duration <= 10 then
		local t = GetGameTimeMilliseconds()
		if t - pullCooldown > 2500 then
			pullCooldown = t
			share.SendCustomData(200 + duration, true)
			M.StartPullCountdown(duration)
		else
			PlaySound(SOUNDS.ABILITY_NOT_ENOUGH_STAMINA)
		end
	end
end
function M.StartPullCountdown(duration)
	if duration and duration >= 3 and duration <= 10 then
		local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_COUNTDOWN_TEXT, SOUNDS.DUEL_START)
		messageParams:SetLifespanMS(duration * 1000)
		messageParams:SetIconData("EsoUI/Art/HUD/HUD_Countdown_Badge_Dueling.dds")
		messageParams:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_COUNTDOWN)
		CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
	end
end
function M.BeginLeaderElection(tag)
	share.SendCustomData(DATA_ELECTION_LEADER)
	BeginGroupElection(GROUP_ELECTION_TYPE_NEW_LEADER, '', tag)
end
function M.UnlockUI()
	M.uiLocked = false
	M.RefreshVisibility()
end
function M.LockUI()
	M.uiLocked = true
	M.RefreshVisibility()
end
function M.RestorePosition()
	local mainCenterX = M.sv.mainCenterX
	local mainCenterY = M.sv.mainCenterY
	if mainCenterX or mainCenterY then
		HodorReflexes_Vote_Main:ClearAnchors()
		HodorReflexes_Vote_Main:SetAnchor(CENTER, GuiRoot, TOPLEFT, mainCenterX, mainCenterY)
	end
end
function M.MainOnMoveStop()
	M.sv.mainCenterX, M.sv.mainCenterY = HodorReflexes_Vote_Main:GetCenter()
	HodorReflexes_Vote_Main:ClearAnchors()
	HodorReflexes_Vote_Main:SetAnchor(CENTER, GuiRoot, TOPLEFT, M.sv.mainCenterX, M.sv.mainCenterY)
end

SLASH_COMMANDS["/pull"] = function(duration)
	M.SendPullCountdown(tonumber(duration))
end