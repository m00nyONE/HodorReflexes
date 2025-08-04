local strings = {
    HR_MOCK1 = "Immaginate di morire con tutti questi addon abilitati.",
    HR_MOCK2 = "Prova ad equipaggiare Mighty Chudan, Plague Doctor e Beekeeper's Gear.",
    HR_MOCK3 = "Darai di nuovo la colpa ai server?",
    HR_MOCK4 = "Una brutta istanza, ovviamente.",
    HR_MOCK5 = "Forse tank o guaritore sarebbero ruoli migliori per te.",
    HR_MOCK6 = "Avete perso la notifica dell'addon?",
    HR_MOCK7 = "Tu sei l'anello più debole, addio.",
    HR_MOCK8 = "Forse dovresti considerare l'acquisto di un carretto per il trasporto.",
    HR_MOCK9 = "Dovresti considerare l'utilizzo della barriera.",
    HR_MOCK10 = "Abbiamo finito i suggerimenti per le vostre morti.",
    HR_MOCK11 = "Se vuoi fare qualcosa di utile, allora controlla il Negozio delle Corone.",
    HR_MOCK12 = "La performance del gioco è pessima, ma la tua è peggiore.",
    HR_MOCK13 = "You are doing good at being bad.",
    HR_MOCK14 = "Try installing more addons to carry you.",
    HR_MOCK15 = "Il tuo APM è troppo basso per questo combattimento.",
    HR_MOCK16 = "Non preoccuparti, alla fine aggiungeranno gli obiettivi di questa Trial al Negozio delle Corone.",
    HR_MOCK17 = "La follia è fare la stessa cosa più e più volte e aspettarsi risultati diversi.",
    HR_MOCK18 = "Nei contenuti PvE si suppone che tu uccida i mob prima che loro uccidano te.",
    HR_MOCK19 = "Hai mai pensato di cambiare il tuo nome in Kenny?",
    HR_MOCK20 = "Ho combattuto granchi più temibili di te.",
    HR_MOCK_AA1 = "Sei morto in su un contenuto di 6 anni fa.",
    HR_MOCK_EU1 = "Perché giocate sul server UE?",
    HR_MOCK_NORMAL1 = "Questa non è nemmeno la modalità veterano...",
    HR_MOCK_VET1 = "Considera di cambiare la difficoltà della trial in Normale.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end