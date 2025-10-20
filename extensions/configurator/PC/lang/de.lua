-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0


--TODO: rename Strings
local strings = {

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