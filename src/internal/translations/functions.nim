proc loadFonts() =
    let neededCodepoints = extractUniqueChars(translations)
    let additionalChars = "0123456789:"
    var allCodepoints = neededCodepoints
    
    for rune in additionalChars.runes:
        let cp = rune.int32
        if cp notin allCodepoints:
            allCodepoints.add(cp)
    
    MENU_FONT = loadFontFromMemory(".ttf", staticReadBytes("../../assets/NotoSans-Regular.ttf"), 64, allCodepoints)
    guiSetFont(MENU_FONT)