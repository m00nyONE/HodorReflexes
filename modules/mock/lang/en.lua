-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MOCK1 = "Imagine dying with all these addons enabled.",
    HR_MOCK2 = "Try equipping Mighty Chudan, Plague Doctor and Beekeeper's Gear.",
    HR_MOCK3 = "Are you going to blame the servers again?",
    HR_MOCK4 = "A bad instance, obviously.",
    HR_MOCK5 = "Maybe tanking or healing would be a better role for you.",
    HR_MOCK6 = "Have you missed the addon notification?",
    HR_MOCK7 = "You are the weakest link, goodbye.",
    HR_MOCK8 = "Maybe you should consider buying a carry run instead.",
    HR_MOCK9 = "Maybe you should consider using barrier rotation.",
    HR_MOCK10 = "We ran out of hints for your deaths.",
    HR_MOCK11 = "If you want to do something useful, then check Crown Store.",
    HR_MOCK12 = "The game's performance is bad, but yours is worse.",
    HR_MOCK13 = "You are doing good at being bad.",
    HR_MOCK14 = "Try installing more addons to carry you.",
    HR_MOCK15 = "Your APM is too low for this fight.",
    HR_MOCK16 = "Don't worry, eventually we'll add this trial's achievements to Crown Store.",
    HR_MOCK17 = "Insanity is doing the same thing over and over again and expecting different results.",
    HR_MOCK18 = "In PvE content you are supposed to kill mobs before they kill you.",
    HR_MOCK19 = "Have you ever considered changing your name to Kenny?",
    HR_MOCK20 = "I've fought mudcrabs more fearsome than you.",
    HR_MOCK_AA1 = "Imaging dying in a six years old content.",
    HR_MOCK_EU1 = "Why do you even play on the EU server?",
    HR_MOCK_NORMAL1 = "This is not even the veteran mode...",
    HR_MOCK_VET1 = "Consider switching the trial difficulty to Normal.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end