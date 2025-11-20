-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "hideme"
local module = addon_modules[module_name]

local LHAS = LibHarvensAddonSettings

--- @return table
function module:GetSubMenuOptions()
    local function generateHideOption(id, label, description)
        return {
            type = LHAS.ST_CHECKBOX,
            label = label,
            tooltip = description,
            default = false,
            getFunction = function() return self.sv.preferences[id] or false end,
            setFunction = function(value)
                self.sv.preferences[id] = value
                self:SendHideMeMessageDebounced()
            end,
        }
    end

    local options = {}
    table.insert(options, core.CreateSectionHeader(GetString(HR_MODULES_HIDEME_MENU_HEADER)))
    for id, hideId in pairs(self.hideIds) do
        table.insert(options, generateHideOption(id, hideId.label, hideId.description))
    end

    return options
end