-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MOCK1 = "¿Cómo se siente morir con tantos addons puestos?.",
    HR_MOCK2 = "Intenta equiparte Chudan, Doctor de la plaga y Apicultor.",
    HR_MOCK3 = "¿Vas a culpar al servidor otra vez?",
    HR_MOCK4 = "Instancia bugeada, claro.",
    HR_MOCK5 = "Quizá mejor te haces tank o healer.",
    HR_MOCK6 = "¿No viste la notificación del addon?",
    HR_MOCK7 = "Poco hacías de todas formas.",
    HR_MOCK8 = "Quizá debas pagar un grupo para que te carrée.",
    HR_MOCK9 = "¿Y si te equipas Barrera?",
    HR_MOCK10 = "Se nos acabaron los consejos.",
    HR_MOCK11 = "Si quieres sentirte útil, mejor revisa la Tienda de Coronas.",
    HR_MOCK12 = "El rendimiento del juego es malo, pero el tuyo es peor.",
    HR_MOCK13 = "Se te da bien jugar mal.",
    HR_MOCK14 = "Ponte más addons a ver si te ayudan.",
    HR_MOCK15 = "Tu APM es demasiado bajo para esta pelea.",
    HR_MOCK16 = "No te preocupes, pronto añadiremos los logros de esta trial en la Tienda de Coronas.",
    HR_MOCK17 = "La locura es hacer lo mismo una y otra vez esperando obtener resultados diferentes.",
    HR_MOCK18 = "¿Ves esa barra roja en la cabeza de los enemigos? Hay que vaciarla antes de que vacíen la tuya.",
    HR_MOCK19 = "¿Has considerado cambiar tu nombre a Kenny?",
    HR_MOCK20 = "Mejor pásate al Roblox.",
    HR_MOCK_AA1 = "Imagina morir en contenido del juego base.",
    HR_MOCK_EU1 = "¿Por qué juegas en EU?",
    HR_MOCK_NORMAL1 = "Ni siquiera está en veterano...",
    HR_MOCK_VET1 = "Para la próxima considera hacerla en normal.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end