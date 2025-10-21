-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.initSubLogger("modules")

local util = addon.util


--- initializes all registered modules if they are enabled in the saved variables.
--- creates saved variables for each module.
--- registers LibGroupBroadcast protocols if available.
--- registers mainMenu options if available.
--- registers submenu if available.
--- runs the module's initialization function.
--- @return void
function core.InitializeModules()
    -- check if saved variables are populated
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
            logger:Info("Initializing module: %s", moduleName)
            module:RunOnce("CreateSavedVariables") -- create saved variables for the module
            module:RunOnce("RegisterLGBProtocols", core.LGBHandler) -- register LibGroupBroadcast Protocols if available

            -- get menu options if available
            local mainMenuOptions = module:RunOnce("GetMainMenuOptions")
            if mainMenuOptions then
                core.RegisterMainMenuOptions(module.friendlyName, mainMenuOptions)
            end
            local subMenuOptions = module:RunOnce("GetSubMenuOptions")
            if subMenuOptions then
                core.RegisterSubMenuOptions(module.friendlyName, subMenuOptions)
            end

            module:RunOnce("Activate") -- run the module's initialization function
            module.enabled = true
        end
    end
end

--- registers a module to the core
--- @param module moduleClass the module to register
--- @return void
function core.RegisterModule(module)
    if addon.modules[module.name] then
        logger:Error("Module " .. module.name .. " is already registered!")
        return
    end
    module.enabled = false -- set enabled to false by default
    addon.modules[module.name] = module -- add module to the addon.modules table
    logger:Debug("Successfully registered module: " .. module.name)
end


--- @class: moduleClass
local module = ZO_InitializingObject:Subclass()
internal.moduleClass = module

-- must implement functions
module:MUST_IMPLEMENT("Activate") -- function that gets called to activate the module when it's enabled

-- can implement functions
function module:RegisterLGBProtocols(handler)
    self.RegisterLGBProtocols = nil
    return nil
end
function module:GetSubMenuOptions()
    self.GetSubMenuOptions = nil
    return nil
end
function module:GetMainMenuOptions()
    self.GetMainMenuOptions = nil
    return nil
end
function module:GetDiagnostic()
    self.GetDiagnosticInfo = nil
    return nil
end

--- returns whether the module is enabled
--- @return boolean true if the module is enabled, false otherwise
function module:IsEnabled()
    return self.enabled
end

--- runs a function only once and then removes it from the object
--- @param funcName string the name of the function to run
--- @param ... any the arguments to pass to the function
--- @return any the return value of the function, or nil if the function does not exist
function module:RunOnce(funcName, ...)
    if type(self[funcName]) == "function" then
        local result = self[funcName](self, ...)
        self[funcName] = nil
        return result
    end
    return nil
end

--- initializes the moduleClass
--- @param t table a table containing the properties to set on the moduleClass
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

    -- create a new subLogger for the module
    self.logger = core.initSubLogger(self.name)

    -- register the module to the core
    core.RegisterModule(self)
end

--- creates the saved variables for the module
--- @return void
function module:CreateSavedVariables()
    local svNamespace = string.format("module_%s", self.name)
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