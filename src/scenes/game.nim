proc updatePlayer() =
    let deltaTime = getFrameTime()
    var movement = Vector2(x: 0.0, y: 0.0)
    
    if isKeyDown(W) or isKeyDown(UP): movement.y -= 1.0
    if isKeyDown(S) or isKeyDown(DOWN): movement.y += 1.0
    if isKeyDown(A) or isKeyDown(LEFT): movement.x -= 1.0
    if isKeyDown(D) or isKeyDown(RIGHT): movement.x += 1.0
    
    if length(movement) > 0.0:
        movement = normalize(movement)
        let velocity = scale(movement, PLAYER.speed * deltaTime)
        PLAYER.pos = add(PLAYER.pos, velocity)
        if (PLAYER.animation.name != "RUN"):
            PLAYER.animation.name = "RUN"
            PLAYER.animation.frame = 0
        
        if movement.x < 0.0:
            PLAYER.animation.horizontalFlip = true
        elif movement.x > 0.0:
            PLAYER.animation.horizontalFlip = false
    else:
        if (PLAYER.animation.name != "IDLE"):
            PLAYER.animation.name = "IDLE"
            PLAYER.animation.frame = 0

proc updateCamera() =
    let deltaTime = getFrameTime()
    let elasticity = 5.0
    
    let targetPos = PLAYER.pos
    
    PLAYER_CAMERA.target.x += (targetPos.x - PLAYER_CAMERA.target.x) * elasticity * deltaTime
    PLAYER_CAMERA.target.y += (targetPos.y - PLAYER_CAMERA.target.y) * elasticity * deltaTime
    
    cameraZoom += getMouseWheelMove() * 0.1f
    cameraZoom = clamp(cameraZoom, 0.5f, 3.0f)
    
    PLAYER_CAMERA.offset = Vector2(x: getScreenWidth().float32 / 2.0, y: getScreenHeight().float32 / 2.0)
    PLAYER_CAMERA.rotation = 0.0
    PLAYER_CAMERA.zoom = cameraZoom

proc drawMap() =
    let mapTexture = addr MAP_LEVELS[SELECTED_MAP]
    let tileSize = Vector2(x: mapTexture.width.float32, y: mapTexture.height.float32)
    
    let viewBounds = Rectangle(
        x: PLAYER_CAMERA.target.x - PLAYER_CAMERA.offset.x / cameraZoom,
        y: PLAYER_CAMERA.target.y - PLAYER_CAMERA.offset.y / cameraZoom,
        width: getScreenWidth().float32 / cameraZoom,
        height: getScreenHeight().float32 / cameraZoom
    )
    
    let tileRange = (
        startX: int(viewBounds.x / tileSize.x) - 1,
        startY: int(viewBounds.y / tileSize.y) - 1,
        endX: int((viewBounds.x + viewBounds.width) / tileSize.x) + 1,
        endY: int((viewBounds.y + viewBounds.height) / tileSize.y) + 1
    )
    
    for x in tileRange.startX..tileRange.endX:
        for y in tileRange.startY..tileRange.endY:
            let tilePos = Vector2(x: x.float32 * tileSize.x, y: y.float32 * tileSize.y)
            drawTexture(mapTexture[], tilePos.x.int32, tilePos.y.int32, WHITE)

proc drawUnits() =
    for unit in MAP_UNITS:
        updateAnimation(unit.animation)
        let frameSize = unit.animation.currentFrame.sourceSize
        let centeredPos = subtract(unit.pos, scale(frameSize, 0.5f))
        drawAnimation(unit.animation, centeredPos)

proc spawnMonster() =
    let currentTime = times.getTime().toUnixFloat()
    let spawnRate = GAME_RUN_TIME / 60
    let spawnInterval = 1.0 / spawnRate
    
    if (currentTime - LAST_UNIT_SPAWN_TIME) >= spawnInterval:
        let batIndex = BAT.ord
        if unitsBase[batIndex].texture.id == 0:
            unitsBase[batIndex].texture = loadTextureFromImage(loadImageFromMemory(".png", unitsBase[batIndex].imgBytes))
            unitsBase[batIndex].animationdata = loadAnimationData(unitsBase[batIndex].json, unitsBase[batIndex].texture)
        
        let screenBounds = Vector2(x: getScreenWidth().float32 / cameraZoom, y: getScreenHeight().float32 / cameraZoom)
        let spawnDistance = add(scale(screenBounds, 0.5), Vector2(x: 100.0, y: 100.0))
        
        let angle = rand(360).float32 * PI / 180.0
        let direction = Vector2(x: cos(angle), y: sin(angle))
        let offset = Vector2(
            x: direction.x * (if abs(direction.x) > abs(direction.y): spawnDistance.x else: spawnDistance.y),
            y: direction.y * (if abs(direction.x) > abs(direction.y): spawnDistance.x else: spawnDistance.y)
        )
        
        let spawnPos = add(PLAYER_CAMERA.target, offset)
        
        let newBat = Unit(
            class: BAT,
            pos: spawnPos,
            speed: BASE_MOVE_SPEED * unitsBase[batIndex].speed,
            animation: newAnimation(unitsBase[batIndex].animationdata, "IDLE"),
            hp: BASE_HP * unitsBase[batIndex].hp
        )
        
        MAP_UNITS.add(newBat)
        LAST_UNIT_SPAWN_TIME = currentTime

proc updateUnits() =
    let deltaTime = getFrameTime()
    
    for unit in MAP_UNITS.mitems:
        if unit.class == BAT:
            if PLAYER.hp > 0:
                let direction = subtract(PLAYER.pos, unit.pos)
                if length(direction) > 0.0:
                    let normalizedDirection = normalize(direction)
                    let velocity = scale(normalizedDirection, unit.speed * deltaTime)
                    unit.pos = add(unit.pos, velocity)
                    unit.animation.name = "RUN"
                    
                    if normalizedDirection.x < 0.0:
                        unit.animation.horizontalFlip = true
                    elif normalizedDirection.x > 0.0:
                        unit.animation.horizontalFlip = false
            else:
                unit.animation.name = "IDLE"

proc initGame() =
    let newUnit = Unit(
        class: SELECTED_CHAR,
        pos: Vector2(x: 0.0, y: 0.0),
        speed: BASE_MOVE_SPEED * unitsBase[SELECTED_CHAR.ord].speed,
        animation: newAnimation(unitsBase[SELECTED_CHAR.ord].animationdata, "IDLE"),
        hp: BASE_HP * unitsBase[SELECTED_CHAR.ord].hp
    )
    MAP_UNITS.add(newUnit)
    PLAYER = newUnit
    
proc logicFunction() =
    {.cast(gcsafe).}:
        while true:
            updateUnits()
            waitTime(getFrameTime())

proc drawGame() =
    if MAP_UNITS.len == 0:
        initGame()
        createThread(logicThread, logicFunction)
    
    GAME_RUN_TIME += getFrameTime()
    updatePlayer()
    spawnMonster()
    updateCamera()

    mode2D(PLAYER_CAMERA):
        drawMap()
        drawUnits()