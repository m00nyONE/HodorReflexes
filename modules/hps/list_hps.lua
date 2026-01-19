-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules

local module_name = "hps"
local module = addon_modules[module_name]

local combat = addon.combat

local svVersion = 1
local svDefault = {
    enabled =  0, -- 1=always, 2=out of combat, 3=non bossfights, 0=off
    disableInPvP = true,

    windowScale = 1.0,
    windowPosLeft = 10,
    windowPosTop = 260,
    windowWidth = 237,
    backgroundOpacity = 0.0,

    listHeaderOpacity = 0.8,
    listRowEvenOpacity = 0.65,
    listRowOddOpacity = 0.45,

    listPlayerHighlight = true,
    listPlayerHighlightColor = {0, 1, 0, 0.36}, -- green

    timerUpdateInterval = 100, -- ms

    colorHPS = "00FF00",       -- green
    colorOverheal = "AAAAAA",  -- gray

    onlyShowHealers = false,

    nameFont = "$(BOLD_FONT)|$(KB_18)|outline",
}

--- initializes the hps list
--- @return void
function module:CreateHpsList()
    local listDefinition = {
        name = "hps",
        svVersion = svVersion,
        svDefault = svDefault,
        Update = function() self:UpdateHpsList() end,
        listHeaderHeight = 22,
        listRowHeight = 22,
    }
    self.hpsList = addon.listClass:New(listDefinition)
    local list = self.hpsList

    list.HEADER_TYPE = list:GetNextDataTypeId() -- type id for header
    list.ROW_TYPE = list:GetNextDataTypeId()   -- type id for rows
    list.HEADER_TEMPLATE = "HodorReflexes_Hps_HpsList_Header"
    list.ROW_TEMPLATE = "HodorReflexes_Hps_HpsList_HpsRow"

    local function rowCreationWrapper(wrappedFunction)
        return function(rowControl, data, scrollList)
            wrappedFunction(self, rowControl, data, scrollList)
        end
    end

    ZO_ScrollList_AddDataType(
            list.listControl,
            list.HEADER_TYPE,
            list.HEADER_TEMPLATE,
            list.listHeaderHeight,
            rowCreationWrapper(self.headerRowCreationFunction)
    )
    ZO_ScrollList_SetTypeCategoryHeader(list.listControl, list.HEADER_TYPE, true)
    list.logger:Debug("added header row type '%d' with template '%s'", list.HEADER_TYPE, list.HEADER_TEMPLATE)

    ZO_ScrollList_AddDataType(
            list.listControl,
            list.ROW_TYPE,
            list.ROW_TEMPLATE,
            list.listRowHeight,
            rowCreationWrapper(self.hpsRowCreationFunction)
    )
    list.logger:Debug("added player row type '%d' with template '%s'", list.ROW_TYPE, list.ROW_TEMPLATE)
end

--- creation function for the header row. This can be overwritten if using a custom theme
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:headerRowCreationFunction(rowControl, data, scrollList)
    local sw = self.hpsList.sw
    rowControl:GetNamedChild("_Title"):SetText(string.format("|c%s%s|r |c%s(%s)|r", sw.colorHPS, GetString(HR_MODULES_HPS_HEALING_HPS), sw.colorOverheal, GetString(HR_MODULES_HPS_HEALING_OVERHEAL)))

    if rowControl._initialized and not self.hpsList._redrawHeaders then
        return
    end

    rowControl:GetNamedChild("_BG"):SetAlpha(sw.listHeaderOpacity)
    local timeControl = rowControl:GetNamedChild("_Time")
    self.hpsList:CreateFightTimeUpdaterOnControl(timeControl)

    rowControl._initialized = true
end

--- creation function for the damage rows. This can be overwritten if using a custom theme
--- @param rowControl Control
--- @param data table
--- @param scrollList ZO_ScrollList
--- @return void
function module:hpsRowCreationFunction(rowControl, data, scrollList)
    local list = self.hpsList
    local sw = list.sw

    list:ApplyUserNameToControl(rowControl:GetNamedChild('_Name'), data.userId)
    list:ApplyUserIconToControl(rowControl:GetNamedChild('_Icon'), data.userId, data.classId)
    list:ApplyNameFontToControl(rowControl:GetNamedChild('_Name'))

    local valueControl = rowControl:GetNamedChild("_Value")
    valueControl:SetText(string.format("|c%s%0.1fK|r |c%s(%dK)|r|u0:2::|u", sw.colorHPS, data.hps / 10, sw.colorOverheal, data.overheal))

    local customColor = false
    if data.isPlayer and sw.listPlayerHighlight then
        local r, g, b, o = unpack(sw.listPlayerHighlightColor)
        if o ~= 0 then
            customColor = true
            rowControl:GetNamedChild('_BG'):SetColor(r, g, b, o or 0.5)
        end
    end
    if not customColor then
        rowControl:GetNamedChild('_BG'):SetColor(0, 0, 0, zo_mod(data.orderIndex, 2) == 0 and sw.listRowEvenOpacity or sw.listRowOddOpacity)
    end
end

--- update function to refresh the hps list. This should usually not be overwritten by a custom theme unless absolutely necessary.
--- @return void
function module:UpdateHpsList()
    local listControl = self.hpsList.listControl
    local list = self.hpsList
    local sw = list.sw

    ZO_ScrollList_Clear(listControl)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    local playersDataList = {}
    for _, playerData in pairs(addon.playersData) do
        if not playerData.hideHps and playerData.overheal > 0 then
            local lfgRole = GetGroupMemberSelectedRole(playerData.tag)
            local isHealer = lfgRole == LFG_ROLE_HEAL or lfgRole == 0 -- treat unknown role as healer
            if not sw.onlyShowHealers or isHealer then
                table.insert(playersDataList, playerData)
            end
        end
    end
    table.sort(playersDataList, self.sortByOverheal)

    -- insert header row
    table.insert(dataList, ZO_ScrollList_CreateDataEntry(list.HEADER_TYPE, {}))

    -- insert hpsRows
    for i, playerData in ipairs(playersDataList) do
        playerData.orderIndex = i
        table.insert(dataList, ZO_ScrollList_CreateDataEntry(list.ROW_TYPE, playerData))
    end

    ZO_ScrollList_Commit(listControl)

    -- cleanup
    playersDataList = nil
end