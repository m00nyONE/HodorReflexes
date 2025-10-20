## HodorReflexes Themes

# 1. prerequisites:
- ALWAYS check if the theme extension is installed and activated in HodorReflexes.
  ```LUA
    if not HodorReflexes or not HodorReflexes.extensions or not HodorReflexes.themes:IsEnabled() then
        d("HodorReflexes theme support disabled or HodorReflexes not installed.")
        return
    end
  ```
- Make sure you understand the basics of ZO_ScrollLists as all themable Lists are based on them.
  - [ZO_ScrollList API Documentation](https://wiki.esoui.com/ZO_ScrollList)
- DO NEVER modify the original list itself or you will break other themes and/or the default one. 
- The .list object inside your theme object is only there to give you a read-only access to the original list, it's savedVariables and settings that you can use in your theme.
- If you feel the desperate need to modify something in the original list for your theme to work, you are doing something wrong. Contact me on Discord and we will find a better solution together.
