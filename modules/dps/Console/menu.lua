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

local module_name = "dps"
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
    local damageList = GetComonListOptions(GetString(HR_MODULES_DPS_MENU_HEADER), self.damageList)
    local damageListSpecificOptions = {
        {
            type = LHAS.ST_CHECKBOX,
            label = GetString(HR_MODULES_DPS_MENU_SHOW_SUMMARY),
            tooltip = GetString(HR_MODULES_DPS_MENU_SHOW_SUMMARY_TT),
            default = self.damageList.svDefault.showSummary,
            getFunction = function() return self.damageList.sw.showSummary end,
            setFunction = function(value)
                self.damageList.sw.showSummary = value
                self.damageList:Update()
            end,
        },
        {
            type = LHAS.ST_SLIDER,
            label = "Burst Window (s)",
            tooltip = "set the time window (in seconds) for calculating burst damage.",
            min = 5,
            max = 60,
            step = 1,
            format = "%.0f",
            default = self.damageList.svDefault.burstWindowSeconds,
            getFunction = function() return self.damageList.sw.burstWindowSeconds end,
            setFunction = function(value)
                self.damageList.sw.burstWindowSeconds = value
                self.damageList:Update()
            end,
            disable = function() return not self.damageList.sw.showSummary end,
        },
        {
            type = LHAS.ST_COLOR,
            label = "Group DPS Color",
            tooltip = "color used to display the group DPS value.",
            default = { util.Hex2RGB(self.damageList.svDefault.colorGroupDPS) },
            getFunction = function() return util.Hex2RGB(self.damageList.sw.colorGroupDPS) end,
            setFunction = function(r, g, b)
                self.damageList.sw.colorGroupDPS = util.RGB2Hex(r, g, b)
                self.damageList:Update()
            end,
            disable = function() return not self.damageList.sw.showSummary end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "Group Burst DPS Color",
            tooltip = "color used to display the group burst DPS value.",
            default = { util.Hex2RGB(self.damageList.svDefault.colorBurstDPS) },
            getFunction = function() return util.Hex2RGB(self.damageList.sw.colorBurstDPS) end,
            setFunction = function(r, g, b)
                self.damageList.sw.colorBurstDPS = util.RGB2Hex(r, g, b)
                self.damageList:Update()
            end,
            disable = function() return not self.damageList.sw.showSummary end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "Total Damage Color",
            tooltip = "",
            default = { util.Hex2RGB(self.damageList.svDefault.colorDamageTotal) },
            getFunction = function() return util.Hex2RGB(self.damageList.sw.colorDamageTotal) end,
            setFunction = function(r, g, b)
                self.damageList.sw.colorDamageTotal = util.RGB2Hex(r, g, b)
                self.damageList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "Boss Damage Color",
            tooltip = "",
            default = { util.Hex2RGB(self.damageList.svDefault.colorDamageBoss) },
            getFunction = function() return util.Hex2RGB(self.damageList.sw.colorDamageBoss) end,
            setFunction = function(r, g, b)
                self.damageList.sw.colorDamageBoss = util.RGB2Hex(r, g, b)
                self.damageList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "Highlight Player Row",
            tooltip = "enable or disable highlighting of the player's row in the damage list.",
            default = self.damageList.svDefault.listPlayerHighlight,
            getFunction = function() return self.damageList.sw.listPlayerHighlight end,
            setFunction = function(value)
                self.damageList.sw.listPlayerHighlight = value
                self.damageList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "player row highlight color",
            tooltip = "highlight color for the player's row in the damage list.",
            default = self.damageList.svDefault.listPlayerHighlightColor,
            getFunction = function() return unpack(self.damageList.sw.listPlayerHighlightColor) end,
            setFunction = function(r, g, b, o)
                self.damageList.sw.listPlayerHighlightColor = {r, g, b, o}
                self.damageList:Update()
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
            default = self.damageList.svDefault.listHeaderOpacity,
            getFunction = function() return self.damageList.sw.listHeaderOpacity end,
            setFunction = function(value)
                self.damageList.sw.listHeaderOpacity = value
                self.damageList:Update()
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
            default = self.damageList.svDefault.listRowEvenOpacity,
            getFunction = function() return self.damageList.sw.listRowEvenOpacity end,
            setFunction = function(value)
                self.damageList.sw.listRowEvenOpacity = value
                self.damageList:Update()
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
            default = self.damageList.svDefault.listRowOddOpacity,
            getFunction = function() return self.damageList.sw.listRowOddOpacity end,
            setFunction = function(value)
                self.damageList.sw.listRowOddOpacity = value
                self.damageList:Update()
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
            default = self.damageList.svDefault.timerUpdateInterval,
            getFunction = function() return self.damageList.sw.timerUpdateInterval end,
            setFunction = function(value)
                self.damageList.sw.timerUpdateInterval = value
            end,
            requiresReload = true,
            isAdvancedSetting = true,
        },
    }

    core.MergeOptions(damageListSpecificOptions, damageList)
    core.MergeOptions(damageList, options)

    return options
end