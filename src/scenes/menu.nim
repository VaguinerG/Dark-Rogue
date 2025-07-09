proc drawMenuScreen() =
    clearBackground(MENU_BG_COLOR)
    let playButtonRectangle = Rectangle(
        x: WINDOW_CENTER.x.float,
        y: WINDOW_CENTER.y.float,
        width: 50,
        height: 50
    )
    if button(playButtonRectangle, translations[LANGUAGE].play):
        CURRENT_SCENE = CHAR_SELECTION