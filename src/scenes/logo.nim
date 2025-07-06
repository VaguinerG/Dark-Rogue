var
  sceneDuration = 4.0
  fadeDuration = sceneDuration / 2.0

proc drawLogoScene() =
    if sceneDuration == 5.0: sceneDuration += getTime()
    let currentTime = getTime()

    if currentTime >= sceneDuration or isMouseButtonPressed(LEFT):
        GAME_SCENE = MENU
        return

    let fadeInAlpha  = clamp(currentTime / fadeDuration, 0.0, 1.0)
    let fadeOutAlpha = clamp((sceneDuration - currentTime) / fadeDuration, 0.0, 1.0)
    let alpha = min(fadeInAlpha, fadeOutAlpha)

    let tint = Color(r: 255, g: 255, b: 255, a: uint8(alpha * 255))

    let logos = @[addr NIM_LOGO, addr RAYLIB_LOGO]

    let
        maxWidth = logos.mapIt(it.width).max
        maxHeight = logos.mapIt(it.height).max
        totalWidth = maxWidth * logos.len
        startX = (getScreenWidth() - totalWidth) div 2

    let
        madeWithText = "Made with Nim and Naylib"
        madeWithTextSize = 16.0
        madeWithSize = measureText(MENU_FONT, madeWithText, madeWithTextSize, 0)
        madeWithPos = Vector2(
            x: getScreenWidth().float / 2 - madeWithSize.x / 2,
            y: getScreenHeight().float - maxHeight.float - madeWithSize.y
        )
    drawText(MENU_FONT, madeWithText, madeWithPos, madeWithTextSize, 0, tint)
    for i, logo in logos.pairs:
        let x = startX + i * maxWidth
        drawTexture(logo[], x.int32, getScreenHeight() - maxHeight, tint)