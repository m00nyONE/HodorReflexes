-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.logger.main

-- class: extensionClass
internal.extensionClass = ZO_InitializingObject:Subclass()
local extensionClass = internal.extensionClass

function core.InitializeExtensions()
    logger:Debug("Initializing extensions...")
end

function core.RegisterExtension(extension)
    assert(addon.extensions[extension.name] == nil, "extension already registered")
    addon.extension[extension.name] = extension -- add extension to the addon.extension table
end

function extensionClass:RunOnce(funcName, ...)
    if type(self[funcName]) == "function" then
        local result = self[funcName](self, ...)
        self[funcName] = nil
        return result
    end
    return nil
end

function extensionClass:Initialize(t)
    -- Initialization code for the moduleClass
    if t then
        for k, v in pairs(t) do
            self[k] = v
        end
    end

    -- create a new sublogger for the module
    self.logger = core.initSublogger(self.name)

    -- register the module to the core
    core.RegisterExtension(self)
end

function extensionClass:CreateSavedVariables()
    -- we use a combination of accountWide saved variables and per character saved variables. This little swappi swappi allows us to switch between them without defining new variables
    self.sw = ZO_SavedVars:NewAccountWide(core.svName, core.svVersion, self.name, self.svDefault)
    if not self.sw.accountWide then
        self.sv = ZO_SavedVars:NewCharacterIdSettings(core.svName, core.svVersion, self.name, self.svDefault)
        self.sv.accountWide = false
    else
        self.sv = self.sw
    end
end