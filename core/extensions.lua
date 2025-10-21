-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.initSubLogger("extensions")

local util = addon.util

--- initializes all registered extensions
--- @return void
function core.InitializeExtensions()
    -- check if saved variables are populated
    if not core.sw.extensions then
        logger:Warn("No extensions found in saved variables, populating with defaults...")
        core.sw.extensions = core.svDefault.extensions
    end

    for extensionName, extension in util.Spairs(addon.extensions, util.SortByPriority) do
        local isEnabled = core.sw.extensions[extensionName]
        if isEnabled == nil then
            logger:Warn("Extension '%s' not found in saved variables, setting default to enabled", extensionName)
            core.sw.extensions[extensionName] = true
            isEnabled = true
        end
        if isEnabled then
            logger:Info("Initializing extension: %s", extensionName)
            extension:RunOnce("CreateSavedVariables") -- create saved variables for the extension

            -- get menu options if available
            local mainMenuOptions = extension:RunOnce("GetMainMenuOptions")
            if mainMenuOptions then
                core.RegisterMainMenuOptions(extension.friendlyName, mainMenuOptions)
            end
            local subMenuOptions = extension:RunOnce("GetSubMenuOptions")
            if subMenuOptions then
                core.RegisterSubMenuOptions(extension.friendlyName, subMenuOptions)
            end


            extension:RunOnce("Activate") -- run the extension's initialization function
            extension.enabled = true
        end
    end
end

--- registers an extension to the core
--- @param extension extensionClass the extension to register
--- @return void
function core.RegisterExtension(extension)
    if addon.extensions[extension.name] then
        logger:Error("Extension " .. extension.name .. " is already registered!")
        return
    end
    extension.enabled = false
    addon.extensions[extension.name] = extension -- add extension to the addon.extensions table
    logger:Debug("Successfully registered extension: " .. extension.name)
end

--- @class: extensionClass : ZO_InitializingObject
local extension = ZO_InitializingObject:Subclass()
internal.extensionClass = extension

-- must implement functions
extension:MUST_IMPLEMENT("Activate") -- function that gets called to activate the extension when it's enabled

-- can implement functions
function extension:GetSubMenuOptions()
    self.GetSubMenuOptions = nil
    return nil
end
function extension:GetMainMenuOptions()
    self.GetMainMenuOptions = nil
    return nil
end
function extension:GetDiagnostic()
    self.GetDiagnosticInfo = nil
    return nil
end

--- returns whether the module is enabled
--- @return boolean true if the module is enabled, false otherwise
function extension:IsEnabled()
    return self.enabled
end

--- runs a function only once and then removes it from the object
--- @param funcName string the name of the function to run
--- @param ... any the arguments to pass to the function
--- @return any the return value of the function, or nil if the function does not exist
function extension:RunOnce(funcName, ...)
    if type(self[funcName]) == "function" then
        local result = self[funcName](self, ...)
        self[funcName] = nil
        return result
    end
    return nil
end

--- initializes the extensionClass
--- @param t table a table containing the properties to set on the extensionClass
--- @return void
function extension:Initialize(extensionDefinition)
    assert(type(extensionDefinition) == "table", "extensionDefinition must be a table")
    assert(type(extensionDefinition.name) == "string" and extensionDefinition.name ~= "", "extension must have a valid name")
    assert(type(extensionDefinition.friendlyName) == "string" and extensionDefinition.friendlyName ~= "", "extension must have a valid friendlyName")
    assert(type(extensionDefinition.description) == "string", "extension must have a valid description")
    assert(type(extensionDefinition.version) == "string", "extension must have a valid version")
    assert(type(extensionDefinition.priority) == "number", "extension must have a valid priority")
    assert(type(extensionDefinition.svDefault) == "table", "extension must have a valid svDefault table")

    for k, v in pairs(extensionDefinition) do
        self[k] = v
    end

    -- create a new subLogger for the module
    self.logger = core.initSubLogger(self.name)

    -- register the module to the core
    core.RegisterExtension(self)
end

--- creates the saved variables for the extension
--- @return void
function extension:CreateSavedVariables()
    local svNamespace = string.format("extension_%s", self.name)
    local svVersion = core.svVersion + self.svVersion
    -- we use a combination of accountWide saved variables and per character saved variables. This little swappi swappi allows us to switch between them without defining new variables
    self.sw = ZO_SavedVars:NewAccountWide(core.svName, svVersion, svNamespace, self.svDefault)
    if not self.sw.accountWide then
        self.sv = ZO_SavedVars:NewCharacterIdSettings(core.svName, svVersion, svNamespace, self.svDefault)
        self.sv.accountWide = false
    else
        self.sv = self.sw
    end
end