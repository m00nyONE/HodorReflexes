-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_extensions = addon.extensions
local internal_extensions = internal.extensions

local extensionDefinition = {
    name = "themes",
    friendlyName = "themes",
    description = "allos you to theme various lists",
    priority = 12,
    version = "0.1.0",
    svDefault = {
        activeListThemes = {},
    },

    listThemeClass = {}, -- will be set later

    themableListsNames = {}, -- stores names of lists which can be themed
    registeredListThemes = {}, -- stores all registered listThemes

    startupThemeActivateDelay = 1000, -- delay in ms before activating themes on startup - hopefully enough time for all external addons to register their themes
}

--- @class themesExtension : extensionClass
local extension = internal.extensionClass:New(extensionDefinition)


function extension:Activate()
    for name, list in internal.registeredLists do
        self.themableListsNames[name] = true
        if self.sw.activeListThemes[name] == nil then
            self.sw.activeListThemes[name] = "default"
        end
    end

    zo_callLater(function()
        self:ActivateSavedTheme()
    end, self.startupThemeActivateDelay)
end

--- Activates the saved themes for all themable lists.
--- @return void
function extension:ActivateSavedTheme()
    for name, list in internal.registeredLists do
        local themeName = self.sw.activeListThemes[name]
        if themeName == "default" then
            self.logger:Debug("No theme selected for '%s', skipping.", name)
        else
            local themeClass = self.themableListsNames[themeName]
            if themeClass then
                self.logger:Info("Applying theme '%s' to list '%s'", themeName, name)
                --themeClass:RunOnce("Activate")
                -- TODO: properly replace types & creationFunctions
            else
                self.logger:Info("Theme '%s' not installed for list '%s'. Reverting to default.", themeName, name)
                self.sw.activeListThemes[name] = "default"
            end
        end
    end
end

--- register a new Theme for a list. !THIS HAS TO BE DONE DURING RUNTIME, NOT DURING LOAD TIME!
--- @param theme listThemeClass
function extension:RegisterListTheme(listThemeClass)
    -- we do not want to assert here, but log errors instead. If we assert, the whole addon might fail to load because of a faulty theme.
    if type(listThemeClass) ~= "table" then
        self.logger:Error("Failed to register theme: theme definition must be a table.")
        return false
    end
    if type(listThemeClass.name) ~= "string" then
        self.logger:Error("Failed to register theme: theme must have a name string.")
        return false
    end
    if type(listThemeClass.description) ~= "string" then
        self.logger:Error("Failed to register theme: theme must have a description string.")
        return false
    end
    if type(listThemeClass.listName) ~= "string" then
        self.logger:Error("Failed to register theme: theme must have a listName defined for which list it's made for.")
        return false
    end

    self.logger:Info("Registering theme '%s' for list '%s'", listThemeClass.name, listThemeClass.listName)
    self.themes[listThemeClass.name] = listThemeClass

    if not self.themableListsNames[listThemeClass.listName] then
        self.logger:Warn("List '%s' is not loaded or not themable. Skipping instantiation of '%s' theme.", listThemeClass.listName, listThemeClass.name)
        return false
    end

    -- instantiate theme with the list it wants to theme
    listThemeClass:RunOnce("Instantiate", internal.registeredLists[listThemeClass.listName])
    return true
end