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

--- @class: listClass
internal.listClass = ZO_InitializingObject:Subclass()
local listClass = internal.listClass

-- must implement fields
listClass:MUST_IMPLEMENT("name") -- unique name of the list
listClass:MUST_IMPLEMENT("svDefault") -- default saved variables table
listClass:MUST_IMPLEMENT("update") -- function to update the list
listClass:MUST_IMPLEMENT("isEnabled") -- function to check if the list is enabled
listClass:MUST_IMPLEMENT("listEnabledSV") -- saved variable to check if the list should be shown

function listClass:RunOnce(funcName, ...)
    if type(self[funcName]) == "function" then
        local result = self[funcName](self, ...)
        self[funcName] = nil
        return result
    end
    return nil
end

function listClass:Initialize(t)
    assert(type(t.name) == "string" and t.name ~= "", "list must have a valid name")
    assert(type(t.svDefault) == "table", "list must have a valid svDefault table")
    assert(type(t.update) == "function", "list must have a valid update function")
    assert(type(t.isEnabled) == "function", "list must have a valid isEnabled function")
    assert(type(t.listEnabledSV) == "number", "list must have a valid listEnabledSV reference")

    if t then
        for k, v in pairs(t) do
            self[k] = v
        end
    end

    self.uiLocked = true

    self:RunOnce("createSavedVariables")
    self:RunOnce("createControls")
    self:RunOnce("createFragment")

    local function refreshVisibility()
        self.controlsVisible = not self.uiLocked or self:isEnabled() and IsUnitGrouped(localPlayer)
        self.fragment:Refresh()
    end

    local function onGroupChanged()
        refreshVisibility()
        self:update()
    end

    local function lockUI()
        self.uiLocked = true
        refreshVisibility()
        hud.LockControls(self.window)
    end
    local function unlockUI()
        self.uiLocked = false
        refreshVisibility()
        hud.UnlockControls(self.window)
    end

    addon.RegisterCallback(HR_EVENT_LOCKUI, lockUI)
    addon.RegisterCallback(HR_EVENT_UNLOCKUI, unlockUI)
    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, onGroupChanged)
end

function listClass:IsListVisible()
    local listEnabledSV = self.listEnabledSV
    if listEnabledSV == 1 then -- always show
        return true
    elseif listEnabledSV == 2 then -- show out of combat
        return not IsUnitInCombat(localPlayer)
    elseif listEnabledSV == 3 then -- show non bossfights
        return not IsUnitInCombat(localPlayer) or not DoesUnitExist(localBoss1) and not DoesUnitExist(localBoss2)
    else -- off
        return false
    end
end

function listClass:createSavedVariables()
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

function listClass:createControls()
    if not self.sv.windowPosLeft then self.sv.windowPosLeft = 0 end
    if not self.sv.windowPosTop then self.sv.windowPosTop = 0 end
    if not self.sv.windowWidth then self.sv.windowWidth = 220 end
    if not self.sv.listHeaderHeight then self.sv.listHeaderHeight = 22 end
    if not self.sv.listRowHeight then self.sv.listRowHeight = 22 end

    local windowName = addon_name .. "_List_" .. self.name
    local window = WM:CreateTopLevelWindow(windowName)
    window:SetClampedToScreen(true)
    window:SetResizeToFitDescendents(true)
    window:SetHidden(true)
    window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.sv.windowPosLeft, self.sv.windowPosTop)
    window:SetWidth(self.sv.windowWidth)
    window:SetHeight(self.sv.listHeaderHeight + (self.sv.listRowHeight * GROUP_SIZE_MAX))
    window:SetHandler( "OnMoveStop", function()
        self.sv.windowPosLeft = window:GetLeft()
        self.sv.windowPosTop = window:GetTop()
    end)
    self.windowName = windowName
    self.window = window

    local listControlName = windowName .. "_List"
    local listControl = WM:CreateControlFromVirtual(listControlName, window, "ZO_ScrollList")
    listControl:SetAnchor(TOPLEFT, window, TOPLEFT, 0, 0, ANCHOR_CONSTRAINS_XY)
    listControl:SetAnchor(TOPRIGHT, window, TOPRIGHT, ZO_SCROLL_BAR_WIDTH, 0, ANCHOR_CONSTRAINS_X)
    listControl:SetHeight(self.sv.listHeaderHeight + (self.sv.listRowHeight * GROUP_SIZE_MAX))
    listControl:SetMouseEnabled(false)
    listControl:GetNamedChild("Contents"):SetMouseEnabled(false)
    self.listControlName = listControlName
    self.listControl = listControl


    ZO_ScrollList_SetHideScrollbarOnDisable(listControl, true)
    ZO_ScrollList_SetUseScrollbar(listControl, false)
    ZO_ScrollList_SetScrollbarEthereal(listControl, true)

end

function listClass:createFragment()
    local function listFragmentCondition()
        return self:IsListVisible(self.listEnabledSV) and self.controlsVisible
    end

    self.fragment = hud.AddFadeFragment(window, listFragmentCondition)
end