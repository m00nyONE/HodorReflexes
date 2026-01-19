-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local util = addon.util
local LHAS = LibHarvensAddonSettings

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "hps"
local module = addon_modules[module_name]

-- TODO: translations
--- @return table[]
function module:GetSubMenuOptions()
    local SCREEN_WIDTH = GuiRoot:GetWidth()
    local SCREEN_HEIGHT = GuiRoot:GetHeight()

    local fontItems = util.GetFontOptions(18)
    local fontValuesMap = {}
    for _, fontInfo in ipairs(fontItems) do
        fontValuesMap[fontInfo.data] = fontInfo.name
    end

    local function GetComonListOptions(listName, list)
        return {
            core.CreateSectionHeader(listName),
            {
                type = LHAS.ST_SLIDER,
                label = GetString(HR_MENU_HORIZONTAL_POSITION),
                tooltip = GetString(HR_MENU_HORIZONTAL_POSITION_TT),
                min = 0,
                max = SCREEN_WIDTH - list.sw.windowWidth,
                step = 10,
                format = "%.0f",
                unit = " px",
                default = list.svDefault.windowPosLeft,
                getFunction = function() return list.sw.windowPosLeft end,
                setFunction = function(value)
                    list.sw.windowPosLeft = value
                    list.window:ClearAnchors()
                    list.window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, list.sw.windowPosLeft, list.sw.windowPosTop)
                end,
            },
            {
                type = LHAS.ST_SLIDER,
                label = GetString(HR_MENU_VERTICAL_POSITION),
                tooltip = GetString(HR_MENU_VERTICAL_POSITION_TT),
                min = 0,
                max = SCREEN_HEIGHT - (list.listHeaderHeight + (list.listRowHeight * 4)),
                step = 10,
                format = "%.0f",
                unit = " px",
                default = list.svDefault.windowPosTop,
                getFunction = function() return list.sw.windowPosTop end,
                setFunction = function(value)
                    list.sw.windowPosTop = value
                    list.window:ClearAnchors()
                    list.window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, list.sw.windowPosLeft, list.sw.windowPosTop)
                end,
            },
            {
                type = LHAS.ST_SLIDER,
                label = GetString(HR_MENU_SCALE),
                tooltip = GetString(HR_MENU_SCALE_TT),
                min = 60,
                max = 160,
                step = 1,
                format = "%.0f",
                unit = " %",
                default = list.svDefault.windowScale * 100,
                getFunction = function() return list.sw.windowScale * 100 end,
                setFunction = function(value)
                    list.sw.windowScale = value / 100
                    list.window:SetScale(list.sw.windowScale)
                end,
            },
            {
                type = LHAS.ST_CHECKBOX,
                label = GetString(HR_MENU_DISABLE_IN_PVP),
                tooltip = GetString(HR_MENU_DISABLE_IN_PVP_TT),
                default = list.svDefault.disableInPvP,
                getFunction = function() return list.sw.disableInPvP end,
                setFunction = function(value)
                    list.sw.disableInPvP = value
                    list:RefreshVisibility()
                end,
            },
            {
                type = LHAS.ST_DROPDOWN,
                label = GetString(HR_MENU_VISIBILITY),
                tooltip = GetString(HR_MENU_VISIBILITY_TT),
                default = GetString(HR_VISIBILITY_SHOW_ALWAYS),
                items = {
                    {name = GetString(HR_VISIBILITY_SHOW_NEVER), data = 0},
                    {name = GetString(HR_VISIBILITY_SHOW_ALWAYS), data = 1},
                    {name = GetString(HR_VISIBILITY_SHOW_OUT_OF_COMBAT), data = 2},
                    {name = GetString(HR_VISIBILITY_SHOW_NON_BOSSFIGHTS), data = 3},
                },
                getFunction = function()
                    if list.sv.enabled == 0 then return GetString(HR_VISIBILITY_SHOW_NEVER) end
                    if list.sv.enabled == 1 then return GetString(HR_VISIBILITY_SHOW_ALWAYS) end
                    if list.sv.enabled == 2 then return GetString(HR_VISIBILITY_SHOW_OUT_OF_COMBAT) end
                    if list.sv.enabled == 3 then return GetString(HR_VISIBILITY_SHOW_NON_BOSSFIGHTS) end
                end,
                setFunction = function(control, itemName, itemData)
                    list.sv.enabled = itemData.data
                    list:RefreshVisibility()
                    list:UpdateDebounced(true) -- force an update to clear potentially old data still being in the list because they where never redrawn when hidden
                end,
                width = "full",
            },
            {
                type = LHAS.ST_SLIDER,
                label = GetString(HR_MENU_LIST_WIDTH),
                tooltip = GetString(HR_MENU_LIST_WIDTH_TT),
                min = list.svDefault.windowWidth,
                max = list.svDefault.windowWidth + 150,
                step = 1,
                format = "%.0f",
                unit = " px",
                default = list.svDefault.windowWidth,
                getFunction = function() return list.sw.windowWidth end,
                setFunction = function(value)
                    list.sw.windowWidth = value
                    list.window:SetWidth(list.sw.windowWidth)
                end,
                isAdvancedSetting = true,
            },
            {
                type = LHAS.ST_DROPDOWN,
                label = "Name Font",
                tooltip = "set the font for the player names in the list.",
                default = "Default",
                items = fontItems,
                getFunction = function()
                    return fontValuesMap[list.sw.nameFont] or "Default"
                end,
                setFunction = function(control, itemName, itemData)
                    list.sw.nameFont = itemData.data
                    list:RefreshVisibility()
                    list:UpdateDebounced(true) -- force an update to clear potentially old data still being in the list because they where never redrawn when hidden
                end,
                isAdvancedSetting = true,
            },
        }
    end


    local options = {}
    local hpsList = GetComonListOptions(GetString(HR_MODULES_HPS_MENU_HEADER), self.hpsList)
    local hpsListSpecificOptions = {
        {
            type = LHAS.ST_CHECKBOX,
            label = GetString(HR_MODULES_HPS_MENU_ONLY_SHOW_HEALERS),
            tooltip = GetString(HR_MODULES_HPS_MENU_ONLY_SHOW_HEALERS_TT),
            default = self.hpsList.svDefault.onlyShowHealers,
            getFunction = function() return self.hpsList.sw.onlyShowHealers end,
            setFunction = function(value)
                self.hpsList.sw.onlyShowHealers = value
                self.hpsList:Update()
            end,
        },
        {
            type = LHAS.ST_COLOR,
            label = "HPS Color",
            tooltip = "",
            default = { util.Hex2RGB(self.hpsList.svDefault.colorHPS) },
            getFunction = function() return util.Hex2RGB(self.hpsList.sw.colorHPS) end,
            setFunction = function(r, g, b)
                self.hpsList.sw.colorHPS = util.RGB2Hex(r, g, b)
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "Overheal Color",
            tooltip = "",
            default = { util.Hex2RGB(self.hpsList.svDefault.colorOverheal) },
            getFunction = function() return util.Hex2RGB(self.hpsList.sw.colorOverheal) end,
            setFunction = function(r, g, b)
                self.hpsList.sw.colorOverheal = util.RGB2Hex(r, g, b)
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "Highlight Player Row",
            tooltip = "enable or disable highlighting of the player's row in the damage list.",
            default = self.hpsList.svDefault.listPlayerHighlight,
            getFunction = function() return self.hpsList.sw.listPlayerHighlight end,
            setFunction = function(value)
                self.hpsList.sw.listPlayerHighlight = value
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "player row highlight color",
            tooltip = "highlight color for the player's row in the hps list.",
            default = self.hpsList.svDefault.listPlayerHighlightColor,
            getFunction = function() return unpack(self.hpsList.sw.listPlayerHighlightColor) end,
            setFunction = function(r, g, b, o)
                self.hpsList.sw.listPlayerHighlightColor = {r, g, b, o}
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_SLIDER,
            label = "Header Opacity",
            tooltip = "set the opacity of the damage list header.",
            min = 0,
            max = 1,
            step = 0.05,
            format = "%.2f",
            default = self.hpsList.svDefault.listHeaderOpacity,
            getFunction = function() return self.hpsList.sw.listHeaderOpacity end,
            setFunction = function(value)
                self.hpsList.sw.listHeaderOpacity = value
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_SLIDER,
            label = "Even Row Opacity",
            tooltip = "set the opacity of the even rows in the damage list.",
            min = 0,
            max = 1,
            step = 0.05,
            format = "%.2f",
            default = self.hpsList.svDefault.listRowEvenOpacity,
            getFunction = function() return self.hpsList.sw.listRowEvenOpacity end,
            setFunction = function(value)
                self.hpsList.sw.listRowEvenOpacity = value
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_SLIDER,
            label = "Odd Row Opacity",
            tooltip = "set the opacity of the odd rows in the damage list.",
            min = 0,
            max = 1,
            step = 0.05,
            format = "%.2f",
            default = self.hpsList.svDefault.listRowOddOpacity,
            getFunction = function() return self.hpsList.sw.listRowOddOpacity end,
            setFunction = function(value)
                self.hpsList.sw.listRowOddOpacity = value
                self.hpsList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_SLIDER,
            label = "Timer Interval (ms)",
            tooltip = "set the update interval of timers in the damage list (in milliseconds). Lower values increase update frequency but may impact performance.",
            min = 50,
            max = 1000,
            step = 25,
            format = "%.0f",
            unit = " ms",
            default = self.hpsList.svDefault.timerUpdateInterval,
            getFunction = function() return self.hpsList.sw.timerUpdateInterval end,
            setFunction = function(value)
                self.hpsList.sw.timerUpdateInterval = value
            end,
            requiresReload = true,
            isAdvancedSetting = true,
        },
    }

    core.MergeOptions(hpsListSpecificOptions, hpsList)
    core.MergeOptions(hpsList, options)

    return options
end