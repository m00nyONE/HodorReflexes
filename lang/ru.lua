-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {

    -------------------------
    -- VISIBILITY
    -------------------------
    HR_VISIBILITY_SHOW_NEVER = "Никогда",
    HR_VISIBILITY_SHOW_ALWAYS = "Всегда",
    HR_VISIBILITY_SHOW_OUT_OF_COMBAT = "Вне боя",
    HR_VISIBILITY_SHOW_NON_BOSSFIGHTS = "Вне боя с боссами",
    HR_VISIBILITY_SHOW_IN_COMBAT = "В бою",

    -------------------------
    -- HUD
    -------------------------
    HR_CORE_HUD_COMMAND_LOCK_HELP = "Заблокировать интерфейс",
    HR_CORE_HUD_COMMAND_UNLOCK_HELP = "Разблокировать интерфейс",
    HR_CORE_HUD_COMMAND_LOCK_ACTION = "Интерфейс заблокирован",
    HR_CORE_HUD_COMMAND_UNLOCK_ACTION = "Интерфейс разблокирован",
    -------------------------
    -- Group
    -------------------------
    HR_CORE_GROUP_COMMAND_TEST_HELP = "Запустить/остановить тест",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_START = "Тест запущен",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_STOP = "Тест остановлен",
    HR_CORE_GROUP_COMMAND_TEST_LEAVE_GROUP = "Необходимо покинуть группу, чтобы запустить тест",
    -------------------------
    -- LibCheck
    -------------------------
    HR_MISSING_LIBS_TITLE = "Получите полный опыт HodorReflexes!",
    HR_MISSING_LIBS_TEXT = "|c00FF00Вы упускаете полный функционал HodorReflexes!|r\n\nУстановите |cFFFF00LibCustomIcons|r и |cFFFF00LibCustomNames|r, чтобы видеть кастомные иконки, ники и стили от других пользователей Hodor, включая ваших друзей и членов гильдии. Превратите поле боя во что-то персональное и полное характера!\n\nЭто полностью опционально и не требуется для работы HodorReflexes.",
    HR_MISSING_LIBS_TEXT_CONSOLE = "|c00FF00Вы упускаете полный функционал HodorReflexes!|r\n\nУстановите |cFFFF00LibCustomNames|r, чтобы видеть кастомные иконки, ники и стили от других пользователей Hodor, включая ваших друзей и членов гильдии. Превратите поле боя во что-то персональное и полное характера!\n\nЭто полностью опционально и не требуется для работы HodorReflexes.",
    HR_MISSING_LIBS_DONTSHOWAGAIN = "Не показывать снова",

}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end
