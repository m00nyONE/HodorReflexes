-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_READYCHECK_FRIENDLYNAME = "Readycheck",
    HR_MODULES_READYCHECK_DESCRIPTION = "Улучшает проверку готовности, показывая, кто как проголосовал.",
    HR_MODULES_READYCHECK_TITLE = "Проверка готовности",
    HR_MODULES_READYCHECK_READY = "Готов",
    HR_MODULES_READYCHECK_NOT_READY = "Не готов",
    HR_MODULES_READYCHECK_MENU_UI_LOCKED = "Заблокировать интерфейс",
    HR_MODULES_READYCHECK_MENU_UI_LOCKED_TT = "Запрещает перемещение или изменение размера окна проверки готовности.",
    HR_MODULES_READYCHECK_MENU_CHAT = "Вывод в чат",
    HR_MODULES_READYCHECK_MENU_CHAT_TT = "Выводит результаты проверки готовности в чат.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end
