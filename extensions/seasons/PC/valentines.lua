-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local util = addon.util

local addon_extensions = addon.extensions
local extension = addon_extensions.seasons

local seasonDefinition = {
    name = "valentines",
    version = "1.0.0",
    description = "random hearts as class icons",
    dates = { "1402" },
}

local season = extension:NewSeason(seasonDefinition)

function season:Activate()
    local valentineIcons = { -- TODO: combine into one texture and set textureCoordinates for performance
        "HodorReflexes/extensions/seasons/PC/assets/valentine/8bitHeart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/angel_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/blue_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/calender.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/ff_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/green_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/happyheart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/orange_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/present.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/purple_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/rainbow_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/ring.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/rose.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/round_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/smiling_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/sparkling_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentine/white_heart.dds",
    }
    local function getRandomValentinesIcon()
        local randomIconIndex = zo_random(1, #valentineIcons)
        return valentineIcons[randomIconIndex], 0, 1, 0, 1
    end

    util.GetClassIcon = getRandomValentinesIcon()
end
