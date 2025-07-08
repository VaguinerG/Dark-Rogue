var
    camera: Camera2D
    playerPos: Vector2 = Vector2(x: 0.0, y: 0.0)
    playerRadius: float32 = 20.0
    playerSpeed: float32 = 200.0

proc updatePlayer() =
    let deltaTime = getFrameTime()
    
    if isKeyDown(W) or isKeyDown(UP): playerPos.y -= playerSpeed * deltaTime
    if isKeyDown(S) or isKeyDown(DOWN): playerPos.y += playerSpeed * deltaTime
    if isKeyDown(A) or isKeyDown(LEFT): playerPos.x -= playerSpeed * deltaTime
    if isKeyDown(D) or isKeyDown(RIGHT): playerPos.x += playerSpeed * deltaTime

proc updateCamera() =
    camera.target = playerPos
    camera.offset = Vector2(x: getScreenWidth().float32 / 2.0, y: getScreenHeight().float32 / 2.0)
    camera.rotation = 0.0
    camera.zoom = 1.0

proc drawMap() =
    if MAP_LEVELS.len > 0 and SELECTED_MAP < MAP_LEVELS.len:
        let mapTexture = addr MAP_LEVELS[SELECTED_MAP]
        let textureWidth = mapTexture.width.float32
        let textureHeight = mapTexture.height.float32
        
        let startX = int((camera.target.x - camera.offset.x) / textureWidth) - 1
        let startY = int((camera.target.y - camera.offset.y) / textureHeight) - 1
        let endX = int((camera.target.x + camera.offset.x) / textureWidth) + 1
        let endY = int((camera.target.y + camera.offset.y) / textureHeight) + 1
        
        for x in startX..endX:
            for y in startY..endY:
                let posX = x.float32 * textureWidth
                let posY = y.float32 * textureHeight
                drawTexture(mapTexture[], posX.int32, posY.int32, WHITE)

proc drawPlayer() =
    drawCircle(playerPos, playerRadius, RED)

proc drawUI() =
    drawText("Use WASD para mover", 10, 10, 20, WHITE)

proc drawGame() =
    updatePlayer()
    updateCamera()
    
    mode2D(camera):
        drawMap()
        drawPlayer()
    
    drawUI()