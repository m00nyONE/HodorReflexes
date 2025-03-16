HodorReflexes.modules.vote = {
	name = "HodorReflexes_Vote",
	version = "1.0.0",

	uiLocked = true,

	default = {
		enabled = true,
		enableChatMessages = true,
		--countdownDuration = 5,
	},

	sv = nil, -- saved variables
}

local HR = HodorReflexes
local M = HR.modules.vote
local EM = EVENT_MANAGER
--local share = HR.modules.share
--local LGB = LibGroupBroadcast

local MAIN_FRAGMENT --= nil

local isPollActive = false -- is there an active ready check

local strformat = string.format
local tinsert = table.insert
local tconcat = table.concat

-- /////////////////////////////////////////////////////////////////////////////
--GROUP_ELECTION_TYPE_GENERIC_SIMPLEMAJORITY = 0,    GROUP_ELECTION_TYPE_GENERIC_SUPERMAJORITY = 1,    GROUP_ELECTION_TYPE_GENERIC_UNANIMOUS = 2,    GROUP_ELECTION_TYPE_KICK_MEMBER = 3,    GROUP_ELECTION_TYPE_NEW_LEADER = 4
local function UpdateElection()
	local electionType, timeRemainingSeconds, electionDescriptor, targetUnitTag = GetGroupElectionInfo()
	local TimerInfo = zo_strformat("<<1>> [<<2>>]", GetString(HR_READY_CHECK), ZO_FormatCountdownTimer(timeRemainingSeconds))
	if targetUnitTag ~= nil then
		if electionType == GROUP_ELECTION_TYPE_KICK_MEMBER then
			TimerInfo = zo_strformat(" Kick Player [<<1>>] [<<2>>]", GetUnitDisplayName(targetUnitTag), ZO_FormatCountdownTimer(timeRemainingSeconds))
		elseif electionType == GROUP_ELECTION_TYPE_NEW_LEADER then
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
			local name = GetUnitDisplayName(unitTag)
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
		else -- electionResult == GROUP_ELECTION_RESULT_ELECTION_LOST then
			if M.sv.enableChatMessages then
				local g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12 = GetGroupElectionUnreadyUnitTags()
				local unreadyPlayers = { g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12 }
				for _, group_tag in pairs(unreadyPlayers) do
					if IsUnitOnline(group_tag) then
						CHAT_ROUTER:AddSystemMessage(zo_strformat('|cFF0000<<1>> <<2>>|r', GetUnitDisplayName(group_tag), GetString(HR_VOTE_NOT_READY_CHAT)))
					else
						CHAT_ROUTER:AddSystemMessage(zo_strformat("|cFFA500<<1>> (OFFLINE)|r", GetUnitDisplayName(group_tag)))
					end
				end
			end
		end
	end
	zo_callLater(function() StopElection() end, 3500) -- new
end
-- /////////////////////////////////////////////////////////////////////////////
function M.Initialize()
	-- Retrieve savedVariables
	M.sv = ZO_SavedVars:NewAccountWide(HR.svName, HR.svVersion, 'vote', M.default)

	-- Build settings menu
	M.BuildMenu()

	-- Restore control positions
	M.RestorePosition()

	-- Create scene fragment for main control
	MAIN_FRAGMENT = HR.hud.AddFadeFragment(HodorReflexes_Vote_Main)

	EVENT_MANAGER:RegisterForEvent(M.name, EVENT_GROUP_ELECTION_REQUESTED, function(_, descriptor)
		StartElection()
	end)
	-- when someone else start vote
	EVENT_MANAGER:RegisterForEvent(M.name, EVENT_GROUP_ELECTION_NOTIFICATION_ADDED, function(...) StartElection() end)
	-- when voted ended/finished
	EVENT_MANAGER:RegisterForEvent(M.name, EVENT_GROUP_ELECTION_RESULT, GroupElectionResult)
	-- when vote failed for some reason "group dispand" for example
	EVENT_MANAGER:RegisterForEvent(M.name, EVENT_GROUP_ELECTION_FAILED, GroupElectionFailed)

	HR.RegisterCallback(HR_EVENT_PLAYER_ACTIVATED, function() M.RefreshVisibility() end)
end


function M.RefreshVisibility()
	MAIN_FRAGMENT:SetHiddenForReason('hidden', not isPollActive and M.uiLocked)
end

function M.BeginLeaderElection(tag)
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
