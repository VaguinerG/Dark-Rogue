proc loadFonts() =
    let neededCodepoints = extractUniqueChars(translations)
    MENU_FONT = loadFontFromMemory(".ttf", staticReadBytes("../../assets/NotoSans-Regular.ttf"), 64, neededCodepoints)
    guiSetFont(MENU_FONT)
