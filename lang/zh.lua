local strings = {

	-------------------------
	-- MENUS
	-------------------------

	HR_MENU_GENERAL = "常规",
	HR_MENU_GENERAL_ENABLED = "启用",
	HR_MENU_GENERAL_ENABLED_TT = "启用/禁用 这个插件. 当禁用时，这个插件不会显示其他玩家的地图标记.",
	HR_MENU_GENERAL_UI_LOCKED = "UI锁定",
	HR_MENU_GENERAL_UI_LOCKED_TT = "解锁UI来显示所有可用的控制选项. 如果你没有在队伍里, 那你可以在聊天框内输入\n |cFFFF00/hodor.share test|r 来显示测试数据.",
	HR_MENU_GENERAL_ACCOUNT_WIDE = "账号共享设置",
	HR_MENU_GENERAL_ACCOUNT_WIDE_TT = "在全局设置和角色设置切换.",
	HR_MENU_GENERAL_DISABLE_PVP = "PvP时禁用",
	HR_MENU_GENERAL_DISABLE_PVP_TT = "在PvP 区域禁用.",
	HR_MENU_GENERAL_EXIT_INSTANCE = "离开区域时确认",
	HR_MENU_GENERAL_EXIT_INSTANCE_TT = "在使用热键或者队长要求下离开当前区域时需要确认",

	HR_MENU_DAMAGE = "伤害",
	HR_MENU_DAMAGE_SHOW = "显示伤害:",
	HR_MENU_DAMAGE_SHOW_TT = "显示团队伤害列表.",
	HR_MENU_DAMAGE_SHOW_NEVER = "永不",
	HR_MENU_DAMAGE_SHOW_ALWAYS = "总是",
	HR_MENU_DAMAGE_SHOW_OUT = "脱战时",
	HR_MENU_DAMAGE_SHOW_NONBOSS = "非头目战斗",
	HR_MENU_DAMAGE_SHARE = "分享DPS:",
	HR_MENU_DAMAGE_SHARE_TT = "分享你的伤害给队友.",

	HR_MENU_HORN = "战争号角",
	HR_MENU_HORN_SHOW = "显示战争号角:",
	HR_MENU_HORN_SHOW_TT = "显示团队终极技能.",
	HR_MENU_HORN_SHARE = "分享终极技能:",
	HR_MENU_HORN_SHARE_TT = "分享你的终极技能百分比％给队友. 当您装备有撒西勒冠军时，您不需要在装备战争号角。插件会分享您消耗最高的终极技能，或者以250点技能点为基准。",
	HR_MENU_HORN_SHARE_NONE = "禁用",
	HR_MENU_HORN_SHARE_HORN = "战争号角",
	HR_MENU_HORN_SHARE_SAXHLEEL1 = "号角或撒西勒冠军(消耗最高的)",
	HR_MENU_HORN_SHARE_SAXHLEEL250 = "号角或撒西勒冠军(250点技能点)",
	HR_MENU_HORN_SELFISH = "自私模式:",
	HR_MENU_HORN_SELFISH_TT = "当启用时，你只会看到自己身上的号角增益效果持续时间",
	HR_MENU_HORN_ICON = "显示图标:",
	HR_MENU_HORN_ICON_TT = "显示一个包含20米范围内队友数量的图标。\n图标会变成 |c00FF00green|r 当所有的DD都在范围内。\n绿色图标会变为|cFFFF00yellow|r 如果有人在号角名单排在您上面。请宣布您要吹号角了！",
	HR_MENU_HORN_COUNTDOWN_TYPE = "倒计时类型:",
	HR_MENU_HORN_COUNTDOWN_TYPE_TT = "- 无：没有倒计时。\n- 自己：只对自己的号角/重大力量进行倒计时。\n- 全部：对所有人的号角/重大力量进行倒计时(队长模式).",
	HR_MENU_HORN_COUNTDOWN_TYPE_NONE = "无",
	HR_MENU_HORN_COUNTDOWN_TYPE_SELF = "战阵号角(自己)",
	HR_MENU_HORN_COUNTDOWN_TYPE_ALL = "战争号角(全部)",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_SELF = "重大力量 (自己)",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_ALL = "重大力量 (全部)",
	HR_MENU_HORN_COUNTDOWN_COLOR = "倒计时文本颜色:",

	HR_MENU_COLOS = "死灵巨像",
	HR_MENU_COLOS_SHOW = "显示死灵巨像:",
	HR_MENU_COLOS_SHOW_TT = "显示于团队终极技能列表",
	HR_MENU_COLOS_SHARE = "分享终极技能:",
	HR_MENU_COLOS_SHARE_TT = "分享你的终极技能百分比％给队友(只有当您装备有死灵巨像时).",
	HR_MENU_COLOS_PRIORITY = "优先级:",
	HR_MENU_COLOS_PRIORITY_TT = "-默认: 最大终极技能百分比是 200.\n- 坦克:发送201％如果您的死灵巨像准备就绪。\n- 总是: 发送201％当您的终极技能准备就绪时。\n- 永不:发送99％或者更少。\n|cFFFFFFNOTE: 发送 99%或者201%而不是100%也会影响您的号角百分比%如果您正在分享两个技能.|r",
	HR_MENU_COLOS_PRIORITY_DEFAULT = "默认",
	HR_MENU_COLOS_PRIORITY_TANK = "坦克",
	HR_MENU_COLOS_PRIORITY_ALWAYS = "总是",
	HR_MENU_COLOS_PRIORITY_NEVER = "从不",
	HR_MENU_COLOS_SUPPORT_RANGE = "只显示附近队友:",
	HR_MENU_COLOS_SUPPORT_RANGE_TT = "离你过远的玩家将不会出现在名单内",
	HR_MENU_COLOS_COUNTDOWN = "显示倒计时:",
	HR_MENU_COLOS_COUNTDOWN_TT = "显示一个倒计时来确认您使用终极技能的时间",
	HR_MENU_COLOS_COUNTDOWN_TEXT = "倒计时文本:",
	HR_MENU_COLOS_COUNTDOWN_COLOR = "倒计时文本颜色:",

	HR_MENU_MISC = "杂项",
	HR_MENU_MISC_DESC = "显示测试队友在对话框中输入|c999999/hodor.share test|r 。\n你同时可以通过输入名字来选择你的队友:\n|c999999/hodor.share test @andy.s @Alcast|r",

	HR_MENU_ICONS = "图标",
	HR_MENU_ICONS_README = "阅读说明 (点击以打开)",
	HR_MENU_ICONS_MY = "我的图标",
	HR_MENU_ICONS_NAME_VAL = "自定义名字",
	HR_MENU_ICONS_NAME_VAL_TT = "插件默认会使用您的ID，在这里可自定义您的名字.",
	HR_MENU_ICONS_GRADIENT = "Gradient",
	HR_MENU_ICONS_GRADIENT_TT = "在下面的颜色基础上创建梯度渐变",
	HR_MENU_ICONS_COLOR1 = "开始的颜色",
	HR_MENU_ICONS_COLOR2 = "结束的颜色",
	HR_MENU_ICONS_PREVIEW = "预览",
	HR_MENU_ICONS_LUA = "LUA代码:",
	HR_MENU_ICONS_LUA_TT = "当你修改图标路径时，你可能需要重新启动游戏（不仅仅是/reloadui）。把这段代码和你的图标文件一起发给插件的作者.",
	HR_MENU_ICONS_VISIBILITY = "亮度",
	HR_MENU_ICONS_VISIBILITY_HORN = "战争号角图标",
	HR_MENU_ICONS_VISIBILITY_HORN_TT = "显示自定义图标于号角分享列表.",
	HR_MENU_ICONS_VISIBILITY_DPS = "伤害图标",
	HR_MENU_ICONS_VISIBILITY_DPS_TT = "显示自定义图标于DPS分享列表.",
	HR_MENU_ICONS_VISIBILITY_COLOS = "死灵巨像图标",
	HR_MENU_ICONS_VISIBILITY_COLOS_TT = "在死灵巨像列表里显示玩家自定义图标",
	HR_MENU_ICONS_VISIBILITY_COLORS = "彩色名字",
	HR_MENU_ICONS_VISIBILITY_COLORS_TT = "显示其他队友的彩色名字.",
	HR_MENU_ICONS_VISIBILITY_ANIM = "动画帧数",
	HR_MENU_ICONS_VISIBILITY_ANIM_TT = "播放动画图标. 注意: 关闭此选项并不会增加您的帧数.",

	HR_MENU_ICONS_README1 = "使用下面的设置来自定义您的名字于图标。这只是预览，其他人无法看见，您需要将LUA代码发送给插件作者",
	HR_MENU_ICONS_README2 = "游戏支支持DirectDraw Surface文件格式的图片，并且图片只能32*32像素的。您可以跳过这部分如果您觉得听起来太过复杂。只需要将原图和LUA代码一起发送即可.",
	HR_MENU_ICONS_README3 = "点击此页面顶部的\"%s\"来获取更多的个性化图标细节。请注意，如果您只在游戏邮箱内进行金币捐赠是不会获得任何回应的！",

	HR_MENU_STYLE = "风格",
	HR_MENU_STYLE_PINS = "显示地图图标",
	HR_MENU_STYLE_PINS_TT = "显示玩家图标与世界地图和罗盘。",
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
	HR_MENU_STYLE_HORN_COLOR = "战争号角持续时间颜色",
	HR_MENU_STYLE_FORCE_COLOR = "重大力量持续时间颜色",
	HR_MENU_STYLE_COLOS_COLOR = "死灵巨像持续时间颜色",
	HR_MENU_STYLE_TIMER_OPACITY = "到期计时器颜色",
	HR_MENU_STYLE_TIMER_OPACITY_TT = "当计时器归零是文本和图标的不透明度(0.0).",
	HR_MENU_STYLE_TIMER_BLINK = "闪烁计时器",
	HR_MENU_STYLE_TIMER_BLINK_TT = "计时器归零时会先闪烁，然后应用不透明度。.",

	HR_MENU_ANIMATIONS = "消息动画",
	HR_MENU_ANIMATIONS_TT = "让巨像和号角倒计时动画化让人更容易注意到.",

	HR_MENU_VOTE = "投票",
	HR_MENU_VOTE_DISABLED = "此功能需要启用Hodor Reflexes！",
	HR_MENU_VOTE_DESC = "此功能可以增强默认的准备确认，可以让您看到启用了Hodor Reflexes的队友谁准备好了。",
	HR_MENU_VOTE_ENABLED_TT = "启用/禁用此功能，当禁用此功能时，其他队友将无法看到您的投票.",
	HR_MENU_VOTE_CHAT = "聊天框消息",
	HR_MENU_VOTE_CHAT_TT = "将投票结果和其他消息显示于聊天框",
	HR_MENU_VOTE_ACTIONS = "动作",
	HR_MENU_VOTE_ACTIONS_RC = "准备确认",
	HR_MENU_VOTE_ACTIONS_RC_TT = "发起准备确认投票",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN = "倒计时",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_TT = "以上述规定的时间开始倒计时。你必须是队长才能使用此功能。",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM = "你必须是队长才能使用发起倒计时！",
	HR_MENU_VOTE_ACTIONS_LEADER = "变更队长",
	HR_MENU_VOTE_ACTIONS_LEADER_TT = "需要60%的队员同意.",
	HR_MENU_VOTE_ACTIONS_LEADER_CONFIRM = "队长变更为",
    HR_MENU_VOTE_COUNTDOWN_DURATION = "倒计时长度",

	HR_MENU_MISC_TOXIC = "恶毒模式",
	HR_MENU_MISC_TOXIC_TT = "嘲笑与讽刺等等",

	-------------------------
	-- BINDINGS
	-------------------------

	HR_BINDING_HORN_SHARE = "Toggle War Horn Share",
	HR_BINDING_COLOS_SHARE = "Toggle Colossus Share",
	HR_BINDING_DPS_SHARE = "Toggle Damage Share",
	HR_BINDING_COUNTDOWN = "倒计时",
	HR_BINDING_EXIT_INSTANCE = "立即离开",
	HR_BINDING_SEND_EXIT_INSTANCE = "解散团队",

	-------------------------
	-- SHARE MODULE
	-------------------------

	HR_SEND_EXIT_INSTANCE = "解散队伍",
	HR_SEND_EXIT_INSTANCE_CONFIRM = "你确定要让所有人都离开队伍吗（包括你自己）？",

	HR_COLOS_COUNTDOWN_DEFAULT_TEXT = "终极技能",
	HR_MAJOR_FORCE = "重大力量",
	HR_HORN = "战争号角",
	HR_COLOS = "死灵巨像",

	-- Damage list title
	HR_DAMAGE = "伤害",
	HR_TOTAL_DAMAGE = "总伤害",
	HR_MISC_DAMAGE = "杂项",
	HR_BOSS_DPS = "头目DPS",
	HR_TOTAL_DPS = "总DPS",

	HR_NOW = "就是现在", -- HORN/COLOS: NOW!

	HR_TEST_STARTED = "测试开始",
	HR_TEST_STOPPED = "测试结束",
	HR_TEST_LEAVE_GROUP = "您必须脱离后才能进行测试",

	-------------------------
	-- VOTE MODULE
	-------------------------

	HR_READY_CHECK = "准备确认",
	HR_READY_CHECK_READY = "所有人都准备就绪！",
	HR_COUNTDOWN = "倒计时",
	HR_COUNTDOWN_START = "开始于",
	HR_READY_CHECK_INIT_CHAT = "启动准备确认",
	HR_COUNTDOWN_INIT_CHAT = "启动倒计时",
	HR_VOTE_NOT_READY_CHAT = "还没准备好",
	HR_VOTE_LEADER_CHAT = "想改变队长",

	-------------------------
	-- MOCK
	-------------------------

	HR_MOCK1 = "这么多插件装了还会死，呵呵呵。",
    HR_MOCK2 = "你还是去穿强大的楚单，瘟疫医生和养蜂人吧！",
    HR_MOCK3 = "你又要怪ZOS的土豆服务器啦？",
	HR_MOCK4 = "很显然，你这是一个糟糕的例子。",
	HR_MOCK5 = "你要不要还是去玩坦奶把。",
	HR_MOCK6 = "插件的提示都没看到？",
	HR_MOCK7 = "你是最薄弱的那一环，再见！",
	HR_MOCK8 = "买金车也许更适合你。",
	HR_MOCK9 = "也许你应该把壁垒加入你的技能循环里。",
	HR_MOCK10 = "我们已经没有提示可以阻止你的死亡了。",
	HR_MOCK11 = "你要是想要让自己对这游戏有用点，还是去皇冠商店消费吧。",
	HR_MOCK12 = "这游戏这么多BUG已经够糟糕了，没想到你居然更差。",
	HR_MOCK13 = "你真的很擅长干出各种蠢事。",
	HR_MOCK14 = "试试看装更多的插件来帮你吧。",
	HR_MOCK15 = "你的手速不适合打这个游戏。",
	HR_MOCK16 = "没事兄弟，以后皇冠商城会提供买成就服务。",
	HR_MOCK17 = "精神错乱的定义就是不停的重复同样的事却希望得到不同的结果",
	HR_MOCK18 = "在PvE模式里你应该在那些怪物打死你之前杀死他们",
	HR_MOCK19 = "你有没有想过多买点人寿保险？",
	HR_MOCK20 = "我打过的小泥蟹都比你更可怕。",
	HR_MOCK_AA1 = "试想一下居然有人会死在了六年前制作的副本里",
	HR_MOCK_EU1 = "你为什么在玩欧服？",
	HR_MOCK_NORMAL1 = "这甚至都不是精英难度...",
	HR_MOCK_VET1 = "您还是把难度改成普通吧。",

	-------------------------
	-- Exit Instance
	-------------------------

	HR_EXIT_INSTANCE = "离开当前区域",
	HR_EXIT_INSTANCE_CONFIRM = "你是否想离开当前区域？",
	
	-------------------------
	-- Updated window
	-------------------------

	HR_UPDATED_TEXT = "Hodor Reflexes已成功更新。但也许没有？ 不幸的是，在通过Minion进行更新时，有些文件有会消失。通常情况下，它们只是图标。 因此，这里有一个来自不同插件文件夹的五个图标的小测试。如果你没有看到所有的图片，那么你应该关闭游戏并重新安装附加组件。否则，就忽略这条信息吧，它不会再出现了。",
	HR_UPDATED_DISMISS = "我能看见五个图标!",

	HR_MISSING_ICON = "无法加载您Hodor Reflexes的图标。重新安装此插件或通过esoui.com手动下载并重新启动游戏。.",

}

for id, val in pairs(strings) do
   ZO_CreateStringId(id, val)
   SafeAddVersion(id, 1)
end