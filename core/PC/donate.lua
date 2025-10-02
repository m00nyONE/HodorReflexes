local addon_name = "HodorReflexes2"
local addon = _G[addon_name]

function addon.Donation()
    SCENE_MANAGER:Show('mailSend')
    zo_callLater(function()
        ZO_MailSendToField:SetText("@m00nyONE")
        ZO_MailSendSubjectField:SetText("Donation for Hodor Reflexes")
        ZO_MailSendBodyField:SetText("ticket-XXXX on Discord.")
        ZO_MailSendBodyField:TakeFocus()
    end, 250)
end