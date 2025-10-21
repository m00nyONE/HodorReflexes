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
    name = "valentines",
    version = "1.0.0",
    description = "random hearts as class icons",
    dates = { "1402" },
}

function season:Activate()
    local valentineIcons = { -- TODO: combine into one texture and set textureCoordinates for performance
        "HodorReflexes/extensions/seasons/PC/assets/valentines/8bitHeart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/angel_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/blue_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/calender.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/ff_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/green_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/happyheart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/orange_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/present.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/purple_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/rainbow_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/ring.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/rose.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/round_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/smiling_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/sparkling_heart.dds",
        "HodorReflexes/extensions/seasons/PC/assets/valentines/white_heart.dds",
    }
    local function getRandomValentinesIcon(classId)
        local randomIconIndex = zo_random(1, #valentineIcons)
        return valentineIcons[randomIconIndex], 0, 1, 0, 1
    end

    util.GetClassIcon = getRandomValentinesIcon
end

extension:NewSeason(season)