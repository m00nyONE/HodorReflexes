-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_DAMAGE = "Урон",
    HR_TOTAL_DAMAGE = "Общий урон",
    HR_MISC_DAMAGE = "Разный урон",
    HR_BOSS_DPS = "Босс DPS",
    HR_TOTAL_DPS = "Общий DPS",

    HR_MENU_DAMAGE_SHOW = "Показывать урон группы:",
    HR_MENU_DAMAGE_SHOW_TT = "Показывать список с уроном группы.",
    HR_MENU_DAMAGE_SHOW_NEVER = "Никогда",
    HR_MENU_DAMAGE_SHOW_ALWAYS = "Всегда",
    HR_MENU_DAMAGE_SHOW_OUT = "Вне боя",
    HR_MENU_DAMAGE_SHOW_NONBOSS = "Вне боя с боссами",

    HR_MENU_STYLE_DPS = "Список урона",
    HR_MENU_STYLE_DPS_FONT = "Шрифт чисел",
    HR_MENU_STYLE_DPS_FONT_DEFAULT = "Стандартный",
    HR_MENU_STYLE_DPS_FONT_GAMEPAD = "Геймпад",
    HR_MENU_STYLE_DPS_BOSS_COLOR = "Цвет урона по боссу",
    HR_MENU_STYLE_DPS_TOTAL_COLOR = "Цвет общего урона",
    HR_MENU_STYLE_DPS_HEADER_OPACITY = "Прозрачность заголовка",
    HR_MENU_STYLE_DPS_EVEN_OPACITY = "Прозрачность чётных строк",
    HR_MENU_STYLE_DPS_ODD_OPACITY = "Прозрачность нечётных строк",
    HR_MENU_STYLE_DPS_HIGHLIGHT = "Цвет подсветки",
    HR_MENU_STYLE_DPS_HIGHLIGHT_TT = "Подсветка своего имени в списке. Чтобы убрать, установите видимость равной нулю. Только вы видите подсветку своего имени.",
    HR_MENU_ICONS_VISIBILITY_COLORS = "Цветные имена",
    HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Показывать цветные имена игроков.",
    HR_MENU_ICONS_VISIBILITY_DPS = "Иконки в списке урона",
    HR_MENU_ICONS_VISIBILITY_DPS_TT = "Показывать иконки игроков в списке урона.",

    HR_TEST_STARTED = "Начало теста.",
    HR_TEST_STOPPED = "Конец теста.",
    HR_TEST_LEAVE_GROUP = "Необходимо выйти из группы, чтобы запустить тест.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end