local strings = {

    -------------------------
    -- MENUS
    -------------------------

    HR_MENU_GENERAL = "Общие",
    HR_MENU_GENERAL_ENABLED = "Включить",
    HR_MENU_GENERAL_ENABLED_TT = "Включить/отключить аддон.",
    HR_MENU_GENERAL_UI_LOCKED = "Заблокировать интерфейс",
    HR_MENU_GENERAL_UI_LOCKED_TT = "Отключите, чтобы разблокировать интерфейс и показать элементы аддона. Если вы не в группе, то введите\n|cFFFF00/hodor.share test|r в чате, чтобы заполнить элементы тестовыми данными.",
    HR_MENU_GENERAL_ACCOUNT_WIDE = "Глобальные настройки",
    HR_MENU_GENERAL_ACCOUNT_WIDE_TT = "Переключиться между глобальными настройками аккаунта и конкретного персонажа.",
    HR_MENU_GENERAL_DISABLE_PVP = "Отключить в ПвП",
    HR_MENU_GENERAL_DISABLE_PVP_TT = "Отключать аддон в ПвП зонах.",
    HR_MENU_GENERAL_EXIT_INSTANCE = "Подтверждать выход из подземелья",
    HR_MENU_GENERAL_EXIT_INSTANCE_TT = "Показывать предупреждение перед выходом из подземелья по запросу лидера группы или при нажатии горячей клавиши.",

    HR_MENU_DAMAGE = "Урон",
    HR_MENU_DAMAGE_SHOW = "Показывать урон группы:",
    HR_MENU_DAMAGE_SHOW_TT = "Показывать список с уроном группы.",
    HR_MENU_DAMAGE_SHOW_NEVER = "Никогда",
    HR_MENU_DAMAGE_SHOW_ALWAYS = "Всегда",
    HR_MENU_DAMAGE_SHOW_OUT = "Вне боя",
    HR_MENU_DAMAGE_SHOW_NONBOSS = "Вне боя с боссами",

    HR_MENU_HORN = "Горн",
    HR_MENU_HORN_SHOW = "Показывать горны группы:",
    HR_MENU_HORN_SHOW_TT = "Показывать список с готовностью горнов группы.",
    HR_MENU_HORN_SHOW_PERCENT = "Показывать процент",
    HR_MENU_HORN_SHOW_PERCENT_TT = "Показывать процент готовности горнов.",
    HR_MENU_HORN_SHOW_RAW = "Показывать очки ульты",
    HR_MENU_HORN_SHOW_RAW_TT = "Показывать количество очков ультимейта у игрока.",
    HR_MENU_HORN_SELFISH = "Жадный режим:",
    HR_MENU_HORN_SELFISH_TT = "Если включён, то оставшееся время действия горна будет отображаться, только если его эффект активен на моём персонаже.",
    HR_MENU_HORN_ICON = "Дополнительная иконка:",
    HR_MENU_HORN_ICON_TT = "Показать иконку с числом игроков в зоне действия горна (20 метров), когда он готов.\nИконка становится |c00FF00зелёной|r, когда все бойцы находятся в зоне действия горна.\nЗелёная иконка заменяется |cFFFF00жёлтой|r, если вы не первый в списке горнов. Не забудьте анонсировать его в этом случае!",
    HR_MENU_HORN_COUNTDOWN_TYPE = "Тип обратного отсчёта:",
    HR_MENU_HORN_COUNTDOWN_TYPE_TT = "- Нет: не показывать уведомление.\n- Мой: обратный отсчёт только для моего горна или эффекта \"Великая сила\".\n- Любой: обратный отсчёт для горнов всех членов группы (режим рейд лидера).",
    HR_MENU_HORN_COUNTDOWN_TYPE_NONE = "Нет",
    HR_MENU_HORN_COUNTDOWN_TYPE_SELF = "Горн (мой)",
    HR_MENU_HORN_COUNTDOWN_TYPE_ALL = "Горн (любой)",
    HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_SELF = "Великая сила (моя)",
    HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_ALL = "Великая сила (любая)",
    HR_MENU_HORN_COUNTDOWN_COLOR = "Цвет обратного отсчёта:",

    HR_MENU_COLOS = "Колосс",
    HR_MENU_COLOS_SHOW = "Показывать колоссов группы:",
    HR_MENU_COLOS_SHOW_TT = "Показывать список с готовностью колоссов группы.",
    HR_MENU_COLOS_SHOW_PERCENT = "Показывать процент",
    HR_MENU_COLOS_SHOW_PERCENT_TT = "Показывать процент готовности колоссов.",
    HR_MENU_COLOS_SHOW_RAW = "Показывать очки ульты",
    HR_MENU_COLOS_SHOW_RAW_TT = "Показывать количество очков ультимейта у игрока.",
    HR_MENU_COLOS_SUPPORT_RANGE = "Только ближайшие союзники:",
    HR_MENU_COLOS_SUPPORT_RANGE_TT = "Игроки, которые слишком далеко от вас, не будут отображаться в списке колоссов.",
    HR_MENU_COLOS_COUNTDOWN = "Показывать обратный отсчёт:",
    HR_MENU_COLOS_COUNTDOWN_TT = "Показать уведомление, когда можно использовать суперспособность.",
    HR_MENU_COLOS_COUNTDOWN_TEXT = "Текст обратного отсчёта:",
    HR_MENU_COLOS_COUNTDOWN_COLOR = "Цвет обратного отсчёта:",

    HR_MENU_ATRONACH = "Атронах",
    HR_MENU_ATRONACH_SHOW = "Показывать атронахов",
    HR_MENU_ATRONACH_SHOW_TT = "Показывать список с готовностью атронахов группы.",
    HR_MENU_ATRONACH_SHOW_PERCENT = "Показывать процент",
    HR_MENU_ATRONACH_SHOW_PERCENT_TT = "Показывать процент готовности атронахов.",
    HR_MENU_ATRONACH_SHOW_RAW = "Показывать очки ульты",
    HR_MENU_ATRONACH_SHOW_RAW_TT = "Показывать количество очков ультимейта у игрока.",

    HR_MENU_MISCULTIMATES = "Другие ультимейты",
    HR_MENU_MISCULTIMATES_SHOW = "Показывать другие ультимейты",
    HR_MENU_MISCULTIMATES_SHOW_TT = "Показывать другие неподдерживаемые ультимейты.",
    HR_MENU_MISCULTIMATES_SHOW_PERCENT = "Показывать процент",
    HR_MENU_MISCULTIMATES_SHOW_PERCENT_TT = "Показывать процент готовности самого дорогого ультимейта, который есть у игрока",
    HR_MENU_MISCULTIMATES_SHOW_RAW = "Показывать очки ульты",
    HR_MENU_MISCULTIMATES_SHOW_RAW_TT = "Показывать количество очков ультимейта у игрока",

    HR_MENU_MISC = "Разное",
    HR_MENU_MISC_DESC = "Чтобы показать/спрятать тестовый список игроков, введите команду\n|c999999/hodor.share test|r в чате.\nМожно так же указать имена игроков, которых необходимо отобразить: \n|c999999/hodor.share test @andy.s @Alcast|r",

    HR_MENU_ICONS = "Иконки",
    HR_MENU_ICONS_VISIBILITY = "Видимость",
    HR_MENU_ICONS_VISIBILITY_HORN = "Иконки в списке горнов",
    HR_MENU_ICONS_VISIBILITY_HORN_TT = "Показывать иконки игроков в списке горнов.",
    HR_MENU_ICONS_VISIBILITY_DPS = "Иконки в списке урона",
    HR_MENU_ICONS_VISIBILITY_DPS_TT = "Показывать иконки игроков в списке урона.",
    HR_MENU_ICONS_VISIBILITY_COLOS = "Иконки в списке колоссов",
    HR_MENU_ICONS_VISIBILITY_COLOS_TT = "Показывать иконки игроков в списке колоссов.",
    HR_MENU_ICONS_VISIBILITY_ATRONACH = "Иконки в списке атронахов",
    HR_MENU_ICONS_VISIBILITY_ATRONACH_TT = "Показывать иконки игроков в списке атронахов.",
    HR_MENU_ICONS_VISIBILITY_MISCULTIMATES = "Другие ультимейты",
    HR_MENU_ICONS_VISIBILITY_MISCULTIMATES_TT = "Показывать иконки игроков в списке ультимейтов.",
    HR_MENU_ICONS_VISIBILITY_COLORS = "Цветные имена",
    HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Показывать цветные имена игроков.",
    HR_MENU_ICONS_VISIBILITY_ANIM = "Анимированные иконки",
    HR_MENU_ICONS_VISIBILITY_ANIM_TT = "Показывать анимированные иконки. Замечание: отключение этой настройки не повлияет на FPS.",

    HR_MENU_ICONS_SECTION_CUSTOM = "Пользовательские имена и иконки",
    HR_MENU_ICONS_NOLIBSINSTALLED = "Для полного функционала HodorReflexes убедитесь, что установлены следующие библиотеки:\n\n - |cFFFF00LibCustomIcons|r – Позволяет использовать персонализированные иконки для игроков.\n - |cFFFF00LibCustomNames|r – Отображает кастомные имена для друзей, гильдий и других.\n\nЭти библиотеки улучшают визуальный опыт и позволяют больше персонализации, но не требуются для базового функционала. Вы можете выбрать, устанавливать их или нет.",
    HR_MENU_ICONS_README_1 = "Перед началом внимательно прочитайте это руководство! Это гарантирует, что вы получите именно то, что ожидаете.\n",
    HR_MENU_ICONS_HEADER_ICONS = "Иконки и анимации – Требования:",
    HR_MENU_ICONS_README_2 = "Пожалуйста, соблюдайте следующие технические ограничения для ваших файлов:\n\n- Максимальный размер: 32×32 пикселей\n- Анимации: максимум 50 кадров\n- Поддерживаемые форматы: .dds, .jpg, .png, .gif, .webp\n",
    HR_MENU_ICONS_HEADER_TIERS = "Уровни доната:",
    HR_MENU_ICONS_README_3 = "есть три уровня доната с разными наградами:\n\n1. 5M золота – кастомное имя\n2. 7M золота – кастомное имя + статичная иконка\n3. 10M золота – кастомное имя + статичная иконка + анимированная иконка\n\nВы можете выбрать желаемый уровень с помощью ползунка ниже. Просто переместите его в позицию 1–3, в зависимости от желаемого уровня.\n",
    HR_MENU_ICONS_HEADER_CUSTOMIZE = "Настройте своё имя:",
    HR_MENU_ICONS_README_4 = "Используйте конфигуратор ниже для настройки своего имени.\n",
    HR_MENU_ICONS_HEADER_TICKET = "Создать тикет в Discord",
    HR_MENU_ICONS_README_5 = "1. Нажмите в текстовое поле с сгенерированным LUA кодом.\n2. Нажмите CTRL+A, чтобы выделить всё.\n3. Нажмите CTRL+C, чтобы скопировать содержимое.",
    HR_MENU_ICONS_README_6 = "\nДалее, откройте тикет на нашем Discord сервере – выберите уровень, который вы выбрали – и вставьте код и иконку в тикет.",
    HR_MENU_ICONS_HEADER_DONATION = "Отправка доната:",
    HR_MENU_ICONS_README_7 = "После создания тикета на Discord:\n\n1. Нажмите кнопку \"%s\".\n2. Введите номер тикета в поле ticket-XXXXX.\n3. Отправьте золото в соответствии с выбранным уровнем доната.",
    HR_MENU_ICONS_HEADER_INFO = "Информация:",
    HR_MENU_ICONS_INFO = "- Это сервис на основе добровольных пожертвований.\n- Вы не покупаете иконки и не получаете права собственности на них.\n- Это добровольное пожертвование с косметическими бонусами в рамках аддонов, использующих LibCustomNames и LibCustomIcons.\n- Вы должны соблюдать правила ZoS – Нецензурные имена или неподобающие иконки будут отклонены!\n- Вы всегда можете отправить PR на github со своей иконкой и именем без необходимости доната, если умеете программировать.",

    HR_MENU_ICONS_CONFIGURATOR_DISCORD = "присоединиться к Discord",
    HR_MENU_ICONS_CONFIGURATOR_DISCORD_TT = "присоединиться к Discord HodorReflexes, чтобы создать тикет с запросом.",
    HR_MENU_ICONS_README_DONATION_TIER = "Уровень доната: ",
    HR_MENU_ICONS_README_DONATION_TIER_TT = "При изменении уровня доната LUA код в конфигураторе ниже будет генерировать дополнительный код в зависимости от выбранного уровня.",
    HR_MENU_ICONS_CONFIGURATOR_LUA_TT = "нажмите в текстовое поле и нажмите ctrl+a, чтобы выделить весь код, затем нажмите ctrl+c, чтобы скопировать код в буфер обмена.",
    HR_MENU_ICONS_CONFIGURATOR_DONATE_TT = "открывает окно почты и вставляет некоторый текст.",

    HR_MENU_STYLE = "Стиль",
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
    HR_MENU_STYLE_HORN_COLOR = "Цвет длительности горна",
    HR_MENU_STYLE_FORCE_COLOR = "Цвет длительности силы",
    HR_MENU_STYLE_ATRONACH_COLOR = "Цвет длительности атронаха",
    HR_MENU_STYLE_BERSERK_COLOR = "Цвет длительности берсерка",
    HR_MENU_STYLE_COLOS_COLOR = "Цвет длительности колосса",
    HR_MENU_STYLE_TIMER_OPACITY = "Прозрачность истёкшего таймера",
    HR_MENU_STYLE_TIMER_OPACITY_TT = "Прозрачность текста и иконки, когда таймер достигает значения 0.0",
    HR_MENU_STYLE_TIMER_BLINK = "Мигающие таймеры",
    HR_MENU_STYLE_TIMER_BLINK_TT = "Таймеры сначала мигают, когда достигают значения 0.0, затем применяется прозрачность.",

    HR_MENU_ANIMATIONS = "Анимированные сообщения",
    HR_MENU_ANIMATIONS_TT = "Анимировать обратные отсчёты колосса и горна, чтобы сделать их более заметными.",

    HR_MENU_VOTE = "Голосование",
    HR_MENU_VOTE_DISABLED = "Этот модуль требует включения основного модуля Hodor Reflexes!",
    HR_MENU_VOTE_DESC = "Этот модуль улучшает стандартное голосование группы, позволяя видеть голоса других игроков, если у них включён аддон Hodor Reflexes.",
    HR_MENU_VOTE_ENABLED_TT = "Включить/отключить этот модуль. Если модуль отключён, то другие игроки не увидят ваш голос.",
    HR_MENU_VOTE_CHAT = "Сообщения в чате",
    HR_MENU_VOTE_CHAT_TT = "Показывать результат голосования и прочие сообщения в чате.",
    HR_MENU_VOTE_ACTIONS = "Действия",
    HR_MENU_VOTE_ACTIONS_COUNTDOWN = "Обратный отсчёт",
    HR_MENU_VOTE_ACTIONS_COUNTDOWN_TT = "Запустить обратный отсчёт длительностью, выбранной выше. Необходимо быть лидером группы.",
    HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM = "Необходимо быть лидером группы, чтобы запустить обратный отсчёт!",
    HR_MENU_VOTE_ACTIONS_LEADER = "Сменить лидера группы",
    HR_MENU_VOTE_ACTIONS_LEADER_TT = "Требуется 60% голосов за смену лидера.",
    HR_MENU_VOTE_ACTIONS_LEADER_CONFIRM = "Сменить лидера группы на",
    HR_MENU_VOTE_COUNTDOWN_DURATION = "Длительность обратного отсчёта",

    HR_MENU_EVENTS = "События",
    HR_MENU_EVENTS_DESC = "Этот модуль включает специальные функции в определённое время года",
    HR_MENU_EVENTS_DISABLED = "Этот модуль требует включения основного модуля Hodor Reflexes!",

    HR_MENU_MISC_TOXIC = "Токсичный режим",
    HR_MENU_MISC_TOXIC_TT = "Полезные советы и прочее.",

    -------------------------
    -- BINDINGS
    -------------------------

    HR_BINDING_PULL_COUNTDOWN = "Обратный отсчёт перед пулом",
    HR_BINDING_EXIT_INSTANCE = "Покинуть локацию немедленно",
    HR_BINDING_SEND_EXIT_INSTANCE = "Покинуть локацию всем",

    -------------------------
    -- SHARE MODULE
    -------------------------

    HR_SEND_EXIT_INSTANCE = "Выгнать группу",
    HR_SEND_EXIT_INSTANCE_CONFIRM = "Вы хотите, чтобы все покинули текущую локацию (включая себя)?",

    HR_COLOS_COUNTDOWN_DEFAULT_TEXT = "УЛЬТ",
    HR_HORN = "Горн",
    HR_COLOS = "Колосс",

    -- Damage list title
    HR_DAMAGE = "Урон",
    HR_TOTAL_DAMAGE = "Общий урон",
    HR_MISC_DAMAGE = "Разный урон",
    HR_BOSS_DPS = "Босс DPS",
    HR_TOTAL_DPS = "Общий DPS",

    HR_NOW = "Сейчас", -- HORN/COLOS: NOW!

    HR_TEST_STARTED = "Начало теста.",
    HR_TEST_STOPPED = "Конец теста.",
    HR_TEST_LEAVE_GROUP = "Необходимо выйти из группы, чтобы запустить тест.",

    -------------------------
    -- VOTE MODULE
    -------------------------

    HR_READY_CHECK = "Проверка готовности",
    HR_READY_CHECK_READY = "Все готовы!",
    HR_PULL_COUNTDOWN = "Обратный отсчёт перед пулом",
    HR_VOTE_NOT_READY_CHAT = "не готов",

    -------------------------
    -- MOCK
    -------------------------

    HR_MOCK1 = "Столько аддонов, а толку никакого.",
    HR_MOCK2 = "Возможно, вам помогут сеты Могучей Чудан, Чумной Доктор и Снаряжение Пасечника.",
    HR_MOCK3 = "Опять серверы виноваты?",
    HR_MOCK4 = "Очевидно, что проблема в лагающем подземелье.",
    HR_MOCK5 = "Попробуйте поиграть за хила или танка.",
    HR_MOCK6 = "Почему меня не предупредил аддон?",
    HR_MOCK7 = "Вы самое слабое звено, прощайте.",
    HR_MOCK8 = "Может быть, проще купить пэйран?",
    HR_MOCK9 = "Возможно, пора задуматься о ротации барьеров...",
    HR_MOCK10 = "У нас закончились советы по поводу ваших смертей.",
    HR_MOCK11 = "Если вам скучно лежать, то откройте Кронный Магазин.",
    HR_MOCK12 = "Производительность игры плохая, но ваша ещё хуже.",
    HR_MOCK13 = "У вас хорошо получается лежать на полу.",
    HR_MOCK14 = "Попробуйте установить побольше аддонов.",
    HR_MOCK15 = "У вас слишком низкий APM для этого боя.",
    HR_MOCK16 = "Не волнуйтесь, рано или поздно мы добавим достижения из этого триала в Кронный Магазин.",
    HR_MOCK17 = "Безумие делать одно и то же снова и снова, ожидая иного результата.",
    HR_MOCK18 = "В ПвЕ контенте вам необходимо убивать мобов ДО того, как они убьют вас.",
    HR_MOCK19 = "Вы никогда не думали сменить имя на \"Кенни\"?",
    HR_MOCK20 = "Даже крабы дерутся лучше чем вы.",
    HR_MOCK_AA1 = "Не представляю, как можно умирать в испытании шестилетней давности.",
    HR_MOCK_EU1 = "Зачем играть на европейском сервере, если есть американский?",
    HR_MOCK_NORMAL1 = "Это даже не ветеранский режим...",
    HR_MOCK_VET1 = "Попробуйте переключить сложность испытания на обычную.",

    -------------------------
    -- Exit Instance
    -------------------------

    HR_EXIT_INSTANCE = "Покинуть локацию",
    HR_EXIT_INSTANCE_CONFIRM = "Вы хотите покинуть текущую локацию?",

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