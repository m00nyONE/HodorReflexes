-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/cmd")

local CM = core.CM

local HR_EVENT_DEBUG_MODE_CHANGED = "HR_EVENT_DEBUG_MODE_CHANGED"
core.HR_EVENT_DEBUG_MODE_CHANGED = HR_EVENT_DEBUG_MODE_CHANGED

local addon_version = addon.version

-- for initializing basic commands from HR Core
--- registers base commands: version, donate, debug
--- @return void
function core.RegisterCoreCommands()
    core.RegisterSubCommand("version", "Show addon version", function()
        df("|cFFFF00%s|r version |c76c3f4%s|r", addon_name, addon_version)
    end)
    core.RegisterSubCommand("donate", "Donate to the author", function()
        addon.Donate()
    end)
    core.RegisterSubCommand("debug", "Toggle debug mode", function()
        addon.debug = not addon.debug
        df("|cFFFF00%s|r debug mode %s", addon_name, addon.debug and "|c00FF00enabled|r" or "|cFF0000disabled|r")
        logger:Info("Debug mode %s", addon.debug and "enabled" or "disabled")

        if addon.debug then
            addon.internal = internal
        else
            addon.internal = nil
        end

        CM:FireCallbacks(HR_EVENT_DEBUG_MODE_CHANGED, addon.debug)
    end)
end


-- registering commands
--- @type table<string, {help: string, func: function}>
local commands = {}

--- allow other modules to register sub commands.
--- @param command string the command name
--- @param help string the help text for the command
--- @param func function the function to execute when the command is called
--- @return void
function core.RegisterSubCommand(command, help, func)
    assert(type(command) == "string", "command must be a string")
    assert(type(help) == "string", "help must be a string")
    assert(type(func) == "function", "func must be a function")
    logger:Debug("Registering command: /%s %s", addon.slashCmd, command)

    commands[command] = {
        help = help,
        func = func,
    }
end

--- allow other modules to unregister sub commands.
--- @param command string the command name
--- @return void
function core.UnregisterSubCommand(command)
    assert(type(command) == "string", "command must be a string")
    logger:Debug("Unregistering command: /%s %s", addon.slashCmd, command)

    commands[command] = nil
end

-- create slash command
SLASH_COMMANDS[string.format("/%s", addon.slashCmd)] = function(str)
    if str == nil or str == "" then
        df("%s commands:", addon_name)
        for name, cmd in pairs(commands) do
            df("/%s %s - %s", addon.slashCmd, name, cmd.help)
        end
        return
    end

    for cmd, _ in pairs(commands) do
        if zo_strmatch(str, "^" .. cmd .. "%s*") then
            str = zo_strmatch(str, "^" .. cmd .. "%s*(.*)$") or ""
            commands[cmd].func(str)
            return
        end
    end

    df("Command not found: /%s %s", addon.slashCmd, str)
    df("Use /%s to see available commands", addon.slashCmd)
end