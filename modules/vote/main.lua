HodorReflexes.modules.vote = {
	name = "HodorReflexes_Vote",
	version = "0.1.0",

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
--local WM = GetWindowManager()
local EM = EVENT_MANAGER
local share = HR.modules.share

local MAIN_FRAGMENT --= nil

local DATA_ELECTION_REQUEST   = 100
local DATA_ELECTION_ACCEPT    = 101
local DATA_ELECTION_DECLINE   = 102
local DATA_ELECTION_COUNTDOWN = 105
local DATA_ELECTION_LEADER    = 106
--local DATA_ELECTION_PULL    = 203 .. 210

local isPollActive = false -- is there an active ready check
local isCountdown = false -- is current/next poll is a countdown
local isCountdownActive = false -- is there an active countdown (5, 4, ..., 1)
local pollEndTime = 0 -- poll end time
local players = {} -- players in the current polling list
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

local function StopPoll()
	isPollActive = false
	pollEndTime = 0
	M.RefreshVisibility()
	EM:UnregisterForUpdate(M.name .. "Run")
end

local function StartPoll(owner)
	if isCountdownActive then M.StopCountdown() end
	players = {} -- clear previous votes
	if owner then players[owner] = true end -- owner is ready
	isPollActive = true
	M.UpdatePlayers()
	HodorReflexes_Vote_Main_Title:SetText(GetString(HR_READY_CHECK))
	M.RefreshVisibility()
	-- Stop the poll after 10 seconds
	pollEndTime = GetFrameTimeSeconds() + 10
	EM:UnregisterForUpdate(M.name .. "Run")
	EM:RegisterForUpdate(M.name .. "Run", 1000, function()
		if GetFrameTimeSeconds() >= pollEndTime then
			if HasPendingGroupElectionVote() then CastGroupVote(GROUP_VOTE_CHOICE_AGAINST) end -- auto vote
			StopPoll()
		end
	end)
end

-- Delay poll end time by s seconds (5 by default), if it ends in less than s seconds.
local function DelayPollEndTime(s)
	s = s or 5
	local t = GetFrameTimeSeconds()
	if pollEndTime < t + s then pollEndTime = t + s end
end

local function SendReady(isReady)
	local name = units.GetDisplayName('player')
	if isPollActive and share.SendCustomData(isReady and DATA_ELECTION_ACCEPT or DATA_ELECTION_DECLINE) then
		players[name] = isReady
		M.UpdatePlayers()
	end
end

local function SetEveryoneReady()
	for i = 1, GetGroupSize() do
		local tag = GetGroupUnitTagByIndex(i)
		if units.IsOnline(tag) then
			players[units.GetDisplayName(tag)] = true
		end
	end
	HodorReflexes_Vote_Main_Title:SetText(GetString(HR_READY_CHECK_READY))
	M.UpdatePlayers()
end

-- Callback for custom data from share module.
local function HandleCustomData(tag, data)

	local name = units.GetDisplayName(tag)
	if not name then return end

	-- Ready check
	if data == DATA_ELECTION_REQUEST then
		isCountdown = false
		StartPoll()
		players[name] = true
		M.UpdatePlayers()
		if M.sv.enableChatMessages then
			d(strformat('|c00FFFF%s %s|r', name, GetString(HR_READY_CHECK_INIT_CHAT)))
		end
	-- Countdown
	elseif data == DATA_ELECTION_COUNTDOWN then
		if IsUnitGroupLeader(tag) then
			isCountdown = true
			StartPoll()
			players[name] = true
			M.UpdatePlayers()
			if M.sv.enableChatMessages then
				d(strformat('|c00FFFF%s %s|r', name, GetString(HR_COUNTDOWN_INIT_CHAT)))
			end
		else
			-- haxor!
		end
	-- Accepted
	elseif data == DATA_ELECTION_ACCEPT then
		if isPollActive then DelayPollEndTime() end -- wait 5 more seconds after each accept
		players[name] = true
		M.UpdatePlayers()
	-- Declined
	elseif data == DATA_ELECTION_DECLINE then
		players[name] = false
		M.UpdatePlayers()
		if M.sv.enableChatMessages then
			d(strformat('|cFF0000%s %s|r', name, GetString(HR_VOTE_NOT_READY_CHAT)))
		end
	elseif data == DATA_ELECTION_LEADER then
		if M.sv.enableChatMessages then
			d(strformat('|c00FFFF%s %s|r', name, GetString(HR_VOTE_LEADER_CHAT)))
		end
	elseif data >= 203 and data <= 210 then
		if IsUnitGroupLeader(tag) then
			d(strformat('|cf76bc1%s: %s|r', GetString(HR_COUNTDOWN_START), data - 200))
			M.StartPullCountdown(data - 200)
		end
	end

end

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
		-- Need to override CastGroupVote(), because there are no events for accepting/declining a group election
		local vote = CastGroupVote
		CastGroupVote = function(choice)
			local electionType, _, descriptor = GetGroupElectionInfo()
			if isPollActive and descriptor == ZO_GROUP_ELECTION_DESCRIPTORS.READY_CHECK then
				if choice == GROUP_VOTE_CHOICE_FOR then DelayPollEndTime() end -- wait 5 more seconds after positive vote
				SendReady(choice == GROUP_VOTE_CHOICE_FOR)
			end
			vote(choice)
		end
		-- Election events
		EM:RegisterForEvent(M.name, EVENT_GROUP_ELECTION_REQUESTED, function(_, descriptor) -- ready check initiated by this player
			if descriptor == ZO_GROUP_ELECTION_DESCRIPTORS.READY_CHECK then
				-- sending ping instantly should guarantee that other players will receive it before voting
				if share.SendCustomData(isCountdown and DATA_ELECTION_COUNTDOWN or DATA_ELECTION_REQUEST, true) then
					StartPoll(units.GetDisplayName('player'))
				end
			end
		end)
		EM:RegisterForEvent(M.name, EVENT_GROUP_ELECTION_RESULT, function(_, resultType, descriptor) -- ready check has ended
			if isPollActive and descriptor == ZO_GROUP_ELECTION_DESCRIPTORS.READY_CHECK then
				resultType = ZO_GetSimplifiedGroupElectionResultType(resultType)
				if resultType == GROUP_ELECTION_RESULT_ELECTION_WON then
					SetEveryoneReady()
					if M.sv.enableChatMessages then d(strformat('|c00FF00%s|r', GetString(HR_READY_CHECK_READY))) end
					M.StartCountdown(5, isCountdown)
				else
					M.StartCountdown(5, false)
				end
			end
			StopPoll()
			isCountdown = false -- make sure next ready check is not a countdown
		end)
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

function M.UpdatePlayers()

	local names = {}
	for i = 1, GetGroupSize() do
		local tag = GetGroupUnitTagByIndex(i)
		if IsUnitOnline(tag) then
			local name = units.GetDisplayName(tag)
			local color = 'FFFFFF' -- didn't vote
			if players[name] == true then -- voted Yes
				color = '00FF00'
			elseif players[name] == false then -- voted No
				color = 'FF0000'
			end
			tinsert(names, strformat('|c%s%s|r', color, HR.player.GetAliasForUserId(name, false)))
		end
	end
	HodorReflexes_Vote_Main_List:SetText(tconcat(names, ', '))

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

SLASH_COMMANDS["/hodor.vote"] = function(str)
	if str == '1' or str == 'yes' then
		SendReady(true)
	elseif str == '0' or str == 'no' then
		SendReady(false)
	end
end

SLASH_COMMANDS["/pull"] = function(duration)
	M.SendPullCountdown(tonumber(duration))
end