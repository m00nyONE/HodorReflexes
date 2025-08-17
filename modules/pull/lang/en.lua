local strings = {
    HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM = "You must be a group leader to initiate a countdown!",
    HR_PULL_COUNTDOWN = "Pull Countdown",
    HR_BINDING_PULL_COUNTDOWN = "Pull Countdown",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end