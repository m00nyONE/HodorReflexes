-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/donate")

core.donationReceiver = {
    ["XB1live"] = "@Ned919x",
    ["XB1live-eu"] = "@Ned919x",
    ["PS4live"] = "@PrxvokedLegend",
    ["PS4live-eu"] = "@PrxvokedLegend",
    ["NA Megaserver"] = "@m00nyONE",
    ["EU Megaserver"] = "@m00nyONE",
}

--- @return void
function addon.Donate()
    --
end
