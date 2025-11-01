-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_PULL_FRIENDLYNAME = "Pull Countdown",
    HR_MODULES_PULL_DESCRIPTION = "Позволяет отправлять обратный отсчёт перед пулом вашей группе.",
    HR_MODULES_PULL_BINDING_COUNTDOWN = "Обратный отсчёт перед пулом",
    HR_MODULES_PULL_COUNTDOWN_DURATION = "Длительность обратного отсчёта",
    HR_MODULES_PULL_COUNTDOWN_DURATION_TT = "Установите длительность обратного отсчёта в секундах.",
    HR_MODULES_PULL_NOT_LEADER = "Необходимо быть лидером группы, чтобы запустить обратный отсчёт!",
    HR_MODULES_PULL_COMMAND_HELP = "Запустить обратный отсчёт.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end
