-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.logger.main

local addon_version = addon.version
local CM = core.CM

-- for initializing basic commands from HR Core
--- registers base commands: version, donate, debug
--- @return void
function core.RegisterCoreCommands()
    logger:Debug("Registering base commands")
    core.RegisterSubCommand("version", "Show addon version", function()
        df("|cFFFF00%s|r version |c76c3f4%s|r", addon_name, addon_version)
    end)
    core.RegisterSubCommand("donate", "Donate to the author", function()
        addon.Donate()
    end)
    core.RegisterSubCommand("debug", "Toggle debug mode", function()
        addon.debug = not addon.debug
        addon.internal = internal
        df("|cFFFF00%s|r debug mode %s", addon_name, addon.debug and "|c00FF00enabled|r" or "|cFF0000disabled|r")
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