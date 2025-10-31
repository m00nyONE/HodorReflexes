-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/modules")

local util = addon.util

--- Initializes all registered modules if they are enabled in the saved variables.
--- Creates saved variables for each module.
--- Registers LibGroupBroadcast protocols if available.
--- Registers main menu options if available.
--- Registers submenu options if available.
--- Runs the module's activation function.
--- @return void
function core.InitializeModules()
    -- Check if saved variables are populated
    if not core.sw.modules then
        logger:Warn("No modules found in saved variables, populating with defaults...")
        core.sw.modules = core.svDefault.modules
    end

    for moduleName, module in util.Spairs(addon.modules, util.SortByPriority) do
        local isEnabled = core.sw.modules[moduleName]
        if isEnabled == nil then
            logger:Warn("Module '%s' not found in saved variables, setting default to enabled", moduleName)
            core.sw.modules[moduleName] = true
            isEnabled = true
        end
        if isEnabled then
            logger:Debug("Initializing module: %s", moduleName)
            module:RunOnce("CreateSavedVariables") -- Create saved variables for the module
            module:RunOnce("RegisterLGBProtocols", core.LGBHandler) -- Register LibGroupBroadcast protocols if available

            module:RunOnce("Activate") -- Run the module's activation function
            module.enabled = true

            -- Get main menu options if available
            local mainMenuOptions = module:RunOnce("GetMainMenuOptions")
            if mainMenuOptions then
                core.RegisterMainMenuOptions(module.friendlyName, mainMenuOptions)
            end

            -- Get submenu options if available
            local subMenuOptions = module:RunOnce("GetSubMenuOptions")
            if subMenuOptions then
                core.RegisterSubMenuOptions(module.friendlyName, subMenuOptions)
            end
        end
    end
end

--- Registers a module to the core.
--- @param module moduleClass The module to register.
--- @return void
function core.RegisterModule(module)
    if addon.modules[module.name] then
        logger:Error("Module " .. module.name .. " is already registered!")
        return
    end
    module.enabled = false -- Set enabled to false by default
    addon.modules[module.name] = module -- Add module to the addon.modules table
    logger:Debug("Successfully registered module: " .. module.name)
end

---@class moduleClass : ZO_InitializingObject
local module = ZO_InitializingObject:Subclass()
internal.moduleClass = module

-- Must implement functions
module:MUST_IMPLEMENT("Activate") -- Function that gets called to activate the module when it's enabled

-- Optional functions
--- Registers LibGroupBroadcast protocols if available.
--- @param handler any The handler for protocol registration.
--- @return nil
function module:RegisterLGBProtocols(handler)
    self.RegisterLGBProtocols = nil
    return nil
end

--- Returns submenu options if available.
--- @return nil
function module:GetSubMenuOptions()
    self.GetSubMenuOptions = nil
    return nil
end

--- Returns main menu options if available.
--- @return nil
function module:GetMainMenuOptions()
    self.GetMainMenuOptions = nil
    return nil
end

--- Returns diagnostic data for the module if available.
--- @return nil
function module:GetDiagnostic()
    self.GetDiagnosticInfo = nil
    return nil
end

--- Returns whether the module is enabled.
--- @return boolean true if the module is enabled, false otherwise.
function module:IsEnabled()
    return self.enabled
end

--- Runs a function only once and then removes it from the object.
--- @param funcName string The name of the function to run.
--- @param ... any Arguments to pass to the function.
--- @return any The return value of the function, or nil if the function does not exist.
function module:RunOnce(funcName, ...)
    if type(self[funcName]) == "function" then
        local result = self[funcName](self, ...)
        self[funcName] = nil
        return result
    end
    return nil
end

--- Initializes the moduleClass.
--- Sets the properties of the module based on the given definition.
--- @param moduleDefinition table A table containing the properties of the module.
--- @return void
function module:Initialize(moduleDefinition)
    assert(type(moduleDefinition) == "table", "moduleDefinition must be a table")
    assert(type(moduleDefinition.name) == "string" and moduleDefinition.name ~= "", "module must have a valid name")
    assert(type(moduleDefinition.friendlyName) == "string" and moduleDefinition.friendlyName ~= "", "module must have a valid friendlyName")
    assert(type(moduleDefinition.description) == "string", "module must have a valid description")
    assert(type(moduleDefinition.version) == "string", "module must have a valid version")
    assert(type(moduleDefinition.priority) == "number", "module must have a valid priority")
    assert(type(moduleDefinition.svDefault) == "table", "module must have a valid svDefault table")

    for k, v in pairs(moduleDefinition) do
        self[k] = v
    end

    -- Create a new subLogger for the module
    self.logger = core.GetLogger("modules/" .. self.name)

    -- Register the module to the core
    core.RegisterModule(self)
end

--- Creates the saved variables for the module.
--- Uses a combination of account-wide and per-character saved variables.
--- @return void
function module:CreateSavedVariables()
    local svNamespace = string.format("module_%s", self.name)
    local svVersion = core.svVersion + self.svVersion
    -- Use a combination of account-wide and per-character saved variables.
    self.sw = ZO_SavedVars:NewAccountWide(core.svName, svVersion, svNamespace, self.svDefault)
    if not core.sw.accountWide then
        self.sv = ZO_SavedVars:NewCharacterIdSettings(core.svName, svVersion, svNamespace, self.svDefault)
        core.sv.accountWide = false
    else
        self.sv = self.sw
    end
end
