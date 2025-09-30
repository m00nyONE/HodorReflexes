-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_DAMAGE = "Schaden",
    HR_TOTAL_DAMAGE = "Gesamtschaden",
    HR_MISC_DAMAGE = "Sonstiges",
    HR_BOSS_DPS = "Boss DPS",
    HR_TOTAL_DPS = "Gesamt DPS",

    HR_MENU_DAMAGE_SHOW = "Zeige Schaden:",
    HR_MENU_DAMAGE_SHOW_TT = "Zeige eine Liste mit verursachtem Schaden der Gruppenmitglieder.",
    HR_MENU_DAMAGE_SHOW_NEVER = "Niemals",
    HR_MENU_DAMAGE_SHOW_ALWAYS = "Immer",
    HR_MENU_DAMAGE_SHOW_OUT = "Außerhalb des Kampfes",
    HR_MENU_DAMAGE_SHOW_NONBOSS = "in Nicht-Bosskämpfen",

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
    HR_MENU_ICONS_VISIBILITY_COLORS = "Gefärbte Namen",
    HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Färbe die Namen anderer Spieler.",
    HR_MENU_ICONS_VISIBILITY_DPS = "Schaden Symbole",
    HR_MENU_ICONS_VISIBILITY_DPS_TT = "Verwende benutzerdefinierte Symbole für Spieler in der Schadensliste.",

    HR_TEST_STARTED = "Test gestartet.",
    HR_TEST_STOPPED = "Test gestoppt.",
    HR_TEST_LEAVE_GROUP = "Verlasse deine Gruppe um testen zu können",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end