-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

-- TODO: UNFINISHED TRANSLATION

local strings = {
    HR_DAMAGE = "Danno",
    HR_TOTAL_DAMAGE = "Danno Totale",
    HR_MISC_DAMAGE = "Varie",
    HR_BOSS_DPS = "DPS Boss",
    HR_TOTAL_DPS = "DPS Totale",

    HR_MENU_DAMAGE_SHOW = "Mostra Danno:",
    HR_MENU_DAMAGE_SHOW_TT = "Mostra l'elenco con i danni del gruppo.",
    --HR_MENU_DAMAGE_SHOW_NEVER = "Never",
    --HR_MENU_DAMAGE_SHOW_ALWAYS = "Always",
    --HR_MENU_DAMAGE_SHOW_OUT = "Out of combat",
    --HR_MENU_DAMAGE_SHOW_NONBOSS = "Non-boss fight",

    HR_MENU_STYLE_DPS = "Elenco Danni",
    HR_MENU_STYLE_DPS_FONT = "Carattere dei Numeri:",
    HR_MENU_STYLE_DPS_FONT_DEFAULT = "Predefinito",
    HR_MENU_STYLE_DPS_FONT_GAMEPAD = "Gamepad",
    HR_MENU_STYLE_DPS_BOSS_COLOR = "Colore Danno del Boss:",
    HR_MENU_STYLE_DPS_TOTAL_COLOR = "Colore Danno Totale:",
    HR_MENU_STYLE_DPS_HEADER_OPACITY = "Opacità Intestazione:",
    HR_MENU_STYLE_DPS_EVEN_OPACITY = "Opacità Righe Pari:",
    HR_MENU_STYLE_DPS_ODD_OPACITY = "Opacità Righe Dispari:",
    HR_MENU_STYLE_DPS_HIGHLIGHT = "Evidenzia Colore:",
    HR_MENU_STYLE_DPS_HIGHLIGHT_TT = "Evidenzia il tuo nome nella lista dei danni con il colore selezionato. Se non vuoi evidenziare il tuo nome, allora imposta Opacity a 0. Solo tu vedi il nome evidenziato.",
    HR_MENU_ICONS_VISIBILITY_COLORS = "Nomi Colorati",
    HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Colori dei nomi di altri giocatori.",
    HR_MENU_ICONS_VISIBILITY_DPS = "Icone Danno",
    HR_MENU_ICONS_VISIBILITY_DPS_TT = "Mostra icone personalizzate per i giocatori nella lista dei danni.",

    HR_TEST_STARTED = "Test Avviato.",
    HR_TEST_STOPPED = "Test Fermato.",
    HR_TEST_LEAVE_GROUP = "Devi lasciare il gruppo per fare il test.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end