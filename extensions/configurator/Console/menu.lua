-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal

local util = addon.util
local LHAS = LibHarvensAddonSettings

local addon_extensions = addon.extensions
local extension = addon_extensions.configurator

function extension:GetSubMenuOptions()
    local options = {
        {
            type = LHAS.ST_SECTION,
            label = string.format("|cFFFACD%s|r", "General"),
        },
        {
            type = LHAS.ST_LABEL,
            label = "Read me first!",
            tooltip = "This is a gold donation based service our volunteers are offering! " ..
                      "If you know how to create a custom name yourself and know how to create a PullRequest on Github, you can ALWAYS do this yourself free of charge!\n\n" ..
                      "If you want to have a custom name created for you, please follow the steps below to get your custom name created by our volunteer staff members.\n\n" ..
                      "This will require you to donate to one of the volunteers, as they otherwise would get completely overwhelmed with requests. Thank you for your understanding!\n\n" ..
                      "If you get an offer from someone to help you create a custom name via PullRequest, that's completely fine. " ..
                      "But if that person charges you real world money, do NOT accept this offer! This is against the rules of ESO and can get both you and the person that is offering this rightfully banned from the game!\n\n" ..
                      "Please keep in mind that this is only a helping service. The volunteers are not affiliated with ZOS in any way and have no special privileges. " ..
                      "They are just regular players like you and me, who want to help out the community. Please be respectful towards them and understand that they are doing this in their free time.\n\n",
        },
        {
            type = LHAS.ST_LABEL,
            label = "Your @name",
            tooltip = "\"|cFFFF00" .. GetUnitDisplayName("player") .. "|r\"\n\n" ..
                    "This is your ESO account name (also often referred to as @name).\n\n" .. "You will need this name when creating your ticket in Discord. THE CAPITALIZATION MUST MATCH EXACTLY! \n\nIf you get this wrong, no assignment to your account can be made!",
        },
        {
            type = LHAS.ST_SECTION,
            label = string.format("|cFFFACD%s|r", "Custom Names"),
        },
        {
            type = LHAS.ST_LABEL,
            label = "0. Prerequisites",
            tooltip = "Before you proceed with the steps below, think about the custom name you want to get created.\n\n" ..
                      "1. Make sure it does not violate any of the ESO naming rules (no offensive names, no impersonation of GMs, etc.).\n\n" ..
                      "2. Also make sure that it is not too long. List space is limited and longer names might get cut off in certain UI elements.\n\n" ..
                      "3. Look for something unique to you! Try to avoid common words or phrases that many other players might also want to use as this defeats the purpose of having a personalized name in the first place.",
        },
        {
            type = LHAS.ST_BUTTON,
            label = "1. Join Discord",
            buttonText = "Join Discord",
            tooltip = "Join the official HodorReflexes Discord server and select your platform and region in the #server-selection channel.",
            clickHandler= function()
                RequestOpenUnsafeURL(self.discordURL)
            end,
        },
        {
            type = LHAS.ST_LABEL,
            label = "2. Read the #info channel",
            tooltip = "After you selected your platform and region, make sure to read the #info channel for important information about custom names on consoles. Everything is explained in there.",
        },
        {
            type = LHAS.ST_LABEL,
            label = "3. Create Ticket",
            tooltip = "When you read the #info channel, go into the #ticket channel and create a \"NEW\" ticket. You have to put in your ESO account name (|cFFFF00" .. GetUnitDisplayName("player") .. "|r) in there to create it. This ticket get's automatically assigned to a volunteer on your platform who will process it.",
        },
        {
            type = LHAS.ST_LABEL,
            label = "4. Use Online Configurator",
            tooltip = "Inside the newly created ticket, you will find a link to the online configurator. Use this configurator to create your custom name and generate the Lua code snippet. Then paste the generated LUA code into the ticket.",
        },
        {
            type = LHAS.ST_BUTTON,
            label = "5. Donate",
            tooltip = "Have a look at the #info section again for donation instructions.\n\n" ..
                    "Make sure to include your ticket number in the message so the volunteer can identify your request quickly. Please do not forget that as it is very important!\n\n" ..
                    "Sadly it is not possible to provide you with a prefilled mail template like on PC because ZoS does block this code on consoles...\n\n" ..
                    "If you have any problems or doubts, feel free to ask in your ticket before proceeding with the donation. \n\n" ..
                    "If for some reason or another your name cannot be created after the donation (e.g. it violates naming rules), the donation will simply not be taken and automatically return to you after 15days.",
            --tooltip = "Use this button to open a prefilled donation mail to the volunteer that is assigned to your platform. Make sure to include your ticket number in the donation note so the volunteer can identify your request quickly. Please do not forget that!",
            buttonText = "Donate",
            clickHandler = function()
                addon.Donate()
            end,
        },
    }

    return options
end