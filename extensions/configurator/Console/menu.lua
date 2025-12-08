-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal

local util = addon.util
local LHAS = LibHarvensAddonSettings

local addon_extensions = addon.extensions
local extension = addon_extensions.configurator

function extension:GetSubMenuOptions()
    local options = {
        {
            type = LHAS.ST_LABEL,
            label = string.format("Discord: %s", self.discordUrl),
            tooltip = "Join the HodorReflexes Discord if you want to have a custom name.",
        }
    }

    return options
end