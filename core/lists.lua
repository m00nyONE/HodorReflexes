-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/lists")

local hud = core.hud
local util = addon.util
local combat = addon.combat

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

--[[ doc.lua begin ]]
local globalUpdateDebounceDelayMS = 5 -- global debounce delay for all lists, can be overridden in each list

--- @class listClass : ZO_InitializingObject base class for all lists
--- @field name string unique name of the list
--- @field sv table GENERATED! per character saved variables for the list
--- @field sw table GENERATED! account wide saved variables for the list
--- @field svDefault table default saved variables for the list
--- @field svVersion number version of the saved variables
--- @field listHeaderHeight number height of the list headers
--- @field listRowHeight number height of the list rows
--- @field updateDebounceDelayMS number debounce delay for the update
--- @field Update function MUST IMPLEMENT! function to update the list
local list = ZO_InitializingObject:Subclass()
addon.listClass = list

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

--- get the main window of the list instance
--- @return TopLevelWindow main window of the list instance
function list:GetWindow()
    return self.window
end

--- get the left position of the list window
--- @return number left position of the list window
function list:GetWindowPosTop()
    return self.sv.windowPosTop
end

--- get the top position of the list window
--- @return number top position of the list window
function list:GetWindowPosLeft()
    return self.sv.windowPosLeft
end

--- get the scrollList control of the list instance
--- @return ZO_ScrollList scrollList control of the list instance
function list:GetListControl()
    return self.listControl
end

--- check if the UI is currently locked
--- @return boolean true if the UI is locked, false otherwise
function list:IsUILocked()
    return self.uiLocked
end

--- get the current update counter of the list instance
--- @return number current update counter
function list:GetUpdateCounter()
    return self._updateCounter
end

--- get the name of the list instance
--- @return string name of the list instance
function list:GetName()
    return self.name
end

--- get the header height of the list instance
--- @return number header height of the list instance
function list:GetHeaderHeight()
    return self.listHeaderHeight
end

--- get the row height of the list instance
--- @return number row height of the list instance
function list:GetRowHeight()
    return self.listRowHeight
end

--- set the flag to redraw headers on the next update to true
--- @return void
function list:SetRedrawHeaders()
    self._redrawHeaders = true
end

--- get the flag to redraw headers
--- @return boolean true if headers need to be redrawn, false otherwise
function list:ShouldRedrawHeaders()
    return self._redrawHeaders
end

--- get the logger (LibDebugLogger) of the list instance
--- @return table logger of the list instance
function list:GetLogger()
    return self.logger
end

--- set the scale of the list
--- @param scale number scale to set
--- @return void
function list:SetScale(scale)
    self.sv.windowScale = scale
    self.window:SetScale(scale)
end

--- get the scale of the list
--- @return number scale of the list
function list:GetScale()
    return self.sv.windowScale
end

--- set the background opacity of the list
--- @param opacity number opacity to set (0.0 - 1.0)
--- @return void
function list:SetBackgroundOpacity(opacity)
    self.backgroundControl:SetAlpha(opacity)
end

--- get the background opacity of the list
--- @return number background opacity (0.0 - 1.0)
function list:GetBackgroundOpacity()
    return self.sw.backgroundOpacity
end

--- set the background texture of the list
--- @param texturePath string path to the texture to set
--- @return void
function list:SetBackgroundTexture(texturePath)
    self.sw.backgroundTexture = texturePath
    self.backgroundControl:SetTexture(texturePath)
end

--- get the background texture of the list
--- @return string|nil background texture path or `nil` if non is set
function list:GetBackgroundTexture()
    return self.sw.backgroundTexture
end

--- set the out of support range opacity of the list
--- @param opacity number opacity to set (0.0 - 1.0)
--- @return void
function list:SetOutOfSupportRangeOpacity(opacity)
    self.sw.outOfSupportRangeOpacity = opacity
end

--- get the out of support range opacity of the list
--- @return number out of support range opacity (0.0 - 1.0)
function list:GetOutOfSupportRangeOpacity()
    return self.sw.outOfSupportRangeOpacity
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
    assert(type(listDefinition.Update) == "function", "list must have a valid update function")

    -- set defaults
    self.svVersion = 1
    self.svDefault = {
        enabled = 1, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
        disableInPvP = true, -- disable the list in PvP zones
        windowWith = 230, -- default window width
        windowScale = 1.0, -- default window scale
        windowPosLeft = 0, -- default window left position
        windowPosTop = 0, -- default window top position
        backgroundOpacity = 0.0, -- default background opacity
        backgroundTexture = nil, -- default background texture
        supportRangeOnly = false, -- default support range only setting
        outOfSupportRangeOpacity = 0.2, -- default opacity for out of support range players
        nameFont = "$(BOLD_FONT)|$(KB_19)|outline",
    }
    self.listHeaderHeight = 22 -- default header height
    self.listRowHeight = 22 -- default row height
    self.updateDebounceDelayMS = globalUpdateDebounceDelayMS -- debounce delay for the update

    -- copy over everything from listDefinition but keep existing tables and just overwrite their inner contents
    for key, value in pairs(listDefinition) do
        if type(value) == "table" and type(self[key]) == "table" then
            for tableKey, tableValue in pairs(value) do
                self[key][tableKey] = tableValue
            end
        else
            self[key] = value
        end
    end

    if internal.registeredLists[self.name] then
        error(string.format("A list with the name '%s' is already registered!", self.name), 2)
    end

    -- set essential defaults. Just to be sure they are not overridden to invalid values
    self.logger = core.GetLogger("list/" .. self.name)
    self.uiLocked = true
    self._redrawHeaders = false
    self._nextTypeId = 1
    self._updateCounter = 0
    self._Id = string.format("%s_%s", util.GetTableReference(self), self.name)
    self._updateDebouncedEventName = self._Id .. "_UpdateDebounced"

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

    self._updateDebouncedTrigger = function()
        EM:UnregisterForUpdate(self._updateDebouncedEventName)
        self._updateCounter = self._updateCounter + 1
        self:Update()
        self:ResizeList()
    end

    addon.RegisterCallback(HR_EVENT_LOCKUI, lockUI)
    addon.RegisterCallback(HR_EVENT_UNLOCKUI, unlockUI)
    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, onGroupChanged)
    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_UPDATED, self:CreateUpdateRebouncedCallback())
    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_CLEANED, self:CreateUpdateRebouncedCallback())
    EM:RegisterForEvent(self._Id .. "_SupportRangeUpdate", EVENT_GROUP_SUPPORT_RANGE_UPDATE, self:CreateUpdateRebouncedCallback())

    self.logger:Debug("initialized in %d ms", GetGameTimeMilliseconds() - beginTime)
    self.Initialize = nil -- prevent re-initialization

    internal.registeredLists[self.name] = self -- register the list
end

--- NOT for manual use! this gets called to resize the list window based on the current data.
--- calculates the total height of the list based on the data types and their heights.
--- @return void
function list:ResizeList()
    local height = 0
    local dataList = ZO_ScrollList_GetDataList(self.listControl)
    for _, entry in pairs(dataList) do
        local type = ZO_ScrollList_GetDataTypeTable(self.listControl, entry.typeId)
        height = height + type.height
    end
    self.window:SetHeight(height)
end

--- NOT for manual use! this gets called to create the debounced update callback function.
--- creates a function that can be used as a callback to update the list with debounce.
--- @return function debounced update callback function
function list:CreateUpdateRebouncedCallback()
    return function(forceUpdate)
        self:UpdateDebounced(forceUpdate)
    end
end

--- NOT for manual use! this gets called to update the list with a debounce.
--- debounce the update calls to prevent excessive updates
--- @return void
function list:UpdateDebounced(forceUpdate)
    if not self:WindowFragmentCondition() and not (forceUpdate == true) then return end
    EM:RegisterForUpdate(self._updateDebouncedEventName, self.updateDebounceDelayMS, self._updateDebouncedTrigger)
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
    end

    return false
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
    if not self:IsUILocked() and isEnabled then
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
    -- make sure minimum size is updated based on defaults (if user set smaller values before)
    if self.sw.windowWidth < self.svDefault.windowWidth then
        self.sw.windowWidth = self.svDefault.windowWidth
    end

    -- create the main window
    local windowName = string.format("%s_%s", addon_name, self._Id)
    local window = WM:CreateTopLevelWindow(windowName)
    window:SetClampedToScreen(true)
    window:SetHidden(true)
    window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.sv.windowPosLeft, self.sv.windowPosTop)
    window:SetWidth(self.sw.windowWidth)
    window:SetHandler( "OnMoveStop", function()
        self.sv.windowPosLeft = window:GetLeft()
        self.sv.windowPosTop = window:GetTop()
        window:ClearAnchors()
        window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.sv.windowPosLeft, self.sv.windowPosTop)
    end)
    window:SetScale(self.sw.windowScale)
    self.window = window
    self.logger:Debug("created main window '%s'", windowName)

    -- create a background for the body of the list
    local backgroundName = string.format("%s_%s", windowName, "Background")
    local backgroundControl = window:CreateControl(backgroundName, CT_TEXTURE)
    backgroundControl:SetAnchor(TOPLEFT, window, TOPLEFT, 0, self.listHeaderHeight, ANCHOR_CONSTRAINS_XY)
    backgroundControl:SetAnchor(BOTTOMRIGHT, window, BOTTOMRIGHT, 0, 0, ANCHOR_CONSTRAINS_XY)
    backgroundControl:SetColor(0, 0, 0, self.sw.backgroundOpacity)
    backgroundControl:SetMouseEnabled(false)
    if self.sw.backgroundTexture then
        backgroundControl:SetTexture(self.sw.backgroundTexture)
    end
    self.backgroundControl = backgroundControl
    self.logger:Debug("created background control '%s'", backgroundName)

    -- create the list control
    local listControlName = string.format("%s_%s", windowName, "List")
    local listControl = WM:CreateControlFromVirtual(listControlName, window, "ZO_ScrollList")
    listControl:SetAnchor(TOPLEFT, window, TOPLEFT, 0, 0, ANCHOR_CONSTRAINS_XY)
    listControl:SetAnchor(TOPRIGHT, window, TOPRIGHT, ZO_SCROLL_BAR_WIDTH, 0, ANCHOR_CONSTRAINS_X)
    listControl:SetHeight(600) -- we need to set a fixed height here to make the scroll list work properly when it gets scaled. don't ask me why :D
    listControl:SetMouseEnabled(false)
    listControl:GetNamedChild("Contents"):SetMouseEnabled(false)
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
    local t = combat:GetCombatTime()
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

--- applies the support range style (transparent look) to the control passed as argument.
--- Can be used by custom themes as well.
--- @param rowControl any the control to apply the style to
--- @param unitTag string the unit tag of the player
--- @return void
function list:ApplySupportRangeStyle(rowControl, unitTag)
    if self.sw.supportRangeOnly and not IsUnitInGroupSupportRange(unitTag) then
        rowControl:SetAlpha(self.sw.outOfSupportRangeOpacity)
    else
        rowControl:SetAlpha(1.0)
    end
end

--- applies the user name to the control passed as argument.
--- Can be used by custom themes as well.
--- @param nameControl LabelControl the control to render the name to
--- @param userId string the user id of the player
--- @return void
function list:ApplyUserNameToControl(nameControl, userId)
    local userName = util.GetUserName(userId, true)
    if userName then
        nameControl:SetText(userName)
        nameControl:SetColor(1, 1, 1)
    end
end

--- applies the name font to the control passed as argument.
--- Can be used by custom themes as well.
--- @param labelControl LabelControl the control to apply the font to
--- @return void
function list:ApplyNameFontToControl(labelControl)
    labelControl:SetFont(self.sw.nameFont)
end

--- applies the user icon to the control passed as argument and sets the texture to be released at zero references.
--- Can be used by custom themes as well.
--- @param iconControl TextureControl the control to render the icon to
--- @param userId string the user id of the player
--- @param classId number the class id of the player
--- @return void
function list:ApplyUserIconToControl(iconControl, userId, classId)
    iconControl:SetTextureReleaseOption(RELEASE_TEXTURE_AT_ZERO_REFERENCES)
    local userIcon, tcLeft, tcRight, tcTop, tcBottom = util.GetUserIcon(userId, classId)
    if userIcon then
        iconControl:SetTexture(userIcon)
        iconControl:SetTextureCoords(tcLeft, tcRight, tcTop, tcBottom)
    end
end

--- creates and registers a buff/debuff countdown timer on the control passed as argument.
--- Can be used by custom themes as well.
--- WARNING: DO NOT use it on controls that get recycled (e.g. playerRows)! ONLY USE on headers or static labels! Otherwise the timers will pile up and cause performance issues. They do NOT get automatically cleaned up on control recycling!
--- @param control LabelControl the control to render the countdown to
--- @param eventName string the event name to register the countdown start callback to (must provide the following arguments: (unitTag, duration) where duration is in milliseconds)
--- @param zeroTimerOpacity number|nil optional opacity to set on the control when the timer reaches zero (default: self.sw.zeroTimerOpacity or 0.7)
--- @return void
function list:CreateCountdownOnControl(control, eventName, zeroTimerOpacity)
    -- check if timer is already registered - if so, return
    if control._onCountdownStart or control._onCountdownTick then return end

    -- create a unique id for the control that can be used as a key for the timer update
    control._Id = util.GetTableReference(control)
    self.logger:Debug("creating countdown timer on control with id '%s'", control._Id)

    local blinkDurationMS = 2500 -- TODO: possibly make configurable by savedVars ?

    control._onCountdownTick = function()
        local nowMS = GetGameTimeMilliseconds()

        -- when the timer ended more than 5 seconds ago, set the opacity to zeroTimerOpacity, stop updating and return
        if not control._countdownEndTime or control._countdownEndTime + blinkDurationMS < nowMS then
            self.RenderTimeToControl(control, 0, zeroTimerOpacity or self.sw.zeroTimerOpacity or 0.35)
            EM:UnregisterForUpdate(control._Id .. "_CountdownUpdate")
            return
        end

        -- render remaining time
        local remainingMS = control._countdownEndTime - nowMS
        local remainingMSDisplayed = zo_max(0, remainingMS)
        local opacity = 1.0

        -- if remaining time is less than blinkDurationMS, start blinking the text
        if remainingMS <= 0 then
            -- Blinking: switch every 250ms between 1.0 and zeroTimerOpacity
            local blinkPhase = zo_floor((remainingMS % 500) / 250)
            opacity = (blinkPhase == 0) and 1.0 or zeroTimerOpacity or self.sw.zeroTimerOpacity or 0.35
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

--[[ doc.lua end ]]