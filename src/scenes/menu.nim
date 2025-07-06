proc drawMenuScreen() =
    let playButtonRectangle = Rectangle(
        x: WINDOW_CENTER.x.float,
        y: WINDOW_CENTER.y.float,
        width: 50,
        height: 50
    )
    if button(playButtonRectangle, "Play"):
        GAME_SCENE = CHAR_SELECTION