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

function module:GetSubMenuOptions()
    local function GetGeneralOptions()
        return {
            core.CreateSectionHeader("General"),
            {
                type = "checkbox",
                name = "account wide settings",
                tooltip = "enable/disable account-wide settings.",
                default = true,
                getFunc = function() return self.sw.accountWide end,
                setFunc = function(value)
                    self.sw.accountWide = value
                end,
                requiresReload = true,
            },
        }
    end

    local function generateHideOption(id, label, description)
        return {
            type = "checkbox",
            name = label,
            tooltip = description,
            default = false,
            getFunc = function() return self.sv.preferences[id] or false end,
            setFunc = function(value)
                self.sv.preferences[id] = value
                self:SendHideMeMessageDebounced()
            end,
        }
    end

    local options = GetGeneralOptions()
    table.insert(options, core.CreateSectionHeader("Hide Me Options"))
    for id, hideId in pairs(self.hideIds) do
        table.insert(options, generateHideOption(id, hideId.label, hideId.description))
    end

    return options
end