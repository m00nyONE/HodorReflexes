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

--- A logger that does nothing
--- @param self table
--- @param ... any
--- @return void
local function noLog(self, ...)
    --df(...)
end
local noLogger = {
    Debug = noLog,
    Info = noLog,
    Warn = noLog,
    Error = noLog,
}

--- Initialize a sub logger
--- @param name string the name of the sub logger
--- @return table the sub logger
function core.GetLogger(name)
    if IsConsoleUI() then
        return noLogger
    end
    return core.logger.main:Create(name)
end