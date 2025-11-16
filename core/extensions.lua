-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/extensions")

local util = addon.util

--- Initializes all registered extensions.
--- Checks if saved variables are populated, initializes extensions if enabled,
--- and runs their respective initialization logic.
--- @return void
function core.InitializeExtensions()
    -- Check if saved variables are populated
    if not core.sw.extensions then
        logger:Warn("No extensions found in saved variables, populating with defaults...")
        core.sw.extensions = core.svDefault.extensions
    end

    -- Iterate through all registered extensions and initialize them if enabled
    for extensionName, extension in util.Spairs(addon.extensions, util.SortByPriority) do
        local isEnabled = core.sw.extensions[extensionName]
        if isEnabled == nil then
            logger:Warn("Extension '%s' not found in saved variables, setting default to enabled", extensionName)
            core.sw.extensions[extensionName] = true
            isEnabled = true
        end
        if isEnabled then
            logger:Debug("Initializing extension: %s", extensionName)
            extension:RunOnce("CreateSavedVariables") -- Create saved variables for the extension

            extension:RunOnce("Activate") -- Run the extension's activation function
            extension.enabled = true

            -- Get main menu options if available
            local mainMenuOptions = extension:RunOnce("GetMainMenuOptions")
            if mainMenuOptions then
                core.RegisterMainMenuOptions(extension.friendlyName, mainMenuOptions)
            end

            -- Get submenu options if available
            local subMenuOptions = extension:RunOnce("GetSubMenuOptions")
            if subMenuOptions then
                core.RegisterSubMenuOptions(extension.friendlyName, subMenuOptions)
            end
        end
    end
end

--- Registers an extension to the core.
--- Ensures the extension is not already registered before adding it.
--- @param extension extensionClass The extension to register.
--- @return void
function core.RegisterExtension(extension)
    if addon.extensions[extension.name] then
        logger:Error("Extension " .. extension.name .. " is already registered!")
        return
    end
    extension.enabled = false -- Set enabled to false by default
    addon.extensions[extension.name] = extension -- Add extension to the addon.extensions table
    logger:Debug("Successfully registered extension: " .. extension.name)
end

--- @class extensionClass : ZO_InitializingObject
--- Base class for extensions. All extensions should inherit from this class.
local extension = ZO_InitializingObject:Subclass()
internal.extensionClass = extension

-- Must implement functions
extension:MUST_IMPLEMENT("Activate") -- Function that gets called to activate the extension when it's enabled

-- Optional functions
--- Returns submenu options if available.
--- @return nil
function extension:GetSubMenuOptions()
    self.GetSubMenuOptions = nil
    return nil
end

--- Returns main menu options if available.
--- @return nil
function extension:GetMainMenuOptions()
    self.GetMainMenuOptions = nil
    return nil
end

--- Returns diagnostic data for the extension if available.
--- @return nil
function extension:GetDiagnostic()
    self.GetDiagnosticInfo = nil
    return nil
end

--- Returns whether the extension is enabled.
--- @return boolean true if the extension is enabled, false otherwise.
function extension:IsEnabled()
    return self.enabled
end

--- Runs a function only once and then removes it from the object.
--- @param funcName string The name of the function to run.
--- @param ... any Arguments to pass to the function.
--- @return any The return value of the function, or nil if the function does not exist.
function extension:RunOnce(funcName, ...)
    if type(self[funcName]) == "function" then
        local result = self[funcName](self, ...)
        self[funcName] = nil
        return result
    end
    return nil
end

--- Initializes the extensionClass.
--- Sets the properties of the extension based on the given definition.
--- @param extensionDefinition table A table containing the properties of the extension.
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

    -- Create a new subLogger for the extension
    self.logger = core.GetLogger("extensions/" .. self.name)

    -- Register the extension to the core
    core.RegisterExtension(self)
end

--- Creates the saved variables for the extension.
--- Uses a combination of account-wide and per-character saved variables.
--- @return void
function extension:CreateSavedVariables()
    local svNamespace = string.format("extension_%s", self.name)
    local svVersion = core.svVersion + self.svVersion
    -- Use a combination of account-wide and per-character saved variables
    self.sw = ZO_SavedVars:NewAccountWide(core.svName, svVersion, svNamespace, self.svDefault)
    if not core.sw.accountWide then
        self.sv = ZO_SavedVars:NewCharacterIdSettings(core.svName, svVersion, svNamespace, self.svDefault)
        core.sv.accountWide = false
    else
        self.sv = self.sw
    end
end
