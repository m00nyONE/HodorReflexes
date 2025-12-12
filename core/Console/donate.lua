-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/donate")

--- @return void
function addon.Donate()
    logger:Debug("Donation function called")
    local receiver = core.donationReceiver[GetWorldName()]

    d("Sadly creating a prefilled mail template on console does not work :-(")

    --SCENE_MANAGER:Show('mailGamepad')
    --SCENE_MANAGER:Push('mailGamepad')
    --/script ZO_MailSend_Gamepad:ComposeMailTo("@m00nyONE", "test")
    --sendTab:SwitchToSendTab()
    --sendTab:InsertBodyText("ticket-XXXXX on Discord.")
end
