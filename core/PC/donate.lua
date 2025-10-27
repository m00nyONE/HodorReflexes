-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/donate")

--- opens the mail interface with prefilled data for donation
--- @return void
function addon.Donate()
    logger:Debug("Donation function called")
    SCENE_MANAGER:Show('mailSend')
    zo_callLater(function()
        ZO_MailSendToField:SetText("@m00nyONE")
        ZO_MailSendSubjectField:SetText("Donation for Hodor Reflexes")
        ZO_MailSendBodyField:SetText("ticket-XXXXX on Discord.")
        ZO_MailSendBodyField:TakeFocus()
    end, 250)
end