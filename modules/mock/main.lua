local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local module = {
    name = "mock",
    version = "1.0.0",
    friendlyName = "Toxic Mode",
    description = "Mocks you when you die",
}

local module_name = module.name
local module_version = module.version

local sv = nil
local svName = addon.svName
local svVersion = addon.svVersion
local svDefault = {
    toxicMode = false, -- Enable "toxic" mock messages in specific zones
}

-- Toxic mock messages configuration
local text = {}  -- Stores the currently displayed mock message
local mockText = {} -- Array of possible mock messages
local mockZones = {
    [636] = true,  -- HRC
    [638] = true,  -- AA
    [639] = true,  -- SO
    [725] = true,  -- MoL
    [975] = true,  -- HoF
    [1000] = true, -- AS
    [1051] = true, -- CR
    [1121] = true, -- SS
    [1196] = true, -- KA
    [1263] = true, -- RG
    [1344] = true, -- DSR
    [1427] = true, -- SE
    [1478] = true, -- LC
}

local EM = EVENT_MANAGER

local localPlayer = "player"

-- Function to handle changes in the Death Recap screen
-- Displays mock messages when "toxicMode" is enabled.
local function DeathRecapChanged(status)
    if sv.toxicMode and status and ZO_DeathRecapScrollContainerScrollChildHintsContainerHints1Text then
        text = mockText[math.random(#mockText)]
        ZO_DeathRecapScrollContainerScrollChildHintsContainerHints1Text:SetText(GetString(text))
    end
end

-- Function to generate mock messages based on zone, language, and dungeon difficulty.
local function generateMock()
    local eventRegisterName = "OnDeathRecapAvailableChanged"

    -- Unregister the Death Recap callback to reset mock messages
    DEATH_RECAP:UnregisterCallback(eventRegisterName, DeathRecapChanged)

    -- Reset the mockText table
    mockText = {}

    -- Retrieve the player's current zone ID and language setting
    local zoneId = GetZoneId(GetUnitZoneIndex(localPlayer))

    -- Check if the language and zone are supported for mock messages
    if mockZones[zoneId] then
        -- Populate the mockText table with predefined mock messages
        mockText = {
            HR_MOCK1, HR_MOCK2, HR_MOCK3, HR_MOCK4,
            HR_MOCK5, HR_MOCK6, HR_MOCK7, HR_MOCK8,
            HR_MOCK9, HR_MOCK10, HR_MOCK11, HR_MOCK12,
            HR_MOCK13, HR_MOCK14, HR_MOCK15, HR_MOCK16,
            HR_MOCK17, HR_MOCK18, HR_MOCK19, HR_MOCK20,
        }

        -- Add zone-specific mock messages for zones with ID < 700
        if zoneId < 700 then
            text = table.insert(mockText, HR_MOCK_AA1)
        end

        -- Add region-specific mock messages for the EU Megaserver
        if GetWorldName() == "EU Megaserver" then
            table.insert(mockText, HR_MOCK_EU1)
        end

        -- Add mock messages based on dungeon difficulty
        if GetCurrentZoneDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL then
            table.insert(mockText, HR_MOCK_NORMAL1)
        else
            table.insert(mockText, HR_MOCK_VET1)
        end

        -- Re-register the Death Recap callback to display new mock messages
        DEATH_RECAP:RegisterCallback(eventRegisterName, DeathRecapChanged)
    end
end

function module:MainMenuOptions()
    return {
        {
            type = "header",
            name = "Toxic Mode"
        },
        {
            type = "description",
            text = "Toxic module description"
        },
        {
            type = "checkbox",
            name = "enabled",
            tooltip = "enable/disable toxic mode",
            getFunc = function() return sv.toxicMode end,
            setFunc = function(value) sv.toxicMode = value end
        }
    }
end

function module:Initialize()
    sv = ZO_SavedVars:NewAccountWide(svName, svVersion, module_name, svDefault)

    local eventRegisterName = "HodorReflexes_mock_PlayerActivated"
    EM:UnregisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED)
    EM:RegisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED, generateMock)
end

addon:RegisterModule(module_name, module)