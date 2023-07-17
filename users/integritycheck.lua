HodorReflexes.integrity = {

}

local u = HodorReflexes.users
local a = HodorReflexes.anim.users
local getIconForUserId = HodorReflexes.player.GetIconForUserId

local WM = GetWindowManager()
local GUIControl = HodorReflexes_IntegrityCheck

local iconSize = 20
local SCREEN_WIDTH = tonumber(GetCVar("WindowedWidth")) --GuiRoot:GetWidth()
local SCREEN_HEIGHT = tonumber(GetCVar("WindowedHeight")) --GuiRoot:GetWidth()
local maxColumns = zo_floor(SCREEN_WIDTH / iconSize)
local maxRows = zo_floor(SCREEN_HEIGHT / iconSize)

local iconPool = {}
local failedList = {}

local function createTexture(iconNumber, userName, iconPath)

    local iconColumn = iconNumber % maxColumns
    local iconRow = (zo_floor((iconSize * iconNumber) / SCREEN_WIDTH)) % maxRows

    local icon = WM:CreateControl( GUIControl:GetName() .. "_Icon_" .. tostring(iconNumber), GUIControl, CT_TEXTURE)

    icon.userName = userName
    icon:ClearAnchors()
    icon:SetAnchor( TOPLEFT, GUIControl, TOPLEFT, (iconColumn * iconSize), (iconRow * iconSize))
    icon:SetTextureReleaseOption(RELEASE_TEXTURE_AT_ZERO_REFERENCES)
    icon:SetHidden(false)
    icon:SetTexture(iconPath)
    icon:SetDimensions(iconSize, iconSize)

    iconPool[iconNumber] = icon
end

local function checkTexture(iconNumber)
    local icon = iconPool[iconNumber]
    local isLoaded = icon:IsTextureLoaded()

    --d("checking " .. icon.userName)

    if isLoaded then
        iconPool[iconNumber]:SetTexture("HodorReflexes/assets/integrity/check.dds")
    else
        --d("failed for " .. icon.userName)
        table.insert(failedList, icon.userName)

        iconPool[iconNumber]:SetTexture("HodorReflexes/assets/integrity/cross.dds")
    end
end

local function deleteTexture(iconNumber)
    iconPool[iconNumber]:SetHidden(true)
    iconPool[iconNumber]:SetTexture("none")
    iconPool[iconNumber] = nil
end

local function integrityCheck()
    d("starting integritycheck")

    local limit = 9999999
    local iconNumber = 1

    for userName, _ in pairs(u) do
        if iconNumber >= limit then
            break
        end

        local iconPath = getIconForUserId(userName)
        if iconPath then
            createTexture(iconNumber, userName, iconPath)
            iconNumber = iconNumber + 1
        end
    end

    for userName, userData in pairs(a) do
        if iconNumber >= limit then
            break
        end

        local iconPath = userData[1]
        createTexture(iconNumber, userName, iconPath)
        iconNumber = iconNumber + 1
    end

    d(iconNumber)

    zo_callLater(function()
        for i, _ in pairs(iconPool) do
            checkTexture(i)
        end
    end, 5000)

    zo_callLater(function()
        for i, _ in pairs(iconPool) do
            deleteTexture(i)
        end

    end, 7000)
    --HodorReflexes_IntegrityCheck = nil

    zo_callLater(function()
        d(failedList)
        d("failed: " .. #failedList)
    end, 7000)

end

function HodorReflexes.integrity.Check()
    integrityCheck()
end
--zo_callLater(function() integrityCheck() end, 2000)
