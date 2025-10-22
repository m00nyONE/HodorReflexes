-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "ult"
local module = addon_modules[module_name]

function module:GetSubMenuOptions()
    local function mergeOptions(source, destination)
        for _, option in ipairs(source) do
            if not option.isAdvancedSetting or self.sw.advancedSettings then
                table.insert(destination, option)
            end
        end
    end
    local function getGeneralOptions()
        return {
            {
                type = "header",
                name = string.format("|cFFFACD%s|r", "General")
            },
            {
                type = "checkbox",
                name = "account wide settings",
                tooltip = "enable/disable account-wide settings.",
                default = true,
                getFunc = function() return self.sw.accountWide end,
                setFunc = function(value)
                    self.sw.accountWide = value
                end,
                requiresReload = true,
            },
            {
                type = "checkbox",
                name = "Advanced Settings",
                tooltip = "allows you to customize more advanced settings for the lists.",
                default = false,
                getFunc = function() return self.sw.advancedSettings end,
                setFunc = function(value)
                    self.sw.advancedSettings = value
                end,
                requiresReload = true,
            },
        }
    end
    local function GetComonListOptions(listName, list)
        return {
            {
                type = "header",
                name = string.format("|cFFFACD%s|r", listName)
            },
            {
                type = "checkbox",
                name = "Disable in PvP",
                tooltip = "disable the list when in PvP.",
                default = list.svDefault.disableInPvP,
                getFunc = function() return list.sw.disableInPvP end,
                setFunc = function(value)
                    list.sw.disableInPvP = value
                    list:RefreshVisibility()
                end,
            },
            {
                type = "dropdown",
                name = "Visibility",
                tooltip = "set the visibility of the list.",
                default = list.svDefault.enabled,
                choices = {
                    GetString(HR_VISIBILITY_SHOW_NEVER),
                    GetString(HR_VISIBILITY_SHOW_ALWAYS),
                    GetString(HR_VISIBILITY_SHOW_OUT_OF_COMBAT),
                    GetString(HR_VISIBILITY_SHOW_NON_BOSSFIGHTS),
                },
                choicesValues = {
                    0, 1, 2, 3
                },
                getFunc = function() return list.sw.enabled end,
                setFunc = function(value)
                    list.sw.enabled = value
                    list:RefreshVisibility()
                end,
                width = "full",
            },
            {
                type = "checkbox",
                name = "Show Percent",
                tooltip = "show/hide the percent value in the list.",
                default = list.svDefault.showPercentValue == 1.0,
                getFunc = function() return list.sw.showPercentValue == 1.0 end,
                setFunc = function(value)
                    list.sw.showPercentValue = value and 1.0 or 0.0
                    list:Update()
                end,
            },
            {
                type = "checkbox",
                name = "Show Points",
                tooltip = "show/hide the raw value in the list.",
                default = list.svDefault.showRawValue == 1.0,
                getFunc = function() return list.sw.showRawValue == 1.0 end,
                setFunc = function(value)
                    list.sw.showRawValue = value and 1.0 or 0.0
                    list:Update()
                end,
            },
            {
                type = "divider",
                isAdvancedSetting = true,
            },
            {
                type = "slider",
                name = "List width",
                min = list.svDefault.windowWidth,
                max = list.svDefault.windowWidth + 150,
                step = 1,
                decimals = 0,
                default = list.svDefault.windowWidth,
                clampInput = true,
                getFunc = function() return list.sw.windowWidth end,
                setFunc = function(value)
                    list.sw.windowWidth = value
                    list.window:SetWidth(list.sw.windowWidth)
                end,
                isAdvancedSetting = true,
            },
            {
                type = "slider",
                name = "Header Opacity",
                tooltip = "set the opacity of the list header.",
                min = 0,
                max = 1,
                step = 0.05,
                decimals = 2,
                clampInput = true,
                default = list.svDefault.headerOpacity,
                getFunc = function() return list.sw.headerOpacity end,
                setFunc = function(value)
                    list.sw.headerOpacity = value
                    list._redrawHeaders = true
                    list:Update()
                end,
                isAdvancedSetting = true,
            },
            {
                type = "slider",
                name = "Zero Timer Opacity",
                tooltip = "set the opacity of the timers when at zero.",
                min = 0.05,
                max = 1,
                step = 0.05,
                decimals = 2,
                clampInput = true,
                default = list.svDefault.zeroTimerOpacity,
                getFunc = function() return list.sw.zeroTimerOpacity end,
                setFunc = function(value)
                    list.sw.zeroTimerOpacity = value
                    list._redrawHeaders = true
                    list:Update()
                end,
                isAdvancedSetting = true,
            },
        }
    end

    local options = getGeneralOptions()

    local hornList = GetComonListOptions("Horn List", self.hornList)
    local hornListSpecificOptions = {
        {
            type = "divider",
        },
        {
            type = "checkbox",
            name = "Highlight Saxhleel",
            tooltip = "highlight saxhleel players in the list.",
            default = self.hornList.svDefault.highlightSaxhleel,
            getFunc = function() return self.hornList.sw.highlightSaxhleel end,
            setFunc = function(value)
                self.hornList.sw.highlightSaxhleel = value
                self.hornList:Update()
            end,
        },
        {
            type = "colorpicker",
            name = "Saxhleel Highlight Color",
            tooltip = "set the highlight color for saxhleel players.",
            disabled = function() return not self.hornList.sw.highlightSaxhleel end,
            default = unpack(self.hornList.svDefault.highlightSaxhleelColor),
            getFunc = function() return unpack(self.hornList.sw.highlightSaxhleelColor) end,
            setFunc = function(r, g, b, a)
                self.hornList.sw.highlightSaxhleelColor = {r, g, b, a}
                self.hornList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "divider",
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "Horn Countdown Color",
            tooltip = "set the color the horn buff countdown.",
            default = unpack(self.hornList.svDefault.colorHorn),
            getFunc = function() return unpack(self.hornList.sw.colorHorn) end,
            setFunc = function(r, g, b)
                self.hornList.sw.colorHorn = {r, g, b}
                self.hornList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "Force Countdown Color",
            tooltip = "set the color the force buff countdown.",
            default = unpack(self.hornList.svDefault.colorForce),
            getFunc = function() return unpack(self.hornList.sw.colorForce) end,
            setFunc = function(r, g, b)
                self.hornList.sw.colorForce = {r, g, b}
                self.hornList:Update()
            end,
            isAdvancedSetting = true,
        },
    }
    mergeOptions(hornListSpecificOptions, hornList)
    mergeOptions(hornList, options)

    local colosList = GetComonListOptions("Colos List", self.colosList)
    local colosListSpecificOptions = {
        {
            type = "divider",
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "Vulnerability Countdown Color",
            tooltip = "set the color the vulnerability debuff countdown.",
            default = unpack(self.colosList.svDefault.colorVuln),
            getFunc = function() return unpack(self.colosList.sw.colorVuln) end,
            setFunc = function(r, g, b)
                self.colosList.sw.colorVuln = {r, g, b}
                self.colosList:Update()
            end,
            isAdvancedSetting = true,
        },
    }
    mergeOptions(colosListSpecificOptions, colosList)
    mergeOptions(colosList, options)


    local atroList = GetComonListOptions("Atro List", self.atroList)
    local atroListSpecificOptions = {
        {
            type = "divider",
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "Atronach Countdown Color",
            tooltip = "set the color of the Atronach ultimate countdown.",
            default = unpack(self.atroList.svDefault.colorAtro),
            getFunc = function() return unpack(self.atroList.sw.colorAtro) end,
            setFunc = function(r, g, b)
                self.atroList.sw.colorAtro = {r, g, b}
                self.atroList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "Berserk Countdown Color",
            tooltip = "set the color of the Berserk countdown.",
            default = unpack(self.atroList.svDefault.colorBerserk),
            getFunc = function() return unpack(self.atroList.sw.colorBerserk) end,
            setFunc = function(r, g, b)
                self.atroList.sw.colorBerserk = {r, g, b}
                self.atroList:Update()
            end,
            isAdvancedSetting = true,
        },
    }
    mergeOptions(atroListSpecificOptions, atroList)
    mergeOptions(atroList, options)

    local miscList = GetComonListOptions("Misc List", self.miscList)
    local miscListSpecificOptions = {
        {
            type = "divider",
        },
        {
            type = "checkbox",
            name = "Exclude Special Ults",
            tooltip = "exclude special ultimates from the list.",
            default = self.miscList.svDefault.excludeSpecialUlts,
            getFunc = function() return self.miscList.sw.excludeSpecialUlts end,
            setFunc = function(value)
                self.miscList.sw.excludeSpecialUlts = value
                self.miscList:Update()
            end,
        },
    }
    mergeOptions(miscListSpecificOptions, miscList)
    mergeOptions(miscList, options)

    local compactList = GetComonListOptions("Compact List", self.compactList)
    local compactListSpecificOptions = {
        {
            type = "divider",
        },
        {
            type = "checkbox",
            name = "show Horn",
            tooltip = "shows horns & saxhleel in the list.",
            default = self.compactList.svDefault.showHorn,
            getFunc = function() return self.compactList.sw.showHorn end,
            setFunc = function(value)
                self.compactList.sw.showHorn = value
                self.compactList:Update()
            end,
        },
        {
            type = "checkbox",
            name = "show Colos",
            tooltip = "shows Colos in the list.",
            default = self.compactList.svDefault.showColos,
            getFunc = function() return self.compactList.sw.showColos end,
            setFunc = function(value)
                self.compactList.sw.showColos = value
                self.compactList:Update()
            end,
        },
        {
            type = "checkbox",
            name = "show Atro",
            tooltip = "shows Atros in the list.",
            default = self.compactList.svDefault.showAtro,
            getFunc = function() return self.compactList.sw.showAtro end,
            setFunc = function(value)
                self.compactList.sw.showAtro = value
                self.compactList:Update()
            end,
        },
        {
            type = "checkbox",
            name = "show Slayer",
            tooltip = "shows Slayer in the list.",
            default = self.compactList.svDefault.showSlayer,
            getFunc = function() return self.compactList.sw.showSlayer end,
            setFunc = function(value)
                self.compactList.sw.showSlayer = value
                self.compactList:Update()
            end,
        },
        {
            type = "checkbox",
            name = "show Pillager",
            tooltip = "shows Pillager in the list.",
            default = self.compactList.svDefault.showPillager,
            getFunc = function() return self.compactList.sw.showPillager end,
            setFunc = function(value)
                self.compactList.sw.showPillager = value
                self.compactList:Update()
            end,
        },
        {
            type = "checkbox",
            name = "show Crypt Cannon",
            tooltip = "shows CryptCannon in the list.",
            default = self.compactList.svDefault.showCryptCannon,
            getFunc = function() return self.compactList.sw.showCryptCannon end,
            setFunc = function(value)
                self.compactList.sw.showCryptCannon = value
                self.compactList:Update()
            end,
        },
        {
            type = "divider",
            isAdvancedSetting = true,
        },
        {
            type = "slider",
            name = "ult background opacity",
            tooltip = "set the background opacity for the ults.",
            min = 0,
            max = 1,
            step = 0.05,
            decimals = 2,
            clampInput = true,
            default = self.compactList.svDefault.backgroundAlpha,
            getFunc = function() return self.compactList.sw.backgroundAlpha end,
            setFunc = function(value)
                self.compactList.sw.backgroundAlpha = value
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "horn background color",
            tooltip = "set the background color for horn ults.",
            default = unpack(self.compactList.svDefault.colorHornBG),
            getFunc = function() return unpack(self.compactList.sw.colorHornBG) end,
            setFunc = function(r, g, b)
                self.compactList.sw.colorHornBG = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "colos background color",
            tooltip = "set the background color for colos ults.",
            default = unpack(self.compactList.svDefault.colorColosBG),
            getFunc = function() return unpack(self.compactList.sw.colorColosBG) end,
            setFunc = function(r, g, b)
                self.compactList.sw.colorColosBG = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "atro background color",
            tooltip = "set the background color for atro ults.",
            default = unpack(self.compactList.svDefault.colorAtroBG),
            getFunc = function() return unpack(self.compactList.sw.colorAtroBG) end,
            setFunc = function(r, g, b)
                self.compactList.sw.colorAtroBG = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "slayer background color",
            tooltip = "set the background color for slayer ults.",
            default = unpack(self.compactList.svDefault.colorSlayerBG),
            getFunc = function() return unpack(self.compactList.sw.colorSlayerBG) end,
            setFunc = function(r, g, b)
                self.compactList.sw.colorSlayerBG = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "pillager background color",
            tooltip = "set the background color for pillager ults.",
            default = unpack(self.compactList.svDefault.colorPillagerBG),
            getFunc = function() return unpack(self.compactList.sw.colorPillagerBG) end,
            setFunc = function(r, g, b)
                self.compactList.sw.colorPillagerBG = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "crypt cannon background color",
            tooltip = "set the background color for crypt cannon ults.",
            default = unpack(self.compactList.svDefault.colorCryptCannonBG),
            getFunc = function() return unpack(self.compactList.sw.colorCryptCannonBG) end,
            setFunc = function(r, g, b)
                self.compactList.sw.colorCryptCannonBG = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "divider",
        },
        {
            type = "checkbox",
            name = "color ult percentage on cooldown",
            tooltip = "mark ults that are on cooldown.",
            default = self.compactList.svDefault.markOnCooldown,
            getFunc = function() return self.compactList.sw.markOnCooldown end,
            setFunc = function(value)
                self.compactList.sw.markOnCooldown = value
                self.compactList:Update()
            end,
        },
        {
            type = "colorpicker",
            name = "ult percentage color",
            tooltip = "set the color for marking ults on cooldown.",
            default = unpack(self.compactList.svDefault.markOnCooldownColor),
            getFunc = function() return unpack(self.compactList.sw.markOnCooldownColor) end,
            setFunc = function(r, g, b)
                self.compactList.sw.markOnCooldownColor = {r, g, b}
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "divider",
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "Duration Color",
            tooltip = "set the color of the ultimate durations.",
            default = unpack(self.compactList.svDefault.colorDurations),
            getFunc = function() return unpack(self.compactList.sw.colorDurations) end,
            setFunc = function(r, g, b)
                self.compactList.sw.colorDurations = {r, g, b}
                self.compactList._redrawHeaders = true
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
        {
            type = "colorpicker",
            name = "Cooldown Color",
            tooltip = "set the color of the ultimate cooldowns.",
            default = unpack(self.compactList.svDefault.colorCooldowns),
            getFunc = function() return unpack(self.compactList.sw.colorCooldowns) end,
            setFunc = function(r, g, b)
                self.compactList.sw.colorCooldowns = {r, g, b}
                self.compactList._redrawHeaders = true
                self.compactList:Update()
            end,
            isAdvancedSetting = true,
        },
    }
    mergeOptions(compactListSpecificOptions, compactList)
    mergeOptions(compactList, options)


    return options
end