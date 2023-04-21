local M = HodorReflexes.modules.vote
local LAM = LibAddonMenu2

function M.BuildMenu()

	local panel = HodorReflexes.GetModulePanelConfig(GetString(HR_MENU_VOTE))

	local options = {}
	if HodorReflexes.modules.share.IsEnabled() then
		options = {
			{
				type = "description",
				text = GetString(HR_MENU_VOTE_DESC),
			},
			{
				type = "header",
				name = string.format("|cFFFACD%s|r", GetString(HR_MENU_GENERAL)),
			},
			{
				reference = "HodorReflexesMenu_Vote_enabled",
				type = "checkbox",
				name = function()
					return string.format(M.sv.enabled and "|c00FF00%s|r" or "|cFF0000%s|r", GetString(HR_MENU_GENERAL_ENABLED))
				end,
				tooltip = GetString(HR_MENU_VOTE_ENABLED_TT),
				default = M.default.enabled,
				getFunc = function() return M.sv.enabled end,
				setFunc = function(value)
					M.sv.enabled = value or false
					HodorReflexesMenu_Vote_enabled.label:SetText(string.format(value and "|c00FF00%s|r" or "|cFF0000%s|r", GetString(HR_MENU_GENERAL_ENABLED)))
				end,
				requiresReload = true,
			},
			{
				type = "checkbox",
				name = GetString(HR_MENU_GENERAL_UI_LOCKED),
				tooltip = GetString(HR_MENU_GENERAL_UI_LOCKED_TT),
				getFunc = function() return M.uiLocked end,
				setFunc = function(value)
					if not value then
						M.UnlockUI()
					else
						M.LockUI()
					end
				end
			},
			{
				type = "checkbox",
				name = GetString(HR_MENU_VOTE_CHAT),
				tooltip = GetString(HR_MENU_VOTE_CHAT_TT),
				default = M.default.enableChatMessages,
				getFunc = function() return M.sv.enableChatMessages end,
				setFunc = function(value)
					M.sv.enableChatMessages = value or false
				end,
			},
			{
				type = "slider",
				name = GetString(HR_MENU_VOTE_COUNTDOWN_DURATION),
				min = 3,
				max = 10,
				step = 1,
				decimals = 0,
				clampInput = true,
				default = M.default.pullDuration,
				getFunc = function() return M.sv.countdownDuration end,
				setFunc = function(value)
					M.sv.countdownDuration = value
				end,
			},
			{
				type = "header",
				name = string.format("|cFFFACD%s|r", GetString(HR_MENU_VOTE_ACTIONS)),
			},
			{
				type = "button",
				name = GetString(HR_MENU_VOTE_ACTIONS_RC),
				tooltip = GetString(HR_MENU_VOTE_ACTIONS_RC_TT),
				func = M.SendReadyCheck,
				width = 'half',
			},
			{
				type = "button",
				name = GetString(HR_MENU_VOTE_ACTIONS_COUNTDOWN),
				tooltip = GetString(HR_MENU_VOTE_ACTIONS_COUNTDOWN_TT),
				func = function()
					if IsUnitGroupLeader('player') then
						M.SendPullCountdown()
					else
						LAM.util.ShowConfirmationDialog(GetString(HR_MENU_VOTE_ACTIONS_COUNTDOWN), GetString(HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM), function()
							if M.sv.enableChatMessages then
								d(string.format('|cFF0000%s|r', GetString(HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM)))
							end
						end)
					end
				end,
				width = 'half',
			},
			{
				reference = "HodorReflexesMenu_Vote_LeaderOptions",
				type = "dropdown",
				name = GetString(HR_MENU_VOTE_ACTIONS_LEADER),
				tooltip = GetString(HR_MENU_VOTE_ACTIONS_LEADER_TT),
				getFunc = function() return 'player' end,
				setFunc = function(value)
					LAM.util.ShowConfirmationDialog(GetString(HR_MENU_VOTE_ACTIONS_LEADER), string.format('%s %s?', GetString(HR_MENU_VOTE_ACTIONS_LEADER_CONFIRM), GetUnitDisplayName(value)), function()
						M.BeginLeaderElection(value)
					end)
				end,
				choices = {GetUnitDisplayName('player')},
				choicesValues = {'player'},
			},
		}

		CALLBACK_MANAGER:RegisterCallback("LAM-PanelOpened", function(p)
			if p.data.name == panel.name then
				local tags = {}
				local names = {}
				for i = 1, GetGroupSize() do
					local tag = GetGroupUnitTagByIndex(i)
					if IsUnitOnline(tag) and not AreUnitsEqual('player', tag) and not IsUnitGroupLeader(tag) then
						table.insert(tags, tag)
						table.insert(names, GetUnitDisplayName(tag))
					end
				end
				HodorReflexesMenu_Vote_LeaderOptions:UpdateChoices(names, tags)
			end
		end)
	else
		options =  {
			{
				type = "description",
				text = string.format("|cFF0000%s|r", GetString(HR_MENU_VOTE_DISABLED))
			},
		}
	end

    LAM:RegisterAddonPanel(M.name .. "Menu", panel)
    LAM:RegisterOptionControls(M.name .. "Menu", options)

end