local strings = {
    HR_DAMAGE = "Dégâts",
    HR_TOTAL_DAMAGE = "Dégâts Totaux",
    HR_MISC_DAMAGE = "Divers",
    HR_BOSS_DPS = "DPS sur le Boss",
    HR_TOTAL_DPS = "DPS Total",

    HR_MENU_DAMAGE_SHOW = "Afficher les dégâts:",
    HR_MENU_DAMAGE_SHOW_TT = "Affiche la liste des dégâts du groupe.",
    HR_MENU_DAMAGE_SHOW_NEVER = "Jamais",
    HR_MENU_DAMAGE_SHOW_ALWAYS = "Toujours",
    HR_MENU_DAMAGE_SHOW_OUT = "Hors combat",
    HR_MENU_DAMAGE_SHOW_NONBOSS = "Combat sans boss",

    HR_MENU_STYLE_DPS = "Liste du DPS",
    HR_MENU_STYLE_DPS_FONT = "Police des nombres:",
    HR_MENU_STYLE_DPS_FONT_DEFAULT = "Par défaut",
    HR_MENU_STYLE_DPS_FONT_GAMEPAD = "Manette",
    HR_MENU_STYLE_DPS_BOSS_COLOR = "Couleur des dégâts sur le Boss:",
    HR_MENU_STYLE_DPS_TOTAL_COLOR = "Couleur des dégâts totaux:",
    HR_MENU_STYLE_DPS_HEADER_OPACITY = "Opacité de l'en-tête:",
    HR_MENU_STYLE_DPS_EVEN_OPACITY = "Opacité des lignes paires:",
    HR_MENU_STYLE_DPS_ODD_OPACITY = "Opacité des lignes impaires:",
    HR_MENU_STYLE_DPS_HIGHLIGHT = "Couleur surlignée:",
    HR_MENU_STYLE_DPS_HIGHLIGHT_TT = "Surligne votre pseudo dans la liste par la couleur sélectionnée. Si vous ne souhaitez pas surligner votre pseudo, réduisez l'opacité à 0. Vous êtes le seul joueur à voir le surlignage.",
    HR_MENU_ICONS_VISIBILITY_COLORS = "Noms colorés",
    HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Noms colorés des autres joueurs.",
    HR_MENU_ICONS_VISIBILITY_DPS = "Icônes des Dégats",
    HR_MENU_ICONS_VISIBILITY_DPS_TT = "Affiche les icônes personnalisées dans la liste des dégâts.",

    HR_TEST_STARTED = "Test lancé.",
    HR_TEST_STOPPED = "Test arrêté.",
    HR_TEST_LEAVE_GROUP = "Vous devez quittez le groupe pour tester.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end