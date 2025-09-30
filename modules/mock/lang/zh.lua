-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
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
}

for id, val in pairs(strings) do
   ZO_CreateStringId(id, val)
   SafeAddVersion(id, 1)
end