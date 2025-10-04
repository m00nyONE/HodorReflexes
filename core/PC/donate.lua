-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

function addon.Donation()
    SCENE_MANAGER:Show('mailSend')
    zo_callLater(function()
        ZO_MailSendToField:SetText("@m00nyONE")
        ZO_MailSendSubjectField:SetText("Donation for Hodor Reflexes")
        ZO_MailSendBodyField:SetText("ticket-XXXXX on Discord.")
        ZO_MailSendBodyField:TakeFocus()
    end, 250)
end