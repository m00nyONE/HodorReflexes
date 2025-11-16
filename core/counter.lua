-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local util = addon.util
local hud = core.hud

local WM = GetWindowManager()
local EM = GetEventManager()
local localPlayer = "player"

local HR_EVENT_LOCKUI = addon.HR_EVENT_LOCKUI
local HR_EVENT_UNLOCKUI = addon.HR_EVENT_UNLOCKUI
local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED

--- @class counter : ZO_InitializingObject
--- @field name string name of the counter
--- @field texture string texture path of the counter icon
--- @field updateInterval number update interval in milliseconds
--- @field svVersion number version of the saved variables
--- @field svDefault table default values for the saved variables
--- @field updateFunc function function to update the counter
--- @field sv table saved variables for the counter
--- @field sw table account wide saved variables for the counter
--- @field logger table logger for the counter
--- @field active boolean whether the counter is active
--- @field uiLocked boolean whether the UI is locked
local counter = ZO_InitializingObject:Subclass()
internal.counterClass = counter

--- NOT for manual use! this is a helper function that runs a function only once and then removes it from the counter instance.
--- If you use it on a still needed function, it will be gone after the first call and thus break your counter!
--- @param funcName string name of the function to run once
--- @param ... any arguments to pass to the function
--- @return any result of the function, or nil if the function does not exist
function counter:RunOnce(funcName, ...)
    if type(self[funcName]) == "function" then
        local result = self[funcName](self, ...)
        self[funcName] = nil
        return result
    end
    return nil
end

--- get the unique ID of the counter instance
--- @return string unique ID of the counter instance
function counter:GetId()
    return self._Id
end

--- check if the counter is enabled based on the saved variable settings
--- @return boolean true if the counter is enabled, false otherwise
function counter:IsEnabled()
    local enabled = self.sv.enabled
    if enabled == 1 then
        return true
    elseif enabled == 2 then
        return IsUnitInCombat(localPlayer)
    end

    return false
end

--- NOT for manual use! this gets called to refresh the visibility of the counter.
--- refresh the visibility of the counter based on the current conditions
--- @return void
function counter:RefreshVisibility()
    self.windowFragment:Refresh()
end

--- NOT for manual use! this gets called to check the visibility
--- condition function for the window fragment of the counter.
--- checks if the counter should be shown based on the current conditions.
--- @return boolean true if the window fragment should be shown, false otherwise
function counter:WindowFragmentCondition()
    local isEnabled = self:IsEnabled() and (not self.sw.hideOnCooldown or not self:IsCooldownActive())
    if not self.uiLocked and isEnabled then
        return true -- always show when ui is unlocked
    end
    if not self.active then
        return false
    end
    if not IsUnitGrouped(localPlayer) then
        return false -- never show when not in a group
    end

    return isEnabled
end

--- Initializes the counter instance with the given definition.
--- @param counterDefinition table definition of the counter
--- @return void
function counter:Initialize(counterDefinition)
    assert(type(counterDefinition) == "table", "counterDefinition must be a table")
    assert(type(counterDefinition.name) == "string" and counterDefinition.name ~= "", "counter must have a valid name")
    assert(type(counterDefinition.texture) == "string" and counterDefinition.texture ~= "", "counter must have a valid texture")
    assert(type(counterDefinition.updateInterval) == "number", "counter must have a valid updateInterval")
    assert(type(counterDefinition.updateFunc) == "function", "counter must have a valid updateFunc method")

    -- set defaults
    self.svVersion = 1
    self.distance = 0
    self.texture = "esoui/art/icons/ability_ultimate_001.dds"
    self.updateInterval = 200 -- milliseconds
    self.svDefault = {
        enabled = 0, -- 1=always, 2=only in combat, 0=off
        windowPosLeft = 0,
        windowPosTop = 0,
        scale = 1.0,
        hideOnCooldown = false,
    }

    -- copy over everything from listDefinition but keep existing tables and just overwrite their inner contents
    for key, value in pairs(counterDefinition) do
        if type(value) == "table" and type(self[key]) == "table" then
            for tableKey, tableValue in pairs(value) do
                self[key][tableKey] = tableValue
            end
        else
            self[key] = value
        end
    end

    -- set essential defaults. Just to be sure they are not overridden to invalid values
    self.logger = core.GetLogger("counter/" .. self.name)
    self.active = false
    self.uiLocked = true
    self.windowName = string.format("%s_Counter_%s", addon_name, self.name)
    self._Id = string.format("%s_%s", util.GetTableReference(self), self.name)
    self._updateEventName = string.format("%s_UpdateEvent", self._Id)
    self._cooldownEndTimeMS = 0

    self:RunOnce("CreateSavedVariables")
    self:RunOnce("CreateControls")
    self:RunOnce("CreateFragment")

    local function onGroupChanged()
        self:RefreshVisibility()
    end
    local function lockUI()
        self.uiLocked = true
        self:RefreshVisibility()
        hud.LockControls(self.window)
    end
    local function unlockUI()
        self.uiLocked = false
        self:RefreshVisibility()
        hud.UnlockControls(self.window)
    end

    self._update = function()
        self:Update()
    end

    addon.RegisterCallback(HR_EVENT_LOCKUI, lockUI)
    addon.RegisterCallback(HR_EVENT_UNLOCKUI, unlockUI)
    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, onGroupChanged)

    internal.registeredCounters[self.name] = self -- register the counter
end

--- NOT for manual use! this gets called once when the counter is initialized.
--- creates the window fragment for the counter.
--- @return void
function counter:CreateFragment()
    local function windowFragmentConditionWrapper()
        local isVisible = self:WindowFragmentCondition()
        if isVisible then
            self:StartUpdate()
        else
            self:StopUpdate()
        end

        return isVisible
    end

    self.windowFragment = hud.AddFadeFragment(self.window, windowFragmentConditionWrapper)
end

--- NOT for manual use! this gets called once when the counter is initialized.
--- creates the controls for the counter window.
--- @return void
function counter:CreateControls()
    local window = WM:CreateTopLevelWindow(self.windowName)
    window:SetClampedToScreen(true)
    window:SetResizeToFitDescendents(true)
    window:SetHidden(true)
    window:SetMovable(false)
    window:SetAnchor(CENTER, GuiRoot, TOPLEFT, self.sv.windowPosLeft, self.sv.windowPosTop)
    window:SetDimensions(64, 64)
    window:SetScale(self.sv.scale)
    window:SetHandler("OnMoveStop", function()
        self.sv.windowPosLeft, self.sv.windowPosTop = window:GetCenter()
        window:ClearAnchors()
        window:SetAnchor(CENTER, GuiRoot, TOPLEFT, self.sv.windowPosLeft, self.sv.windowPosTop)
    end)
    window:SetHandler("OnMouseWheel", function(_, delta)
        self.sv.scale = zo_clamp(self.sv.scale + delta * 0.1, 0.5, 2)
        window:SetScale(self.sv.scale)
    end)
    local bg = window:CreateControl(self.windowName .. "_BG", CT_TEXTURE)
    bg:SetTextureReleaseOption(RELEASE_TEXTURE_AT_ZERO_REFERENCES)
    bg:SetAnchor(CENTER, window, CENTER, 0, 0)
    bg:SetDimensions(64, 64)
    bg:SetColor(0, 0, 0, 1)
    local icon = window:CreateControl(self.windowName .. "_Icon", CT_TEXTURE)
    icon:SetTextureReleaseOption(RELEASE_TEXTURE_AT_ZERO_REFERENCES)
    icon:SetAnchor(CENTER, window, CENTER, 0, 0)
    icon:SetDimensions(56, 56)
    icon:SetTexture(self.texture)
    local highLight = window:CreateControl(self.windowName .. "_Highlight", CT_TEXTURE)
    highLight:SetTextureReleaseOption(RELEASE_TEXTURE_AT_ZERO_REFERENCES)
    highLight:SetAnchor(CENTER, window, CENTER, 0, 0)
    highLight:SetDimensions(56, 56)
    highLight:SetTexture("esoui/art/actionBar/abilityHighlightAnimation.dds")
    local animation = CreateSimpleAnimation(ANIMATION_TEXTURE, highLight)
    animation:SetImageData(64, 1)
    animation:SetFramerate(30)
    animation:GetTimeline():SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
    local label = window:CreateControl(self.windowName .. "_Label", CT_LABEL)
    label:SetAnchor(CENTER, window, CENTER, 0, 0)
    label:SetFont("$(MEDIUM_FONT)|$(KB_40)|thick-outline")
    label:SetInheritAlpha(true)
    label:SetInheritScale(true)
    label:SetColor(1, 1, 1)
    label:SetWrapMode(TEXT_WRAP_MODE_TRUNCATE)
    label:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    label:SetVerticalAlignment(TEXT_ALIGN_CENTER)
    label:SetText("0")

    self.window = window
    self.animation = animation
end

--- NOT for manual use! this gets called once when the list is initialized.
--- Create saved variables for the list.
--- sets default values if they are not provided during initialization.
--- @return void
function counter:CreateSavedVariables()
    local svNamespace = string.format("counter_%s", self.name)
    local svVersion = core.svVersion + self.svVersion
    self.logger:Debug("using saved variables version %d", svVersion)
    -- we use a combination of accountWide saved variables and per character saved variables. This little swappi swappi allows us to switch between them without defining new variables
    self.sw = ZO_SavedVars:NewAccountWide(core.svName, svVersion, svNamespace, self.svDefault)
    if not core.sw.accountWide then
        self.sv = ZO_SavedVars:NewCharacterIdSettings(core.svName, svVersion, svNamespace, self.svDefault)
        core.sv.accountWide = false
    else
        self.sv = self.sw
    end
end

--- NOT for manual use! this gets called periodically to update the counter.
--- calls the update function and updates the counter display.
--- @return void
function counter:Update()
    if not self:WindowFragmentCondition() then return end

    local labelControl = self.window:GetNamedChild("_Label")
    local bgControl = self.window:GetNamedChild("_BG")

    -- show countdown when on cooldown or buff is still active
    local remainingCooldownMS = self:GetRemainingCooldownMS()
    if remainingCooldownMS > 0 then
        labelControl:SetColor(1, 0, 0)
        bgControl:SetColor(1, 0, 0)
        labelControl:SetText(string.format("%.1f", remainingCooldownMS / 1000))
        self:StopAnimation()
        return
    end

    -- call the update function
    local count, ready = self.updateFunc()
    count = count or 0
    ready = ready or false

    labelControl:SetText(string.format("%d", count))
    if ready then
        labelControl:SetColor(0, 1, 0)
        bgControl:SetColor(0, 1, 0)
        self:RunAnimation()
    else
        labelControl:SetColor(1, 1, 1)
        bgControl:SetColor(0, 0, 0)
        self:StopAnimation()
    end
end
--- Starts the update of the counter.
--- @return void
function counter:StartUpdate()
    if self.isUpdating then return end
    EM:RegisterForUpdate(self._updateEventName, self.updateInterval, self._update)
    self.isUpdating = true
end
--- Stops the update of the counter.
--- @return void
function counter:StopUpdate()
    EM:UnregisterForUpdate(self._updateEventName)
    self.isUpdating = false
end

--- Runs the counter animation.
--- @return void
function counter:RunAnimation()
    if self.animation:GetTimeline():IsPlaying() then return end

    self.animation:GetTimeline():PlayFromStart()
end
--- Stops the counter animation.
--- @return void
function counter:StopAnimation()
    self.animation:GetTimeline():Stop()
end

--- Sets the active state of the counter.
--- @param active boolean true to activate the counter, false to deactivate it.
--- @return void
function counter:SetActive(active)
    self.active = active
    self:RefreshVisibility()
end

--- Checks if the cooldown is currently active.
--- @return boolean true if the cooldown is active, false otherwise
function counter:IsCooldownActive()
    return self:GetRemainingCooldownMS() > 0
end

--- Gets the remaining cooldown time in milliseconds.
--- @return number remaining cooldown time in milliseconds
function counter:GetRemainingCooldownMS()
    return zo_max(0, self._cooldownEndTimeMS - GetGameTimeMilliseconds())
end

--- Sets the cooldown duration for the counter.
--- @param durationMS number duration of the cooldown in milliseconds
--- @return void
function counter:SetCooldown(durationMS)
    self._cooldownEndTimeMS = zo_max(self._cooldownEndTimeMS, GetGameTimeMilliseconds() + durationMS)
end