-- SPDX-FileCopyrightText: 2025 m00nyONE NeBioNik
-- SPDX-License-Identifier: Artistic-2.0

local strings = {

    ------------------------- CORE -------------------------
    -- VISIBILITY
    HR_VISIBILITY_SHOW_NEVER = "Никогда",
    HR_VISIBILITY_SHOW_ALWAYS = "Всегда",
    HR_VISIBILITY_SHOW_OUT_OF_COMBAT = "Вне боя",
    HR_VISIBILITY_SHOW_NON_BOSSFIGHTS = "Вне боя с боссами",
    HR_VISIBILITY_SHOW_IN_COMBAT = "В бою",
    -- HUD
    HR_CORE_HUD_COMMAND_LOCK_HELP = "Заблокировать интерфейс",
    HR_CORE_HUD_COMMAND_UNLOCK_HELP = "Разблокировать интерфейс",
    HR_CORE_HUD_COMMAND_LOCK_ACTION = "Интерфейс заблокирован",
    HR_CORE_HUD_COMMAND_UNLOCK_ACTION = "Интерфейс разблокирован",
    -- Group
    HR_CORE_GROUP_COMMAND_TEST_HELP = "Запустить/остановить тест",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_START = "Тест запущен",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_STOP = "Тест остановлен",
    HR_CORE_GROUP_COMMAND_TEST_LEAVE_GROUP = "Необходимо покинуть группу, чтобы запустить тест",
    -- LibCheck
    HR_MISSING_LIBS_TITLE = "Получите полный опыт HodorReflexes!",
    HR_MISSING_LIBS_TEXT = "|c00FF00Вы упускаете полный функционал HodorReflexes!|r\n\nУстановите |cFFFF00LibCustomIcons|r и |cFFFF00LibCustomNames|r, чтобы видеть кастомные иконки, ники и стили от других пользователей Hodor, включая ваших друзей и членов гильдии. Превратите поле боя во что-то персональное и полное характера!\n\nЭто полностью опционально и не требуется для работы HodorReflexes.",
    HR_MISSING_LIBS_TEXT_CONSOLE = "|c00FF00Вы упускаете полный функционал HodorReflexes!|r\n\nУстановите |cFFFF00LibCustomNames|r, чтобы видеть кастомные иконки, ники и стили от других пользователей Hodor, включая ваших друзей и членов гильдии. Превратите поле боя во что-то персональное и полное характера!\n\nЭто полностью опционально и не требуется для работы HodorReflexes.",
    HR_MISSING_LIBS_DONTSHOWAGAIN = "Не показывать снова",
    -- Menu
    --HR_MENU_GENERAL = "General",
    --HR_MENU_MODULES = "Modules",
    --HR_MENU_EXTENSIONS = "Extensions",
    --HR_MENU_RESET_MESSAGE = "Reset complete! Some changes might require a /reloadui to take effect.",
    --HR_MENU_RELOAD = "Reload UI",
    --HR_MENU_RELOAD_TT = "Reloads the UI",
    --HR_MENU_RELOAD_HIGHLIGHT = "Settings highlighted in |cffff00yellow|r require a reload.",
    --HR_MENU_TESTMODE = "Toggle Test Mode",
    --HR_MENU_TESTMODE_TT = "Toggles the test mode for the addon. This does NOT work when you are in a group.",
    --HR_MENU_LOCKUI = "Lock UI",
    --HR_MENU_LOCKUI_TT = "Locks/Unlocks the addon UI.",
    --HR_MENU_ACCOUNTWIDE = "Account Wide Settings",
    --HR_MENU_ACCOUNTWIDE_TT = "If enabled, your settings will be saved account wide instead of per character.",
    --HR_MENU_ADVANCED_SETTINGS = "Advanced Settings",
    --HR_MENU_ADVANCED_SETTINGS_TT = "Allows you to customize more advanced settings.",
    --HR_MENU_HORIZONTAL_POSITION = "Horizontal Position",
    --HR_MENU_HORIZONTAL_POSITION_TT = "Adjust the horizontal position.",
    --HR_MENU_VERTICAL_POSITION = "Vertical Position",
    --HR_MENU_VERTICAL_POSITION_TT = "Adjust the vertical position.",
    --HR_MENU_SCALE = "Scale",
    --HR_MENU_SCALE_TT = "Set the scale.",
    --HR_MENU_DISABLE_IN_PVP = "Disable in PvP",
    --HR_MENU_DISABLE_IN_PVP_TT = "disable when in PvP.",
    --HR_MENU_VISIBILITY = "Visibility",
    --HR_MENU_VISIBILITY_TT = "Set when it should be visible.",
    --HR_MENU_LIST_WIDTH = "List Width",
    --HR_MENU_LIST_WIDTH_TT = "Set the width of the list.",
    -- general strings
    --HR_UNIT_SECONDS = "seconds",

    ------------------------- MODULES -------------------------
    -- DPS
    HR_MODULES_DPS_FRIENDLYNAME = "Damage",
    HR_MODULES_DPS_DESCRIPTION = "Позволяет видеть статистику наносимого группой урона.",
    HR_MODULES_DPS_DAMAGE = "Урон",
    HR_MODULES_DPS_DAMAGE_TOTAL = "Общий урон",
    HR_MODULES_DPS_DAMAGE_MISC = "Разное",
    HR_MODULES_DPS_DPS_BOSS = "Босс DPS",
    HR_MODULES_DPS_DPS_TOTAL = "Общий DPS",
    --HR_MODULES_DPS_MENU_HEADER = "Damage List",
    --HR_MODULES_DPS_MENU_SHOW_SUMMARY = "Show Summary",
    --HR_MODULES_DPS_MENU_SHOW_SUMMARY_TT = "toggle the display of the summary row in the damage list.",
    -- EXIT INSTANCE
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
    -- HIDEME
    --HR_MODULES_HIDEME_FRIENDLYNAME = "Hide Me",
    --HR_MODULES_HIDEME_DESCRIPTION = "Allows you to hide some of your stats from other group members lists.",
    --HR_MODULES_HIDEME_HIDEDAMAGE_LABEL = "Hide Damage",
    --HR_MODULES_HIDEME_HIDEDAMAGE_DESCRIPTION = "Hide your damage numbers from other group members dps list.",
    --HR_MODULES_HIDEME_HIDEHORN_LABEL = "Hide Horn",
    --HR_MODULES_HIDEME_HIDEHORN_DESCRIPTION = "Hide your horn from the lists.",
    --HR_MODULES_HIDEME_HIDECOLOS_LABEL = "Hide Colossus",
    --HR_MODULES_HIDEME_HIDECOLOS_DESCRIPTION = "Hide your colossus from the lists.",
    --HR_MODULES_HIDEME_HIDEATRO_LABEL = "Hide Atro",
    --HR_MODULES_HIDEME_HIDEATRO_DESCRIPTION = "Hide your atronach from the lists.",
    --HR_MODULES_HIDEME_HIDESAXHLEEL_LABEL = "Hide Saxhleel",
    --HR_MODULES_HIDEME_HIDESAXHLEEL_DESCRIPTION = "Hide your saxhleel from the lists.",
    --HR_MODULES_HIDEME_MENU_HEADER = "Hide Me Options",
    -- PULL
    HR_MODULES_PULL_FRIENDLYNAME = "Pull Countdown",
    HR_MODULES_PULL_DESCRIPTION = "Позволяет отправлять обратный отсчёт перед пулом вашей группе.",
    HR_MODULES_PULL_BINDING_COUNTDOWN = "Обратный отсчёт перед пулом",
    HR_MODULES_PULL_COUNTDOWN_DURATION = "Длительность обратного отсчёта",
    HR_MODULES_PULL_COUNTDOWN_DURATION_TT = "Установите длительность обратного отсчёта в секундах.",
    HR_MODULES_PULL_NOT_LEADER = "Необходимо быть лидером группы, чтобы запустить обратный отсчёт!",
    HR_MODULES_PULL_COMMAND_HELP = "Запустить обратный отсчёт.",
    -- READYCHECK
    HR_MODULES_READYCHECK_FRIENDLYNAME = "Readycheck",
    HR_MODULES_READYCHECK_DESCRIPTION = "Улучшает проверку готовности, показывая, кто как проголосовал.",
    HR_MODULES_READYCHECK_TITLE = "Проверка готовности",
    HR_MODULES_READYCHECK_READY = "Готов",
    HR_MODULES_READYCHECK_NOT_READY = "Не готов",
    HR_MODULES_READYCHECK_MENU_UI_LOCKED = "Заблокировать интерфейс",
    HR_MODULES_READYCHECK_MENU_UI_LOCKED_TT = "Запрещает перемещение или изменение размера окна проверки готовности.",
    HR_MODULES_READYCHECK_MENU_CHAT = "Вывод в чат",
    HR_MODULES_READYCHECK_MENU_CHAT_TT = "Выводит результаты проверки готовности в чат.",
    -- SKILL LINES
    HR_MODULES_SKILLLINES_FRIENDLYNAME = "Skill Lines",
    HR_MODULES_SKILLLINES_DESCRIPTION = "Позволяет отслеживать, какие линии навыков подклассов используют члены вашей группы.",
    -- ULT
    HR_MODULES_ULT_FRIENDLYNAME = "Ultimates",
    HR_MODULES_ULT_DESCRIPTION = "Позволяет видеть статистику ультимейтов группы.",

    ------------------------- EXTENSIONS -------------------------
    -- ANIMATIONS
    --HR_EXTENSIONS_ANIMATIONS_FRIENDLYNAME = "Animations",
    --HR_EXTENSIONS_ANIMATIONS_DESCRIPTION = "Provides animated user icon support for lists via LibCustomIcons.",
    -- ICONS
    --HR_EXTENSIONS_ICONS_FRIENDLYNAME = "Icons",
    --HR_EXTENSIONS_ICONS_DESCRIPTION = "Extension to provide static user icons via LibCustomIcons.",
    -- NAMES
    --HR_EXTENSIONS_NAMES_FRIENDLYNAME = "Names",
    --HR_EXTENSIONS_NAMES_DESCRIPTION = "Extension to provide custom user names via LibCustomNames.",
    -- SEASONS
    --HR_EXTENSIONS_SEASONS_FRIENDLYNAME = "Seasons",
    --HR_EXTENSIONS_SEASONS_DESCRIPTION = "Seasonal events which change some behaviors of the addon on specific dates.",
    -- CONFIGURATOR
    --HR_EXTENSIONS_CONFIGURATOR_FRIENDLYNAME = "Configurator",
    --HR_EXTENSIONS_CONFIGURATOR_DESCRIPTION = "Allows you to request a custom name/icon yourself with an easy to use editor.",
    --HR_MENU_ICONS_SECTION_CUSTOM = "Custom names & icons",
    --HR_MENU_ICONS_NOLIBSINSTALLED = "For the full experience of HodorReflexes, please make sure the following libraries are installed:\n\n - |cFFFF00LibCustomIcons|r – Enables personalized icons for players.\n - |cFFFF00LibCustomNames|r – Displays custom names for friends, guildmates, and more.\n\nThese libraries enhance the visual experience and allow for more personalization but are not required for basic functionality. It's your choice if you want to have them installed or not.",
    --HR_MENU_ICONS_README_1 = "Before doing anything, please read this guide carefully! This ensures that you receive exactly what you expect.\n",
    --HR_MENU_ICONS_HEADER_ICONS = "Icons & Animations – Requirements:",
    --HR_MENU_ICONS_README_2 = "Please follow these technical limitations for your files:\n\n- Maximum size: 32×32 pixels\n- Animations: maximum of 50 frames\n- Accepted file formats: .dds, .jpg, .png, .gif, .webp\n",
    --HR_MENU_ICONS_HEADER_TIERS = "Donation Tiers:",
    --HR_MENU_ICONS_README_3 = "there are three donation tiers, each with different rewards:\n\n1. 5M gold – custom name\n2. 7M gold – custom name + static icon\n3. 10M gold – custom name + static icon + animated icon\n\nYou can select the desired tier using the slider below. Simply move it to position 1–3, depending on which tier you want.\n",
    --HR_MENU_ICONS_HEADER_CUSTOMIZE = "Customize your name:",
    --HR_MENU_ICONS_README_4 = "Use the configurator below to customize your name.\n",
    --HR_MENU_ICONS_HEADER_TICKET = "Create Ticket in Discord",
    --HR_MENU_ICONS_README_5 = "1. Click inside the textbox containing the generated LUA code.\n2. Press CTRL+A to select all.\n3. Press CTRL+C to copy the content.",
    --HR_MENU_ICONS_README_6 = "\nNext, open a ticket on our Discord server – choose the tier you selected – and paste the code and the icon into the ticket.",
    --HR_MENU_ICONS_HEADER_DONATION = "Sending a Donation:",
    --HR_MENU_ICONS_README_7 = "Once you’ve created your ticket on Discord:\n\n1. Click the \"%s\" button.\n2. Enter your ticket number in the ticket-XXXXX field.\n3. Send the gold according to your selected donation tier.",
    --HR_MENU_ICONS_HEADER_INFO = "Info:",
    --HR_MENU_ICONS_INFO = "- This is a donation-based service.\n- You are not purchasing icons, nor do you acquire any ownership of them.\n- This is a voluntary donation with cosmetic perks within the scope of addons using LibCustomNames and LibCustomIcons.\n- You need to stay within the ToS of ZoS - Swear words in names or unappropriated icons will be denied!\n- You can always send PRs on github with your icon and name without any donation needed if you know how to code.",
    --HR_MENU_ICONS_CONFIGURATOR_DISCORD = "join discord",
    --HR_MENU_ICONS_CONFIGURATOR_DISCORD_TT = "join the HodorReflexes discord to create a request ticket.",
    --HR_MENU_ICONS_README_DONATION_TIER = "Donation tier: ",
    --HR_MENU_ICONS_README_DONATION_TIER_TT = "By changing the donation tier, the LUA Code in the configurator below will generate additional code depending on the tier you choose",
    --HR_MENU_ICONS_CONFIGURATOR_LUA_TT = "click into the textbox and press ctrl+a to highlight the whole code, then press ctrl+c to copy the code to your clipboard.",
    --HR_MENU_ICONS_CONFIGURATOR_DONATE_TT = "opens the mail window and puts in some text.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end
