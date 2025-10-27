-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/donate")

-- function needs to be implemented platform specific
function addon.Donate()
    logger:Warn("Donation function not implemented for this platform")
end