-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MOCK1 = "Imagine mourir avec tous ces addons activés.",
    HR_MOCK2 = "Essaye d'équiper le Gros Chudan, le Médecin de la Peste, et l'Harnachement de l'Apiculteur.",
    HR_MOCK3 = "Vas-tu encore accuser le serveur ?",
    HR_MOCK4 = "Mauvaise instance, évidemment !",
    HR_MOCK5 = "Tu devrais plutôt essayer de tank ou heal.",
    HR_MOCK6 = "As-tu manqué la notification de l'addon ?",
    HR_MOCK7 = "Vous êtes le maillon faible. Au revoir.",
    HR_MOCK8 = "Tu devrais peux-être envisager le fait d'acheter un carry plutôt.",
    HR_MOCK9 = "Tu devrais peux-être envisager le fait d'utiliser une rotation de barrières.",
    HR_MOCK10 = "Nous n'avons plus d'indices pour vous éviter de mourir.",
    HR_MOCK11 = "Si tu veux faire quelque chose d'utile, regarde la boutique à couronnes.",
    HR_MOCK12 = "Les performances du jeu sont mauvaises, mais les tiennes sont pires.",
    HR_MOCK13 = "Tu es bon a être mauvais.",
    HR_MOCK14 = "Essaye d'installer plus d'addons pour te carry.",
    HR_MOCK15 = "Tes APM sont trop basses pour ce combat.",
    HR_MOCK16 = "Ne t'inquète pas, nous ajouterons peux-être les succés de ce raid dans la boutique à couronnes.",
    HR_MOCK17 = "La folie c'est de faire toujours la même chose et de s'attendre à un résultat différent.",
    HR_MOCK18 = "Tes APM sont trop basses pour ce combat.",
    HR_MOCK19 = "Imagine mourir avec tous ces addons activés.",
    HR_MOCK20 = "Vous êtes le maillon faible. Au revoir.",
    HR_MOCK_AA1 = "Imagine mourir dans du contenu vieux de six ans.",
    HR_MOCK_EU1 = "Pourquoi joues-tu sur le serveur EU ?",
    HR_MOCK_NORMAL1 = "Ce n'est même pas le mode vétéran...",
    HR_MOCK_VET1 = "Envisage le fait de passer en difficulté normal.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end