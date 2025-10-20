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
    local christmasIcons = {
        [1] = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_dragonknight_christmas.dds",
        [2] = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_sorcerer_christmas.dds",
        [3] = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_nightblade_christmas.dds",
        [4] = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_warden_christmas.dds",
        [5] = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_necromancer_christmas.dds",
        [6] = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_templar_christmas.dds",
        [117] = "HodorReflexes/extensions/seasons/PC/assets/christmas/class_arcanist_christmas.dds"
    }
    util.overwriteClassIcons(christmasIcons)
end

extension:NewSeason(season)