local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local addon_version = addon.version
local internal = addon.internal
local CM = internal.CM

-- Events
local HR_EVENT_LOCKUI = "LockUI"
local HR_EVENT_UNLOCKUI = "UnlockUI"
addon.HR_EVENT_LOCKUI = HR_EVENT_LOCKUI
addon.HR_EVENT_UNLOCKUI = HR_EVENT_UNLOCKUI



-- for initializing basic commands from HR Core
function internal.RegisterBaseCommands()
    internal.RegisterSubCommand("version", "Show addon version", function()
        d(string.format("|cFFFF00%s|r version |c76c3f4%s|r", addon_name, addon_version))
    end)
    internal.RegisterSubCommand("donate", "Donate to the author", function()
        addon.Donate()
    end)
    internal.RegisterSubCommand("lock", "Lock the addon UI", function()
        CM:FireCallbacks(HR_EVENT_LOCKUI)
        d(string.format("|cFFFF00%s|r UI locked", addon_name))
    end)
    internal.RegisterSubCommand("unlock", "Unlock the addon UI", function()
        CM:FireCallbacks(HR_EVENT_UNLOCKUI)
        d(string.format("|cFFFF00%s|r UI unlocked", addon_name))
    end)
end


-- registering commands
local commands = {}

function internal.RegisterSubCommand(command, help, func)
    assert(type(command) == "string", "command must be a string")
    assert(type(help) == "string", "help must be a string")
    assert(type(func) == "function", "func must be a function")

    commands[command] = {
        help = help,
        func = func,
    }
end

-- create slash command
SLASH_COMMANDS[string.format("/%s", addon.slashCmd)] = function(str)
    if str == nil or str == "" then
        d("")
        d(string.format("%s commands:", addon_name))
        for name, cmd in pairs(commands) do
            d(string.format("/%s %s - %s", addon.slashCmd, name, cmd.help))
        end
        d("")
        return
    end

    for cmd, _ in pairs(commands) do
        if zo_strmatch(str, "^" .. cmd .. "%s*") then
            str = zo_strmatch(str, "^" .. cmd .. "%s*(.*)$") or ""
            commands[cmd].func(str)
            return
        end
    end

    d("command not found")
end