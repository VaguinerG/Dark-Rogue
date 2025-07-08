var
  scrollIndex: int32 = 0
  active: int32 = -1
  localeChecked = false

proc localeCheck() =
    if not localeChecked and LANGUAGE < 0:
        localeChecked = true
        for i, t in translations:
            if LOCALE.startsWith(t.locale):
                LANGUAGE = i
                CURRENT_SCENE = LOGO
                break

proc drawLanguageSelectionScene() =
    localeCheck()
    if LANGUAGE >= 0:
        return
    guiSetStyle(Default, TextSize, 32)
    guiSetStyle(Default, BackgroundColor, colorToInt(MENU_BG_COLOR))
    let bounds = Rectangle(
        x: getScreenWidth().float / 2.0 - 100, 
        y: 100, 
        width: 200, 
        height: 330
    )

    let languageList = translations.mapIt(it.language).join("\n")

    listView(bounds, languageList, scrollIndex, active)
    if active >= 0:
        LANGUAGE = active
        CURRENT_SCENE = LOGO