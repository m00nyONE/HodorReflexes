-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.logger.main

local hud = core.hud
local util = addon.util

local WM = GetWindowManager()
local EM = GetEventManager()
local localPlayer = "player"
local localBoss1 = "boss1"
local localBoss2 = "boss2"

local HR_EVENT_LOCKUI = addon.HR_EVENT_LOCKUI
local HR_EVENT_UNLOCKUI = addon.HR_EVENT_UNLOCKUI
local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED
local HR_EVENT_PLAYERSDATA_CLEANED = addon.HR_EVENT_PLAYERSDATA_CLEANED
local HR_EVENT_PLAYERSDATA_UPDATED = addon.HR_EVENT_PLAYERSDATA_UPDATED
local HR_EVENT_COMBAT_START = addon.HR_EVENT_COMBAT_START
local HR_EVENT_COMBAT_END = addon.HR_EVENT_COMBAT_END

local globalUpdateDebounceDelayMS = 15 -- global debounce delay for all lists, can be overridden in each list

--- @class: listClass
local list = ZO_InitializingObject:Subclass()
addon.listClass = list

list.uiLocked = true
list.windowName = ""
list.window = {}
list.windowFragment = {}
list.listControlName = ""
list.listControl = {}

-- must implement fields
list:MUST_IMPLEMENT("Update") -- function to update the list

--- NOT for manual use! this is a helper function that runs a function only once and then removes it from the list instance.
--- If you use it on a still needed function, it will be gone after the first call and thus break your list!
--- @param funcName string name of the function to run once
--- @param ... any arguments to pass to the function
--- @return any result of the function, or nil if the function does not exist
function list:RunOnce(funcName, ...)
    if type(self[funcName]) == "function" then
        local result = self[funcName](self, ...)
        self[funcName] = nil
        return result
    end
    return nil
end

--- get the unique ID of the List instance
--- @return string unique ID of the list instance
function list:GetId()
    return self._Id
end

--- get the next unique data type ID for the list instance that can be used to register a new dataType with the scrollList.
--- @return number unique data type ID
function list:GetNextDataTypeId()
    self._nextTypeId = self._nextTypeId + 1
    return self._nextTypeId - 1
end

--- NOT for manual use! this gets automatically called by :New() when creating a new list instance.
--- initializes the list with the given definition.
--- calls CreateSavedVariables(), CreateControls() and CreateFragment() once and deletes them afterwards.
--- sets up event listeners for group changes, ui lock/unlock and player data updates.
--- @param listDefinition table definition of the list
--- @return void
function list:Initialize(listDefinition)
    local beginTime = GetGameTimeMilliseconds()
    assert(type(listDefinition) == "table", "listDefinition must be a table")
    assert(type(listDefinition.name) == "string" and listDefinition.name ~= "", "list must have a valid name")
    assert(type(listDefinition.svDefault) == "table", "list must have a valid svDefault table")
    assert(type(listDefinition.Update) == "function", "list must have a valid update function")

    for k, v in pairs(listDefinition) do
        self[k] = v
    end

    if internal.registeredLists[self.name] then
        error(string.format("A list with the name '%s' is already registered!", self.name), 2)
    end

    self.logger = core.initSubLogger("list/" .. self.name)
    self.logger:Debug("initializing")

    self.listHeaderHeight = self.listHeaderHeight or 22
    self.listRowHeight = self.listRowHeight or 22

    self._nextTypeId = 1 -- initialize the next data type id counter

    -- create a unique id for the list instance (and make it somewhat readable by adding the list name at the end)
    self._Id = string.format("%s_%s", util.GetTableReference(self), self.name)
    self.updateDebouncedEventName = self._Id .. "_UpdateDebounced"

    self.logger:Debug("assigned unique id '%s'", self._Id)
    self.updateDebounceDelayMS = self.updateDebounceDelayMS or globalUpdateDebounceDelayMS
    self.logger:Debug("using update debounce delay of %d ms", self.updateDebounceDelayMS)

    self:RunOnce("CreateSavedVariables")
    self:RunOnce("CreateControls")
    self:RunOnce("CreateFragment")

    local function onGroupChanged()
        self:RefreshVisibility()
        self:UpdateDebounced()
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
    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_UPDATED, function(...) self:UpdateDebounced(...) end)
    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_CLEANED, function(...) self:UpdateDebounced(...) end)

    self.logger:Debug("initialized in %d ms", GetGameTimeMilliseconds() - beginTime)
    self.Initialize = nil -- prevent re-initialization

    internal.registeredLists[self.name] = self -- register the list
end

--- NOT for manual use! this gets called to update the list with a debounce.
--- debounces the update calls to prevent excessive updates
--- @return void
function list:UpdateDebounced()
    if not self:WindowFragmentCondition() then return end
    EM:RegisterForUpdate(self.updateDebouncedEventName, self.updateDebounceDelayMS, function()
        EM:UnregisterForUpdate(self.updateDebouncedEventName)
        self:Update()
    end)
end

--- NOT for manual use! this gets called to check if the list is enabled.
--- checks if the list is enabled based on the saved variables and current conditions
--- @return boolean true if the list is enabled, false otherwise
function list:IsEnabled()
    if self.sv.disableInPvP and (IsPlayerInAvAWorld() or IsActiveWorldBattleground()) then
        return false
    end

    local enabled = self.sv.enabled
    if enabled == 1 then -- always show
        return true
    elseif enabled == 2 then -- show out of combat
        return not IsUnitInCombat(localPlayer)
    elseif enabled == 3 then -- show non bossfights
        return not IsUnitInCombat(localPlayer) or not DoesUnitExist(localBoss1) and not DoesUnitExist(localBoss2)
    else -- off
        return false
    end
end

--- NOT for manual use! this gets called to refresh the visibility of the list.
--- refresh the visibility of the list based on the current conditions
--- @return void
function list:RefreshVisibility()
    self.windowFragment:Refresh()
end

--- NOT for manual use! this gets called to check the visibility
--- condition function for the window fragment of the list.
--- checks if the list should be shown based on the current conditions.
--- @return boolean true if the window fragment should be shown, false otherwise
function list:WindowFragmentCondition()
    local isEnabled = self:IsEnabled()
    if not self.uiLocked and isEnabled then
        return true -- always show when ui is unlocked
    end
    if not IsUnitGrouped(localPlayer) then
        return false -- never show when not in a group
    end

    return isEnabled
end

--- NOT for manual use! this gets called once when the list is initialized.
--- Create saved variables for the list.
--- sets default values if they are not provided during initialization.
--- @return void
function list:CreateSavedVariables()
    if not self.svVersion then self.svVersion = 1 end
    self.svDefault.enabled = self.svDefault.enabled or 1 -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    self.svDefault.disableInPvP = self.svDefault.disableInPvP or true
    self.svDefault.windowPosLeft = self.svDefault.windowPosLeft or 0
    self.svDefault.windowPosTop = self.svDefault.windowPosTop or 0
    self.svDefault.windowWidth = self.svDefault.windowWidth or 220

    local svNamespace = string.format("list_%s", self.name)
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

    -- Ensure sv is not nil
    if not self.sv then
        self.sv = self.svDefault
    end
end

--- NOT for manual use! this gets called once when the list is initialized.
--- creates the window and controls for the list.
--- the window is saved under sel.window and the scrollList control under self.listControl
--- @return void
function list:CreateControls()
    -- create the main window
    local windowName = string.format("%s_%s", addon_name, self._Id)
    local window = WM:CreateTopLevelWindow(windowName)
    window:SetClampedToScreen(true)
    window:SetResizeToFitDescendents(true)
    window:SetHidden(true)
    window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.sv.windowPosLeft, self.sv.windowPosTop)
    window:SetWidth(self.sv.windowWidth)
    window:SetHeight(self.listHeaderHeight + (self.listRowHeight * GROUP_SIZE_MAX) + self.listRowHeight) -- header + rows + extraRow for padding
    window:SetHandler( "OnMoveStop", function()
        self.sv.windowPosLeft = window:GetLeft()
        self.sv.windowPosTop = window:GetTop()
    end)
    self.windowName = windowName
    self.window = window
    self.logger:Debug("created main window '%s'", windowName)

    -- create the list control
    local listControlName = string.format("%s_%s", windowName, "List")
    local listControl = WM:CreateControlFromVirtual(listControlName, window, "ZO_ScrollList")
    listControl:SetAnchor(TOPLEFT, window, TOPLEFT, 0, 0, ANCHOR_CONSTRAINS_XY)
    listControl:SetAnchor(TOPRIGHT, window, TOPRIGHT, ZO_SCROLL_BAR_WIDTH, 0, ANCHOR_CONSTRAINS_X)
    listControl:SetHeight(self.listHeaderHeight + (self.listRowHeight * GROUP_SIZE_MAX) + self.listRowHeight) -- header + rows + extraRow for padding
    listControl:SetMouseEnabled(false)
    listControl:GetNamedChild("Contents"):SetMouseEnabled(false)
    self.listControlName = listControlName
    self.listControl = listControl
    self.logger:Debug("created list control '%s'", listControlName)

    ZO_ScrollList_SetHideScrollbarOnDisable(listControl, true)
    ZO_ScrollList_SetUseScrollbar(listControl, false)
    ZO_ScrollList_SetScrollbarEthereal(listControl, true)
end

--- NOT for manual use! this gets called once when the list is initialized.
--- creates the window fragment for the list.
--- @return void
function list:CreateFragment()
    local function windowFragmentConditionWrapper()
        return self:WindowFragmentCondition()
    end

    self.windowFragment = hud.AddFadeFragment(self.window, windowFragmentConditionWrapper)
    self.logger:Debug("created window fragment")
end

--- renders the current fight time to the control passed as argument.
--- Can be used by custom themes as well.
--- @param control LabelControl
--- @return void
function list.RenderCurrentFightTimeToControl(control)
    -- it would be more expensive here to check if the list is visible and prevent the rendering of the text than just rendering it anyways
    local t = core.combat:GetCombatTime()
    control:SetText(t > 0 and string.format("%d:%04.1f|u0:2::|u", t / 60, t % 60) or "")
end

--- creates and registers a fight time updater on the control passed as argument.
--- Can be used by custom themes as well.
--- WARNING: DO NOT use it on controls that get recycled (e.g. playerRows)! ONLY USE on headers or static labels! Otherwise the timers will pile up and cause performance issues. They do NOT get automatically cleaned up on control recycling!
--- @param control LabelControl the control to render the fight time to
--- @return void
function list:CreateFightTimeUpdaterOnControl(control)
    -- check if timer is already registered - if so, return
    if control._onCombatStart or control._onCombatStop then return end

    -- create a unique id for the control that can be used as a key for the timer update
    control._Id = util.GetTableReference(control)
    self.logger:Debug("creating fight time updater on control with id '%s'", control._Id)

    local function renderFightTimeToControl()
        self.RenderCurrentFightTimeToControl(control)
    end

    -- reate timer start & stop functions
    control._onCombatStop = function()
        renderFightTimeToControl()
        EM:UnregisterForUpdate(control._Id .. "_TimerUpdate")
    end
    control._onCombatStart = function()
        control._onCombatStop()
        EM:RegisterForUpdate(control._Id .. "_TimerUpdate", self.sw.timerUpdateInterval or 100, renderFightTimeToControl)
    end
    -- register timer update callbacks
    addon.RegisterCallback(HR_EVENT_COMBAT_START, control._onCombatStart)
    addon.RegisterCallback(HR_EVENT_COMBAT_END, control._onCombatStop)
    self.logger:Debug("registered fight time updater on control with id '%s'", control._Id)
end

--- renders the given time (in milliseconds) to the control passed as argument.
--- Can be used by custom themes as well.
--- @param control LabelControl
--- @param timeMS number time in milliseconds
--- @param opacity number|nil optional opacity to set on the control
--- @return void
function list.RenderTimeToControl(control, timeMS, opacity)
    local timeS = timeMS / 1000
    control:SetText(string.format("%0.1f|u0:2::|u", timeS) or "")
    if opacity then
        control:SetAlpha(opacity)
    end
end

--- creates and registers a buff/debuff countdown timer on the control passed as argument.
--- Can be used by custom themes as well.
--- WARNING: DO NOT use it on controls that get recycled (e.g. playerRows)! ONLY USE on headers or static labels! Otherwise the timers will pile up and cause performance issues. They do NOT get automatically cleaned up on control recycling!
--- @param control LabelControl the control to render the countdown to
--- @param eventName string the event name to register the countdown start callback to (must provide the following arguments: (unitTag, duration) where duration is in milliseconds)
--- @param zeroTimerOpacity number|nil optional opacity to set on the control when the timer reaches zero (default: 0.7)
--- @return void
function list:CreateCountdownOnControl(control, eventName, zeroTimerOpacity)
    -- check if timer is already registered - if so, return
    if control._onCountdownStart or control._onCountdownTick then return end

    -- create a unique id for the control that can be used as a key for the timer update
    control._Id = util.GetTableReference(control)
    self.logger:Debug("creating countdown timer on control with id '%s'", control._Id)

    local blinkDurationMS = 2500 -- TODO: possibly make configurable by savedVars ?
    self.logger:Debug("using blink duration of %d ms", blinkDurationMS)
    zeroTimerOpacity = zeroTimerOpacity or 0.7
    self.logger:Debug("using zero timer opacity of %.2f", zeroTimerOpacity)

    control._onCountdownTick = function()
        local nowMS = GetGameTimeMilliseconds()

        -- when the timer ended more than 5 seconds ago, set the opacity to zeroTimerOpacity, stop updating and return
        if not control._countdownEndTime or control._countdownEndTime + blinkDurationMS < nowMS then
            self.RenderTimeToControl(control, 0, zeroTimerOpacity)
            EM:UnregisterForUpdate(control._Id .. "_CountdownUpdate")
            return
        end

        -- render remaining time
        local remainingMS = control._countdownEndTime - nowMS
        local remainingMSDisplayed = zo_max(0, remainingMS)
        local opacity = nil

        -- if remaining time is less than blinkDurationMS, start blinking the text
        if remainingMS <= 0 then
            -- Blinking: switch every 250ms between 1.0 and zeroTimerOpacity
            local blinkPhase = zo_floor((remainingMS % 500) / 250)
            opacity = (blinkPhase == 0) and 1.0 or zeroTimerOpacity
        end

        self.RenderTimeToControl(control, remainingMSDisplayed, opacity)
    end

    control._onCountdownStart = function(_, durationMS)
        -- draw the initial time
        self.RenderTimeToControl(control, durationMS, 1.0)

        -- set the end time and start/overwrite the update timer
        control._countdownEndTime = GetGameTimeMilliseconds() + durationMS
        EM:RegisterForUpdate(control._Id .. "_CountdownUpdate", self.sw.timerUpdateInterval or 100, control._onCountdownTick)
    end

    -- register countdown start callback
    addon.RegisterCallback(eventName, control._onCountdownStart)
    self.logger:Debug("registered countdown timer on control with id '%s'", control._Id)
end