proc drawMapSelectionScene() =
  const
    MAP_SIZE = 256
    PADDING = 16
    BORDER_WIDTH = 2.0
    MAPS_PER_ROW = 2
  
  for i, mapTexture in MAP_LEVELS.mpairs:
    let col = i mod MAPS_PER_ROW
    let row = i div MAPS_PER_ROW
    
    let x = float32(PADDING + col * (MAP_SIZE + PADDING))
    let y = float32(PADDING + row * (MAP_SIZE + PADDING))
    
    let mapRect = Rectangle(x: x, y: y, width: MAP_SIZE.float32, height: MAP_SIZE.float32)
    
    # Desenha o mapa
    drawTexture(mapTexture, int32(x), int32(y), WHITE)
    
    # Desenha a borda
    drawRectangleLines(mapRect, BORDER_WIDTH, BLACK)
    
    # Verifica clique no mapa
    if checkCollisionPointRec(getMousePosition(), mapRect) and isMouseButtonPressed(LEFT):
        SELECTED_MAP = i
        CURRENT_SCENE = GAME