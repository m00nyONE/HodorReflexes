-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {

    -------------------------
    -- Missing Libraries
    -------------------------
    HR_MISSING_LIBS_TITLE = "Получите полный опыт HodorReflexes!",
    HR_MISSING_LIBS_TEXT = "|c00FF00Вы упускаете полный функционал HodorReflexes!|r\n\nУстановите |cFFFF00LibCustomIcons|r и |cFFFF00LibCustomNames|r, чтобы видеть кастомные иконки, ники и стили от других пользователей Hodor, включая ваших друзей и членов гильдии. Превратите поле боя во что-то персональное и полное характера!\n\nЭто полностью опционально и не требуется для работы HodorReflexes.",
    HR_MISSING_LIBS_OK = "OK",
    HR_MISSING_LIBS_DONTSHOWAGAIN = "Не показывать снова",

}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end