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

--- Activates the valentines season extension
--- @return void
function season:Activate()
    local texturePath = "HodorReflexes/extensions/seasons/PC/assets/valentines/icons-4x4.dds"
    local textureCoordinates = {
        -- row 1
        { 0, 0.25, 0, 0.25 },    -- 8-bit heart
        { 0.25, 0.5, 0, 0.25 },  -- angel heart
        { 0.5, 0.75, 0, 0.25 },  -- happy heart
        { 0.75, 1, 0, 0.25 },    -- surprised heart
        -- row 2
        { 0, 0.25, 0.25, 0.5 },   -- red heart in yellow circle
        { 0.25, 0.5, 0.25, 0.5 }, -- white heart in red circle
        { 0.5, 0.75, 0.25, 0.5 }, -- rainbow heart
        { 0.75, 1, 0.25, 0.5 },   -- purple heart
        -- row 3
        { 0, 0.25, 0.5, 0.75 },   -- white heart
        { 0.25, 0.5, 0.5, 0.75 }, -- blue heart
        { 0.5, 0.75, 0.5, 0.75 }, -- green heart
        { 0.75, 1, 0.5, 0.75 },   -- orange heart
        -- row 4
        { 0, 0.25, 0.75, 1 },     -- sparkling heart
        { 0.25, 0.5, 0.75, 1 },   -- ring
        { 0.5, 0.75, 0.75, 1 },   -- rose
        { 0.75, 1, 0.75, 1 },     -- date
    }

    local function getRandomValentinesIcon(classId)
        local randomIconIndex = zo_random(1, #textureCoordinates)
        return texturePath, unpack(textureCoordinates[randomIconIndex])
    end

    util.GetClassIcon = getRandomValentinesIcon
end

extension:NewSeason(season)