-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/LibCheck")

-- function needs to be implemented platform specific
function core.OptionalLibrariesCheck()
    logger:Debug("No optional libraries to check for this platform.")
end