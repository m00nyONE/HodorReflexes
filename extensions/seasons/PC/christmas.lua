-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local util = addon.util

local addon_extensions = addon.extensions
local extension = addon_extensions.seasons

local season = {
    name = "christmas",
    version = "1.0.0",
    description = "class icons with christmas hats",
    dates = { "2412", "2512", "2612" },
}

--- Activates the christmas season
--- @return void
function season:Activate()
    local christmasIcons = {
        [1] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/icons-3x3.dds",
            left = 0,
            right = 1/3,
            top = 0,
            bottom = 1/3,
        },
        [2] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/icons-3x3.dds",
            left = 1/3,
            right = 2/3,
            top = 0,
            bottom = 1/3,
        },
        [3] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/icons-3x3.dds",
            left = 2/3,
            right = 3/3,
            top = 0,
            bottom = 1/3,
        },
        [4] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/icons-3x3.dds",
            left = 0,
            right = 1/3,
            top = 1/3,
            bottom = 2/3,
        },
        [5] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/icons-3x3.dds",
            left = 1/3,
            right = 2/3,
            top = 1/3,
            bottom = 2/3,
        },
        [6] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/icons-3x3.dds",
            left = 2/3,
            right = 3/3,
            top = 1/3,
            bottom = 2/3,
        },
        [117] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/icons-3x3.dds",
            left = 0,
            right = 1/3,
            top = 2/3,
            bottom = 3/3,
        },
    }
    util.overwriteClassIcons(christmasIcons)
end

extension:NewSeason(season)