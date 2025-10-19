-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

--- @type table<string, Logger>
core.logger = {}
--- @class Logger
core.logger.main = LibDebugLogger:Create(addon_name)

--- Initialize a sub logger
--- @param name string the name of the sub logger
--- @return table the sub logger
function core.initSubLogger(name)
    local mainLogger = core.logger.main
    if name == nil or name == "" then
        return mainLogger
    end
    if core.logger[name] ~= nil then
        mainLogger:Warn("SubLogger %s already exists!", name)
        return core.logger[name]
    end

    local subLogger = core.logger.main:Create(name)
    mainLogger:Debug("SubLogger %s created", name)
    core.logger[name] = subLogger
    return subLogger
end