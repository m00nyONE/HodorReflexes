local HR = HodorReflexes
local M = HR.modules.events
local MS = HR.modules.share

local christmasIcons = {
    [1] = "HodorReflexes/assets/events/christmas/class_dragonknight_christmas.dds",
    [2] = "HodorReflexes/assets/events/christmas/class_sorcerer_christmas.dds",
    [3] = "HodorReflexes/assets/events/christmas/class_nightblade_christmas.dds",
    [4] = "HodorReflexes/assets/events/christmas/class_warden_christmas.dds",
    [5] = "HodorReflexes/assets/events/christmas/class_necromancer_christmas.dds",
    [6] = "HodorReflexes/assets/events/christmas/class_templar_christmas.dds",
    [7] = "HodorReflexes/assets/events/christmas/class_arcanist_christmas.dds"
}

local function Initialize()
    if M.date == "2412" or M.date == "2512" or M.date == "2612" then
        MS.OverwriteClassIcons(christmasIcons)
    end
end

M.RegisterEvent(Initialize)