-- Japanese translation by @naechan

local strings = {

	-------------------------
	-- MENUS
	-------------------------

	HR_MENU_GENERAL = "一般",
	HR_MENU_GENERAL_ENABLED = "有効化",
	HR_MENU_GENERAL_ENABLED_TT = "アドオンの有効/無効。 無効にすると他プレイヤーからのマップピンを処理せずミュートします。",
	HR_MENU_GENERAL_UI_LOCKED = "UIロック",
	HR_MENU_GENERAL_UI_LOCKED_TT = "UIのロックを解除します。",
	HR_MENU_GENERAL_ACCOUNT_WIDE = "アカウント共通設定",
	HR_MENU_GENERAL_ACCOUNT_WIDE_TT = "設定をアカウント全体とキャラクターごとで切り替えます。",
	HR_MENU_GENERAL_DISABLE_PVP = "PvPエリアでの無効化",
	HR_MENU_GENERAL_DISABLE_PVP_TT = "PvPエリアでアドオンを無効にします。",

	HR_MENU_DAMAGE = "ダメージ",
	HR_MENU_DAMAGE_SHOW = "ダメージ表示:",
	HR_MENU_DAMAGE_SHOW_TT = "グループダメージのリストを表示します。",
	HR_MENU_DAMAGE_SHARE = "DPS共有:",
	HR_MENU_DAMAGE_SHARE_TT = "グループメンバーへダメージを送信します。",

	HR_MENU_HORN = "角笛",
	HR_MENU_HORN_SHOW = "角笛の表示:",
	HR_MENU_HORN_SHOW_TT = "グループのアルティメットのリストを表示します。",
	HR_MENU_HORN_SHARE = "アルティメット共有:",
	HR_MENU_HORN_SELFISH = "自己モード:",
	HR_MENU_HORN_SELFISH_TT = "有効にすると、バフの効果がある時のみ角笛の残り時間を表示します。",
	HR_MENU_HORN_ICON = "アイコン表示:",
	HR_MENU_HORN_ICON_TT = "角笛の使用可能時に、20m以内にいるメンバーの人数を表示します。\nアイコンは全DPSが範囲内にいるときは |c00FF00緑|r で表示されます。\nまた角笛リストの上位に他の人がいる場合は |cFFFF00黄色|r になります。 掛け声をしてね！",
	HR_MENU_HORN_COUNTDOWN_TYPE = "カウントダウンタイプ:",
	HR_MENU_HORN_COUNTDOWN_TYPE_TT = "- なし: カウントダウンしない。\n- 自己: 自身のバフだけカウントダウンします。\n- 全員: 全員のバフをカウントダウンします。",
	HR_MENU_HORN_COUNTDOWN_TYPE_NONE = "なし",
	HR_MENU_HORN_COUNTDOWN_TYPE_SELF = "角笛（自己）",
	HR_MENU_HORN_COUNTDOWN_TYPE_ALL = "角笛（全員）",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_SELF = "威力(強) （自己）",
	HR_MENU_HORN_COUNTDOWN_TYPE_FORCE_ALL = "威力(強) （全員）",
	HR_MENU_HORN_COUNTDOWN_COLOR = "カウントダウンの色:",

	HR_MENU_COLOS = "巨像",
	HR_MENU_COLOS_SHOW = "巨像の表示:",
	HR_MENU_COLOS_SHOW_TT = "グループのアルティメットのリストを表示します。",
	HR_MENU_COLOS_SHARE = "アルティメット共有:",
	HR_MENU_COLOS_SHARE_TT = "グループメンバーへアルティメットの％を送信する。（巨像をセット時のみ）",
	HR_MENU_COLOS_PRIORITY = "優先度:",
	HR_MENU_COLOS_PRIORITY_TT = "- デフォルト: 最大200％\n- タンク: ロールがタンクで巨像使用可能なとき201％で送信します。\n- 常時: 巨像が使用可能なとき201％で送信します。\n- なし: 99％かそれ以下で送信します。\n|cFFFFFF注: 角笛と巨像を両方共有している場合、99％や201％での送信は角笛の％にも影響します。|r",
	HR_MENU_COLOS_PRIORITY_DEFAULT = "デフォルト",
	HR_MENU_COLOS_PRIORITY_TANK = "タンク",
	HR_MENU_COLOS_PRIORITY_ALWAYS = "常時",
	HR_MENU_COLOS_PRIORITY_NEVER = "なし",
	HR_MENU_COLOS_SUPPORT_RANGE = "近くの味方のみ表示:",
	HR_MENU_COLOS_SUPPORT_RANGE_TT = "遠くにいるプレイヤーはリストに表示されません。",
	HR_MENU_COLOS_COUNTDOWN = "カウントダウン表示:",
	HR_MENU_COLOS_COUNTDOWN_TT = "カウントダウンの通知を表示します。",
	HR_MENU_COLOS_COUNTDOWN_TEXT = "カウントダウンテキスト:",
	HR_MENU_COLOS_COUNTDOWN_COLOR = "カウントダウンの色:",

	HR_MENU_MISC = "その他",
	HR_MENU_MISC_DESC = "サンプルリストの表示/非表示はチャット欄に |c999999/hodor.share test|r と入力します。\n名前を入力することで表示するプレイヤーを選ぶこともできます。\n|c999999/hodor.share test @andy.s @Alcast|r",

	HR_MENU_ICONS = "アイコン",
	HR_MENU_ICONS_README = "最初に読んでね (クリックで展開)",
	HR_MENU_ICONS_MY = "マイアイコン",
	HR_MENU_ICONS_NAME_VAL = "カスタムネーム",
	HR_MENU_ICONS_NAME_VAL_TT = "デフォルトではアカウント名を表示します。 ここでカスタムネームを設定できます。",
	HR_MENU_ICONS_GRADIENT = "Gradient",
	HR_MENU_ICONS_GRADIENT_TT = "Create gradient based on the colors below.",
	HR_MENU_ICONS_COLOR1 = "Start color",
	HR_MENU_ICONS_COLOR2 = "End color",
	HR_MENU_ICONS_PREVIEW = "プレビュー",
	HR_MENU_ICONS_LUA = "LUA code:",
	HR_MENU_ICONS_LUA_TT = "You may need to restart the game (not just /reloadui) when you modify the icon path. Send this code to the addon author alongside your icon file.",
	HR_MENU_ICONS_VISIBILITY = "表示",
	HR_MENU_ICONS_VISIBILITY_HORN = "角笛",
	HR_MENU_ICONS_VISIBILITY_HORN_TT = "マイアイコンを角笛リストに表示します。",
	HR_MENU_ICONS_VISIBILITY_DPS = "ダメージ",
	HR_MENU_ICONS_VISIBILITY_DPS_TT = "マイアイコンをダメージリストに表示します。",
	HR_MENU_ICONS_VISIBILITY_COLOS = "巨像",
	HR_MENU_ICONS_VISIBILITY_COLOS_TT = "マイアイコンを巨像リストに表示します。",
	HR_MENU_ICONS_VISIBILITY_COLORS = "カラーネーム",
	HR_MENU_ICONS_VISIBILITY_COLORS_TT = "他プレイヤーのカラーネームを表示します。",
	HR_MENU_ICONS_VISIBILITY_ANIM = "アニメーションアイコン",
	HR_MENU_ICONS_VISIBILITY_ANIM_TT = "アニメーションアイコンを有効にします。 注: 無効化してもFPSは上昇しません。",

	HR_MENU_STYLE = "スタイル",
	HR_MENU_STYLE_PINS = "マップピンの表示",
	HR_MENU_STYLE_PINS_TT = "ワールドマップとコンパスにプレイヤーのピンを表示します",
	HR_MENU_STYLE_DPS = "ダメージリスト",
	HR_MENU_STYLE_DPS_FONT = "数字フォント:",
	HR_MENU_STYLE_DPS_FONT_DEFAULT = "デフォルト",
	HR_MENU_STYLE_DPS_FONT_GAMEPAD = "ゲームパッド",
	HR_MENU_STYLE_DPS_BOSS_COLOR = "ボスダメージの色:",
	HR_MENU_STYLE_DPS_TOTAL_COLOR = "総ダメージの色:",
	HR_MENU_STYLE_DPS_HEADER_OPACITY = "ヘッダーの不透明度:",
	HR_MENU_STYLE_DPS_EVEN_OPACITY = "偶数列の不透明度:",
	HR_MENU_STYLE_DPS_ODD_OPACITY = "奇数列の不透明度:",
	HR_MENU_STYLE_DPS_HIGHLIGHT = "ハイライトの色:",
	HR_MENU_STYLE_DPS_HIGHLIGHT_TT = "選択した色でダメージリストの名前をハイライトします。 名前をハイライトしたくない場合は、不透明度を0に設定します。ハイライトされた名前は自身だけに表示されます。",

	HR_MENU_VOTE = "投票",
	HR_MENU_VOTE_DISABLED = "このモジュールには、Hodor Reflexesを有効にする必要があります！",
	HR_MENU_VOTE_DESC = "このモジュールはデフォルトの準備チェックを改善し、メンバーがHodor Reflexesを有効にしていれば誰が準備完了しているか否かをチェックできます。",
	HR_MENU_VOTE_ENABLED_TT = "モジュールの有効/無効。 無効にすると他プレイヤーはあなたの投票を見ることができません。",
	HR_MENU_VOTE_CHAT = "チャットメッセージ",
	HR_MENU_VOTE_CHAT_TT = "投票結果などをチャット欄に表示します。",
	HR_MENU_VOTE_ACTIONS = "実行",
	HR_MENU_VOTE_ACTIONS_RC = "準備チェック",
	HR_MENU_VOTE_ACTIONS_RC_TT = "準備チェックを開始します。",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN = "カウントダウン",
	--HR_MENU_VOTE_ACTIONS_COUNTDOWN_TT = "全員が準備完了後、5秒のカウントダウンを開始します。\n実行にはグループリーダーである必要があります。",
	HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM = "カウントダウンの開始にはグループリーダーである必要があります！",
	HR_MENU_VOTE_ACTIONS_LEADER = "リーダーの変更",
	HR_MENU_VOTE_ACTIONS_LEADER_TT = "メンバーの60％が賛成する必要があります。",
	HR_MENU_VOTE_ACTIONS_LEADER_CONFIRM = "グループリーダーを変更",

	-------------------------
	-- BINDINGS
	-------------------------

	HR_BINDING_HORN_SHARE = "角笛の共有（切替）",
	HR_BINDING_COLOS_SHARE = "巨像の共有（切替）",
	HR_BINDING_DPS_SHARE = "ダメージ共有（切替）",
	HR_BINDING_COUNTDOWN = "カウントダウン",

	-------------------------
	-- SHARE MODULE
	-------------------------

	HR_COLOS_COUNTDOWN_DEFAULT_TEXT = "ULT",
	HR_MAJOR_FORCE = "威力(強)",
	HR_HORN = "角笛",
	HR_COLOS = "巨像",

	-- Damage list title
	HR_DAMAGE = "ダメージ",
	HR_TOTAL_DAMAGE = "総ダメージ",
	HR_MISC_DAMAGE = "その他",
	HR_BOSS_DPS = "ボスDPS",
	HR_TOTAL_DPS = "総DPS",

	HR_NOW = "NOW", -- HORN/COLOS: NOW!

	HR_TEST_STARTED = "テスト開始",
	HR_TEST_STOPPED = "テスト停止",
	HR_TEST_LEAVE_GROUP = "テストにはグループから抜ける必要があります。",

	-------------------------
	-- VOTE MODULE
	-------------------------

	HR_READY_CHECK = "準備チェック",
	HR_READY_CHECK_READY = "全員の準備完了!",
	HR_COUNTDOWN = "カウントダウン",
	HR_COUNTDOWN_START = "開始",
	HR_READY_CHECK_INIT_CHAT = "準備チェックを開始します",
	HR_COUNTDOWN_INIT_CHAT = "カウントダウンを開始します",
	HR_VOTE_NOT_READY_CHAT = "の準備ができていません",
	HR_VOTE_LEADER_CHAT = "がリーダーの変更を要望しています",

}

for id, val in pairs(strings) do
	SafeAddString(_G[id], val, 1)
end