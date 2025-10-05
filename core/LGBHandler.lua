-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.logger.main

local LGB = LibGroupBroadcast

function core.RegisterLGBHandler()
    logger:Debug("Registering LGB Handler")
    local handler = LGB:RegisterHandler(addon_name)
    handler:SetDisplayName("Hodor Reflexes")
    handler:SetDescription("provides various group tools like pull countdowns and exit instance requests")

    core.LGBHandler = handler
end