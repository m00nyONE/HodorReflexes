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

function module:GetSubMenuOptions()
    local function mergeOptions(source, destination)
        for _, option in ipairs(source) do
            if option.requiresReload then
                option.label = string.format("|cffff00%s|r", option.label)
            end
            table.insert(destination, option)
        end
    end

    local function GetGeneralOptions()
        return {
            core.CreateSectionHeader("General"),
            {
                type = LHAS.ST_CHECKBOX,
                label = "account wide settings",
                tooltip = "enable/disable account-wide settings.",
                default = true,
                getFunction = function() return self.sw.accountWide end,
                setFunction = function(value)
                    self.sw.accountWide = value
                end,
                requiresReload = true,
            },
        }
    end

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
    local generalOptions = GetGeneralOptions()
    mergeOptions(generalOptions, options)

    local hideMeOptions = {
        core.CreateSectionHeader("Hide Me Options")
    }
    for id, hideId in pairs(self.hideIds) do
        table.insert(hideMeOptions, generateHideOption(id, hideId.label, hideId.description))
    end
    mergeOptions(hideMeOptions, options)

    return options
end