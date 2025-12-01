-- SPDX-FileCopyrightText: 2025 m00nyONE Lykeion
-- SPDX-License-Identifier: Artistic-2.0

local strings = {

    ------------------------- CORE -------------------------
    -- VISIBILITY
    HR_VISIBILITY_SHOW_NEVER = "从不",
    HR_VISIBILITY_SHOW_ALWAYS = "总是",
    HR_VISIBILITY_SHOW_OUT_OF_COMBAT = "仅在非战斗中",
    HR_VISIBILITY_SHOW_NON_BOSSFIGHTS = "非boss战斗",
    HR_VISIBILITY_SHOW_IN_COMBAT = "仅在战斗中",
    -- HUD
    HR_CORE_HUD_COMMAND_LOCK_HELP = "锁定插件界面",
    HR_CORE_HUD_COMMAND_UNLOCK_HELP = "解锁插件界面",
    HR_CORE_HUD_COMMAND_LOCK_ACTION = "插件界面已锁定",
    HR_CORE_HUD_COMMAND_UNLOCK_ACTION = "插件界面已解锁",
    -- Group
    HR_CORE_GROUP_COMMAND_TEST_HELP = "开始/停止测试",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_START = "测试已开始",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_STOP = "测试已停止",
    HR_CORE_GROUP_COMMAND_TEST_LEAVE_GROUP = "你必须离开队伍才能开始测试",
    -- LibCheck
    HR_MISSING_LIBS_TITLE = "获取完整的HodorReflexes体验!",
    HR_MISSING_LIBS_TEXT = "|c00FF00你错过了完整的HodorReflexes体验!|r\n\n安装|cFFFF00LibCustomIcons|r和|cFFFF00LibCustomNames|r来查看其他Hodor用户/你的朋友/公会成员的自定义图标、昵称和独特风格。将战场变成充满个性元素的独到体验！\n\n此功能为可选项，并非HodorReflexes必需的依赖库。",
    HR_MISSING_LIBS_TEXT_CONSOLE = "|c00FF00你错过了完整的HodorReflexes体验!|r\n\n安装|cFFFF00LibCustomNames|r来查看其他Hodor用户/你的朋友/公会成员的自定义昵称与独特风格。将战场变成充满个性元素的独到体验！\n\n此功能为可选项，并非HodorReflexes必需的依赖库。",
    HR_MISSING_LIBS_DONTSHOWAGAIN = "Don't show again",
    -- Menu
    HR_MENU_GENERAL = "通用",
    HR_MENU_MODULES = "模块",
    HR_MENU_EXTENSIONS = "扩展",
    HR_MENU_RESET_MESSAGE = "重置完成！某些更改可能需要/reloadui以生效。",
    HR_MENU_RELOAD = "重载界面",
    HR_MENU_RELOAD_TT = "重新加载界面",
    HR_MENU_RELOAD_HIGHLIGHT = "设置高亮为|cffff00黄色|r需要重新加载。",
    HR_MENU_TESTMODE = "切换测试模式",
    HR_MENU_TESTMODE_TT = "切换测试模式。此功能在队伍中无法使用。",
    HR_MENU_LOCKUI = "锁定界面",
    HR_MENU_LOCKUI_TT = "锁定/解锁插件界面。",
    HR_MENU_ACCOUNTWIDE = "全局设置",
    HR_MENU_ACCOUNTWIDE_TT = "如果启用，你的设置将全局保存，而不是每个角色单独保存。",
    HR_MENU_ADVANCED_SETTINGS = "高级设置",
    HR_MENU_ADVANCED_SETTINGS_TT = "允许你自定义更多高级设置。",
    HR_MENU_HORIZONTAL_POSITION = "水平位置",
    HR_MENU_HORIZONTAL_POSITION_TT = "调整水平位置。",
    HR_MENU_VERTICAL_POSITION = "垂直位置",
    HR_MENU_VERTICAL_POSITION_TT = "调整垂直位置。",
    HR_MENU_SCALE = "缩放",
    HR_MENU_SCALE_TT = "设置缩放。",
    HR_MENU_DISABLE_IN_PVP = "PvP时禁用",
    HR_MENU_DISABLE_IN_PVP_TT = "在进行PvP时禁用。",
    HR_MENU_VISIBILITY = "可见性",
    HR_MENU_VISIBILITY_TT = "设置可见性。",
    HR_MENU_LIST_WIDTH = "列表宽度",
    HR_MENU_LIST_WIDTH_TT = "设置列表宽度。",
    -- general strings
    HR_UNIT_SECONDS = "秒",

    ------------------------- MODULES -------------------------
    -- DPS
    HR_MODULES_DPS_FRIENDLYNAME = "伤害",
    HR_MODULES_DPS_DESCRIPTION = "允许你查看你的队伍的伤害统计。",
    HR_MODULES_DPS_DAMAGE = "伤害",
    HR_MODULES_DPS_DAMAGE_TOTAL = "总伤害",
    HR_MODULES_DPS_DAMAGE_MISC = "其他",
    HR_MODULES_DPS_DPS_BOSS = "Boss DPS",
    HR_MODULES_DPS_DPS_TOTAL = "总DPS",
    HR_MODULES_DPS_MENU_HEADER = "伤害列表",
    HR_MODULES_DPS_MENU_SHOW_SUMMARY = "显示汇总",
    HR_MODULES_DPS_MENU_SHOW_SUMMARY_TT = "开关伤害列表中的汇总行显示。",
    --HR_MODULES_DPS_SUMMARY_GROUP_TOTAL = "Group Total: ",
    -- EXIT INSTANCE
    HR_MODULES_EXITINSTANCE_FRIENDLYNAME = "退出副本",
    HR_MODULES_EXITINSTANCE_DESCRIPTION = "允许你向你的队伍发送退出副本请求。",
    HR_MODULES_EXITINSTANCE_BINDING_SENDEJECT = "弹出队伍",
    HR_MODULES_EXITINSTANCE_BINDING_EXITINSTANCE = "立即退出副本",
    HR_MODULES_EXITINSTANCE_COMMAND_HELP = "发送弹出副本请求。",
    HR_MODULES_EXITINSTANCE_NOT_LEADER = "你必须是队伍队长才能发送弹出副本请求！",
    HR_MODULES_EXITINSTANCE_SENDEXITINSTANCE_DIALOG_TITLE = "弹出队伍",
    HR_MODULES_EXITINSTANCE_SENDEXITINSTANCE_DIALOG_TEXT = "你是否想让所有人离开副本（包括你自己）？",
    HR_MODULES_EXITINSTANCE_EXITINSTANCE_DIALOG_TITLE = "退出副本",
    HR_MODULES_EXITINSTANCE_EXITINSTANCE_DIALOG_TEXT = "你是否想立即退出副本？",
    HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT = "确认退出",
    HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT_TT = "如果启用，你将在退出副本前被询问确认。",
    HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS = "忽略请求",
    HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS_TT = "如果启用，你将忽略所有来自队伍队长的退出副本请求。",
    -- HIDEME
    HR_MODULES_HIDEME_FRIENDLYNAME = "将我隐藏",
    HR_MODULES_HIDEME_DESCRIPTION = "允许你从其他队伍成员列表中隐藏一些你的统计数据。",
    HR_MODULES_HIDEME_HIDEDAMAGE_LABEL = "隐藏伤害",
    HR_MODULES_HIDEME_HIDEDAMAGE_DESCRIPTION = "从其他队伍成员的DPS列表中隐藏你的伤害数字。",
    HR_MODULES_HIDEME_HIDEHORN_LABEL = "隐藏号角",
    HR_MODULES_HIDEME_HIDEHORN_DESCRIPTION = "从列表中隐藏你的号角。",
    HR_MODULES_HIDEME_HIDECOLOS_LABEL = "隐藏死灵巨像",
    HR_MODULES_HIDEME_HIDECOLOS_DESCRIPTION = "从列表中隐藏你的死灵巨像。",
    HR_MODULES_HIDEME_HIDEATRO_LABEL = "隐藏石头人",
    HR_MODULES_HIDEME_HIDEATRO_DESCRIPTION = "从列表中隐藏你的石头人。",
    HR_MODULES_HIDEME_HIDESAXHLEEL_LABEL = "隐藏Sax",
    HR_MODULES_HIDEME_HIDESAXHLEEL_DESCRIPTION = "从列表中隐藏你的Sax。",
    --HR_MODULES_HIDEME_HIDEBARRIER_LABEL = "Hide Barrier",
    --HR_MODULES_HIDEME_HIDEBARRIER_DESCRIPTION = "Hide your barrier from the lists.",
    HR_MODULES_HIDEME_MENU_HEADER = "将我隐藏选项",
    -- PULL
    HR_MODULES_PULL_FRIENDLYNAME = "开战倒计时",
    HR_MODULES_PULL_DESCRIPTION = "允许你向你的队伍发送开战倒计时。",
    HR_MODULES_PULL_BINDING_COUNTDOWN = "开战倒计时",
    HR_MODULES_PULL_COUNTDOWN_DURATION = "倒计时持续时间",
    HR_MODULES_PULL_COUNTDOWN_DURATION_TT = "设置开战倒计时持续时间。",
    HR_MODULES_PULL_NOT_LEADER = "你必须是队伍队长才能发送开战倒计时！",
    HR_MODULES_PULL_COMMAND_HELP = "发送开战倒计时。",
    -- READYCHECK
    HR_MODULES_READYCHECK_FRIENDLYNAME = "准备状态检查",
    HR_MODULES_READYCHECK_DESCRIPTION = "增强版准备状态检查，显示谁投了什么状态。",
    HR_MODULES_READYCHECK_TITLE = "准备状态检查",
    HR_MODULES_READYCHECK_READY = "准备",
    HR_MODULES_READYCHECK_NOT_READY = "未准备",
    --HR_MODULES_READYCHECK_MENU_UI = "show ui",
    --HR_MODULES_READYCHECK_MENU_UI_TT = "Displays the readycheck window with the results.",
    HR_MODULES_READYCHECK_MENU_CHAT = "输出至聊天栏",
    HR_MODULES_READYCHECK_MENU_CHAT_TT = "打印准备状态检查结果到聊天栏。",
    -- SKILL LINES
    HR_MODULES_SKILLLINES_FRIENDLYNAME = "技能线",
    HR_MODULES_SKILLLINES_DESCRIPTION = "允许你查看你的队伍成员使用的子类技能线。",
    -- ULT
    HR_MODULES_ULT_FRIENDLYNAME = "终极",
    HR_MODULES_ULT_DESCRIPTION = "允许你查看你的队伍成员的终极点数。",

    ------------------------- EXTENSIONS -------------------------
    -- ANIMATIONS
    HR_EXTENSIONS_ANIMATIONS_FRIENDLYNAME = "动画",
    HR_EXTENSIONS_ANIMATIONS_DESCRIPTION = "通过LibCustomIcons为你的列表提供动态图片支持。",
    -- ICONS
    HR_EXTENSIONS_ICONS_FRIENDLYNAME = "图标",
    HR_EXTENSIONS_ICONS_DESCRIPTION = "通过LibCustomIcons为你的列表提供静态图片支持。",
    -- NAMES
    HR_EXTENSIONS_NAMES_FRIENDLYNAME = "昵称",
    HR_EXTENSIONS_NAMES_DESCRIPTION = "通过LibCustomNames为你的列表提供自定义昵称支持。",
    -- SEASONS
    HR_EXTENSIONS_SEASONS_FRIENDLYNAME = "节日彩蛋",
    HR_EXTENSIONS_SEASONS_DESCRIPTION = "在特定节日改变插件的一些行为。",
    -- CONFIGURATOR
    HR_EXTENSIONS_CONFIGURATOR_FRIENDLYNAME = "编辑器",
    HR_EXTENSIONS_CONFIGURATOR_DESCRIPTION = "允许你使用简单的编辑器来生成自定义名称/图标。",
    HR_MENU_ICONS_SECTION_CUSTOM = "自定义名称&图标",
    HR_MENU_ICONS_NOLIBSINSTALLED = "为了获得完整的HodorReflexes体验，请确保以下库已安装：\n\n - |cFFFF00LibCustomIcons|r – 启用个性化图标。\n - |cFFFF00LibCustomNames|r – 显示自定义昵称。\n\n这些库增强了视觉效果，并允许更多的个性化定制内容，但它们不是必需的。你完全可以按照自己的意愿选择是否安装它们。",
    HR_MENU_ICONS_README_1 = "在开始之前，请仔细阅读此指南！这能帮助你你获得你想要的结果。\n",
    HR_MENU_ICONS_HEADER_ICONS = "图标 & 动画 – 需求:",
    HR_MENU_ICONS_README_2 = "请遵循以下格式要求：\n\n- 最大尺寸: 32×32像素\n- 动画: 最多50帧\n- 接受的文件格式: .dds, .jpg, .png, .gif, .webp\n",
    HR_MENU_ICONS_HEADER_TIERS = "捐赠等级:",
    HR_MENU_ICONS_README_3 = "有三个捐赠等级，每个等级都有不同的回馈：\n\n1. 5M 金币 – 自定义名称\n2. 7M 金币 – 自定义名称 + 静态图标\n3. 10M 金币 – 自定义名称 + 静态图标 + 动态图标\n\n你可以使用下面的滑块来选择你想要的等级，采用1–3哪个等级完全取决于你。\n",
    HR_MENU_ICONS_HEADER_CUSTOMIZE = "自定义你的名称：",
    HR_MENU_ICONS_README_4 = "使用下面的编辑器来自定义你的名称。\n",
    HR_MENU_ICONS_HEADER_TICKET = "在Discord创建支持单",
    HR_MENU_ICONS_README_5 = "1. 点击包含生成的LUA代码的文本框。\n2. 按CTRL+A选择全部。\n3. 按CTRL+C复制内容。",
    HR_MENU_ICONS_README_6 = "\n接下来，在Discord服务器上创建一个支持单 – 选择你的捐赠等级 – 并将代码和图标粘贴到支持单中。",
    HR_MENU_ICONS_HEADER_DONATION = "发送捐赠：",
    HR_MENU_ICONS_README_7 = "一旦你在Discord上创建了支持单:\n\n1. 点击 \"%s\" 按钮。\n2. 在ticket-XXXXX字段中输入你的单据编号。\n3. 根据你选择的捐赠等级发送金币。",
    HR_MENU_ICONS_HEADER_INFO = "信息：",
    HR_MENU_ICONS_INFO = "- 这是一个基于捐赠的服务。\n- 你并非在购买图标，也不会获取其所有权。\n- 这是一个意在回馈你的捐赠的自定义视觉效果，其有效范围仅限于使用了LibCustomNames和LibCustomIcons的玩家。\n- 你需要遵守ZoS的ToS - 使用包含粗俗词汇的名称或不适当的图标将会被拒绝！\n- 如果你知道如何编写代码，你总是可以在github上发送PR，这个方式无需任何捐赠。",
    HR_MENU_ICONS_CONFIGURATOR_DISCORD = "加入Discord",
    HR_MENU_ICONS_CONFIGURATOR_DISCORD_TT = "假如 HodorReflexes的Discord来创建一个支持单。",
    HR_MENU_ICONS_README_DONATION_TIER = "捐赠等级: ",
    HR_MENU_ICONS_README_DONATION_TIER_TT = "改变捐赠等级时，LUA代码会自行匹配你的等级并生成对应的代码",
    HR_MENU_ICONS_CONFIGURATOR_LUA_TT = "点击文本框并按下Ctrl+A来选中所有代码，然后按下Ctrl+C来复制它们到剪贴板。",
    HR_MENU_ICONS_CONFIGURATOR_DONATE_TT = "打开邮件窗口并输入文本。",
}

for id, val in pairs(strings) do
   ZO_CreateStringId(id, val)
   SafeAddVersion(id, 1)
end