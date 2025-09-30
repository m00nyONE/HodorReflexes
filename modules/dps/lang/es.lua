-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

-- TODO: UNFINISHED TRANSLATION

local strings = {
    HR_DAMAGE = "Daño",
    HR_TOTAL_DAMAGE = "Daño total",
    HR_MISC_DAMAGE = "Total",
    HR_BOSS_DPS = "Daño al jefe",
    HR_TOTAL_DPS = "Daño total",

    HR_MENU_DAMAGE_SHOW = "Mostrar daño:",
    HR_MENU_DAMAGE_SHOW_TT = "Muestra una lista del daño realizado por cada miembro de tu grupo.",
    --HR_MENU_DAMAGE_SHOW_NEVER = "Never",
    --HR_MENU_DAMAGE_SHOW_ALWAYS = "Always",
    --HR_MENU_DAMAGE_SHOW_OUT = "Out of combat",
    --HR_MENU_DAMAGE_SHOW_NONBOSS = "Non-boss fight",

    HR_MENU_STYLE_DPS = "Lista de daño",
    HR_MENU_STYLE_DPS_FONT = "Fuente de los números:",
    HR_MENU_STYLE_DPS_FONT_DEFAULT = "Por defecto",
    HR_MENU_STYLE_DPS_FONT_GAMEPAD = "Mando",
    HR_MENU_STYLE_DPS_BOSS_COLOR = "Color de daño al jefe:",
    HR_MENU_STYLE_DPS_TOTAL_COLOR = "Color de daño total:",
    HR_MENU_STYLE_DPS_HEADER_OPACITY = "Opacidad del recuadro:",
    HR_MENU_STYLE_DPS_EVEN_OPACITY = "Opacidad de las filas pares:",
    HR_MENU_STYLE_DPS_ODD_OPACITY = "Opacidad de las filas impares:",
    HR_MENU_STYLE_DPS_HIGHLIGHT = "Color de resaltado:",
    HR_MENU_STYLE_DPS_HIGHLIGHT_TT = "Resalta el color de tu nombre en la lista de daño con el color deseado. Si no quieres que se resalte, coloca su opacidad a 0. (Solo tú puedes ver el nombre resaltado).",
    HR_MENU_ICONS_VISIBILITY_COLORS = "Nombres coloridos",
    HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Muestra los colores de los nombres personalizados de los jugadores.",
    HR_MENU_ICONS_VISIBILITY_DPS = "Iconos en marco de daño",
    HR_MENU_ICONS_VISIBILITY_DPS_TT = "Muestra iconos personalizados de los jugadores en la lista de daño.",

    HR_TEST_STARTED = "Prueba iniciada.",
    HR_TEST_STOPPED = "Prueba detenida.",
    HR_TEST_LEAVE_GROUP = "Debes salir del grupo para realizar una prueba.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end