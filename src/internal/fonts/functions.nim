proc loadSystemFont() =
    if SYSTEM_FONTS.len > 0:
        try:
            let fontData = readFile(SYSTEM_FONTS[0])
            let fontBytes = cast[seq[uint8]](fontData)
            let extension = splitFile(SYSTEM_FONTS[0]).ext
            MENU_FONT = loadFontFromMemory(extension, fontBytes, 64, 0)
        except:
            discard