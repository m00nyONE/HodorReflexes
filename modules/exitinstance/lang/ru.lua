-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_EXITINSTANCE_FRIENDLYNAME = "Exit Instance",
    HR_MODULES_EXITINSTANCE_DESCRIPTION = "Позволяет отправлять запросы на выход из локации вашей группе.",
    HR_MODULES_EXITINSTANCE_BINDING_SENDEJECT = "Выгнать группу",
    HR_MODULES_EXITINSTANCE_BINDING_EXITINSTANCE = "Немедленно выйти из локации",
    HR_MODULES_EXITINSTANCE_COMMAND_HELP = "Отправляет вашей группе запрос на выход из текущей локации.",
    HR_MODULES_EXITINSTANCE_NOT_LEADER = "Вы должны быть лидером группы, чтобы инициировать запрос на выход из локации!",
    HR_MODULES_EXITINSTANCE_SENDEXITINSTANCE_DIALOG_TITLE = "Выгнать группу",
    HR_MODULES_EXITINSTANCE_SENDEXITINSTANCE_DIALOG_TEXT = "Вы хотите, чтобы все покинули локацию (включая вас)?",
    HR_MODULES_EXITINSTANCE_EXITINSTANCE_DIALOG_TITLE = "Выход из локации",
    HR_MODULES_EXITINSTANCE_EXITINSTANCE_DIALOG_TEXT = "Вы хотите немедленно покинуть локацию?",
    HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT = "Подтверждать выход",
    HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT_TT = "Если включено, перед выходом из локации будет запрашиваться подтверждение.",
    HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS = "Игнорировать запросы",
    HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS_TT = "Если включено, вы будете игнорировать все запросы на выход из локации от лидера вашей группы.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end
