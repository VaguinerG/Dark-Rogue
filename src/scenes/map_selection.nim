proc drawMapSelectionScene() =
  clearBackground(MENU_BG_COLOR)
  const
    PADDING = 16
    BORDER_WIDTH = 2.0
    MAPS_PER_ROW = 2
  
  for i, mapTexture in MAP_LEVELS.mpairs:
    let col = i mod MAPS_PER_ROW
    let row = i div MAPS_PER_ROW
    
    let x = float32(PADDING + col * (map_size + PADDING))
    let y = float32(PADDING + row * (map_size + PADDING))
    
    let mapRect = Rectangle(x: x, y: y, width: map_size.float32, height: map_size.float32)
    
    drawTexture(mapTexture, int32(x), int32(y), WHITE)
    
    drawRectangleLines(mapRect, BORDER_WIDTH, BLACK)
    
    if checkCollisionPointRec(getMousePosition(), mapRect) and isMouseButtonPressed(LEFT):
        SELECTED_MAP = i
        CURRENT_SCENE = GAME