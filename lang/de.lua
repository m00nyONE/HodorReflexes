-- German translation by @muh, @Freebaer. @m00nyONE

local strings = {

	-------------------------
	-- MENUS
	-------------------------

	HR_MENU_GENERAL = "Allgemein",
	HR_MENU_GENERAL_ENABLED = "Aktiviert",
	HR_MENU_GENERAL_ENABLED_TT = "De-/aktiviere dieses Addon.",
	HR_MENU_GENERAL_UI_LOCKED = "UI verankert",
	HR_MENU_GENERAL_UI_LOCKED_TT = "Löse UI um alle aktivierten Elemente zu zeigen.",
	HR_MENU_GENERAL_ACCOUNT_WIDE = "Account übergreifende Einstellungen",
	HR_MENU_GENERAL_ACCOUNT_WIDE_TT = "Wechsel zwischen Account übergreifenden Einstellungen und Charakter spezifischen Einstellungen.",
	HR_MENU_GENERAL_DISABLE_PVP = "Deaktivieren in PvP",
	HR_MENU_GENERAL_DISABLE_PVP_TT = "Deaktiviert das Addon in PvP Zonen.",
	HR_MENU_GENERAL_EXIT_INSTANCE = "Verlassen der Instanz bestätigen",
	HR_MENU_GENERAL_EXIT_INSTANCE_TT = "Zeigt einen Bestätigungsdialog wenn der Gruppenleiter dich zum verlassen der Instanz auffordert.",

	HR_MENU_DAMAGE = "Schaden",
	HR_MENU_DAMAGE_SHOW = "Zeige Schaden:",
	HR_MENU_DAMAGE_SHOW_TT = "Zeige eine Liste mit verursachtem Schaden der Gruppenmitglieder.",
	HR_MENU_DAMAGE_SHOW_NEVER = "Niemals",
	HR_MENU_DAMAGE_SHOW_ALWAYS = "Immer",
	HR_MENU_DAMAGE_SHOW_OUT = "Außerhalb des Kampfes",
	HR_MENU_DAMAGE_SHOW_NONBOSS = "in Nicht-Bosskämpfen",

	HR_MENU_HORN = "Kriegshorn",
	HR_MENU_HORN_SHOW = "Zeige Kriegshorn:",
	HR_MENU_HORN_SHOW_TT = "Zeige eine Liste mit dem aktuellem Füllstand der ultimativen Fähigkeit der Gruppenmitglieder.",
	HR_MENU_HORN_SHOW_PERCENT = "Zeige Prozent",
	HR_MENU_HORN_SHOW_PERCENT_TT = "Zeige die errechnete Prozentzahl der ultimativen Fähigkeit",
	HR_MENU_HORN_SHOW_RAW = "Zeige Ulti Punkte",
	HR_MENU_HORN_SHOW_RAW_TT = "Zeige die Ulti Punkte die der Spieler hat",
	HR_MENU_HORN_SELFISH = "Egoistischer Modus:",
	HR_MENU_HORN_SELFISH_TT = "Wenn aktiviert, zeigt die aktuell verbleibende Zeit vom Kriegshorn nur an wenn du selbst von dem Bonus aktuell betroffen bist.",
	HR_MENU_HORN_ICON = "Zeige Symbol:",
	HR_MENU_HORN_ICON_TT = "Zeige ein Symbol an, mit der Anzahl der Spieler in einem 20 Meter Umkreis von dir, wenn dein Kriegshorn bereit ist.\nDas Symbol wird |c00FF00grün|r wenn alle DD im Radius des Kriegshorns sind.\nDas grüne Symbol wird |cFFFF00gelb|r wenn jemand anderes über dir in der Kriegshornliste steht. Kündige dein Kriegshorn in diesem Fall an!",
	HR_MENU_HORN_COUNTDOWN_TYPE = "Art des Countdown:",
	HR_MENU_HORN_COUNTDOWN_TYPE_TT = "- Kein: kein Countdown.\n- Eigene(s): Countdown nur für dein eigenes Kriegshorn/eigene größere Kraft.\n- Alle: Countdown für alle Kriegshörner/größere Kraft (Raidleiter).",
	HR_MENU_HORN_COUNTDOWN_TYPE_NONE = "Kein",
	HR_MENU_HORN_COUNTDOWN_TYPE_SELF = "Kriegshorn (eigenes)",
	HR_MENU_HORN_COUNTDOWN_TYPE_ALL = "Kriegshorn (alle)",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_SELF = "größere Kraft (eigene)",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_ALL = "größere Kraft (alle)",
	HR_MENU_HORN_COUNTDOWN_COLOR = "Textfarbe des Countdown:",

	HR_MENU_COLOS = "Koloss",
	HR_MENU_COLOS_SHOW = "Zeige Koloss:",
	HR_MENU_COLOS_SHOW_TT = "Zeige eine Liste mit dem aktuellem Füllstand der ultimativen Fähigkeit der Gruppenmitglieder.",
	HR_MENU_COLOS_SHOW_PERCENT = "Zeige Prozent",
	HR_MENU_COLOS_SHOW_PERCENT_TT = "Zeige die errechnete Prozentzahl der ultimativen Fähigkeit",
	HR_MENU_COLOS_SHOW_RAW = "Zeige Ulti Punkte",
	HR_MENU_COLOS_SHOW_RAW_TT = "Zeige die Ulti Punkte die der Spieler hat",
	HR_MENU_COLOS_SUPPORT_RANGE = "Zeige nur Spieler in deiner Nähe:",
	HR_MENU_COLOS_SUPPORT_RANGE_TT = "Spieler die zu weit von dir entfernt sind werden nicht in der Liste angezeigt.",
	HR_MENU_COLOS_COUNTDOWN = "Zeige Countdown an:",
	HR_MENU_COLOS_COUNTDOWN_TT = "Zeigt eine Benachrichtigung mit dem Countdown wann du deine ultimative Fähigkeit benutzen sollst an.",
	HR_MENU_COLOS_COUNTDOWN_TEXT = "Countdown Text:",
	HR_MENU_COLOS_COUNTDOWN_COLOR = "Textfarbe des Countdown:",

	HR_MENU_ATRONACH = "Atronach",
	HR_MENU_ATRONACH_SHOW = "Zeige Atronach",
	HR_MENU_ATRONACH_SHOW_TT =  "Zeige eine Liste mit dem aktuellem Füllstand der ultimativen Fähigkeit der Gruppenmitglieder.",
	HR_MENU_ATRONACH_SHOW_PERCENT = "Zeige Prozent",
	HR_MENU_ATRONACH_SHOW_PERCENT_TT = "Zeige die errechnete Prozentzahl der ultimativen Fähigkeit",
	HR_MENU_ATRONACH_SHOW_RAW = "Zeige Ulti Punkte",
	HR_MENU_ATRONACH_SHOW_RAW_TT = "Zeige die Ulti Punkte die der Spieler hat",

	HR_MENU_MISCULTIMATES = "Andere Ultimates",
	HR_MENU_MISCULTIMATES_SHOW = "Zeige alle Ultis",
	HR_MENU_MISCULTIMATES_SHOW_TT = "Zeige alle nicht unterstützten Ultis",

	HR_MENU_MISC = "Sonstiges",
	HR_MENU_MISC_DESC = "Um eine Beispielliste mit Spielern anzuzeigen/auszublenden gib |c999999/hodor.share test|r in den Chat ein.\nDu kannst ebenfalls auswählen welche Spieler angezeigt werden sollen, indem du ihre Namen angibst:\n|c999999/hodor.share test @andy.s @Alcast|r",

	HR_MENU_ICONS = "Symbole",
	HR_MENU_ICONS_VISIBILITY = "Sichtbarkeit",
	HR_MENU_ICONS_VISIBILITY_HORN = "Kriegshorn Symbole",
	HR_MENU_ICONS_VISIBILITY_HORN_TT = "Verwende benutzerdefinierte Symbole für Spieler in der Kriegshornliste.",
	HR_MENU_ICONS_VISIBILITY_DPS = "Schaden Symbole",
	HR_MENU_ICONS_VISIBILITY_DPS_TT = "Verwende benutzerdefinierte Symbole für Spieler in der Schadensliste.",
	HR_MENU_ICONS_VISIBILITY_COLOS = "Koloss Symbole",
	HR_MENU_ICONS_VISIBILITY_COLOS_TT = "Verwende benutzerdefinierte Symbole für Spieler in der Kolossliste.",
	HR_MENU_ICONS_VISIBILITY_ATRONACH = "Atronach Symbole",
	HR_MENU_ICONS_VISIBILITY_ATRONACH_TT = "Verwende benutzerdefinierte Symbole für Spieler in der Atronachenliste.",
	HR_MENU_ICONS_VISIBILITY_MISCULTIMATES = "Ultimates Symbole",
	HR_MENU_ICONS_VISIBILITY_MISCULTIMATES_TT = "Verwende benutzerdefinierte Symbole für Spieler in der Ultimates Liste.",
	HR_MENU_ICONS_VISIBILITY_COLORS = "Gefärbte Namen",
	HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Färbe die Namen anderer Spieler.",
	HR_MENU_ICONS_VISIBILITY_ANIM = "Animierte Symbole",
	HR_MENU_ICONS_VISIBILITY_ANIM_TT = "Spiele animierte Symbole ab. Achtung: die Deaktivierung dieser Funktion wird deine FPS nicht erhöhen.",

	HR_MENU_ICONS_SECTION_CUSTOM = "Benutzerdefinierte Namen & Icons",
	HR_MENU_ICONS_NOLIBSINSTALLED = "Für das volle Erlebnis von HodorReflexes stelle bitte sicher, dass die folgenden Bibliotheken installiert sind:\n\n - |cFFFF00LibCustomIcons|r – Ermöglicht personalisierte Spieler-Icons.\n - |cFFFF00LibCustomNames|r – Zeigt benutzerdefinierte Namen für Freunde, Gildenmitglieder und mehr an.\n\nDiese Bibliotheken verbessern das visuelle Erlebnis und erlauben mehr Personalisierung, sind aber für die grundlegende Funktionalität nicht erforderlich. Du entscheidest, ob du sie installieren möchtest oder nicht.",
	HR_MENU_ICONS_README_1 = "Bevor du etwas konfigurierst, lies dir bitte diese Anleitung aufmerksam durch! Nur so stellst du sicher, dass du genau das bekommst, was du erwartest.\n",
	HR_MENU_ICONS_HEADER_ICONS = "Icons & Animationen – Vorgaben:",
	HR_MENU_ICONS_README_2 = "Bitte beachte folgende technische Einschränkungen für deine Dateien:\n\n- Maximale Größe: 32×32 Pixel\n- Animationen: maximal 50 Frames\n- Erlaubte Dateiformate: .dds, .jpg, .png, .gif, .webp\n",
	HR_MENU_ICONS_HEADER_TIERS = "Donation-Stufen:",
	HR_MENU_ICONS_README_3 = "Es gibt drei Donation-Stufen, jede mit unterschiedlichen Belohnungen:\n\n1. 5M Gold – benutzerdefinierter Name\n2. 7M Gold – benutzerdefinierter Name + statisches Icon\n3. 10M Gold – benutzerdefinierter Name + statisches Icon + animiertes Icon\n\nDu kannst die gewünschte Stufe mit dem untenstehenden Slider auswählen. Bewege ihn einfach auf Position 1–3, je nachdem, welche Stufe du möchtest.\n",
	HR_MENU_ICONS_HEADER_CUSTOMIZE = "Name anpassen:",
	HR_MENU_ICONS_README_4 = "Nutze den untenstehenden Konfigurator, um deinen Namen anzupassen.\n",
	HR_MENU_ICONS_HEADER_TICKET = "Ticket im Discord erstellen",
	HR_MENU_ICONS_README_5 = "1. Klicke in die Textbox mit dem generierten LUA-Code.\n2. Drücke STRG+A, um alles zu markieren.\n3. Drücke STRG+C, um den Inhalt zu kopieren.",
	HR_MENU_ICONS_README_6 = "\nÖffne anschließend ein Ticket auf unserem Discord-Server – wähle die passende Donation-Stufe – und füge den Code sowie das Icon in das Ticket ein.",
	HR_MENU_ICONS_HEADER_DONATION = "Spende senden:",
	HR_MENU_ICONS_README_7 = "Sobald du dein Ticket auf Discord erstellt hast:\n\n1. Klicke auf die Schaltfläche „%s“.\n2. Gib deine Ticketnummer im Feld ticket-XXXXX ein.\n3. Sende das Gold entsprechend deiner gewählten Donation-Stufe.",
	HR_MENU_ICONS_HEADER_INFO = "Info:",
	HR_MENU_ICONS_INFO = "- Dies ist ein spendenbasierter Service.\n- Du kaufst keine Icons und erwirbst keine Besitzrechte daran.\n- Es handelt sich um eine freiwillige Spende mit kosmetischem Nutzen innerhalb von Addons, die LibCustomNames und LibCustomIcons verwenden.\n- Du musst dich an die Nutzungsbedingungen von ZoS halten – Namen mit Schimpfwörtern oder unangebrachte Icons werden abgelehnt!\n- Wenn du weißt, wie man programmiert, kannst du auch jederzeit Pull Requests auf GitHub mit deinem Namen und Icon senden – ganz ohne Spende.",

	HR_MENU_ICONS_CONFIGURATOR_DISCORD = "Discord beitreten",
	HR_MENU_ICONS_CONFIGURATOR_DISCORD_TT = "Tritt dem HodorReflexes-Discord bei, um ein Ticket zu erstellen.",
	HR_MENU_ICONS_README_DONATION_TIER = "Donation-Stufe: ",
	HR_MENU_ICONS_README_DONATION_TIER_TT = "Wenn du die Donation-Stufe änderst, wird im Konfigurator unten zusätzlicher LUA-Code erzeugt – abhängig von der gewählten Stufe.",
	HR_MENU_ICONS_CONFIGURATOR_LUA_TT = "Klicke in die Textbox und drücke STRG+A, um den gesamten Code zu markieren. Drücke anschließend STRG+C, um ihn in die Zwischenablage zu kopieren.",
	HR_MENU_ICONS_CONFIGURATOR_DONATE_TT = "öffnet den eine Mail und schreibt etwas text hinein.",

	HR_MENU_STYLE = "Style",
	HR_MENU_STYLE_DPS = "Schadensliste",
	HR_MENU_STYLE_DPS_FONT = "Schriftart der Zahlen:",
	HR_MENU_STYLE_DPS_FONT_DEFAULT = "Standard",
	HR_MENU_STYLE_DPS_FONT_GAMEPAD = "Gamepad",
	HR_MENU_STYLE_DPS_BOSS_COLOR = "Schriftfarbe für Schaden an Bossen:",
	HR_MENU_STYLE_DPS_TOTAL_COLOR = "Schriftfarbe für Gesamtschaden:",
	HR_MENU_STYLE_DPS_HEADER_OPACITY = "Transparenz der Überschrift:",
	HR_MENU_STYLE_DPS_EVEN_OPACITY = "Transparenz gerader Zeilen:",
	HR_MENU_STYLE_DPS_ODD_OPACITY = "Transparenz ungerader Zeilen:",
	HR_MENU_STYLE_DPS_HIGHLIGHT = "hervorgehobene Farbe:",
	HR_MENU_STYLE_DPS_HIGHLIGHT_TT = "Dein Name wird in der hervorgehobenen Farbe in der Schadensliste angezeigt. Wenn du deinen Namen nicht hervorheben möchtest, setze die Transparenz auf 0. Der Name wird ausschließlich für dich hervorgehoben.",
	HR_MENU_STYLE_HORN_COLOR = "Kriegshorn verbleibene Zeit Farbe",
	HR_MENU_STYLE_FORCE_COLOR = "Größere Kraft verbleibende Zeit Farbe",
	HR_MENU_STYLE_ATRONACH_COLOR = "Atronach verbleibende Zeit Farbe",
	HR_MENU_STYLE_BERSERK_COLOR = "Major Berserk verbleibende Zeit Farbe",
	HR_MENU_STYLE_COLOS_COLOR = "Koloss verbleibende Zeit Farbe",
	HR_MENU_STYLE_TIMER_OPACITY = "Ausgelaufener Timer Transparenz",
	HR_MENU_STYLE_TIMER_OPACITY_TT = "Text- und Icontransparenz wenn der Timer 0 erreicht",
	HR_MENU_STYLE_TIMER_BLINK = "Blinkende TImer",
	HR_MENU_STYLE_TIMER_BLINK_TT = "Die TImer blinken wenn sie 0 erreichen. Danach wird die Transparenz angewendet.",

	HR_MENU_ANIMATIONS = "Animierte Benachrichtigungen",
	HR_MENU_ANIMATIONS_TT = "Animiert Horn und Koloss Countdowns um sie sichtbarer zu machen.",

	HR_MENU_VOTE = "Abstimmung",
	HR_MENU_VOTE_DISABLED = "Für dieses Modul muss Hodor Reflexes aktiviert sein!",
	HR_MENU_VOTE_DESC = "Dieses Modul verbessert die eingebaute Bereitschaftabfrage und ermöglicht es zu sehen wer bereit oder nicht bereit ist sofern Gruppenmitglieder Hodor Reflexes aktiviert haben.",
	HR_MENU_VOTE_ENABLED_TT = "De-/Aktiviere dieses Modul. Wenn deaktiviert können andere Spieler das Ergebnis deiner Abstimmung nicht sehen.",
	HR_MENU_VOTE_CHAT = "Chat Nachrichten",
	HR_MENU_VOTE_CHAT_TT = "Zeigt Abstimmungsergebnisse und andere Informationen im Chatfenster an.",
	HR_MENU_VOTE_ACTIONS = "Aktionen",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN = "Countdown",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_TT = "Startet einen Countdown mit der oben angegebenen Zeit. Du musst der Gruppenleiter sein um das zu tun.",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM = "Du musst der Gruppenleiter sein um einen Countdown zu starten!",
	HR_MENU_VOTE_ACTIONS_LEADER = "Ändere Gruppenleiter",
	HR_MENU_VOTE_ACTIONS_LEADER_TT = "60% der Gruppenmitglieder müssen mit Ja abstimmen.",
	HR_MENU_VOTE_ACTIONS_LEADER_CONFIRM = "Ändere Gruppenleiter zu",
	HR_MENU_VOTE_COUNTDOWN_DURATION = "Countdown Zeit",

	HR_MENU_EVENTS = "Events",
	HR_MENU_EVENTS_DESC = "Dieses Modul aktiviert verschiedene Funktionen über das Jahr hinweg.",
	HR_MENU_EVENTS_DISABLED = "Für dieses Modul muss Hodor Reflexes aktiviert sein!",

	HR_MENU_MISC_TOXIC = "Toxic mode",
	HR_MENU_MISC_TOXIC_TT = "Verändert deine Todesrückblicke mit toxischen Inhalten.",

	-------------------------
	-- BINDINGS
	-------------------------

	HR_BINDING_PULL_COUNTDOWN = "Pull Countdown",
	HR_BINDING_EXIT_INSTANCE = "Instanz sofort verlassen",
	HR_BINDING_SEND_EXIT_INSTANCE = "Gruppe rauswerfen",

	-------------------------
	-- SHARE MODULE
	-------------------------

	HR_SEND_EXIT_INSTANCE = "Gruppe rauswerfen",
	HR_SEND_EXIT_INSTANCE_CONFIRM = "Möchtest du deine Gruppenmitglieder auffordern die Instanz zu verlassen (dich eingeschlossen)?",

	HR_COLOS_COUNTDOWN_DEFAULT_TEXT = "ULT",
	HR_HORN = "Kriegshorn",
	HR_COLOS = "Koloss",

	-- Damage list title
	HR_DAMAGE = "Schaden",
	HR_TOTAL_DAMAGE = "Gesamtschaden",
	HR_MISC_DAMAGE = "Sonstiges",
	HR_BOSS_DPS = "Boss DPS",
	HR_TOTAL_DPS = "Gesamt DPS",

	HR_NOW = "JETZT", -- HORN/COLOS: NOW!

	HR_TEST_STARTED = "Test gestartet.",
	HR_TEST_STOPPED = "Test gestoppt.",
	HR_TEST_LEAVE_GROUP = "Verlasse deine Gruppe um testen zu können",

	-------------------------
	-- VOTE MODULE
	-------------------------

	HR_READY_CHECK = "Bereitschaftsabfrage",
	HR_READY_CHECK_READY = "Alle sind bereit!",
	HR_PULL_COUNTDOWN = "Pull Countdown",
	HR_VOTE_NOT_READY_CHAT = "ist nicht bereit",

	-------------------------
	-- Exit Instance
	-------------------------

	HR_EXIT_INSTANCE = "Instanz verlassen",
	HR_EXIT_INSTANCE_CONFIRM = "Möchtest du die aktuelle Instanz wirklich verlassen?",

	-------------------------
	-- Missing Libraries
	-------------------------

	HR_MISSING_LIBS_TITLE = "Hol dir das volle HodorReflexes-Erlebnis!",
	HR_MISSING_LIBS_TEXT = "|c00FF00Du verpasst das volle HodorReflexes-Erlebnis!|r\n\nInstalliere |cFFFF00LibCustomIcons|r und |cFFFF00LibCustomNames|r, um benutzerdefinierte Icons, Spitznamen und Stile von anderen Hodor-Nutzern – einschließlich deiner Freunde und Gildenmitglieder – zu sehen. Verwandle das Schlachtfeld in etwas Persönliches und Charaktervolles!\n\nDas ist vollkommen optional und nicht erforderlich, damit HodorReflexes funktioniert.",
	HR_MISSING_LIBS_OK = "OK",
	HR_MISSING_LIBS_DONTSHOWAGAIN = "Nicht noch einmal anzeigen",

}

for id, val in pairs(strings) do
   ZO_CreateStringId(id, val)
   SafeAddVersion(id, 1)
end