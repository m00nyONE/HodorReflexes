-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal

local core = internal.core

local LCN = LibCustomNames
local LCI = LibCustomIcons
local util = addon.util

local extensionDefinition = {
    name = "configurator",
    friendlyName = GetString(HR_EXTENSIONS_CONFIGURATOR_FRIENDLYNAME),
    version = "1.0.0",
    description = GetString(HR_EXTENSIONS_CONFIGURATOR_DESCRIPTION),
    priority = 11,
    svVersion = 1,
    svDefault = {
        selectedDonationTier = 1,

        nameRaw = UndecorateDisplayName(GetUnitDisplayName("player")),
        nameColored = UndecorateDisplayName(GetUnitDisplayName("player")),

        nameGradient = false,
        nameColorBegin = {1, 1, 1},
        nameColorEnd = {1, 1, 1},
    },

    currentFolder = "", -- will be set with LCI.GetCurrentFolder() on activation
    displayName = GetUnitDisplayName("player"),
    discordURL = "https://discord.gg/8YpvXJhAyz" -- official HodorReflexes Discord
}

--- @class generatorExtension : extensionClass
local extension = internal.extensionClass:New(extensionDefinition)

--- Module activation function.
--- NOT for manual use. This function gets called once when the extension is loaded and then deleted afterwards.
--- @return void
function extension:Activate()
    if not LCN then
        self.enabled = false
        return
    end

    self.currentFolder = (LCI and LCI.GetCurrentFolder and LCI.GetCurrentFolder()) or "misc"
end

--- Escapes the display name to a valid string that can be used as a filename.
--- @param displayName string|nil optional display name. If nil, uses self.displayName
--- @return string escaped name
function extension:escapeName(displayName)
    if displayName == nil then displayName = self.displayName end

    return displayName:gsub("^@", ""):gsub("[^%w%-_]", "")
end

--- Generates a colored name with optional gradient coloring.
--- @param withGradient boolean|nil optional whether to use gradient coloring or not. If nil, uses self.sw.nameGradient
--- @param nameRaw string|nil optional raw name. If nil, uses self.sw.nameRaw
--- @param colorBegin table optional begin color as {r, g, b}. If nil, uses self.sw.nameColorBegin
--- @param colorEnd table optional end color as {r, g, b}. If nil, uses self.sw.nameColorEnd
--- @return string The formatted name.
function extension:generateColoredName(withGradient, nameRaw, colorBegin, colorEnd)
    if withGradient == nil then withGradient = self.sw.nameGradient end
    if nameRaw == nil then nameRaw = self.sw.nameRaw end
    if colorBegin == nil then colorBegin = self.sw.nameColorBegin end
    if colorEnd == nil then colorEnd = self.sw.nameColorEnd end

    if withGradient then
        return self:generateGradient(nameRaw, colorBegin, colorEnd)
    end

    local hex = util.RGB2Hex(unpack(colorBegin))
    return string.format("|c%s%s|r", hex, nameRaw )

end

--- Generates code for adding a name to LibCustomNames.
--- @param displayName string|nil optional display name. If nil, uses self.displayName
--- @param nameRaw string|nil optional raw name. If nil, uses self.sw.nameRaw
--- @param nameColored string|nil optional formatted name. If nil, uses self.sw.nameColored
--- @return string code
function extension:generateCodeForColoredName(displayName, nameRaw, nameColored)
    if displayName == nil then displayName = self.displayName end
    if nameRaw == nil then nameRaw = self.sw.nameRaw end
    if nameColored == nil then nameColored = self.sw.nameColored end

    return string.format('n["%s"] = {"%s", "%s"}', displayName, nameRaw, nameColored)
end

--- Generates code for adding a static icon to LibCustomIcons.
--- @param displayName string|nil optional display name. If nil, uses self.displayName
--- @param folderName string|nil optional folder name. If nil, uses self.currentFolder
--- @return string code
function extension:generateCodeForStaticIcon(displayName, folderName)
    if displayName == nil then displayName = self.displayName end
    if folderName == nil then folderName = self.currentFolder end

    return string.format('s["%s"] = "LibCustomIcons/icons/%s/%s.dds"', displayName, folderName, self:escapeName(displayName))
end

--- Generates code for adding an animated icon to LibCustomIcons.
--- @param displayName string|nil optional display name. If nil, uses self.displayName
--- @param folderName string|nil optional folder name. If nil, uses self.currentFolder
--- @param width number|nil optional width of the animation. If nil, uses 0
--- @param height number|nil optional height of the animation. If nil, uses 0
--- @param fps number|nil optional frames per second of the animation. If nil, uses 0
--- @return string code
function extension:generateCodeForAnimatedIcon(displayName, folderName, width, height, fps)
    if displayName == nil then displayName = self.displayName end
    if folderName == nil then folderName = self.currentFolder end
    if width == nil then width = 0 end
    if height == nil then height = 0 end
    if fps == nil then fps = 0 end

    return string.format('a["%s"] = {"LibCustomIcons/icons/%s/%s_anim.dds", %d, %d, %d}', displayName, folderName, self:escapeName(displayName), width, height, fps)
end

--- Generates code for adding name/icon based on donation tier.
--- @param donationTier number|nil optional donation tier. If nil, uses self.sw.selectedDonationTier
--- @param displayName string|nil optional display name. If nil, uses self.displayName
--- @param nameRaw string|nil optional raw name. If nil, uses self.sw.nameRaw
--- @param nameColored string|nil optional formatted name. If nil, uses self.sw.nameColored
--- @param folderName string|nil optional folder name. If nil, uses self.currentFolder
--- @param width number|nil optional width of the animation. If nil, uses 0
--- @param height number|nil optional height of the animation. If nil, uses 0
--- @param fps number|nil optional frames per second of the animation. If nil, uses 0
--- @return string code
function extension:generateCode(donationTier, displayName, nameRaw, nameColored, folderName, width, height, fps)
    if donationTier == nil then donationTier = self.sw.selectedDonationTier end
    if displayName == nil then displayName = self.displayName end
    if nameRaw == nil then nameRaw = self.sw.nameRaw end
    if nameColored == nil then nameColored = self.sw.nameColored end
    if folderName == nil then folderName = self.currentFolder end
    if width == nil then width = 0 end
    if height == nil then height = 0 end
    if fps == nil then fps = 0 end

    local code = "```\n"
    if donationTier >= 1 then
        code = string.format("%s%s\n", code, self:generateCodeForColoredName(displayName, nameRaw, nameColored))
    end
    if donationTier >= 2 then
        code = string.format("%s%s\n", code, self:generateCodeForStaticIcon(displayName, folderName))
    end
    if donationTier >= 3 then
        code = string.format("%s%s\n", code, self:generateCodeForAnimatedIcon(displayName, folderName, width, height, fps))
    end
    code = code .. "```"

    return code
end

--- Generates a gradient colored name.
--- @param rawName string|nil optional raw name. If nil, uses self.sw.rawName
--- @param colorBegin table|nil optional begin color as {r, g, b}. If nil, uses self.sw.nameColorBegin
--- @param colorEnd table|nil optional end color as {r, g, b}. If nil, uses self.sw.nameColorEnd
--- @return string gradient colored name
function extension:generateGradient(rawName, colorBegin, colorEnd)
    if rawName == nil then rawName = self.sw.rawName end
    if colorBegin == nil then colorBegin = self.sw.nameColorBegin end
    if colorEnd == nil then colorEnd = self.sw.nameColorEnd end

    local r1, g1, b1 = unpack(colorBegin)
    local r2, g2, b2 = unpack(colorEnd)
    local chars = {} -- raw name split into single characters
    local numChars = 0 -- number of non spaces

    -- sanity check for colors
    if r1 == r2 and g1 == g2 and b1 == b2 then
        local hex = util.RGB2Hex(r1, g1, b1)
        return string.format('|c%s%s|r', hex, rawName)
    end

    -- Split raw name into single utf8 characters.
    for i = 1, utf8.len(rawName) do
        chars[i] = string.sub(rawName, utf8.offset(rawName, i), utf8.offset(rawName, i + 1) - 1)
        if chars[i] ~= " " then
            numChars = numChars + 1
        end
    end
    -- Don't color spaces.
    local coloredChars = {}
    if numChars > 0 then
        local rdelta, gdelta, bdelta = (r2 - r1) / numChars, (g2 - g1) / numChars, (b2 - b1) / numChars
        for i = 1, #chars do
            if chars[i] ~= " " then
                r1 = r1 + rdelta
                g1 = g1 + gdelta
                b1 = b1 + bdelta
                coloredChars[i] = string.format('|c%s%s|r', util.RGB2Hex(r1, g1, b1), chars[i])
            end
        end
        return table.concat(coloredChars)
    else
        return ""
    end
end

