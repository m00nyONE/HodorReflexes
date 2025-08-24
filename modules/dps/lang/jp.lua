-- TODO: UNFINISHED TRANSLATION

local strings = {
    HR_DAMAGE = "ダメージ",
    HR_TOTAL_DAMAGE = "総ダメージ",
    HR_MISC_DAMAGE = "その他",
    HR_BOSS_DPS = "ボスDPS",
    HR_TOTAL_DPS = "総DPS",

    HR_MENU_DAMAGE_SHOW = "ダメージ表示:",
    HR_MENU_DAMAGE_SHOW_TT = "グループダメージのリストを表示します。",
    --HR_MENU_DAMAGE_SHOW_NEVER = "Never",
    --HR_MENU_DAMAGE_SHOW_ALWAYS = "Always",
    --HR_MENU_DAMAGE_SHOW_OUT = "Out of combat",
    --HR_MENU_DAMAGE_SHOW_NONBOSS = "Non-boss fight",

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
    HR_MENU_ICONS_VISIBILITY_COLORS = "カラーネーム",
    HR_MENU_ICONS_VISIBILITY_COLORS_TT = "他プレイヤーのカラーネームを表示します。",
    HR_MENU_ICONS_VISIBILITY_DPS = "ダメージ",
    HR_MENU_ICONS_VISIBILITY_DPS_TT = "マイアイコンをダメージリストに表示します。",

    HR_TEST_STARTED = "テスト開始",
    HR_TEST_STOPPED = "テスト停止",
    HR_TEST_LEAVE_GROUP = "テストにはグループから抜ける必要があります。",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end