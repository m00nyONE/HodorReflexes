local HR = HodorReflexes
local M = HR.modules.events
local player = HR.player

local originalGetIconForUserId = player.GetIconForUserId

local icons = {
    "HodorReflexes/assets/events/valentine/8bitHeart.dds",
    "HodorReflexes/assets/events/valentine/angel_heart.dds",
    "HodorReflexes/assets/events/valentine/blue_heart.dds",
    "HodorReflexes/assets/events/valentine/calender.dds",
    "HodorReflexes/assets/events/valentine/ff_heart.dds",
    "HodorReflexes/assets/events/valentine/green_heart.dds",
    "HodorReflexes/assets/events/valentine/happyheart.dds",
    "HodorReflexes/assets/events/valentine/orange_heart.dds",
    "HodorReflexes/assets/events/valentine/present.dds",
    "HodorReflexes/assets/events/valentine/purple_heart.dds",
    "HodorReflexes/assets/events/valentine/rainbow_heart.dds",
    "HodorReflexes/assets/events/valentine/ring.dds",
    "HodorReflexes/assets/events/valentine/rose.dds",
    "HodorReflexes/assets/events/valentine/round_heart.dds",
    "HodorReflexes/assets/events/valentine/smiling_heart.dds",
    "HodorReflexes/assets/events/valentine/sparkling_heart.dds",
    "HodorReflexes/assets/events/valentine/white_heart.dds",
}

local function getRandomValentinesIcon()
    local randomIconIndex = zo_random(1, #icons)
    return icons[randomIconIndex]
end

local function GetIconForUserIdHook(id)
    local icon = originalGetIconForUserId(id)
    if icon == nil then
        icon = getRandomValentinesIcon()
    end
    return icon
end

local function Initialize()
    if M.date == "1402" then
        player.GetIconForUserId = GetIconForUserIdHook
    end
end

M.RegisterEvent(Initialize)