local strings = {

	-------------------------
	-- MENUS
	-------------------------

	HR_MENU_GENERAL = "Общие",
	HR_MENU_GENERAL_ENABLED = "Включить",
	HR_MENU_GENERAL_ENABLED_TT = "Включить/отключить аддон. Если аддон отключён, то он не будет обрабатывать метки на карте от других игроков.",
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
	HR_MENU_DAMAGE_SHARE = "Отправлять мой урон:",
	HR_MENU_DAMAGE_SHARE_TT = "Отправлять мой урон другим членам группы.",

	HR_MENU_HORN = "Горн",
	HR_MENU_HORN_SHOW = "Показывать горны группы:",
	HR_MENU_HORN_SHOW_TT = "Показывать список с готовностью горнов группы.",
	HR_MENU_HORN_SHARE = "Отправлять мой горн:",
	HR_MENU_HORN_SHARE_TT = "Отправлять процент готовности моего горна другим членам группы, если он есть на панели способностей. При использовании сета Saxhleel можно отправлять либо суперспособность с наибольшей стоимостью, либо процент от 250 очков.",
	HR_MENU_HORN_SHARE_NONE = "Отключить",
	HR_MENU_HORN_SHARE_HORN = "Только горн",
	HR_MENU_HORN_SHARE_SAXHLEEL1 = "Горн или Saxhleel (наибольшая стоимость)",
	HR_MENU_HORN_SHARE_SAXHLEEL250 = "Горн или Saxhleel (250 очк.)",
	HR_MENU_HORN_SELFISH = "Жадный режим:",
	HR_MENU_HORN_SELFISH_TT = "Если включён, то оставшееся время действия горна будет отображаться, только если его эффект активен на моём персонаже.",
	HR_MENU_HORN_ICON = "Дополнительная иконка:",
	HR_MENU_HORN_ICON_TT = "Показать иконку с числом игроков в зоне действия горна (20 метров), когда он готов.\nИконка становится |c00FF00зелёной|r, когда все бойцы находятся в зоне действия горна.\nЗелёная иконка заменяется |cFFFF00жёлтой|r, если вы не первый в списке горнов. Не забудьте анонсировать его в этом случае!",
	HR_MENU_HORN_COUNTDOWN_TYPE = "Обратный отсчёт:",
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
	HR_MENU_COLOS_SHARE = "Отправлять моего колосса:",
	HR_MENU_COLOS_SHARE_TT = "Отправлять процент готовности моего колосса другим членам группы, если он есть на панели способностей.",
	HR_MENU_COLOS_PRIORITY = "Приоритет:",
	HR_MENU_COLOS_PRIORITY_TT = "- Стандартный: максимальная готовность 200%.\n- Танк: отправлять 201%, если моя роль Танк, и колосс готов.\n- Всегда: отправлять 201%, если колосс готов.\n- Никогда: отправлять не более 99%.\n|cFFFFFFЗамечание: отправка 99% или 201% вместо 100% повлияет на отправляемый процент готовности моего горна.|r",
	HR_MENU_COLOS_PRIORITY_DEFAULT = "Стандартный",
	HR_MENU_COLOS_PRIORITY_TANK = "Танк",
	HR_MENU_COLOS_PRIORITY_ALWAYS = "Всегда",
	HR_MENU_COLOS_PRIORITY_NEVER = "Никогда",
	HR_MENU_COLOS_SUPPORT_RANGE = "Только ближайшие союзники:",
	HR_MENU_COLOS_SUPPORT_RANGE_TT = "Игроки, которые слишком далеко от вас, не будут отображаться в списке колоссов.",
	HR_MENU_COLOS_COUNTDOWN = "Обратный отсчёт:",
	HR_MENU_COLOS_COUNTDOWN_TT = "Показать уведомление, когда можно использовать суперспособность.",
	HR_MENU_COLOS_COUNTDOWN_TEXT = "Текст обратного отсчёта:",
	HR_MENU_COLOS_COUNTDOWN_COLOR = "Цвет обратного отсчёта:",

	HR_MENU_MISC = "Разное",
	HR_MENU_MISC_DESC = "Чтобы показать/спрятать тестовый список игроков, введите команду\n|c999999/hodor.share test|r в чате.\nМожно так же указать имена игроков, которых необходимо отобразить: \n|c999999/hodor.share test @andy.s @Alcast|r",

	HR_MENU_ICONS = "Иконки",
	HR_MENU_ICONS_README = "Прочти меня (нажми, чтобы открыть)",
	HR_MENU_ICONS_MY = "Моя иконка",
	HR_MENU_ICONS_NAME_VAL = "Моё имя",
	HR_MENU_ICONS_NAME_VAL_TT = "По умолчанию аддон показывает ваш ID игрока. Можно заменить его на другое.",
	HR_MENU_ICONS_GRADIENT = "Градиент",
	HR_MENU_ICONS_GRADIENT_TT = "Создать градиент на основе цветов ниже.",
	HR_MENU_ICONS_COLOR1 = "Начальный цвет",
	HR_MENU_ICONS_COLOR2 = "Конечный цвет",
	HR_MENU_ICONS_PREVIEW = "Предварительный просмотр",
	HR_MENU_ICONS_LUA = "LUA код:",
	HR_MENU_ICONS_LUA_TT = "Код генерируется автоматически на основе выбранных выше настроек. Отправьте его автору аддона вместе со своей иконкой.",
	HR_MENU_ICONS_LUA_TT = "После изменения пути иконки может потребоваться перезапуск игры. Отправьте этот код автору аддона вместе с файлом иконки.",
	HR_MENU_ICONS_VISIBILITY = "Видимость",
	HR_MENU_ICONS_VISIBILITY_HORN = "Иконки в списке горнов",
	HR_MENU_ICONS_VISIBILITY_HORN_TT = "Показывать иконки игроков в списке горнов.",
	HR_MENU_ICONS_VISIBILITY_DPS = "Иконки в списке урона",
	HR_MENU_ICONS_VISIBILITY_DPS_TT = "Показывать иконки игроков в списке урона.",
	HR_MENU_ICONS_VISIBILITY_COLOS = "Иконки в списке колоссов",
	HR_MENU_ICONS_VISIBILITY_COLOS_TT = "Показывать иконки игроков в списке колоссов.",
	HR_MENU_ICONS_VISIBILITY_COLORS = "Цветные имена",
	HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Показывать цветные имена игроков.",
	HR_MENU_ICONS_VISIBILITY_ANIM = "Анимированные иконки",
	HR_MENU_ICONS_VISIBILITY_ANIM_TT = "Показывать анимированные иконки. Замечание: отключение этой настройки не повлияет на FPS.",

	HR_MENU_ICONS_README1 = "С помощью настроек ниже можно выбрать цвет и иконку для своего имени в аддоне. Однако никто не увидит эти изменения, пока вы не отправите автору аддона сгенерированный LUA код.",
	HR_MENU_ICONS_README2 = "Игра поддерживает изображения только в формате DirectDraw Surface. Требуемый размер для аддона: 32x32 пикселей. Можно не конвертировать изображение самому, а просто отправить оригинал вместе с LUA кодом.",
	HR_MENU_ICONS_README3 = "Нажмите \"%s\" вверху этого меню для пошаговой инструкции, как связаться с автором и получить персональную иконку в аддоне. Не нужно задавать вопросы, используя внутриигровую почту!",

	HR_MENU_STYLE = "Стили",
	HR_MENU_STYLE_PINS = "Показывать метки на карте",
	HR_MENU_STYLE_PINS_TT = "Показывать метки игроков на карте мира и компасе.",
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
	HR_MENU_STYLE_COLOS_COLOR = "Цвет длительности колосса",
	HR_MENU_STYLE_TIMER_OPACITY = "Прозрачность истёкшего таймера",
	HR_MENU_STYLE_TIMER_OPACITY_TT = "Прозрачность текста и иконки, когда таймер достигает значения 0.0",
	HR_MENU_STYLE_TIMER_BLINK = "Мигающие таймеры",
	HR_MENU_STYLE_TIMER_BLINK_TT = "Таймеры сначала мигают, когда достигают значения 0.0, затем применяется прозрачность.",

	HR_MENU_ANIMATIONS = "Анимация сообщений",
	HR_MENU_ANIMATIONS_TT = "Более заметный анимированныый обратный отсчёт горна и колосса.",

	HR_MENU_VOTE = "Голосование",
	HR_MENU_VOTE_DISABLED = "Этот модуль требует включения основного модуля Hodor Reflexes!",
	HR_MENU_VOTE_DESC = "Этот модуль улучшает стандартное голосование группы, позволяя видеть голоса других игроков, если у них включён аддон Hodor Reflexes.",
	HR_MENU_VOTE_ENABLED_TT = "Включить/отключить этот модуль. Если модуль отключён, то другие игроки не увидят ваш голос.",
	HR_MENU_VOTE_CHAT = "Сообщения в чате",
	HR_MENU_VOTE_CHAT_TT = "Показывать результат голосования и прочие сообщения в чате.",
	HR_MENU_VOTE_ACTIONS = "Действия",
	HR_MENU_VOTE_ACTIONS_RC = "Проверка готовности",
	HR_MENU_VOTE_ACTIONS_RC_TT = "Запустить проверку готовности.",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN = "Обратный отсчёт",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_TT = "Запустить обратный отсчёт длительностью, выбранной выше. Необходимо быть лидером группы.",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM = "Необходимо быть лидером группы, чтобы запустить обратный отсчёт!",
	HR_MENU_VOTE_ACTIONS_LEADER = "Сменить лидера группы",
	HR_MENU_VOTE_ACTIONS_LEADER_TT = "Требуется 60% голосов за смену лидера.",
	HR_MENU_VOTE_ACTIONS_LEADER_CONFIRM = "Сменить лидера группы на",
	HR_MENU_VOTE_COUNTDOWN_DURATION = "Длительность обратного отсчёта",

	HR_MENU_MISC_TOXIC = "Токсичный режим",
	HR_MENU_MISC_TOXIC_TT = "Полезные советы и прочее.",

	-------------------------
	-- BINDINGS
	-------------------------

	HR_BINDING_HORN_SHARE = "Переключить отправку горна",
	HR_BINDING_COLOS_SHARE = "Переключить отправку колосса",
	HR_BINDING_DPS_SHARE = "Переключить отправку урона",
	HR_BINDING_COUNTDOWN = "Обратный отсчёт",
	HR_BINDING_EXIT_INSTANCE = "Покинуть локацию немедленно",
	HR_BINDING_SEND_EXIT_INSTANCE = "Покинуть локацию всем",

	-------------------------
	-- SHARE MODULE
	-------------------------

	HR_SEND_EXIT_INSTANCE = "Покинуть всем",
	HR_SEND_EXIT_INSTANCE_CONFIRM = "Вы хотите, чтобы все покинули текущую локацию (включая себя)?",

	HR_COLOS_COUNTDOWN_DEFAULT_TEXT = "Колосс",
	HR_HORN = "Горн",
	HR_MAJOR_FORCE = "Сила",
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
	HR_COUNTDOWN = "Обратный отсчёт",
	HR_COUNTDOWN_START = "Старт через",
	HR_READY_CHECK_INIT_CHAT = "запустил проверку готовности",
	HR_COUNTDOWN_INIT_CHAT = "запустил обратный отсчёт",
	HR_VOTE_NOT_READY_CHAT = "не готов",
	HR_VOTE_LEADER_CHAT = "хочет сменить лидера группы",

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
	-- Updated window
	-------------------------

	HR_UPDATED_TEXT = "Hodor Reflexes был успешно обновлён, или нет? К сожалению, при обновлении через Minion есть шанс, что некоторые файлы аддона не скачаются. Обычно это только иконки, но не всегда. Под этим сообщением есть пять картинок из разных директорий аддона. Если вы не видите одну из них, то закройте игру и переустановите аддон. В противном случае просто закройте это окно.",
	HR_UPDATED_DISMISS = "Я вижу пять иконок!",

	HR_MISSING_ICON = "Не удалось загрузить вашу иконку Hodor Reflexes. Переустановите аддон или скачайте его вручную с сайта esoui.com и перезапустите игру.",

}

for id, val in pairs(strings) do
	SafeAddString(_G[id], val, 1)
end