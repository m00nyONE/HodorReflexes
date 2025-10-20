-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_extensions = addon.extensions

--- @class listThemeClass : ZO_Object
local listThemeClass = ZO_InitializingObject:Subclass()
addon_extensions.listThemeClass = listThemeClass


listThemeClass:MUST_IMPLEMNT("Activate")

--- NOT for manual use! this is a helper function that runs a function only once and then removes it from the instance.
--- If you use it on a still needed function, it will be gone after the first call and thus break your theme!
--- @param funcName string name of the function to run once
--- @param ... any arguments to pass to the function
--- @return any result of the function, or nil if the function does not exist
function listThemeClass:RunOnce(funcName, ...)
    if type(self[funcName]) == "function" then
        local result = self[funcName](self, ...)
        self[funcName] = nil
        return result
    end
    return nil
end

--- check if the theme is enabled
--- @return boolean
function listThemeClass:IsEnabled()
    return self.enabled
end

--- activate and enable the theme
--- @return void
function listThemeClass:ActivateAndEnable()
    if not self:IsEnabled() then
        self.enabled = true
        self:Activate()
    end
end

function listThemeClass:Initialize()

end

function listThemeClass:Instantiate(list)
    self.list = list

    self:RunOnce("CreateSavedVariables")
end

--- create saved variables for the theme
--- @return void
function listThemeClass:CreateSavedVariables()
    local svNamespace = self.listName .. "List" .. "_theme_" .. self.name
    local svVersion = core.svVersion + self.svVersion
    -- we use a combination of accountWide saved variables and per character saved variables. This little swappi swappi allows us to switch between them without defining new variables
    self.sw = ZO_SavedVars:NewAccountWide(core.svName, svVersion, svNamespace, self.svDefault)
    if not core.sw.accountWide then
        self.sv = ZO_SavedVars:NewCharacterIdSettings(core.svName, svVersion, svNamespace, self.svDefault)
        core.sv.accountWide = false
    else
        self.sv = self.sw
    end
end