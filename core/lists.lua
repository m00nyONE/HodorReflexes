-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.logger.main

local util = core.util
local hud = core.hud

local WM = GetWindowManager()
local localPlayer = "player"
local localBoss1 = "boss1"
local localBoss2 = "boss2"

local HR_EVENT_LOCKUI = addon.HR_EVENT_LOCKUI
local HR_EVENT_UNLOCKUI = addon.HR_EVENT_UNLOCKUI
local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED
local HR_EVENT_PLAYERSDATA_CLEANED = addon.HR_EVENT_PLAYERSDATA_CLEANED
local HR_EVENT_PLAYERSDATA_UPDATED = addon.HR_EVENT_PLAYERSDATA_UPDATED

local debounceDelayMS = 15

--- @class: listClass
local listClass = ZO_InitializingObject:Subclass()
internal.listClass = listClass

listClass.uiLocked = true
listClass.windowName = ""
listClass.window = {}
listClass.windowFragment = {}
listClass.listControlName = ""
listClass.listControl = {}

-- must implement fields
listClass:MUST_IMPLEMENT("Update") -- function to update the list

function listClass:RunOnce(funcName, ...)
    if type(self[funcName]) == "function" then
        local result = self[funcName](self, ...)
        self[funcName] = nil
        return result
    end
    return nil
end

function listClass:Initialize(listDefinition)
    assert(type(listDefinition) == "table", "listDefinition must be a table")
    assert(type(listDefinition.name) == "string" and listDefinition.name ~= "", "list must have a valid name")
    assert(type(listDefinition.svDefault) == "table", "list must have a valid svDefault table")
    assert(type(listDefinition.Update) == "function", "list must have a valid update function")

    for k, v in pairs(listDefinition) do
        self[k] = v
    end

    self._eventId = string.match(tostring(self), "0%x+")

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
end

function listClass:UpdateDebounced()
    if not self:WindowFragmentCondition() then return end
    EVENT_MANAGER:RegisterForUpdate(self._eventId, debounceDelayMS, function()
        EVENT_MANAGER:UnregisterForUpdate(self._eventId)
        self:Update()
    end)
end

function listClass:IsEnabled()
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

function listClass:RefreshVisibility()
    self.windowFragment:Refresh()
end

function listClass:WindowFragmentCondition()
    if not self.uiLocked then
        return true -- always show when ui is unlocked
    end
    if not IsUnitGrouped(localPlayer) then
        return false -- never show when not in a group
    end

    return self:IsEnabled()
end

--- Create saved variables for the list.
--- sets default values if they are not provided during initialization.
function listClass:CreateSavedVariables()
    self.svDefault.enabled = self.svDefault.enabled or 1 -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    self.svDefault.disableInPvP = self.svDefault.disableInPvP or true
    self.svDefault.windowPosLeft = self.svDefault.windowPosLeft or 0
    self.svDefault.windowPosTop = self.svDefault.windowPosTop or 0
    self.svDefault.windowWidth = self.svDefault.windowWidth or 220
    self.svDefault.listHeaderHeight = self.svDefault.listHeaderHeight or 22
    self.svDefault.listRowHeight = self.svDefault.listRowHeight or 22

    local svNamespace = self.name .. "List"
    -- we use a combination of accountWide saved variables and per character saved variables. This little swappi swappi allows us to switch between them without defining new variables
    self.sw = ZO_SavedVars:NewAccountWide(core.svName, core.svVersion, svNamespace, self.svDefault)
    if not core.sw.accountWide then
        self.sv = ZO_SavedVars:NewCharacterIdSettings(core.svName, core.svVersion, svNamespace, self.svDefault)
        core.sv.accountWide = false
    else
        self.sv = self.sw
    end
end
--- creates the window and controls for the list
function listClass:CreateControls()
    -- create the main window
    local windowName = addon_name .. "_List_" .. self.name
    local window = WM:CreateTopLevelWindow(windowName)
    window:SetClampedToScreen(true)
    window:SetResizeToFitDescendents(true)
    window:SetHidden(true)
    window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.sv.windowPosLeft, self.sv.windowPosTop)
    window:SetWidth(self.sv.windowWidth)
    window:SetHeight(self.sv.listHeaderHeight + (self.sv.listRowHeight * GROUP_SIZE_MAX) + self.sv.listRowHeight) -- header + rows + extraRow for padding
    window:SetHandler( "OnMoveStop", function()
        self.sv.windowPosLeft = window:GetLeft()
        self.sv.windowPosTop = window:GetTop()
    end)
    self.windowName = windowName
    self.window = window

    -- create the list control
    local listControlName = windowName .. "_List"
    local listControl = WM:CreateControlFromVirtual(listControlName, window, "ZO_ScrollList")
    listControl:SetAnchor(TOPLEFT, window, TOPLEFT, 0, 0, ANCHOR_CONSTRAINS_XY)
    listControl:SetAnchor(TOPRIGHT, window, TOPRIGHT, ZO_SCROLL_BAR_WIDTH, 0, ANCHOR_CONSTRAINS_X)
    listControl:SetHeight(self.sv.listHeaderHeight + (self.sv.listRowHeight * GROUP_SIZE_MAX) + self.sv.listRowHeight) -- header + rows + extraRow for padding
    listControl:SetMouseEnabled(false)
    listControl:GetNamedChild("Contents"):SetMouseEnabled(false)
    self.listControlName = listControlName
    self.listControl = listControl

    ZO_ScrollList_SetHideScrollbarOnDisable(listControl, true)
    ZO_ScrollList_SetUseScrollbar(listControl, false)
    ZO_ScrollList_SetScrollbarEthereal(listControl, true)
end

--- creates the window fragment for the list
function listClass:CreateFragment()
    local function windowFragmentConditionWrapper()
        return self:WindowFragmentCondition()
    end

    self.windowFragment = hud.AddFadeFragment(self.window, windowFragmentConditionWrapper)
end