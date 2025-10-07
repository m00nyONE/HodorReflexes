-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

core.logger = {}

-- logger template ( originally made by @Solinur )
if LibDebugLogger then
    core.logger.main = LibDebugLogger.Create(addon_name)
else
    local internalLogger = {}
    function internalLogger:Debug(...)
        if addon.debug then
            df(...)
        end
    end
    internalLogger.Error = internalLogger.Debug
    internalLogger.Warn = internalLogger.Debug
    internalLogger.Info = internalLogger.Debug
    internalLogger.Verbose = internalLogger.Debug
    core.logger.main = internalLogger
end


function core.initSublogger(name)
    local mainlogger = core.logger.main
    if mainlogger.Create == nil or name == nil or name == "" then return mainlogger end
    if core.logger[name] ~= nil then
        mainlogger:Warn("Sublogger %s already exists!", name)
        return core.logger[name]
    end

    local sublogger = core.logger.main:Create(name)
    mainlogger:Debug("Sublogger %s created", name)
    core.logger[name] = sublogger
    return sublogger
end