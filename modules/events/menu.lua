local M = HodorReflexes.modules.events
local LAM = LibAddonMenu2

function M.BuildMenu()

    local panel = HodorReflexes.GetModulePanelConfig(GetString(HR_MENU_EVENTS))

    local options = {}
    if HodorReflexes.modules.share.IsEnabled() then
        options = {
            {
                type = "description",
                text = GetString(HR_MENU_EVENTS_DESC),
            },
            {
                type = "header",
                name = string.format("|cFFFACD%s|r", GetString(HR_MENU_GENERAL)),
            },
            {
                reference = "HodorReflexesMenu_Events_enabled",
                type = "checkbox",
                name = function()
                    return string.format(M.sv.enabled and "|c00FF00%s|r" or "|cFF0000%s|r", GetString(HR_MENU_GENERAL_ENABLED))
                end,
                --tooltip = GetString(HR_MENU_EVENTS_ENABLED_TT),
                default = M.default.enabled,
                getFunc = function() return M.sv.enabled end,
                setFunc = function(value)
                    M.sv.enabled = value or false
                    HodorReflexesMenu_Events_enabled.label:SetText(string.format(value and "|c00FF00%s|r" or "|cFF0000%s|r", GetString(HR_MENU_GENERAL_ENABLED)))
                end,
                requiresReload = true,
            },
        }
    else
        options =  {
            {
                type = "description",
                text = string.format("|cFF0000%s|r", GetString(HR_MENU_EVENTS_DISABLED))
            },
        }
    end

    LAM:RegisterAddonPanel(M.name .. "Menu", panel)
    LAM:RegisterOptionControls(M.name .. "Menu", options)

end