-- German translation by @muh, @Freebaer

local strings = {

	-------------------------
	-- MENUS
	-------------------------

	HR_MENU_GENERAL = "Allgemein",
	HR_MENU_GENERAL_ENABLED = "Aktiviert",
	HR_MENU_GENERAL_ENABLED_TT = "De-/aktiviere dieses Addon. Wenn deaktiviert, werden von dem Addon Pings auf der Karte stumm geschaltet und Pings von anderen Spielern verarbeitet.",
	HR_MENU_GENERAL_UI_LOCKED = "UI verankert",
	HR_MENU_GENERAL_UI_LOCKED_TT = "Löse UI um alle aktivierten Elemente zu zeigen.",
	HR_MENU_GENERAL_ACCOUNT_WIDE = "Account übergreifende Einstellungen",
	HR_MENU_GENERAL_ACCOUNT_WIDE_TT = "Wechsel zwischen Account übergreifenden Einstellungen und Charakter spezifischen Einstellungen.",

	HR_MENU_DAMAGE = "Schaden",
	HR_MENU_DAMAGE_SHOW = "Zeige Schaden:",
	HR_MENU_DAMAGE_SHOW_TT = "Zeige eine Liste mit verursachtem Schaden der Gruppenmitglieder.",
	HR_MENU_DAMAGE_SHARE = "Teile DPS:",
	HR_MENU_DAMAGE_SHARE_TT = "Sendet deinen verursachten Schaden an Gruppenmitglieder.",

	HR_MENU_HORN = "Kriegshorn",
	HR_MENU_HORN_SHOW = "Zeige Kriegshorn:",
	HR_MENU_HORN_SHOW_TT = "Zeige eine Liste mit dem aktuellem Füllstand der ultimativen Fähigkeit der Gruppenmitglieder.",
	HR_MENU_HORN_SHARE = "Teile ultimative Fähigkeit:",
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
	HR_MENU_COLOS_SHARE = "Teile ultimative Fähigkeit",
	HR_MENU_COLOS_SHARE_TT = "Sendet deinen Füllstand der ultimativen Fähigkeit in % an Gruppenmitglieder (nur wenn Koloss ausgerüstet ist).",
	HR_MENU_COLOS_PRIORITY = "Priorität:",
	HR_MENU_COLOS_PRIORITY_TT = "- Standard: Maximaler Füllstand ist 200%.\n- Tank Rolle: Sende 201% wenn du Tank bist und dein Koloss bereit ist.\n- Immer: Sende immer 201% wenn dein Koloss bereit ist.\n- Nie: Sende immer 99% oder weniger.\n|cFFFFFFACHTUNG: Das Senden von 99% oder 201% betrifft ebenfalls Kriegshorn solltest du beide ultimativen Fähigkeiten teilen.|r",
	HR_MENU_COLOS_PRIORITY_DEFAULT = "Standard",
	HR_MENU_COLOS_PRIORITY_TANK = "Tank Rolle",
	HR_MENU_COLOS_PRIORITY_ALWAYS = "Immer",
	HR_MENU_COLOS_PRIORITY_NEVER = "Nie",
	HR_MENU_COLOS_SUPPORT_RANGE = "Zeige nur Spieler in deiner Nähe:",
	HR_MENU_COLOS_SUPPORT_RANGE_TT = "Spieler die zu weit von dir entfernt sind werden nicht in der Liste angezeigt.",
	HR_MENU_COLOS_COUNTDOWN = "Zeige Countdown an:",
	HR_MENU_COLOS_COUNTDOWN_TT = "Zeigt eine Benachrichtigung mit dem Countdown wann du deine ultimative Fähigkeit benutzen sollst an.",
	HR_MENU_COLOS_COUNTDOWN_TEXT = "Countdown Text:",
	HR_MENU_COLOS_COUNTDOWN_COLOR = "Textfarbe des Countdown:",

	HR_MENU_ATRONACH = "Atronach",
	HR_MENU_ATRONACH_SHOW = "Zeige Atronach",
	HR_MENU_ATRONACH_SHOW_TT =  "Zeige eine Liste mit dem aktuellem Füllstand der ultimativen Fähigkeit der Gruppenmitglieder.",
	HR_MENU_ATRONACH_SHARE = "Teile Atronach",
	HR_MENU_ATRONACH_SHARE_TT = "Sendet deinen Füllstand der ultimativen Fähigkeit an Gruppenmitglieder (nur wenn Atronach ausgerüstet ist).",
	HR_MENU_ATRONACH_SHOW_PERCENT = "Zeige Prozent",
	HR_MENU_ATRONACH_SHOW_PERCENT_TT = "Zeige die errechnete Prozentzahl der ultimativen Fähigkeit",
	HR_MENU_ATRONACH_SHOW_RAW = "Zeige Ulti Punkte",
	HR_MENU_ATRONACH_SHOW_RAW_TT = "Zeige die Ulti Punkte die der Spieler hat",

	HR_MENU_MISCULTIMATES = "Andere Ultimates",
	HR_MENU_MISCULTIMATES_SHOW = "Zeige alle Ultis",
	HR_MENU_MISCULTIMATES_SHOW_TT = "Zeige alle nicht unterstützten Ultis",
	HR_MENU_MISCULTIMATES_SHARE = "Teile alle Ultis",
	HR_MENU_MISCULTIMATES_SHARE_TT = "Teile alle auch nicht unterstützten Ultis",

	HR_MENU_MISC = "Sonstiges",
	HR_MENU_MISC_DESC = "Um eine Beispielliste mit Spielern anzuzeigen/auszublenden gib |c999999/hodor.share test|r in den Chat ein.\nDu kannst ebenfalls auswählen welche Spieler angezeigt werden sollen, indem du ihre Namen angibst:\n|c999999/hodor.share test @andy.s @Alcast|r",

	HR_MENU_ICONS = "Symbole",
	HR_MENU_ICONS_README = "Readme (Anklicken zum Öffnen)",
	HR_MENU_ICONS_MY = "Mein Symbol",
	HR_MENU_ICONS_NAME_VAL = "Benutzerdefinierter Name",
	HR_MENU_ICONS_NAME_VAL_TT = "Standardmäßig zeigt das Addon deinen Accountnamen. Du kannst hier einen benutzerdefinierten Namen angeben.",
	HR_MENU_ICONS_GRADIENT = "Gradient",
	HR_MENU_ICONS_GRADIENT_TT = "Create gradient based on the colors below.",
	HR_MENU_ICONS_COLOR1 = "Start color",
	HR_MENU_ICONS_COLOR2 = "End color",
	HR_MENU_ICONS_PREVIEW = "Vorschau",
	HR_MENU_ICONS_LUA = "LUA code:",
	HR_MENU_ICONS_LUA_TT = "You may need to restart the game (not just /reloadui) when you modify the icon path. Send this code to the addon author alongside your icon file.",
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
	HR_MENU_ICONS_INTEGRITY = "Integrität",
	HR_MENU_ICONS_INTEGRITY_DESCRIPTION = "Überprüfe die Vollständigkeit der HodorReflexes Icons.",
	HR_MENU_ICONS_INTEGRITY_CHECK = "Überprüfen",

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

	HR_MENU_VOTE = "Abstimmung",
	HR_MENU_VOTE_DISABLED = "Für dieses Modul muss Hodor Reflexes aktiviert sein!",
	HR_MENU_VOTE_DESC = "Dieses Modul verbessert die eingebaute Bereitschaftabfrage und ermöglicht es zu sehen wer bereit oder nicht bereit ist sofern Gruppenmitglieder Hodor Reflexes aktiviert haben.",
	HR_MENU_VOTE_ENABLED_TT = "De-/Aktiviere dieses Modul. Wenn deaktiviert können andere Spieler das Ergebnis deiner Abstimmung nicht sehen.",
	HR_MENU_VOTE_CHAT = "Chat Nachrichten",
	HR_MENU_VOTE_CHAT_TT = "Zeigt Abstimmungsergebnisse und andere Informationen im Chatfenster an.",
	HR_MENU_VOTE_ACTIONS = "Aktionen",
	HR_MENU_VOTE_ACTIONS_RC = "Bereitschaftsabfrage",
	HR_MENU_VOTE_ACTIONS_RC_TT = "Starte eine Bereitschaftsabfrage.",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN = "Countdown",
	--HR_MENU_VOTE_ACTIONS_COUNTDOWN_TT = "Starte einen 5-sekündigen Countdown, wenn alle Spieler bereit sind.\nDu musst der Gruppenleiter sein um diese Funktion zu nutzen.",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM = "Du musst der Gruppenleiter sein um einen Countdown zu starten!",
	HR_MENU_VOTE_ACTIONS_LEADER = "Ändere Gruppenleiter",
	HR_MENU_VOTE_ACTIONS_LEADER_TT = "60% der Gruppenmitglieder müssen mit Ja abstimmen.",
	HR_MENU_VOTE_ACTIONS_LEADER_CONFIRM = "Ändere Gruppenleiter zu",

	HR_MENU_EVENTS = "Events",
	HR_MENU_EVENTS_DESC = "Dieses Modul aktiviert verschiedene Funktionen über das Jahr hinweg.",
	HR_MENU_EVENTS_DISABLED = "Für dieses Modul muss Hodor Reflexes aktiviert sein!",

	HR_MENU_MISC_DISABLEDEPENDENCYWARNING = "Deaktiviere Inkompatibilitätswarnung",
	HR_MENU_MISC_DISABLEDEPENDENCYWARNING_TT = "De-/Aktiviere die Warnung für inkompatibilität mit alten versionen von LibAddonMenu2.0",

	-------------------------
	-- BINDINGS
	-------------------------

	HR_BINDING_HORN_SHARE = "De-/aktiviere Kriegshorn teilen",
	HR_BINDING_COLOS_SHARE = "De-/aktiviere Koloss teilen",
	HR_BINDING_DPS_SHARE = "De-/aktiviere Schadens teilen",
	HR_BINDING_MISCULTIMATES_SHARE = "De-/aktiviere andere Ultimates teilen",
	HR_BINDING_COUNTDOWN = "Countdown",

	-------------------------
	-- SHARE MODULE
	-------------------------

	HR_COLOS_COUNTDOWN_DEFAULT_TEXT = "ULT",
	HR_MAJOR_FORCE = "größere Kraft",
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
	HR_COUNTDOWN = "Countdown",
	HR_COUNTDOWN_START = "Start in",
	HR_READY_CHECK_INIT_CHAT = "hat eine Bereitschaftsabfrage gestartet",
	HR_COUNTDOWN_INIT_CHAT = "hat einen Countdown gestartet",
	HR_VOTE_NOT_READY_CHAT = "ist nicht bereit",
	HR_VOTE_LEADER_CHAT = "möchte den Gruppenleiter ändern",

	-------------------------
	-- Exit Instance
	-------------------------

	HR_EXIT_INSTANCE = "Instanz verlassen",
	HR_EXIT_INSTANCE_CONFIRM = "Möchtest du die aktuelle Instanz wirklich verlassen?",

	-------------------------
	-- Updated window
	-------------------------

	HR_UPDATED_TEXT = "HodorReflexes wurde erfolgreich aktualisiert, oder nicht? Leider passiert es manchmal das Minion nicht alle Dateien herunterlädt. Normalerweise betrifft das nur Icons, normalerweise... Hier ist ein kleiner Test mit 5 Icons aus unterschiedlichen Ordnern. Wenn du nicht alle siehst, solltest du das Spiel schließen und Hodor neuinstallieren. Andernfalls ignoriere den Kram hier einfach.",
	HR_UPDATED_DISMISS = "Ja, da sind 5 Icons!",

	HR_MISSING_ICON = "Dein Icon konnte nicht geladen werden. Reinstalliere das Addon oder downloade es manuell via esoui.com. Danach starte bitte das Spiel neu.",

}

for id, val in pairs(strings) do
   ZO_CreateStringId(id, val)
   SafeAddVersion(id, 1)
end