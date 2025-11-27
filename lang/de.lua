-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {

    ------------------------- CORE -------------------------
    -- VISIBILITY
    HR_VISIBILITY_SHOW_NEVER = "Niemals",
    HR_VISIBILITY_SHOW_ALWAYS = "Immer",
    HR_VISIBILITY_SHOW_OUT_OF_COMBAT = "Außerhalb des Kampfes",
    HR_VISIBILITY_SHOW_NON_BOSSFIGHTS = "in Nicht-Bosskämpfen",
    HR_VISIBILITY_SHOW_IN_COMBAT = "Nur im Kampf",
    -- HUD
    HR_CORE_HUD_COMMAND_LOCK_HELP = "Sperre das UI",
    HR_CORE_HUD_COMMAND_UNLOCK_HELP = "Entsperre das UI",
    HR_CORE_HUD_COMMAND_LOCK_ACTION = "UI gesperrt",
    HR_CORE_HUD_COMMAND_UNLOCK_ACTION = "UI entsperrt",
    -- Group
    HR_CORE_GROUP_COMMAND_TEST_HELP = "Test starten/stoppen",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_START = "Test gestartet",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_STOP = "Test gestoppt",
    HR_CORE_GROUP_COMMAND_TEST_LEAVE_GROUP = "Du musst die Gruppe verlassen, um einen Test zu starten",
	-- LibCheck
    HR_MISSING_LIBS_TITLE = "Hol dir das volle HodorReflexes-Erlebnis!",
    HR_MISSING_LIBS_TEXT = "|c00FF00Du verpasst das volle HodorReflexes-Erlebnis!|r\n\nInstalliere |cFFFF00LibCustomIcons|r und |cFFFF00LibCustomNames|r, um benutzerdefinierte Icons, Spitznamen und Stile von anderen Hodor-Nutzern – einschließlich deiner Freunde und Gildenmitglieder – zu sehen. Verwandle das Schlachtfeld in etwas Persönliches und Charaktervolles!\n\nDas ist vollkommen optional und nicht erforderlich, damit HodorReflexes funktioniert.",
    HR_MISSING_LIBS_TEXT_CONSOLE = "|c00FF00Du verpasst das volle HodorReflexes-Erlebnis!|r\n\nInstalliere |cFFFF00LibCustomNames|r, um benutzerdefinierte Spitznamen und Stile von anderen Hodor-Nutzern – einschließlich deiner Freunde und Gildenmitglieder – zu sehen. Verwandle das Schlachtfeld in etwas Persönliches und Charaktervolles!\n\nDas ist vollkommen optional und nicht erforderlich, damit HodorReflexes funktioniert.",
    HR_MISSING_LIBS_DONTSHOWAGAIN = "Nicht noch einmal anzeigen",
    -- Menu
    HR_MENU_GENERAL = "Allgemein",
    HR_MENU_MODULES = "Module",
    HR_MENU_EXTENSIONS = "Erweiterungen",
    HR_MENU_RESET_MESSAGE = "Einstellungen wurden zurückgesetzt! Manches benötigt vielleicht ein /reloadui",
    HR_MENU_RELOAD = "Reload UI",
    HR_MENU_RELOAD_TT = "Lädt die Benutzeroberfläche neu, um Änderungen zu übernehmen.",
    HR_MENU_RELOAD_HIGHLIGHT = "|cffff00Gelb|r markierte Einstellungen benötigen ein neuladen der Benutzeroberfläche",
    HR_MENU_TESTMODE = "Test Modus umschalten",
    HR_MENU_TESTMODE_TT = "Schaltet den Testmodus ein oder aus. Das funktioniert NICHT wenn du in einer Gruppe bist!",
    HR_MENU_LOCKUI = "UI Sperren",
    HR_MENU_LOCKUI_TT = "Sperrt/Entsperrt die HUD-Benutzeroberfläche",
    HR_MENU_ACCOUNTWIDE = "Accountweite Einstellungen",
    HR_MENU_ACCOUNTWIDE_TT = "Wenn aktiviert, werden die Einstellungen für alle Charaktere auf diesem Account übernommen.",
    HR_MENU_ADVANCED_SETTINGS = "Erweiterte Einstellungen",
    HR_MENU_ADVANCED_SETTINGS_TT = "Zeigt erweiterte Einstellungen im Menü an.",
    HR_MENU_HORIZONTAL_POSITION = "Horizontal Position",
    HR_MENU_HORIZONTAL_POSITION_TT = "Stellt die horizontale Position ein.",
    HR_MENU_VERTICAL_POSITION = "Vertikale Position",
    HR_MENU_VERTICAL_POSITION_TT = "Stellt die vertikale Position ein.",
    HR_MENU_SCALE = "Skalierung",
    HR_MENU_SCALE_TT = "Stellt die Skalierung des Elements ein.",
    HR_MENU_DISABLE_IN_PVP = "Im PvP deaktivieren",
    HR_MENU_DISABLE_IN_PVP_TT = "Deaktiviert das Element automatisch, wenn du dich in einem PvP-Gebiet befindest.",
    HR_MENU_VISIBILITY = "Sichtbarkeit",
    HR_MENU_VISIBILITY_TT = "Legt fest, wann das Element angezeigt wird.",
    HR_MENU_LIST_WIDTH = "Listenbreite",
    HR_MENU_LIST_WIDTH_TT = "Legt die Breite der Liste fest.",
    -- general strings
    HR_UNIT_SECONDS = "Sekunden",

    ------------------------- MODULES -------------------------
    -- DPS
    HR_MODULES_DPS_FRIENDLYNAME = "Schaden",
    HR_MODULES_DPS_DESCRIPTION = "Ermöglicht es dir, die Schadensstatistiken deiner Gruppe zu sehen.",
    HR_MODULES_DPS_DAMAGE = "Schaden",
    HR_MODULES_DPS_DAMAGE_TOTAL = "Gesamtschaden",
    HR_MODULES_DPS_DAMAGE_MISC = "Sonstiges",
    HR_MODULES_DPS_DPS_BOSS = "Boss DPS",
    HR_MODULES_DPS_DPS_TOTAL = "Gesamt DPS",
    HR_MODULES_DPS_MENU_HEADER = "Schadensliste",
    HR_MODULES_DPS_MENU_SHOW_SUMMARY = "Zusammenfassungszeile anzeigen",
    HR_MODULES_DPS_MENU_SHOW_SUMMARY_TT = "Wenn aktiviert, wird eine Zusammenfassungszeile mit den Gesamtschadenszahlen der Gruppe unten in der Liste angezeigt.",
    HR_MODULES_DPS_SUMMARY_GROUP_TOTAL = "Gruppe: ",
    -- EXIT INSTANCE
    HR_MODULES_EXITINSTANCE_FRIENDLYNAME = "Instanz verlassen",
    HR_MODULES_EXITINSTANCE_DESCRIPTION = "Ermöglicht es dir, Anfragen zum Verlassen der Instanz an deine Gruppe zu senden.",
    HR_MODULES_EXITINSTANCE_BINDING_SENDEJECT = "Gruppe rauswerfen",
    HR_MODULES_EXITINSTANCE_BINDING_EXITINSTANCE = "Instanz sofort verlassen",
    HR_MODULES_EXITINSTANCE_COMMAND_HELP = "Sendet eine Anfrage an deine Gruppe, die aktuelle Instanz zu verlassen.",
    HR_MODULES_EXITINSTANCE_NOT_LEADER = "Du musst Gruppenleiter sein, um eine Instanz-verlassen-Anfrage zu starten!",
    HR_MODULES_EXITINSTANCE_SENDEXITINSTANCE_DIALOG_TITLE = "Gruppe rauswerfen",
    HR_MODULES_EXITINSTANCE_SENDEXITINSTANCE_DIALOG_TEXT = "Möchtest du, dass alle die Instanz verlassen (einschließlich dir selbst)?",
    HR_MODULES_EXITINSTANCE_EXITINSTANCE_DIALOG_TITLE = "Instanz verlassen",
    HR_MODULES_EXITINSTANCE_EXITINSTANCE_DIALOG_TEXT = "Möchtest du die aktuelle Instanz sofort verlassen?",
    HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT = "Verlassen bestätigen",
    HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT_TT = "Wenn aktiviert, wirst du vor dem Verlassen der Instanz um Bestätigung gebeten.",
    HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS = "Anfragen ignorieren",
    HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS_TT = "Wenn aktiviert, ignorierst du alle Instanz-verlassen-Anfragen deines Gruppenleiters.",
    -- HIDEME
    HR_MODULES_HIDEME_FRIENDLYNAME = "Hide Me",
    HR_MODULES_HIDEME_DESCRIPTION = "Erlaubt es dir einige deiner Statistiken von den Listen anderer Gruppenmitglieder zu verbergen.",
    HR_MODULES_HIDEME_HIDEDAMAGE_LABEL = "Verberge Schaden",
    HR_MODULES_HIDEME_HIDEDAMAGE_DESCRIPTION = "Verberge deine Schadenszahlen von der DPS-Liste anderer Gruppenmitglieder.",
    HR_MODULES_HIDEME_HIDEHORN_LABEL = "Verberge Horn",
    HR_MODULES_HIDEME_HIDEHORN_DESCRIPTION = "Verberge dein Horn von den Listen.",
    HR_MODULES_HIDEME_HIDECOLOS_LABEL = "Verberge Koloss",
    HR_MODULES_HIDEME_HIDECOLOS_DESCRIPTION = "Verberge deinen Koloss von den Listen.",
    HR_MODULES_HIDEME_HIDEATRO_LABEL = "Verberge Atronach",
    HR_MODULES_HIDEME_HIDEATRO_DESCRIPTION = "Verberge deinen Atronach von den Listen.",
    HR_MODULES_HIDEME_HIDESAXHLEEL_LABEL = "Verberge Saxhleel",
    HR_MODULES_HIDEME_HIDESAXHLEEL_DESCRIPTION = "Verberge dein Saxhleel von den Listen.",
    HR_MODULES_HIDEME_HIDEBARRIER_LABEL = "Verberge Barriere",
    HR_MODULES_HIDEME_HIDEBARRIER_DESCRIPTION = "Verberge deine Barriere von den Listen.",
    HR_MODULES_HIDEME_MENU_HEADER = "Hide Me Einstellungen",
    -- PULL
    HR_MODULES_PULL_FRIENDLYNAME = "Pull Countdown",
    HR_MODULES_PULL_DESCRIPTION = "Erlaubt es dir pull countdowns an deine Gruppe zu senden.",
    HR_MODULES_PULL_BINDING_COUNTDOWN = "Pull Countdown",
    HR_MODULES_PULL_COUNTDOWN_DURATION = "Countdown Dauer",
    HR_MODULES_PULL_COUNTDOWN_DURATION_TT = "Setzt die standard COuntdown Dauer in Sekunden.",
    HR_MODULES_PULL_NOT_LEADER = "Du musst der Gruppenleiter sein um einen Countdown zu starten!",
    HR_MODULES_PULL_COMMAND_HELP = "Startet einen Pull Countdown mit der angegebenen Dauer in Sekunden.",
    -- READYCHECK
    HR_MODULES_READYCHECK_FRIENDLYNAME = "Bereitschaftscheck",
    HR_MODULES_READYCHECK_DESCRIPTION = "Erweitert den Bereitschaftscheck und zeigt wer bereit ist und wer nicht.",
    HR_MODULES_READYCHECK_TITLE = "Bereitschaftscheck",
    HR_MODULES_READYCHECK_READY = "Bereit",
    HR_MODULES_READYCHECK_NOT_READY = "Nicht bereit",
    HR_MODULES_READYCHECK_MENU_UI = "Fenster anzeigen",
    HR_MODULES_READYCHECK_MENU_UI_TT = "Zeigt das Bereitschaftscheck-Fenster an.",
    HR_MODULES_READYCHECK_MENU_CHAT = "Chat-Ausgabe",
    HR_MODULES_READYCHECK_MENU_CHAT_TT = "Gibt die Bereitschaftscheck-Ergebnisse im Chat aus.",
    -- SKILL LINES
    HR_MODULES_SKILLLINES_FRIENDLYNAME = "Skill Lines",
    HR_MODULES_SKILLLINES_DESCRIPTION = "Erlaubt es dir zu sehen welche Subclassing Skill Lines deine Gruppenmitglieder verwenden.",
    -- ULT
    HR_MODULES_ULT_FRIENDLYNAME = "Ultimates",
    HR_MODULES_ULT_DESCRIPTION = "Ermöglicht es dir, die Ultimate-Statistiken deiner Gruppe zu sehen.",

    ------------------------- EXTENSIONS -------------------------
    -- ANIMATIONS
    HR_EXTENSIONS_ANIMATIONS_FRIENDLYNAME = "Animationen",
    HR_EXTENSIONS_ANIMATIONS_DESCRIPTION = "Erweiterung zur Bereitstellung von benutzerdefinierten animierten Icons über LibCustomIcons.",
    -- ICONS
    HR_EXTENSIONS_ICONS_FRIENDLYNAME = "Icons",
    HR_EXTENSIONS_ICONS_DESCRIPTION = "Erweiterung zur Bereitstellung von benutzerdefinierten statischen Icons über LibCustomIcons.",
    -- NAMES
    HR_EXTENSIONS_NAMES_FRIENDLYNAME = "Namen",
    HR_EXTENSIONS_NAMES_DESCRIPTION = "Erweiterung zur Bereitstellung von benutzerdefinierten Namen über LibCustomNames.",
    -- SEASONS
    HR_EXTENSIONS_SEASONS_FRIENDLYNAME = "Saisons",
    HR_EXTENSIONS_SEASONS_DESCRIPTION = "Schaltet einige saisonale Ereignisse frei, die im Laufe des Jahres verfügbar sind.",
    -- CONFIGURATOR
    HR_EXTENSIONS_CONFIGURATOR_FRIENDLYNAME = "Configurator",
    HR_EXTENSIONS_CONFIGURATOR_DESCRIPTION = "Allows you to request a custom name/icon yourself with an easy to use editor.",
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
}

for id, val in pairs(strings) do
   ZO_CreateStringId(id, val)
   SafeAddVersion(id, 1)
end