-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local HR_EVENT_DEBUG_MODE_CHANGED = core.HR_EVENT_DEBUG_MODE_CHANGED

--- @class seasonClass : ZO_Object
local seasonClass = ZO_InitializingObject:Subclass()
seasonClass:MUST_IMPLEMENT("Activate")

--- Initialize a season.
--- @param season table season definition
--- @return seasonClass season object
function seasonClass:Initialize(season)
    for k, v in pairs(season) do
        self[k] = v
    end

    self.enabled = false
end
--- Check if the season is enabled.
--- @return boolean enabled
function seasonClass:IsEnabled()
    return self.enabled
end
--- Activate and enable the season.
--- @return void
function seasonClass:ActivateAndEnable()
    if not self:IsEnabled() then
        self.enabled = true
        self:Activate()
    end
end

local extensionDefinition = {
    name = "seasons",
    version = "1.0.0",
    friendlyName = GetString(HR_EXTENSIONS_SEASONS_FRIENDLYNAME),
    description = GetString(HR_EXTENSIONS_SEASONS_DESCRIPTION),
    priority = 10,
    svVersion = 1,
    svDefault = {}, -- per-season settings are created dynamically

    seasons = {},
}

--- @class seasonsExtension : extensionClass
local extension = internal.extensionClass:New(extensionDefinition)

--- Module activation function.
--- NOT for manual use. This function gets called once when the extension is loaded and then deleted afterwards.
--- @return void
function extension:Activate()
    self.date = os.date("%d%m")

    for name, season in pairs(self.seasons) do
        if self.sw[name] == nil then
            self.sw[name] = true
        end

        if self.sw[name] then
            for _, date in ipairs(season.dates) do
                if date == self.date then
                    self.logger:Debug("Activating season '%s' - %s", name, season.description)
                    season:ActivateAndEnable()
                    break
                end
            end
        end
    end

    -- debug command to manually activate seasons
    local function onDebugModeChanged(enabled)
        if enabled then
            self.logger:Debug("current date is: " .. tostring(self.date))
            core.RegisterSubCommand("seasons", "activates seasonal events for testing purposes", function(str)
                local availableSeasons = "Available seasons:"
                for name, season in pairs(self.seasons) do
                    availableSeasons = string.format("%s %s", availableSeasons, name)
                    if str == name then
                        season:ActivateAndEnable()
                        return
                    end
                end

                d(availableSeasons)
            end)
        else
            core.UnregisterSubCommand("seasons")
        end
    end
    addon.RegisterCallback(HR_EVENT_DEBUG_MODE_CHANGED, onDebugModeChanged)
end

--- create a new season.
--- @param season table season definition
--- @return seasonClass season object
function extension:NewSeason(season)
    local obj = seasonClass:New(season)
    self.seasons[obj.name] = obj
end
