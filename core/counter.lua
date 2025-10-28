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

local counter = ZO_InitializingObject:Subclass()
internal.counterClass = counter

counter.name = ""
counter.windowName = ""
counter.window = {}
counter.windowFragment = {}
counter.animation = {}
counter.distance = 0
counter.texture = "esoui/art/icons/ability_ultimate_001.dds"
counter.updateInterval = 200 -- milliseconds
counter.updateFunc = nil -- function to call to update the counter -- should return count and ready state
counter.active = false

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

function counter:IsEnabled()
    local enabled = self.sv.enabled
    if enabled == 1 then
        return true
    elseif enabled == 2 then
        return IsUnitInCombat(localPlayer)
    end
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
    local isEnabled = self:IsEnabled()
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

function counter:Initialize(counterDefinition)
    assert(type(counterDefinition) == "table", "counterDefinition must be a table")
    assert(type(counterDefinition.name) == "string" and counterDefinition.name ~= "", "counter must have a valid name")
    assert(type(counterDefinition.texture) == "string" and counterDefinition.texture ~= "", "counter must have a valid texture")
    assert(type(counterDefinition.updateInterval) == "number", "counter must have a valid updateInterval")
    assert(type(counterDefinition.enableConditionFunc) == "function", "counter must have a valid enableConditionFunc method")

    for k, v in pairs(counterDefinition) do
        self[k] = v
    end

    self.uiLocked = true
    self.logger = core.GetLogger("counter/" .. self.name)
    self.logger:Debug("Initializing")

    self.windowName = string.format("%s_Counter_%s", addon_name, self.name)

    self._Id = string.format("%s_%s", util.GetTableReference(self), self.name)
    self.logger:Debug("assigned unique id '%s'", self._Id)

    self._updateEventName = string.format("%s_UpdateEvent", self._Id)

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

    addon.RegisterCallback(HR_EVENT_LOCKUI, lockUI)
    addon.RegisterCallback(HR_EVENT_UNLOCKUI, unlockUI)
    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, onGroupChanged)
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
    self.logger:Debug("created window fragment")
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
    end)
    window:SetHandler("OnMouseWheel", function(_, delta)
        self.sv.scale = zo_max(0.5, zo_min(2, self.sv.scale + delta * 0.1))
        window:SetScale(self.sv.scale)
    end)
    local bg = window:CreateControl(self.windowName .. "_BG", CT_TEXTURE)
    bg:SetAnchor(CENTER, window, CENTER, 0, 0)
    bg:SetDimensions(64, 64)
    bg:SetColor(0, 0, 0, 1)
    local icon = window:CreateControl(self.windowName .. "_Icon", CT_TEXTURE)
    icon:SetAnchor(CENTER, window, CENTER, 0, 0)
    icon:SetDimensions(56, 56)
    icon:SetTexture(self.texture)
    local highLight = window:CreateControl(self.windowName .. "_Highlight", CT_TEXTURE)
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
    if not self.svVersion then self.svVersion = 1 end
    self.svDefault.enabled = self.svDefault.enabled or 0 -- 1=always, 2=only in combat, 0=off
    self.svDefault.windowPosLeft = self.svDefault.windowPosLeft or 0
    self.svDefault.windowPosTop = self.svDefault.windowPosTop or 0
    self.svDefault.scale = self.svDefault.scale or 1.0
    self.svDefault.accountWide = self.svDefault.accountWide or false

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

    local count, ready = self.updateFunc()
    count = count or 0
    ready = ready or false

    labelControl:SetText(tostring(count))
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
    EM:RegisterForUpdate(self._updateEventName, self.updateInterval, function()
        self:Update()
    end)
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