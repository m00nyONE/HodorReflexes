-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal

local LAM = LibAddonMenu2

local addon_extensions = addon.extensions
local extension = addon_extensions.configurator

function extension:BuildMenu()
    local menuReference = string.format("%s_extension_%s_menu", addon_name, self.name)
    local discordURL = "https://discord.gg/8YpvXJhAyz"

    local function _generatePreview(updateControl)
        local s = string.format("                    %s", self.sw.nameColored)
        if updateControl then
            _G[menuReference .. "_preview"].data.text = s
        end
    end

    local function _generateCodeWrapper(...)
        if _G[menuReference .. "_Code"] then
            _G[menuReference .. "_Code"].container:SetHeight(24 * 6)
            _G[menuReference .. "_Code"]:SetHeight(24 * 6)
        end

        return self:generateCode(...)
    end
    local function _generateColoredNameWrapper(updateControl)
        self.sw.nameColored = self:generateColoredName()
        if updateControl then
            _generatePreview(updateControl)
        end
        return self.sw.nameColored
    end

    local panel = {
        type = "panel",
        name = string.format("%s - %s", addon.friendlyName, self.friendlyName),
        displayName = string.format('|cFFFACD%s - %s|r', addon.friendlyName, self.friendlyName),
        author = addon.author,
        version = addon.version,
        website = "https://www.esoui.com/downloads/info2311-HodorReflexes-DPSULTtracker.html#donate",
        donation = addon.Donate,
        registerForRefresh = true,
    }
    
    local options = {
        {
            type = "header",
            name = string.format("|cFFFACD%s|r", GetString(HR_MENU_ICONS_SECTION_CUSTOM))
        },
        {
            type = "description",
            text = string.format(GetString(HR_MENU_ICONS_README_1))
        },
        {
            type = "header",
            name = string.format("|cFFFACD1. %s|r", GetString(HR_MENU_ICONS_HEADER_ICONS))
        },
        {
            type = "description",
            text = GetString(HR_MENU_ICONS_README_2)
        },

        {
            type = "header",
            name = string.format("|cFFFACD2. %s|r", GetString(HR_MENU_ICONS_HEADER_TIERS))
        },
        {
            type = "description",
            text = GetString(HR_MENU_ICONS_README_3)
        },
        {
            type = "slider",
            name = GetString(HR_MENU_ICONS_README_DONATION_TIER),
            tooltip = GetString(HR_MENU_ICONS_README_DONATION_TIER_TT),
            min = 1,
            max = 3,
            step = 1,
            default = 1,
            decimals = 0,
            clampInput = true,
            getFunc = function() return self.sw.selectedDonationTier end,
            setFunc = function(value) self.sw.selectedDonationTier = value end,
        },

        {
            type = "header",
            name = string.format("|cFFFACD3. %s|r", GetString(HR_MENU_ICONS_HEADER_CUSTOMIZE))
        },
        {
            type = "description",
            text = GetString(HR_MENU_ICONS_README_4)
        },
        {
            type = "editbox",
            name = GetString(LCN_MENU_NAME_VAL),
            tooltip = GetString(LCN_MENU_NAME_VAL_TT),
            default = self.sw.nameRaw,
            getFunc = function() return self.sw.nameRaw end,
            setFunc = function(value)
                if value ~= self.sw.nameRaw then
                    self.sw.nameRaw = value or ""
                    _generateColoredNameWrapper(true)
                end
            end,
        },
        {
            type = "checkbox",
            name = GetString(LCN_MENU_GRADIENT),
            tooltip = GetString(LCN_MENU_GRADIENT_TT),
            default = false,
            getFunc = function() return self.sw.nameGradient end,
            setFunc = function(value)
                self.sw.nameGradient = value
                _generateColoredNameWrapper(true)
            end,
        },
        {
            type = "colorpicker",
            name = GetString(LCN_MENU_COLOR1),
            default = ZO_ColorDef:New(1, 1, 1, 1),
            getFunc = function() return unpack(self.sw.nameColorBegin) end,
            setFunc = function(r2, g2, b2)
                local r1, g1, b1 = unpack(self.sw.nameColorBegin)
                if r1 ~= r2 or g1 ~= g2 or b1 ~= b2 then
                    self.sw.nameColorBegin = {r2, g2, b2}
                    _generateColoredNameWrapper(true)
                end
            end,
            width = 'full',
        },
        {
            type = "colorpicker",
            name = GetString(LCN_MENU_COLOR2),
            default = ZO_ColorDef:New(1, 1, 1, 1),
            getFunc = function() return unpack(self.sw.nameColorEnd) end,
            setFunc = function(r2, g2, b2)
                local r1, g1, b1 = unpack(self.sw.nameColorEnd)
                if r1 ~= r2 or g1 ~= g2 or b1 ~= b2 then
                    self.sw.nameColorEnd = {r2, g2, b2}
                    _generateColoredNameWrapper(true)
                end
            end,
            width = 'full',
        },
        {
            type = "description",
            text = GetString(LCN_MENU_PREVIEW),
            width = "half",
        },
        {
            type = "description",
            text = _generatePreview(),
            reference = menuReference .. "_preview",
            width = "half",
        },

        {
            type = "header",
            name = string.format("|cFFFACD4. %s|r", GetString(HR_MENU_ICONS_HEADER_TICKET))
        },
        {
            type = "description",
            text = GetString(HR_MENU_ICONS_README_5),
        },
        {
            type = "editbox",
            tooltip = GetString(HR_MENU_ICONS_CONFIGURATOR_LUA_TT),
            default = _generateCodeWrapper(),
            getFunc = function() return _generateCodeWrapper() end,
            setFunc = function(value) end,
            isMultiline = true,
            isExtraWide = true,
            reference = menuReference .. "_Code",
        },
        {
            type = "description",
            text = GetString(HR_MENU_ICONS_README_6),
        },
        {
            type = "button",
            name = GetString(HR_MENU_ICONS_CONFIGURATOR_DISCORD),
            tooltip = GetString(HR_MENU_ICONS_CONFIGURATOR_DISCORD_TT),
            func = function() RequestOpenUnsafeURL(discordURL) end,
            width = "full"
        },
        {
            type = "header",
            name = string.format("|cFFFACD6. %s|r", GetString(HR_MENU_ICONS_HEADER_DONATION))
        },
        {
            type = "description",
            text = string.format(GetString(HR_MENU_ICONS_README_7), LAM.util.L.DONATION),
        },
        {
            type = "button",
            name = LAM.util.L.DONATION,
            tooltip = GetString(HR_MENU_ICONS_CONFIGURATOR_DONATE_TT),
            func = addon.Donate,
            width = "full"
        },
        {
            type = "header",
            name = string.format("|cFFFACD%s|r", GetString(HR_MENU_ICONS_HEADER_INFO))
        },
        {
            type = "description",
            text = GetString(HR_MENU_ICONS_INFO),
        },
    }

    LAM:RegisterAddonPanel(menuReference, panel)
    LAM:RegisterOptionControls(menuReference, options)
end