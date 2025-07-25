local strings = {

	-------------------------
	-- MENUS
	-------------------------

	HR_MENU_GENERAL = "General",
	HR_MENU_GENERAL_ENABLED = "Enabled",
	HR_MENU_GENERAL_ENABLED_TT = "Enable/disable this addon.",
	HR_MENU_GENERAL_UI_LOCKED = "UI Locked",
	HR_MENU_GENERAL_UI_LOCKED_TT = "Unlock UI to show all enabled controls. If you are not grouped, then you can type\n |cFFFF00/hodor.share test|r in chat to fill controls with test data.",
	HR_MENU_GENERAL_ACCOUNT_WIDE = "Account Wide Settings",
	HR_MENU_GENERAL_ACCOUNT_WIDE_TT = "Switch between global account settings and character settings.",
	HR_MENU_GENERAL_DISABLE_PVP = "Disable in PvP",
	HR_MENU_GENERAL_DISABLE_PVP_TT = "Disable the addon in PvP zones.",
	HR_MENU_GENERAL_EXIT_INSTANCE = "Confirm Instance Exit",
	HR_MENU_GENERAL_EXIT_INSTANCE_TT = "Show confirmation dialog before exiting the current instance by a group leader request or with a hotkey.",

	HR_MENU_DAMAGE = "Damage",
	HR_MENU_DAMAGE_SHOW = "Show Damage:",
	HR_MENU_DAMAGE_SHOW_TT = "Show the list with group damage.",
	HR_MENU_DAMAGE_SHOW_NEVER = "Never",
	HR_MENU_DAMAGE_SHOW_ALWAYS = "Always",
	HR_MENU_DAMAGE_SHOW_OUT = "Out of combat",
	HR_MENU_DAMAGE_SHOW_NONBOSS = "Non-boss fight",

	HR_MENU_HORN = "War Horn",
	HR_MENU_HORN_SHOW = "Show War Horns:",
	HR_MENU_HORN_SHOW_TT = "Show the list with group ultimates.",
	HR_MENU_HORN_SHOW_PERCENT = "Show Percentage",
	HR_MENU_HORN_SHOW_PERCENT_TT = "Show the calculated percentage of Horn ultimates",
	HR_MENU_HORN_SHOW_RAW = "Show Ulti points",
	HR_MENU_HORN_SHOW_RAW_TT = "Show the raw ulti points the player has",
	HR_MENU_HORN_SELFISH = "Selfish mode:",
	HR_MENU_HORN_SELFISH_TT = "When enabled, you will see the remaining horn duration only if you have an active buff from it.",
	HR_MENU_HORN_ICON = "Show Icon:",
	HR_MENU_HORN_ICON_TT = "Show an icon with a number of people in 20 meters range when your horn is ready.\nThe icon turns |c00FF00green|r when all DDs are in the horn range.\nGreen icon turns |cFFFF00yellow|r if somebody is higher than you in the horn list. Announce your horn!",
	HR_MENU_HORN_COUNTDOWN_TYPE = "Countdown Type:",
	HR_MENU_HORN_COUNTDOWN_TYPE_TT = "- None: no countdown.\n- Self: countdown for my horn/major force only.\n- All: countdown for everyone's horn/major force (raid lead mode).",
	HR_MENU_HORN_COUNTDOWN_TYPE_NONE = "None",
	HR_MENU_HORN_COUNTDOWN_TYPE_SELF = "War Horn (self)",
	HR_MENU_HORN_COUNTDOWN_TYPE_ALL = "War Horn (all)",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_SELF = "Major Force (self)",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_ALL = "Major Force (all)",
	HR_MENU_HORN_COUNTDOWN_COLOR = "Countdown Text Color:",

	HR_MENU_COLOS = "Colossus",
	HR_MENU_COLOS_SHOW = "Show Colossuses:",
	HR_MENU_COLOS_SHOW_TT = "Show the list with group ultimates.",
	HR_MENU_COLOS_SHOW_PERCENT = "Show Percentage",
	HR_MENU_COLOS_SHOW_PERCENT_TT = "Show the calculated percentage of Colossus ultimates",
	HR_MENU_COLOS_SHOW_RAW = "Show Ulti points",
	HR_MENU_COLOS_SHOW_RAW_TT = "Show the raw ulti points the player has",
	HR_MENU_COLOS_SUPPORT_RANGE = "Only show nearby allies:",
	HR_MENU_COLOS_SUPPORT_RANGE_TT = "Players who are too far from you will be hidden in the list.",
	HR_MENU_COLOS_COUNTDOWN = "Show Countdown:",
	HR_MENU_COLOS_COUNTDOWN_TT = "Show a notification with a countdown to use your ultimate.",
	HR_MENU_COLOS_COUNTDOWN_TEXT = "Countdown Text:",
	HR_MENU_COLOS_COUNTDOWN_COLOR = "Countdown Text Color:",

	HR_MENU_ATRONACH = "Atronach",
	HR_MENU_ATRONACH_SHOW = "Show Atronach",
	HR_MENU_ATRONACH_SHOW_TT =  "Show the list with group ultimates.",
	HR_MENU_ATRONACH_SHOW_PERCENT = "Show Percentage",
	HR_MENU_ATRONACH_SHOW_PERCENT_TT = "Show the calculated percentage of Atronach ultimates",
	HR_MENU_ATRONACH_SHOW_RAW = "Show Ulti points",
	HR_MENU_ATRONACH_SHOW_RAW_TT = "Show the raw ulti points the player has",

	HR_MENU_MISCULTIMATES = "Other Ultimates",
	HR_MENU_MISCULTIMATES_SHOW = "Show other Ultimates",
	HR_MENU_MISCULTIMATES_SHOW_TT = "Show other unsupported Ultimates",

	HR_MENU_MISC = "Misc",
	HR_MENU_MISC_DESC = "To show/hide a sample list of players type |c999999/hodor.share test|r in chat.\nYou can also choose which players to show by typing their names:\n|c999999/hodor.share test @andy.s @Alcast|r",

	HR_MENU_ICONS = "Icons",
	HR_MENU_ICONS_VISIBILITY = "Visibility",
	HR_MENU_ICONS_VISIBILITY_HORN = "War Horn Icons",
	HR_MENU_ICONS_VISIBILITY_HORN_TT = "Show custom icons for players in the horns list.",
	HR_MENU_ICONS_VISIBILITY_DPS = "Damage Icons",
	HR_MENU_ICONS_VISIBILITY_DPS_TT = "Show custom icons for players in the damage list.",
	HR_MENU_ICONS_VISIBILITY_COLOS = "Colossus Icons",
	HR_MENU_ICONS_VISIBILITY_COLOS_TT = "Show custom icons for players in the colossuses list.",
	HR_MENU_ICONS_VISIBILITY_ATRONACH = "Atronach Icons",
	HR_MENU_ICONS_VISIBILITY_ATRONACH_TT = "Show custom icons for players in the atronach list.",
	HR_MENU_ICONS_VISIBILITY_MISCULTIMATES = "Other Ultimates",
	HR_MENU_ICONS_VISIBILITY_MISCULTIMATES_TT = "Show custom icons for players in the ultimates list.",
	HR_MENU_ICONS_VISIBILITY_COLORS = "Colored names",
	HR_MENU_ICONS_VISIBILITY_COLORS_TT = "Color names of other players.",
	HR_MENU_ICONS_VISIBILITY_ANIM = "Animated Icons",
	HR_MENU_ICONS_VISIBILITY_ANIM_TT = "Play animated icons. Note: disabling this feature won't increase your FPS.",

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

	HR_MENU_STYLE = "Style",
	HR_MENU_STYLE_PINS = "Show map pings",
	HR_MENU_STYLE_PINS_TT = "Show players' pings on the world map and compass.",
	HR_MENU_STYLE_DPS = "Damage list",
	HR_MENU_STYLE_DPS_FONT = "Numbers font",
	HR_MENU_STYLE_DPS_FONT_DEFAULT = "Default",
	HR_MENU_STYLE_DPS_FONT_GAMEPAD = "Gamepad",
	HR_MENU_STYLE_DPS_BOSS_COLOR = "Boss damage color",
	HR_MENU_STYLE_DPS_TOTAL_COLOR = "Total damage color",
	HR_MENU_STYLE_DPS_HEADER_OPACITY = "Header opacity",
	HR_MENU_STYLE_DPS_EVEN_OPACITY = "Even row opacity",
	HR_MENU_STYLE_DPS_ODD_OPACITY = "Odd row opacity",
	HR_MENU_STYLE_DPS_HIGHLIGHT = "Highlight color",
	HR_MENU_STYLE_DPS_HIGHLIGHT_TT = "Highlight your name in the damage list with the selected color. If you don't want to highlight your name, then set Opacity to 0. Only you see the highlighted name.",
	HR_MENU_STYLE_HORN_COLOR = "War Horn duration color",
	HR_MENU_STYLE_FORCE_COLOR = "Major Force duration color",
	HR_MENU_STYLE_ATRONACH_COLOR = "Atronach duration color",
	HR_MENU_STYLE_BERSERK_COLOR = "Major Berserk duration color",
	HR_MENU_STYLE_COLOS_COLOR = "Colossus duration color",
	HR_MENU_STYLE_TIMER_OPACITY = "Expired timer opacity",
	HR_MENU_STYLE_TIMER_OPACITY_TT = "Text and icon opacity when a timer reaches zero (0.0).",
	HR_MENU_STYLE_TIMER_BLINK = "Blinking timers",
	HR_MENU_STYLE_TIMER_BLINK_TT = "Timers blink first when they reach 0 seconds, then opacity is applied.",

	HR_MENU_ANIMATIONS = "Animated messages",
	HR_MENU_ANIMATIONS_TT = "Animate colossus and horn countdowns to make them more noticeable.",

	HR_MENU_VOTE = "Vote",
	HR_MENU_VOTE_DISABLED = "This module requires Hodor Reflexes to be enabled!",
	HR_MENU_VOTE_DESC = "This module improves default ready check and allows to see who is ready or not if group members have Hodor Reflexes enabled.",
	HR_MENU_VOTE_ENABLED_TT = "Enable/disable this module. When disabled, other players won't be able to see your votes.",
	HR_MENU_VOTE_CHAT = "Chat messages",
	HR_MENU_VOTE_CHAT_TT = "Display vote results and some other information in the game chat.",
	HR_MENU_VOTE_ACTIONS = "Actions",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN = "Countdown",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_TT = "Start a countdown with the duration specified above. You must be a group leader to do it.",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM = "You must be a group leader to initiate a countdown!",
	HR_MENU_VOTE_ACTIONS_LEADER = "Change group leader",
	HR_MENU_VOTE_ACTIONS_LEADER_TT = "Requires 60% of group members to vote Yes.",
	HR_MENU_VOTE_ACTIONS_LEADER_CONFIRM = "Change group leader to",
	HR_MENU_VOTE_COUNTDOWN_DURATION = "Countdown Duration",

	HR_MENU_EVENTS = "Events",
	HR_MENU_EVENTS_DESC = "This module enables specific features at specific times of the year",
	HR_MENU_EVENTS_DISABLED = "This module requires Hodor Reflexes to be enabled!",

	HR_MENU_MISC_TOXIC = "Toxic mode",
	HR_MENU_MISC_TOXIC_TT = "Mocking hints and stuff.",

	-------------------------
	-- BINDINGS
	-------------------------

	HR_BINDING_PULL_COUNTDOWN = "Pull Countdown",
	HR_BINDING_EXIT_INSTANCE = "Exit Instance Immediately",
	HR_BINDING_SEND_EXIT_INSTANCE = "Eject Group",

	-------------------------
	-- SHARE MODULE
	-------------------------

	HR_SEND_EXIT_INSTANCE = "Eject Group",
	HR_SEND_EXIT_INSTANCE_CONFIRM = "Do you want everyone to leave the instance (including yourself)?",

	HR_COLOS_COUNTDOWN_DEFAULT_TEXT = "ULT",
	HR_HORN = "War Horn",
	HR_COLOS = "Colossus",

	-- Damage list title
	HR_DAMAGE = "Damage",
	HR_TOTAL_DAMAGE = "Total Damage",
	HR_MISC_DAMAGE = "Misc",
	HR_BOSS_DPS = "Boss DPS",
	HR_TOTAL_DPS = "Total DPS",

	HR_NOW = "NOW", -- HORN/COLOS: NOW!

	HR_TEST_STARTED = "Test started.",
	HR_TEST_STOPPED = "Test stopped.",
	HR_TEST_LEAVE_GROUP = "You must leave the group to test.",

	-------------------------
	-- VOTE MODULE
	-------------------------

	HR_READY_CHECK = "Ready Check",
	HR_READY_CHECK_READY = "Everyone is ready!",
	HR_PULL_COUNTDOWN = "Pull Countdown",
	HR_VOTE_NOT_READY_CHAT = "is not ready",

	-------------------------
	-- MOCK
	-------------------------

	HR_MOCK1 = "Imagine dying with all these addons enabled.",
	HR_MOCK2 = "Try equipping Mighty Chudan, Plague Doctor and Beekeeper's Gear.",
	HR_MOCK3 = "Are you going to blame the servers again?",
	HR_MOCK4 = "A bad instance, obviously.",
	HR_MOCK5 = "Maybe tanking or healing would be a better role for you.",
	HR_MOCK6 = "Have you missed the addon notification?",
	HR_MOCK7 = "You are the weakest link, goodbye.",
	HR_MOCK8 = "Maybe you should consider buying a carry run instead.",
	HR_MOCK9 = "Maybe you should consider using barrier rotation.",
	HR_MOCK10 = "We ran out of hints for your deaths.",
	HR_MOCK11 = "If you want to do something useful, then check Crown Store.",
	HR_MOCK12 = "The game's performance is bad, but yours is worse.",
	HR_MOCK13 = "You are doing good at being bad.",
	HR_MOCK14 = "Try installing more addons to carry you.",
	HR_MOCK15 = "Your APM is too low for this fight.",
	HR_MOCK16 = "Don't worry, eventually we'll add this trial's achievements to Crown Store.",
	HR_MOCK17 = "Insanity is doing the same thing over and over again and expecting different results.",
	HR_MOCK18 = "In PvE content you are supposed to kill mobs before they kill you.",
	HR_MOCK19 = "Have you ever considered changing your name to Kenny?",
	HR_MOCK20 = "I've fought mudcrabs more fearsome than you.",
	HR_MOCK_AA1 = "Imaging dying in a six years old content.",
	HR_MOCK_EU1 = "Why do you even play on the EU server?",
	HR_MOCK_NORMAL1 = "This is not even the veteran mode...",
	HR_MOCK_VET1 = "Consider switching the trial difficulty to Normal.",

	-------------------------
	-- Exit Instance
	-------------------------

	HR_EXIT_INSTANCE = "Leave Instance",
	HR_EXIT_INSTANCE_CONFIRM = "Do you want to leave the current instance?",

	-------------------------
	-- Missing Libraries
	-------------------------

	HR_MISSING_LIBS_TITLE = "Get the Full HodorReflexes Experience!",
	HR_MISSING_LIBS_TEXT = "|c00FF00You're missing out on the full HodorReflexes experience!|r\n\nInstall |cFFFF00LibCustomIcons|r and |cFFFF00LibCustomNames|r to see custom icons, nicknames, and styles from other Hodor users including your friends and guildmates. Transform the battlefield into something personal and full of character!\n\nThis is entirely optional and not required for HodorReflexes to function.",
	HR_MISSING_LIBS_OK = "OK",
	HR_MISSING_LIBS_DONTSHOWAGAIN = "Don't show again",

}

for id, val in pairs(strings) do
	ZO_CreateStringId(id, val)
	SafeAddVersion(id, 1)
end