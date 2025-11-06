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

function season:Activate()
    -- TODO: rework to use a single texture instead of one per class
    local christmasIcons = {
        [1] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_dragonknight_christmas.dds",
            left = 0,
            right = 1,
            top = 0,
            bottom = 1,
        },
        [2] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_sorcerer_christmas.dds",
            left = 0,
            right = 1,
            top = 0,
            bottom = 1,
        },
        [3] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_nightblade_christmas.dds",
            left = 0,
            right = 1,
            top = 0,
            bottom = 1,
        },
        [4] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_warden_christmas.dds",
            left = 0,
            right = 1,
            top = 0,
            bottom = 1,
        },
        [5] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_necromancer_christmas.dds",
            left = 0,
            right = 1,
            top = 0,
            bottom = 1,
        },
        [6] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_templar_christmas.dds",
            left = 0,
            right = 1,
            top = 0,
            bottom = 1,
        },
        [117] = {
            texturePath = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_arcanist_christmas.dds",
            left = 0,
            right = 1,
            top = 0,
            bottom = 1,
        },
    }
    util.overwriteClassIcons(christmasIcons)
end

extension:NewSeason(season)