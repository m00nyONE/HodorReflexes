-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local util = addon.util

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "ult"
local module = addon_modules[module_name]

local LHAS = LibHarvensAddonSettings

--- builds the submenu options for the ult module
--- @return table[]
function module:GetSubMenuOptions()
    local SCREEN_WIDTH = GuiRoot:GetWidth()
    local SCREEN_HEIGHT = GuiRoot:GetHeight()

    local fontItems = util.GetFontOptions(19)
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
                getFunction = function() return list.sv.disableInPvP end,
                setFunction = function(value)
                    list.sv.disableInPvP = value
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
                type = LHAS.ST_CHECKBOX,
                label = "Show Percent",
                tooltip = "show/hide the percent value in the list.",
                default = list.svDefault.showPercentValue == 1.0,
                getFunction = function() return list.sw.showPercentValue == 1.0 end,
                setFunction = function(value)
                    list.sw.showPercentValue = value and 1.0 or 0.0
                    list:Update()
                end,
            },
            {
                type = LHAS.ST_CHECKBOX,
                label = "Show Points",
                tooltip = "show/hide the raw value in the list.",
                default = list.svDefault.showRawValue == 1.0,
                getFunction = function() return list.sw.showRawValue == 1.0 end,
                setFunction = function(value)
                    list.sw.showRawValue = value and 1.0 or 0.0
                    list:Update()
                end,
            },
            {
                type = LHAS.ST_CHECKBOX,
                label = "Support Range Only",
                tooltip = "only show players that are in range for support ultimates.",
                default = list.svDefault.supportRangeOnly,
                getFunction = function() return list.sw.supportRangeOnly end,
                setFunction = function(value)
                    list.sw.supportRangeOnly = value
                    list:Update()
                end,
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
            {
                type = LHAS.ST_SLIDER,
                label = "Header Opacity",
                tooltip = "set the opacity of the list header.",
                min = 0,
                max = 1,
                step = 0.05,
                format = "%.2f",
                unit = " ",
                default = list.svDefault.headerOpacity,
                getFunction = function() return list.sw.headerOpacity end,
                setFunction = function(value)
                    list.sw.headerOpacity = value
                    list._redrawHeaders = true
                    list:Update()
                end,
                isAdvancedSetting = true,
            },
            {
                type = LHAS.ST_SLIDER,
                label = "Background Opacity",
                tooltip = "set the background opacity of the list.",
                min = 0,
                max = 1,
                step = 0.05,
                format = "%.2f",
                unit = " ",
                default = list.svDefault.backgroundOpacity,
                getFunction = function() return list.sw.backgroundOpacity end,
                setFunction = function(value)
                    list.sw.backgroundOpacity = value
                    list:SetBackgroundOpacity(value)
                end,
                isAdvancedSetting = true,
            },
            {
                type = LHAS.ST_SLIDER,
                label = "Zero Timer Opacity",
                tooltip = "set the opacity of the timers when at zero.",
                min = 0.05,
                max = 1,
                step = 0.05,
                format = "%.2f",
                unit = " ",
                default = list.svDefault.zeroTimerOpacity,
                getFunction = function() return list.sw.zeroTimerOpacity end,
                setFunction = function(value)
                    list.sw.zeroTimerOpacity = value
                    list._redrawHeaders = true
                    list:Update()
                end,
                isAdvancedSetting = true,
            },
        }
    end
    local function getCommonCounterOptions(counterName, counter)
        return {
            core.CreateSectionHeader(counterName .. " Counter"),
            {
                type = LHAS.ST_DROPDOWN,
                label = GetString(HR_MENU_VISIBILITY),
                tooltip = GetString(HR_MENU_VISIBILITY_TT),
                default = GetString(HR_VISIBILITY_SHOW_NEVER),
                items = {
                    {name = GetString(HR_VISIBILITY_SHOW_NEVER), data = 0},
                    {name = GetString(HR_VISIBILITY_SHOW_ALWAYS), data = 1},
                    {name = GetString(HR_VISIBILITY_SHOW_IN_COMBAT), data = 2},
                },
                getFunction = function()
                    if counter.sv.enabled == 0 then return GetString(HR_VISIBILITY_SHOW_NEVER) end
                    if counter.sv.enabled == 1 then return GetString(HR_VISIBILITY_SHOW_ALWAYS) end
                    if counter.sv.enabled == 2 then return GetString(HR_VISIBILITY_SHOW_IN_COMBAT) end
                end,
                setFunction = function(control, itemName, itemData)
                    counter.sv.enabled = itemData.data
                    counter:RefreshVisibility()
                end,
                width = "full",
            },
            {
                type = LHAS.ST_SLIDER,
                label = GetString(HR_MENU_HORIZONTAL_POSITION),
                tooltip = GetString(HR_MENU_HORIZONTAL_POSITION_TT),
                min = 0,
                max = SCREEN_WIDTH,
                step = 10,
                format = "%.0f",
                unit = " px",
                default = counter.svDefault.windowPosLeft,
                getFunction = function() return counter.sw.windowPosLeft end,
                setFunction = function(value)
                    counter.sw.windowPosLeft = value
                    counter.window:ClearAnchors()
                    counter.window:SetAnchor(CENTER, GuiRoot, TOPLEFT, counter.sw.windowPosLeft, counter.sw.windowPosTop)
                end,
            },
            {
                type = LHAS.ST_SLIDER,
                label = GetString(HR_MENU_VERTICAL_POSITION),
                tooltip = GetString(HR_MENU_VERTICAL_POSITION_TT),
                min = 0,
                max = SCREEN_HEIGHT,
                step = 10,
                format = "%.0f",
                unit = " px",
                default = counter.svDefault.windowPosTop,
                getFunction = function() return counter.sw.windowPosTop end,
                setFunction = function(value)
                    counter.sw.windowPosTop = value
                    counter.window:ClearAnchors()
                    counter.window:SetAnchor(CENTER, GuiRoot, TOPLEFT, counter.sw.windowPosLeft, counter.sw.windowPosTop)
                end,
            },
            {
                type = LHAS.ST_CHECKBOX,
                label = "hide on active buff/cooldown",
                tooltip = "show/hide the counter depending on if a buff or cooldown is active.",
                default = counter.svDefault.hideOnCooldown,
                getFunction = function() return counter.sw.hideOnCooldown end,
                setFunction = function(value)
                    counter.sw.hideOnCooldown = value
                    counter:RefreshVisibility()
                end,
            },
        }
    end

    local options = {}

    local hornList = GetComonListOptions("Horn List", self.hornList)
    local hornListSpecificOptions = {
        {
            type = LHAS.ST_CHECKBOX,
            label = "Highlight Saxhleel",
            tooltip = "highlight saxhleel players in the list.",
            default = self.hornList.svDefault.highlightSaxhleel,
            getFunction = function() return self.hornList.sw.highlightSaxhleel end,
            setFunction = function(value)
                self.hornList.sw.highlightSaxhleel = value
                self.hornList:Update()
            end,
        },
        {
            type = LHAS.ST_COLOR,
            label = "Saxhleel Highlight Color",
            tooltip = "set the highlight color for saxhleel players.",
            disabled = function() return not self.hornList.sw.highlightSaxhleel end,
            default = self.hornList.svDefault.highlightSaxhleelColor,
            getFunction = function() return unpack(self.hornList.sw.highlightSaxhleelColor) end,
            setFunction = function(r, g, b, a)
                self.hornList.sw.highlightSaxhleelColor = {r, g, b, a}
                self.hornList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "Horn Countdown Color",
            tooltip = "set the color the horn buff countdown.",
            default = self.hornList.svDefault.colorHorn,
            getFunction = function() return unpack(self.hornList.sw.colorHorn) end,
            setFunction = function(r, g, b)
                self.hornList.sw.colorHorn = {r, g, b}
                self.hornList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "Force Countdown Color",
            tooltip = "set the color the force buff countdown.",
            default = self.hornList.svDefault.colorForce,
            getFunction = function() return unpack(self.hornList.sw.colorForce) end,
            setFunction = function(r, g, b)
                self.hornList.sw.colorForce = {r, g, b}
                self.hornList:Update()
            end,
            isAdvancedSetting = true,
        },
    }
    core.MergeOptions(hornListSpecificOptions, hornList)
    core.MergeOptions(hornList, options)

    local colosList = GetComonListOptions("Colos List", self.colosList)
    local colosListSpecificOptions = {
        {
            type = LHAS.ST_COLOR,
            label = "Vulnerability Countdown Color",
            tooltip = "set the color the vulnerability debuff countdown.",
            default = self.colosList.svDefault.colorVuln,
            getFunction = function() return unpack(self.colosList.sw.colorVuln) end,
            setFunction = function(r, g, b)
                self.colosList.sw.colorVuln = {r, g, b}
                self.colosList:Update()
            end,
            isAdvancedSetting = true,
        },
    }
    core.MergeOptions(colosListSpecificOptions, colosList)
    core.MergeOptions(colosList, options)


    local atroList = GetComonListOptions("Atro List", self.atroList)
    local atroListSpecificOptions = {
        {
            type = LHAS.ST_COLOR,
            label = "Atronach Countdown Color",
            tooltip = "set the color of the Atronach ultimate countdown.",
            default = self.atroList.svDefault.colorAtro,
            getFunction = function() return unpack(self.atroList.sw.colorAtro) end,
            setFunction = function(r, g, b)
                self.atroList.sw.colorAtro = {r, g, b}
                self.atroList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "Berserk Countdown Color",
            tooltip = "set the color of the Berserk countdown.",
            default = self.atroList.svDefault.colorBerserk,
            getFunction = function() return unpack(self.atroList.sw.colorBerserk) end,
            setFunction = function(r, g, b)
                self.atroList.sw.colorBerserk = {r, g, b}
                self.atroList:Update()
            end,
            isAdvancedSetting = true,
        },
    }
    core.MergeOptions(atroListSpecificOptions, atroList)
    core.MergeOptions(atroList, options)

    local miscList = GetComonListOptions("Misc List", self.miscList)
    local miscListSpecificOptions = {
        {
            type = LHAS.ST_CHECKBOX,
            label = "Exclude Special Ults",
            tooltip = "exclude special ultimates from the list.",
            default = self.miscList.svDefault.excludeSpecialUlts,
            getFunction = function() return self.miscList.sw.excludeSpecialUlts end,
            setFunction = function(value)
                self.miscList.sw.excludeSpecialUlts = value
                self.miscList:Update()
            end,
        },
    }
    core.MergeOptions(miscListSpecificOptions, miscList)
    core.MergeOptions(miscList, options)

    local compactList = GetComonListOptions("Compact List", self.compactList)
    local compactListSpecificOptions = {
        {
            type = LHAS.ST_CHECKBOX,
            label = "show Horn",
            tooltip = "shows horns & saxhleel in the list.",
            default = self.compactList.svDefault.showHorn,
            getFunction = function() return self.compactList.sw.showHorn end,
            setFunction = function(value)
                self.compactList.sw.showHorn = value
                self.compactList:Update()
            end,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "show Colos",
            tooltip = "shows Colos in the list.",
            default = self.compactList.svDefault.showColos,
            getFunction = function() return self.compactList.sw.showColos end,
            setFunction = function(value)
                self.compactList.sw.showColos = value
                self.compactList:Update()
            end,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "show Atro",
            tooltip = "shows Atros in the list.",
            default = self.compactList.svDefault.showAtro,
            getFunction = function() return self.compactList.sw.showAtro end,
            setFunction = function(value)
                self.compactList.sw.showAtro = value
                self.compactList:Update()
            end,
        },
        {
            type = LHAS.ST_CHECKBOX,
            name = "show Barrier",
            tooltip = "shows Barrier in the list.",
            default = self.compactList.svDefault.showBarrier,
            getFunction = function() return self.compactList.sw.showBarrier end,
            setFunction = function(value)
                self.compactList.sw.showBarrier = value
                self.compactList:Update()
            end,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "show Slayer",
            tooltip = "shows Slayer in the list.",
            default = self.compactList.svDefault.showSlayer,
            getFunction = function() return self.compactList.sw.showSlayer end,
            setFunction = function(value)
                self.compactList.sw.showSlayer = value
                self.compactList:Update()
            end,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "show Pillager",
            tooltip = "shows Pillager in the list.",
            default = self.compactList.svDefault.showPillager,
            getFunction = function() return self.compactList.sw.showPillager end,
            setFunction = function(value)
                self.compactList.sw.showPillager = value
                self.compactList:Update()
            end,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "show Crypt Cannon",
            tooltip = "shows CryptCannon in the list.",
            default = self.compactList.svDefault.showCryptCannon,
            getFunction = function() return self.compactList.sw.showCryptCannon end,
            setFunction = function(value)
                self.compactList.sw.showCryptCannon = value
                self.compactList:Update()
            end,
        },
        {
            type = LHAS.ST_SLIDER,
            label = "ult background opacity",
            tooltip = "set the background opacity for the ults.",
            min = 0,
            max = 1,
            step = 0.05,
            format = "%.2f",
            unit = " ",
            default = self.compactList.svDefault.backgroundAlpha,
            getFunction = function() return self.compactList.sw.backgroundAlpha end,
            setFunction = function(value)
                self.compactList.sw.backgroundAlpha = value
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "horn background color",
            tooltip = "set the background color for horn ults.",
            default = self.compactList.svDefault.colorHornBG,
            getFunction = function() return unpack(self.compactList.sw.colorHornBG) end,
            setFunction = function(r, g, b)
                self.compactList.sw.colorHornBG = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "colos background color",
            tooltip = "set the background color for colos ults.",
            default = self.compactList.svDefault.colorColosBG,
            getFunction = function() return unpack(self.compactList.sw.colorColosBG) end,
            setFunction = function(r, g, b)
                self.compactList.sw.colorColosBG = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "atro background color",
            tooltip = "set the background color for atro ults.",
            default = self.compactList.svDefault.colorAtroBG,
            getFunction = function() return unpack(self.compactList.sw.colorAtroBG) end,
            setFunction = function(r, g, b)
                self.compactList.sw.colorAtroBG = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "slayer background color",
            tooltip = "set the background color for slayer ults.",
            default = self.compactList.svDefault.colorSlayerBG,
            getFunction = function() return unpack(self.compactList.sw.colorSlayerBG) end,
            setFunction = function(r, g, b)
                self.compactList.sw.colorSlayerBG = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "pillager background color",
            tooltip = "set the background color for pillager ults.",
            default = self.compactList.svDefault.colorPillagerBG,
            getFunction = function() return unpack(self.compactList.sw.colorPillagerBG) end,
            setFunction = function(r, g, b)
                self.compactList.sw.colorPillagerBG = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "crypt cannon background color",
            tooltip = "set the background color for crypt cannon ults.",
            default = self.compactList.svDefault.colorCryptCannonBG,
            getFunction = function() return unpack(self.compactList.sw.colorCryptCannonBG) end,
            setFunction = function(r, g, b)
                self.compactList.sw.colorCryptCannonBG = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "color ult percentage on cooldown",
            tooltip = "mark ults that are on cooldown.",
            default = self.compactList.svDefault.markOnCooldown,
            getFunction = function() return self.compactList.sw.markOnCooldown end,
            setFunction = function(value)
                self.compactList.sw.markOnCooldown = value
                self.compactList:Update()
            end,
        },
        {
            type = LHAS.ST_COLOR,
            label = "ult percentage color",
            tooltip = "set the color for marking ults on cooldown.",
            default = self.compactList.svDefault.markOnCooldownColor,
            getFunction = function() return unpack(self.compactList.sw.markOnCooldownColor) end,
            setFunction = function(r, g, b)
                self.compactList.sw.markOnCooldownColor = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "Show Horn Countdown",
            tooltip = "show/hide the horn buff countdown.",
            default = self.compactList.svDefault.showHornCountdown,
            getFunction = function() return self.compactList.sw.showHornCountdown end,
            setFunction = function(value)
                self.compactList.sw.showHornCountdown = value
                self.compactList._redrawHeaders = true
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "Show Force Countdown",
            tooltip = "show/hide the major force buff countdown.",
            default = self.compactList.svDefault.showForceCountdown,
            getFunction = function() return self.compactList.sw.showForceCountdown end,
            setFunction = function(value)
                self.compactList.sw.showForceCountdown = value
                self.compactList._redrawHeaders = true
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "Show Vulnerability Countdown",
            tooltip = "show/hide the major vulnerability debuff countdown.",
            default = self.compactList.svDefault.showVulnCountdown,
            getFunction = function() return self.compactList.sw.showVulnCountdown end,
            setFunction = function(value)
                self.compactList.sw.showVulnCountdown = value
                self.compactList._redrawHeaders = true
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "Show Berserk Countdown",
            tooltip = "show/hide the major berserk countdown.",
            default = self.compactList.svDefault.showBerserkCountdown,
            getFunction = function() return self.compactList.sw.showBerserkCountdown end,
            setFunction = function(value)
                self.compactList.sw.showBerserkCountdown = value
                self.compactList._redrawHeaders = true
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "Show Slayer Countdown",
            tooltip = "show/hide the major slayer countdown.",
            default = self.compactList.svDefault.showSlayerCountdown,
            getFunction = function() return self.compactList.sw.showSlayerCountdown end,
            setFunction = function(value)
                self.compactList.sw.showSlayerCountdown = value
                self.compactList._redrawHeaders = true
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_CHECKBOX,
            label = "Show Pillager Cooldown",
            tooltip = "show/hide the pillager buff cooldown.",
            default = self.compactList.svDefault.showPillagerCooldown,
            getFunction = function() return self.compactList.sw.showPillagerCooldown end,
            setFunction = function(value)
                self.compactList.sw.showPillagerCooldown = value
                self.compactList._redrawHeaders = true
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "Duration Color",
            tooltip = "set the color of the ultimate durations.",
            default = self.compactList.svDefault.colorDurations,
            getFunction = function() return unpack(self.compactList.sw.colorDurations) end,
            setFunction = function(r, g, b)
                self.compactList.sw.colorDurations = {r, g, b}
                self.compactList._redrawHeaders = true
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = LHAS.ST_COLOR,
            label = "Cooldown Color",
            tooltip = "set the color of the ultimate cooldowns.",
            default = self.compactList.svDefault.colorCooldowns,
            getFunction = function() return unpack(self.compactList.sw.colorCooldowns) end,
            setFunction = function(r, g, b)
                self.compactList.sw.colorCooldowns = {r, g, b}
                self.compactList._redrawHeaders = true
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
    }
    core.MergeOptions(compactListSpecificOptions, compactList)
    core.MergeOptions(compactList, options)

    core.MergeOptions(getCommonCounterOptions("Horn", self.hornCounter), options)
    core.MergeOptions(getCommonCounterOptions("Pillager", self.pillagerCounter), options)
    --core.MergeOptions(getCommonCounterOptions("Slayer", self.slayerCounter), options) -- experimental, disabled for now

    return options
end