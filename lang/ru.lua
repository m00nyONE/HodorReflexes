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
    HR_MENU_GENERAL = "Общее",
    HR_MENU_MODULES = "Модули",
    HR_MENU_EXTENSIONS = "Расширения",
    HR_MENU_RESET_MESSAGE = "Сброс завершен! Для применения некоторых изменений может потребоваться /reloadui.",
    HR_MENU_RELOAD = "Перезагрузить интерфейс",
    HR_MENU_RELOAD_TT = "Перезагружает интерфейс",
    HR_MENU_RELOAD_HIGHLIGHT = "Настройки подсвеченные |cffff00жёлтым|r требуют перезагрузки интерфейса.",
    HR_MENU_TESTMODE = "Включить/выключить тестовый режим",
    HR_MENU_TESTMODE_TT = "Включает или выключает тестовый режим для аддона. НЕ работает, когда вы находитесь в группе.",
    HR_MENU_LOCKUI = "Заблокировать интерфейс",
    HR_MENU_LOCKUI_TT = "Заблокировать/разблокировать интерфейс аддона.",
    HR_MENU_ACCOUNTWIDE = "Настройки на аккаунт",
    HR_MENU_ACCOUNTWIDE_TT = "Если включено, ваши настройки будут сохраняться для всего аккаунта, а не для каждого персонажа отдельно.",
    HR_MENU_ADVANCED_SETTINGS = "Расширенные настройки",
    HR_MENU_ADVANCED_SETTINGS_TT = "Позволяет настроить дополнительные параметры.",
    HR_MENU_HORIZONTAL_POSITION = "Горизонтальное положение",
    HR_MENU_HORIZONTAL_POSITION_TT = "Настроить горизонтальное положение.",
    HR_MENU_VERTICAL_POSITION = "Вертикальное положение",
    HR_MENU_VERTICAL_POSITION_TT = "Настроить вертикальное положение.",
    HR_MENU_SCALE = "Масштаб",
    HR_MENU_SCALE_TT = "Установить масштаб.",
    HR_MENU_DISABLE_IN_PVP = "Отключать в PvP",
    HR_MENU_DISABLE_IN_PVP_TT = "Отключать при участии в PvP.",
    HR_MENU_VISIBILITY = "Видимость",
    HR_MENU_VISIBILITY_TT = "Условия отображения элемента.",
    HR_MENU_LIST_WIDTH = "Ширина списка",
    HR_MENU_LIST_WIDTH_TT = "Установить ширину списка.",
    -- general strings
    HR_UNIT_SECONDS = "секунд",

    ------------------------- MODULES -------------------------
    -- DPS
    HR_MODULES_DPS_FRIENDLYNAME = "Damage",
    HR_MODULES_DPS_DESCRIPTION = "Позволяет видеть статистику наносимого группой урона.",
    HR_MODULES_DPS_DAMAGE = "Урон",
    HR_MODULES_DPS_DAMAGE_TOTAL = "Общий урон",
    HR_MODULES_DPS_DAMAGE_MISC = "Разное",
    HR_MODULES_DPS_DPS_BOSS = "Босс DPS",
    HR_MODULES_DPS_DPS_TOTAL = "Общий DPS",
    HR_MODULES_DPS_MENU_HEADER = "Список урона",
    HR_MODULES_DPS_MENU_SHOW_SUMMARY = "Показывать сводку",
    HR_MODULES_DPS_MENU_SHOW_SUMMARY_TT = "Добавить строку со сводкой урона в списке.",
    --HR_MODULES_DPS_SUMMARY_GROUP_TOTAL = "Group Total: ",
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
    HR_MODULES_HIDEME_FRIENDLYNAME = "Hide Me",
    HR_MODULES_HIDEME_DESCRIPTION = "Позволяет скрыть некоторые ваши показатели из списков других участников группы.",
    HR_MODULES_HIDEME_HIDEDAMAGE_LABEL = "Скрыть урон (DPS)",
    HR_MODULES_HIDEME_HIDEDAMAGE_DESCRIPTION = "Скрыть показатель вашего урона из списков.",
    HR_MODULES_HIDEME_HIDEHORN_LABEL = "Скрыть горн (Horn)",
    HR_MODULES_HIDEME_HIDEHORN_DESCRIPTION = "Скрыть ваш горн из списков.",
    HR_MODULES_HIDEME_HIDECOLOS_LABEL = "Скрыть колосса (Colossus)",
    HR_MODULES_HIDEME_HIDECOLOS_DESCRIPTION = "Скрыть вашего колосса из списков.",
    HR_MODULES_HIDEME_HIDEATRO_LABEL = "Скрыть атронаха (Atronach)",
    HR_MODULES_HIDEME_HIDEATRO_DESCRIPTION = "Скрыть вашего атронаха из списков.",
    HR_MODULES_HIDEME_HIDESAXHLEEL_LABEL = "Скрыть саксхлил (Saxhleel)",
    HR_MODULES_HIDEME_HIDESAXHLEEL_DESCRIPTION = "Скрыть вашего саксхлил из списков.",
    --HR_MODULES_HIDEME_HIDEBARRIER_LABEL = "Hide Barrier",
    --HR_MODULES_HIDEME_HIDEBARRIER_DESCRIPTION = "Hide your barrier from the lists.",
    HR_MODULES_HIDEME_MENU_HEADER = "Параметры",
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
    --HR_MODULES_READYCHECK_MENU_UI = "show ui",
    --HR_MODULES_READYCHECK_MENU_UI_TT = "Displays the readycheck window with the results.",
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
    HR_EXTENSIONS_ANIMATIONS_FRIENDLYNAME = "Animations",
    HR_EXTENSIONS_ANIMATIONS_DESCRIPTION = "Добавляет поддержку анимированных значков пользователей с помощью LibCustomIcons.",
    -- ICONS
    HR_EXTENSIONS_ICONS_FRIENDLYNAME = "Icons",
    HR_EXTENSIONS_ICONS_DESCRIPTION = "Добавляет поддержку статических значков пользователей с помощью LibCustomIcons.",
    -- NAMES
    HR_EXTENSIONS_NAMES_FRIENDLYNAME = "Names",
    HR_EXTENSIONS_NAMES_DESCRIPTION = "Добавляет поддержку пользовательских имен с помощью LibCustomNames.",
    -- SEASONS
    HR_EXTENSIONS_SEASONS_FRIENDLYNAME = "Seasons",
    HR_EXTENSIONS_SEASONS_DESCRIPTION = "Сезонные события, во время которых, поведение аддона может быть изменено.",
    -- CONFIGURATOR
    HR_EXTENSIONS_CONFIGURATOR_FRIENDLYNAME = "Configurator",
    HR_EXTENSIONS_CONFIGURATOR_DESCRIPTION = "Позволяет запросить пользовательское имя/значок с помощью простого в использовании редактора.",
    HR_MENU_ICONS_SECTION_CUSTOM = "Пользовательские имена и значки",
    HR_MENU_ICONS_NOLIBSINSTALLED = "Для полного опыта использования HodorReflexes убедитесь, что установлены следующие библиотеки:\n\n - |cFFFF00LibCustomIcons|r – Включает персонализированные значки для игроков.\n - |cFFFF00LibCustomNames|r – Отображает пользовательские имена для друзей, согильдийцев и других.\n\nЭти библиотеки улучшают визуальный опыт и позволяют больше персонализации, но не требуются для базовой функциональности. Вы сами решаете, устанавливать их или нет.",
    HR_MENU_ICONS_README_1 = "Прежде чем что-либо делать, внимательно прочтите это руководство! Это гарантирует, что вы получите именно то, что ожидаете.\n",
    HR_MENU_ICONS_HEADER_ICONS = "Значки и Анимации – Требования:",
    HR_MENU_ICONS_README_2 = "Пожалуйста, соблюдайте эти технические ограничения для ваших файлов:\n\n- Максимальный размер: 32×32 пикселей\n- Анимации: максимум 50 кадров\n- Поддерживаемые форматы файлов: .dds, .jpg, .png, .gif, .webp\n",
    HR_MENU_ICONS_HEADER_TIERS = "Уровни доната:",
    HR_MENU_ICONS_README_3 = "Существует три уровня доната, каждый с разными наградами:\n\n1. 5M золота – пользовательское имя\n2. 7M золота – пользовательское имя + статичный значок\n3. 10M золота – пользовательское имя + статичный значок + анимированный значок\n\nВы можете выбрать желаемый уровень с помощью ползунка ниже. Просто переместите его в позицию 1–3 в зависимости от того, какой уровень вы хотите.\n",
    HR_MENU_ICONS_HEADER_CUSTOMIZE = "Настройте свое имя:",
    HR_MENU_ICONS_README_4 = "Используйте конфигуратор ниже для настройки вашего имени.\n",
    HR_MENU_ICONS_HEADER_TICKET = "Создать тикет в Discord",
    HR_MENU_ICONS_README_5 = "1. Нажмите в текстовое поле с сгенерированным LUA кодом.\n2. Нажмите CTRL+A, чтобы выделить все.\n3. Нажмите CTRL+C, чтобы скопировать содержимое.",
    HR_MENU_ICONS_README_6 = "\nЗатем откройте тикет на нашем Discord сервере – выберите уровень, который вы выбрали – и вставьте код и значок в тикет.",
    HR_MENU_ICONS_HEADER_DONATION = "Отправка доната:",
    HR_MENU_ICONS_README_7 = "После создания тикета в Discord:\n\n1. Нажмите кнопку \"%s\".\n2. Введите номер вашего тикета в поле ticket-XXXXX.\n3. Отправьте золото в соответствии с выбранным уровнем доната.",
    HR_MENU_ICONS_HEADER_INFO = "Информация:",
    HR_MENU_ICONS_INFO = "- Это услуга на основе добровольных взносов.\n- Вы не покупаете значки и не приобретаете на них права собственности.\n- Это добровольное пожертвование с косметическими бонусами в рамках аддонов, использующих LibCustomNames и LibCustomIcons.\n- Вы должны соблюдать ToS от ZoS - Нецензурные имена или неподходящие значки будут отклонены!\n- Вы всегда можете отправить PR на github со своим значком и именем без какого-либо доната, если умеете программировать.",
    HR_MENU_ICONS_CONFIGURATOR_DISCORD = "Открыть Discord",
    HR_MENU_ICONS_CONFIGURATOR_DISCORD_TT = "Присоединиться к Discord HodorReflexes для создания тикета.",
    HR_MENU_ICONS_README_DONATION_TIER = "Уровень доната: ",
    HR_MENU_ICONS_README_DONATION_TIER_TT = "При изменении уровня доната LUA код в конфигураторе ниже будет генерировать дополнительный код в зависимости от выбранного уровня",
    HR_MENU_ICONS_CONFIGURATOR_LUA_TT = "Нажмите в текстовое поле и нажмите CTRL+A, чтобы выделить весь код, затем нажмите CTRL+C, чтобы скопировать код в буфер обмена.",
    HR_MENU_ICONS_CONFIGURATOR_DONATE_TT = "Открывает окно внутриигровой почты и вставляет некоторый текст.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end
