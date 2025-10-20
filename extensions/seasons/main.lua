-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal

local util = addon.util

local extensionDefinition = {
    name = "seasons",
    version = "1.0.0",
    description = "Seasonal events which change some behaviors of the addon on specific dates.",
    priority = 10,
    svVersion = 1,
    svDefault = {
        enableAprilFools = true,
        enableChristmas = true,
        enableValentines = true,
    },
}

--- @class eventsExtension : extensionClass
local extension = internal.extensionClass:New(extensionDefinition)

--- Module activation function.
--- NOT for manual use. This function gets called once when the extension is loaded and then deleted afterwards.
--- @return void
function extension:Activate()
    self.date = os.date("%d%m")

    -- April Fools Day: reverse DPS ranking
    if self.sw.enableAprilFools and self.date == "0104" then
        self.logger:Debug("enable april fools mode: reverse dps ranking")
        local dps_module = addon.modules.dps
        local function sortByDamageReversed(a, b)
            if a.dmg == b.dmg then
                return dps_module.sortByName(a, b)
            end
            return a.dmg < b.dmg
        end
        dps_module.sortByDamage = sortByDamageReversed
    end

    -- Christmas event: change class icons
    if self.sw.enableChristmas and (self.date == "2412" or self.date == "2512" or self.date == "2612") then
        self.logger:Debug("enable christmas mode: change class icons")
        local christmasIcons = {
            [1] = "HodorReflexes/assets/events/christmas/class_dragonknight_christmas.dds",
            [2] = "HodorReflexes/assets/events/christmas/class_sorcerer_christmas.dds",
            [3] = "HodorReflexes/assets/events/christmas/class_nightblade_christmas.dds",
            [4] = "HodorReflexes/assets/events/christmas/class_warden_christmas.dds",
            [5] = "HodorReflexes/assets/events/christmas/class_necromancer_christmas.dds",
            [6] = "HodorReflexes/assets/events/christmas/class_templar_christmas.dds",
            [117] = "HodorReflexes/assets/events/christmas/class_arcanist_christmas.dds"
        }
        util.OverwriteClassIcons(christmasIcons)
    end

    -- Valentine's Day: random hearts as user icons
    if self.sw.enableValentines and self.date == "1402" then
        self.logger:Debug("enable valentines mode: random hearts as class icons")
        local valentineIcons = {
            "HodorReflexes/assets/events/valentine/8bitHeart.dds",
            "HodorReflexes/assets/events/valentine/angel_heart.dds",
            "HodorReflexes/assets/events/valentine/blue_heart.dds",
            "HodorReflexes/assets/events/valentine/calender.dds",
            "HodorReflexes/assets/events/valentine/ff_heart.dds",
            "HodorReflexes/assets/events/valentine/green_heart.dds",
            "HodorReflexes/assets/events/valentine/happyheart.dds",
            "HodorReflexes/assets/events/valentine/orange_heart.dds",
            "HodorReflexes/assets/events/valentine/present.dds",
            "HodorReflexes/assets/events/valentine/purple_heart.dds",
            "HodorReflexes/assets/events/valentine/rainbow_heart.dds",
            "HodorReflexes/assets/events/valentine/ring.dds",
            "HodorReflexes/assets/events/valentine/rose.dds",
            "HodorReflexes/assets/events/valentine/round_heart.dds",
            "HodorReflexes/assets/events/valentine/smiling_heart.dds",
            "HodorReflexes/assets/events/valentine/sparkling_heart.dds",
            "HodorReflexes/assets/events/valentine/white_heart.dds",
        }
        local function getRandomValentinesIcon()
            local randomIconIndex = zo_random(1, #valentineIcons)
            return valentineIcons[randomIconIndex], 0, 1, 0, 1
        end

        util.GetClassIcon = getRandomValentinesIcon()
    end
end

