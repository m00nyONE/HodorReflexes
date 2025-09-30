-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_DAMAGE = "伤害",
    HR_TOTAL_DAMAGE = "总伤害",
    HR_MISC_DAMAGE = "杂项",
    HR_BOSS_DPS = "头目DPS",
    HR_TOTAL_DPS = "总DPS",

    HR_MENU_DAMAGE_SHOW = "显示伤害:",
    HR_MENU_DAMAGE_SHOW_TT = "显示团队伤害列表.",
    HR_MENU_DAMAGE_SHOW_NEVER = "永不",
    HR_MENU_DAMAGE_SHOW_ALWAYS = "总是",
    HR_MENU_DAMAGE_SHOW_OUT = "脱战时",
    HR_MENU_DAMAGE_SHOW_NONBOSS = "非头目战斗",

    HR_MENU_STYLE_DPS = "伤害列表",
    HR_MENU_STYLE_DPS_FONT = "数字字体",
    HR_MENU_STYLE_DPS_FONT_DEFAULT = "默认",
    HR_MENU_STYLE_DPS_FONT_GAMEPAD = "手柄模式",
    HR_MENU_STYLE_DPS_BOSS_COLOR = "头目伤害数字颜色",
    HR_MENU_STYLE_DPS_TOTAL_COLOR = "总伤害数字颜色",
    HR_MENU_STYLE_DPS_HEADER_OPACITY = "标题不透明度",
    HR_MENU_STYLE_DPS_EVEN_OPACITY = "偶数行不透明度",
    HR_MENU_STYLE_DPS_ODD_OPACITY = "奇数行不透明度",
    HR_MENU_STYLE_DPS_HIGHLIGHT = "自身特殊颜色",
    HR_MENU_STYLE_DPS_HIGHLIGHT_TT = "用选定的颜色来使您的名字在伤害列表中更具有辨识度。如果你不想让你的名字被特殊标记，那就把不透明度调为0.只有您能看见自己特殊的名字颜色",
    HR_MENU_ICONS_VISIBILITY_COLORS = "彩色名字",
    HR_MENU_ICONS_VISIBILITY_COLORS_TT = "显示其他队友的彩色名字.",
    HR_MENU_ICONS_VISIBILITY_DPS = "伤害图标",
    HR_MENU_ICONS_VISIBILITY_DPS_TT = "显示自定义图标于DPS分享列表.",

    HR_TEST_STARTED = "测试开始",
    HR_TEST_STOPPED = "测试结束",
    HR_TEST_LEAVE_GROUP = "您必须脱离后才能进行测试",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end