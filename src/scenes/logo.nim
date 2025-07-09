var
    sceneBaseDuration = 4.0
    sceneDuration = sceneBaseDuration
    fadeDuration = sceneDuration / 2.0

proc drawLogoScene() =
    clearBackground(MENU_BG_COLOR)
    if sceneDuration == sceneBaseDuration: sceneDuration += getTime()
    let currentTime = getTime()

    if currentTime >= sceneDuration or isMouseButtonPressed(LEFT):
        for logo in logos.mitems:
            logo.texture = Texture2D()
        guiSetStyle(Default, TextSize, 16)
        CURRENT_SCENE = MENU
        return

    let fadeInAlpha  = clamp(currentTime / fadeDuration, 0.0, 1.0)
    let fadeOutAlpha = clamp((sceneDuration - currentTime) / fadeDuration, 0.0, 1.0)
    let alpha = min(fadeInAlpha, fadeOutAlpha)

    let tint = Color(r: 255, g: 255, b: 255, a: uint8(alpha * 255))

    let
        maxWidth = logos.mapIt(it.texture.width).max
        maxHeight = logos.mapIt(it.texture.height).max
        totalWidth = maxWidth * logos.len
        startX = (getScreenWidth() - totalWidth) div 2

    let
        madeWithText = translations[LANGUAGE].madewith
        madeWithTextSize = 16.0
        madeWithSize = measureText(MENU_FONT, madeWithText, madeWithTextSize, 0)
        madeWithPos = Vector2(
            x: getScreenWidth().float / 2 - madeWithSize.x / 2,
            y: getScreenHeight().float - maxHeight.float - madeWithSize.y
        )

    drawText(MENU_FONT, madeWithText, madeWithPos, madeWithTextSize, 0, tint)

    for i, item in logos.mpairs:
        let x = startX + i * maxWidth
        if item.texture.id == 0:
            item.texture = loadTextureFromImage(loadImageFromMemory(".png", item.raw))
        drawTexture(item.texture, x.int32, getScreenHeight() - maxHeight, tint)