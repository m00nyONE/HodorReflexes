-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.logger.main

local util = core.util


-- utility functions
--- sorts a table of modules by their priority field, and by name if priorities are equal
--- @param t table table of modules
--- @param a string key of the first module to compare
--- @param b string key of the second module to compare
--- @return boolean true if a should come before b, false otherwise
local function sortByPriority(t, a, b)
    if t[a].priority == t[b].priority then
        return a < b
    end
    return t[a].priority < t[b].priority
end

--- initializes all registered modules if they are enabled in the saved variables.
--- creates saved variables for each module.
--- registers LibGroupBroadcast protocols if available.
--- registers mainMenu options if available.
--- registers submenu if available.
--- runs the module's initialization function.
--- @return void
function core.InitializeModules()
    logger:Debug("Initializing modules...")

    -- check if saved variables are populated
    if not core.sw.modules then
        logger:Debug("No modules found in saved variables, populating with defaults...")
        core.sw.modules = core.svDefault.modules
    end

    for moduleName, module in util.Spairs(addon.modules, sortByPriority) do
        logger:Debug("Initializing module: %s", moduleName)
        if core.sw.modules[moduleName] then
            -- create saved variables for the module
            module:RunOnce("CreateSavedVariables")

            -- register LibGroupBroadcast Protocols if available
            module:RunOnce("RegisterLGBProtocols", core.LGBHandler)

            -- register mainMenu options if available
            local mainMenuOptions = module:RunOnce("GetMainMenuOptions")

            -- register submenu if available
            local menuOptions = module:RunOnce("GetMenuOptions")

            -- run the module's initialization function
            module:RunOnce("Activate")
            module.RunOnce = nil
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
internal.moduleClass = ZO_InitializingObject:Subclass()
local moduleClass = internal.moduleClass

-- must implement fields
moduleClass:MUST_IMPLEMENT("name") -- unique name of the module
moduleClass:MUST_IMPLEMENT("friendlyName") -- user friendly name of the module; for example to be displayed in the menu
moduleClass:MUST_IMPLEMENT("description") -- short description of the module; for example to be displayed in the menu
moduleClass:MUST_IMPLEMENT("version") -- version of the module
moduleClass:MUST_IMPLEMENT("priority") -- modules with higher priority get activated first and menus get added first
moduleClass:MUST_IMPLEMENT("svDefault") -- default saved variables for the module

-- must implement functions
moduleClass:MUST_IMPLEMENT("Activate") -- function that gets called to activate the module when it's enabled

-- can implement functions
function moduleClass:RegisterLGBProtocols(handler)
    self.RegisterLGBProtocols = nil
end
function moduleClass:GetMainMenuOptions()
    self.GetMainMenuOptions = nil
end
function moduleClass:GetMenuOptions()
    self.GetMenuOptions = nil
end
function moduleClass:GetDiagnostic()
    self.GetDiagnosticInfo = nil
end

--- runs a function only once and then removes it from the object
--- @param funcName string the name of the function to run
--- @param ... any the arguments to pass to the function
--- @return any the return value of the function, or nil if the function does not exist
function moduleClass:RunOnce(funcName, ...)
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
function moduleClass:Initialize(t)
    -- Initialization code for the moduleClass
    if t then
        for k, v in pairs(t) do
            self[k] = v
        end
    end

    -- create a new subLogger for the module
    self.logger = core.initSubLogger(self.name)

    -- register the module to the core
    core.RegisterModule(self)
end

--- creates the saved variables for the module
--- @return void
function moduleClass:CreateSavedVariables()
    -- we use a combination of accountWide saved variables and per character saved variables. This little swappi swappi allows us to switch between them without defining new variables
    self.sw = ZO_SavedVars:NewAccountWide(core.svName, core.svVersion, self.name, self.svDefault)
    if not core.sw.accountWide then
        self.sv = ZO_SavedVars:NewCharacterIdSettings(core.svName, core.svVersion, self.name, self.svDefault)
        core.sv.accountWide = false
    else
        self.sv = self.sw
    end
end