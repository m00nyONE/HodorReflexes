local strings = {
    HR_DAMAGE = "Damage",
    HR_TOTAL_DAMAGE = "Total Damage",
    HR_MISC_DAMAGE = "Misc",
    HR_BOSS_DPS = "Boss DPS",
    HR_TOTAL_DPS = "Total DPS",

    HR_MENU_DAMAGE_SHOW = "Show Damage:",
    HR_MENU_DAMAGE_SHOW_TT = "Show the list with group damage.",
    HR_MENU_DAMAGE_SHOW_NEVER = "Never",
    HR_MENU_DAMAGE_SHOW_ALWAYS = "Always",
    HR_MENU_DAMAGE_SHOW_OUT = "Out of combat",
    HR_MENU_DAMAGE_SHOW_NONBOSS = "Non-boss fight",

    HR_MENU_STYLE_DPS = "Damage list",
    HR_MENU_STYLE_DPS_FONT = "Numbers font",
    HR_MENU_STYLE_DPS_FONT_DEFAULT = "Default",
    HR_MENU_STYLE_DPS_FONT_GAMEPAD = "Gamepad",
    HR_MENU_STYLE_DPS_BOSS_COLOR = "Boss damage color",
    HR_MENU_STYLE_DPS_TOTAL_COLOR = "Total damage color",
    HR_MENU_STYLE_DPS_HEADER_OPACITY = "Header opacity",
    HR_MENU_STYLE_DPS_EVEN_OPACITY = "Even row opacity",
    HR_MENU_STYLE_DPS_ODD_OPACITY = "Odd row opacity",
    HR_MENU_STYLE_DPS_HIGHLIGHT = "Highlight color",
    HR_MENU_STYLE_DPS_HIGHLIGHT_TT = "Highlight your name in the damage list with the selected color. If you don't want to highlight your name, then set Opacity to 0. Only you see the highlighted name.",
    HR_MENU_ICONS_VISIBILITY_COLORS = "Colored names",
    HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Color names of other players.",
    HR_MENU_ICONS_VISIBILITY_DPS = "Damage Icons",
    HR_MENU_ICONS_VISIBILITY_DPS_TT = "Show custom icons for players in the damage list.",

    HR_TEST_STARTED = "Test started.",
    HR_TEST_STOPPED = "Test stopped.",
    HR_TEST_LEAVE_GROUP = "You must leave the group to test.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end