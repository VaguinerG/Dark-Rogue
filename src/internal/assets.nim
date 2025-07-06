proc loadSystemFont() =
    if SYSTEM_FONTS.len > 0:
        try:
            let fontData = readFile(SYSTEM_FONTS[0])
            let fontBytes = cast[seq[uint8]](fontData)
            let extension = splitFile(SYSTEM_FONTS[0]).ext
            MENU_FONT = loadFontFromMemory(extension, fontBytes, 64, 0)
        except:
            discard

proc loadLogoImages() =
    NIM_LOGO = loadTextureFromImage(loadImageFromMemory(".png", NIM_LOGO_BYTES))
    RAYLIB_LOGO = loadTextureFromImage(loadImageFromMemory(".png", RAYLIB_LOGO_BYTES))

proc initAssets() =
    loadSystemFont()
    loadLogoImages()