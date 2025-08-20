local strings = {
    HR_DAMAGE = "Damage",
    HR_TOTAL_DAMAGE = "Total Damage",
    HR_MISC_DAMAGE = "Misc",
    HR_BOSS_DPS = "Boss DPS",
    HR_TOTAL_DPS = "Total DPS",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end