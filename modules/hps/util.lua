-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "hps"
local module = addon_modules[module_name]

-- sorting functions

--- sort by name descending
--- @param a table
--- @param b table
--- @return boolean
function module.sortByName(a, b)
    return a.name > b.name
end
--- sort by overheal descending
--- @param a table
--- @param b table
--- @return boolean
function module.sortByOverheal(a, b)
    if a.overheal == b.overheal then
        return module.sortByName(a, b)
    end
    return a.overheal > b.overheal
end
