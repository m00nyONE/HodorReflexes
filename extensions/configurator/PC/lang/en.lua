-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

--TODO: rename Strings
local strings = {

    HR_MENU_ICONS_SECTION_CUSTOM = "Custom names & icons",
    HR_MENU_ICONS_NOLIBSINSTALLED = "For the full experience of HodorReflexes, please make sure the following libraries are installed:\n\n - |cFFFF00LibCustomIcons|r – Enables personalized icons for players.\n - |cFFFF00LibCustomNames|r – Displays custom names for friends, guildmates, and more.\n\nThese libraries enhance the visual experience and allow for more personalization but are not required for basic functionality. It's your choice if you want to have them installed or not.",
    HR_MENU_ICONS_README_1 = "Before doing anything, please read this guide carefully! This ensures that you receive exactly what you expect.\n",
    HR_MENU_ICONS_HEADER_ICONS = "Icons & Animations – Requirements:",
    HR_MENU_ICONS_README_2 = "Please follow these technical limitations for your files:\n\n- Maximum size: 32×32 pixels\n- Animations: maximum of 50 frames\n- Accepted file formats: .dds, .jpg, .png, .gif, .webp\n",
    HR_MENU_ICONS_HEADER_TIERS = "Donation Tiers:",
    HR_MENU_ICONS_README_3 = "there are three donation tiers, each with different rewards:\n\n1. 5M gold – custom name\n2. 7M gold – custom name + static icon\n3. 10M gold – custom name + static icon + animated icon\n\nYou can select the desired tier using the slider below. Simply move it to position 1–3, depending on which tier you want.\n",
    HR_MENU_ICONS_HEADER_CUSTOMIZE = "Customize your name:",
    HR_MENU_ICONS_README_4 = "Use the configurator below to customize your name.\n",
    HR_MENU_ICONS_HEADER_TICKET = "Create Ticket in Discord",
    HR_MENU_ICONS_README_5 = "1. Click inside the textbox containing the generated LUA code.\n2. Press CTRL+A to select all.\n3. Press CTRL+C to copy the content.",
    HR_MENU_ICONS_README_6 = "\nNext, open a ticket on our Discord server – choose the tier you selected – and paste the code and the icon into the ticket.",
    HR_MENU_ICONS_HEADER_DONATION = "Sending a Donation:",
    HR_MENU_ICONS_README_7 = "Once you’ve created your ticket on Discord:\n\n1. Click the \"%s\" button.\n2. Enter your ticket number in the ticket-XXXXX field.\n3. Send the gold according to your selected donation tier.",
    HR_MENU_ICONS_HEADER_INFO = "Info:",
    HR_MENU_ICONS_INFO = "- This is a donation-based service.\n- You are not purchasing icons, nor do you acquire any ownership of them.\n- This is a voluntary donation with cosmetic perks within the scope of addons using LibCustomNames and LibCustomIcons.\n- You need to stay within the ToS of ZoS - Swear words in names or unappropriated icons will be denied!\n- You can always send PRs on github with your icon and name without any donation needed if you know how to code.",

    HR_MENU_ICONS_CONFIGURATOR_DISCORD = "join discord",
    HR_MENU_ICONS_CONFIGURATOR_DISCORD_TT = "join the HodorReflexes discord to create a request ticket.",
    HR_MENU_ICONS_README_DONATION_TIER = "Donation tier: ",
    HR_MENU_ICONS_README_DONATION_TIER_TT = "By changing the donation tier, the LUA Code in the configurator below will generate additional code depending on the tier you choose",
    HR_MENU_ICONS_CONFIGURATOR_LUA_TT = "click into the textbox and press ctrl+a to highlight the whole code, then press ctrl+c to copy the code to your clipboard.",
    HR_MENU_ICONS_CONFIGURATOR_DONATE_TT = "opens the mail window and puts in some text.",

}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end