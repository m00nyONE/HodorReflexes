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
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end