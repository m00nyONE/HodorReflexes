-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_EXITINSTANCE_FRIENDLYNAME = "Exit Instance",
    HR_MODULES_EXITINSTANCE_DESCRIPTION = "Allows you to send exit instance requests to your group.",
    HR_MODULES_EXITINSTANCE_BINDING_SENDEJECT = "Eject Group",
    HR_MODULES_EXITINSTANCE_BINDING_EXITINSTANCE = "Exit Instance Immediately",
    HR_MODULES_EXITINSTANCE_COMMAND_HELP = "Sends a request to your group to exit the current instance.",
    HR_MODULES_EXITINSTANCE_NOT_LEADER = "You must be a group leader to initiate an ExitInstance request!",
    HR_MODULES_EXITINSTANCE_SENDEXITINSTANCE_DIALOG_TITLE = "Eject Group",
    HR_MODULES_EXITINSTANCE_SENDEXITINSTANCE_DIALOG_TEXT = "Do you want everyone to leave the instance (including yourself)?",
    HR_MODULES_EXITINSTANCE_EXITINSTANCE_DIALOG_TITLE = "Exit Instance",
    HR_MODULES_EXITINSTANCE_EXITINSTANCE_DIALOG_TEXT = "Do you want to leave the instance immediately?",
    HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT = "Confirm Exit",
    HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT_TT = "If enabled, you will be asked to confirm before exiting the instance.",
    HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS = "Ignore Requests",
    HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS_TT = "If enabled, you will ignore all exit instance requests from your group leader.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end