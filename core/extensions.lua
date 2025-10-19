-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.initSubLogger("extensions")

--- initializes all registered extensions
--- @return void
function core.InitializeExtensions()
    -- check if saved variables are populated
    if not core.sw.extensions then
        logger:Warn("No extensions found in saved variables, populating with defaults...")
        core.sw.extensions = core.svDefault.extensions
    end

    for extensionName, extension in pairs(addon.extensions) do
        local isEnabled = core.sw.extensions[extensionName]
        if isEnabled == nil then
            logger:Warn("Extension '%s' not found in saved variables, setting default to enabled", extensionName)
            core.sw.extensions[extensionName] = true
            isEnabled = true
        end
        if isEnabled then
            logger:Info("Initializing extension: %s", extensionName)
            extension:RunOnce("CreateSavedVariables")
            extension:RunOnce("Activate")
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
local extensionClass = ZO_InitializingObject:Subclass()
internal.extensionClass = extensionClass

-- must implement functions
extensionClass:MUST_IMPLEMENT("Activate") -- function that gets called to activate the extension when it's enabled


--- returns whether the module is enabled
--- @return boolean true if the module is enabled, false otherwise
function extensionClass:IsEnabled()
    return self.enabled
end

--- runs a function only once and then removes it from the object
--- @param funcName string the name of the function to run
--- @param ... any the arguments to pass to the function
--- @return any the return value of the function, or nil if the function does not exist
function extensionClass:RunOnce(funcName, ...)
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
function extensionClass:Initialize(t)
    -- Initialization code for the moduleClass
    if t then
        for k, v in pairs(t) do
            self[k] = v
        end
    end

    -- create a new subLogger for the module
    self.logger = core.initSubLogger(self.name)

    -- register the module to the core
    core.RegisterExtension(self)
end

--- creates the saved variables for the extension
--- @return void
function extensionClass:CreateSavedVariables()
    local svVersion = core.svVersion + self.svVersion
    -- we use a combination of accountWide saved variables and per character saved variables. This little swappi swappi allows us to switch between them without defining new variables
    self.sw = ZO_SavedVars:NewAccountWide(core.svName, svVersion, self.name, self.svDefault)
    if not self.sw.accountWide then
        self.sv = ZO_SavedVars:NewCharacterIdSettings(core.svName, svVersion, self.name, self.svDefault)
        self.sv.accountWide = false
    else
        self.sv = self.sw
    end
end