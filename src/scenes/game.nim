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
    let spawnRate = GAME_RUN_TIME / 1
    let spawnInterval = 1.0 / spawnRate
    
    if (currentTime - LAST_UNIT_SPAWN_TIME) >= spawnInterval:
        let screenBounds = Vector2(x: getScreenWidth().float32 / cameraZoom, y: getScreenHeight().float32 / cameraZoom)
        let spawnDistance = add(scale(screenBounds, 0.5), Vector2(x: 100.0, y: 100.0))
        
        let angle = rand(360).float32 * PI / 180.0
        let direction = Vector2(x: cos(angle), y: sin(angle))
        let offset = Vector2(
            x: direction.x * (if abs(direction.x) > abs(direction.y): spawnDistance.x else: spawnDistance.y),
            y: direction.y * (if abs(direction.x) > abs(direction.y): spawnDistance.x else: spawnDistance.y)
        )
        
        let spawnPos = add(PLAYER_CAMERA.target, offset)
        let batIndex = BAT.ord
        let newBat = Unit(
            class: BAT,
            pos: spawnPos,
            speed: BASE_MOVE_SPEED * unitsBase[batIndex].speed,
            attackrange: BASE_ATTACK_RANGE * unitsBase[batIndex].attackrange,
            attackdamage: BASE_ATTACK_DAMAGE * unitsBase[batIndex].attackdamage,
            animation: newAnimation(unitsBase[batIndex].animationdata, "IDLE"),
            hp: BASE_HP * unitsBase[batIndex].hp
        )
        
        MAP_UNITS.add(newBat)
        LAST_UNIT_SPAWN_TIME = currentTime

proc getNearbyUnits(unit: Unit, radius: float): seq[Unit] =
    MAP_UNITS.filterIt(it != unit and distance(unit.pos, it.pos) <= radius and not (it.animation.name == "DEATH"))

proc moveUnitToUnit(unit: Unit, target: Unit) =
   let
       collisionRadius = unit.attackrange
       pushForce = 10.0
       direction = subtract(target.pos, unit.pos)
       normalizedDirection = normalize(direction)
       velocity = scale(normalizedDirection, unit.speed * getFrameTime())
       nearbyUnits = getNearbyUnits(unit, collisionRadius)
   
   for nearby in nearbyUnits:
       let pushDirection = normalize(subtract(nearby.pos, unit.pos))
       nearby.pos = add(nearby.pos, scale(pushDirection, pushForce * getFrameTime()))
   
   unit.pos = add(unit.pos, velocity)
   unit.animation.horizontalFlip = unit.pos.x > PLAYER.pos.x
   unit.animation.name = "RUN"

proc isUnitMovable(unit: Unit): bool =
    if unit.animation.playOnce:
        if unit.animation.finished:
            unit.animation.name = "IDLE"
            unit.animation.playOnce = false
            unit.animation.finished = false
            unit.animation.paused = false
            return true
        else:
            return false
    if unit.animation.paused: return false
    return true

proc updatePlayer() =
    let deltaTime = getFrameTime()
    var movement = Vector2(x: 0.0, y: 0.0)
    
    if isKeyDown(W) or isKeyDown(UP): movement.y -= 1.0
    if isKeyDown(S) or isKeyDown(DOWN): movement.y += 1.0
    if isKeyDown(A) or isKeyDown(LEFT): movement.x -= 1.0
    if isKeyDown(D) or isKeyDown(RIGHT): movement.x += 1.0
    
    if isUnitMovable(PLAYER):
        if length(movement) > 0.0:
            movement = normalize(movement)
            let velocity = scale(movement, PLAYER.speed * deltaTime)
            PLAYER.pos = add(PLAYER.pos, velocity)

            PLAYER.animation.name = "RUN"
            
            PLAYER.animation.horizontalFlip = movement.x < 0.0    
        else:
            PLAYER.animation.name = "IDLE"
            
proc unitAnimateOnce(unit: Unit, animations: varargs[string]) =
    let frames = unit.animation.animationData.frames
    let availableAnimations = animations.filterIt(it in frames)

    unit.animation.name = availableAnimations.sample()
    unit.animation.frame = 0
    unit.animation.playOnce = true
    unit.animation.finished = false
    unit.animation.paused = false

proc damageUnit(attacker: Unit, target: Unit) =
    target.hp -= attacker.attackdamage
    if target.hp < 1:
        target.animation.name = "DEATH"
        target.animation.frame = 0
        target.animation.playOnce = true
        target.animation.finished = false
        target.animation.paused = false

proc updateUnits() =
    MAP_UNITS = MAP_UNITS.filterIt(not (it.hp < 1 and it.animation.name == "DEATH" and it.animation.finished))
    
    for unit in MAP_UNITS:
        if unit.hp < 1:
            continue
            
        case unit.class:
            of BAT:
                if isUnitMovable(unit) and PLAYER.hp > 0:
                    if distance(unit.pos, PLAYER.pos) > unit.attackrange:
                        moveUnitToUnit(unit, PLAYER)
                    else:
                        unitAnimateOnce(unit, "ATTACK1", "ATTACK2")
            of MOONSTONE:
                if isUnitMovable(unit):
                    let nearbyUnits = getNearbyUnits(unit, unit.attackrange)
                    if nearbyUnits.len > 0:
                        unitAnimateOnce(unit, "ATTACK1", "ATTACK2")
                        for target in nearbyUnits:
                            damageUnit(PLAYER, target)
                        
            else:
                discard

proc initGame() =
    let batIndex = BAT.ord
    if unitsBase[batIndex].texture.id == 0:
        unitsBase[batIndex].texture = loadTextureFromImage(loadImageFromMemory(".png", unitsBase[batIndex].imgBytes))
        unitsBase[batIndex].animationdata = loadAnimationData(unitsBase[batIndex].json, unitsBase[batIndex].texture)
    
    let newUnit = Unit(
        class: SELECTED_CHAR,
        pos: Vector2(x: 0.0, y: 0.0),
        speed: BASE_MOVE_SPEED * unitsBase[SELECTED_CHAR.ord].speed,
        attackdamage: BASE_ATTACK_DAMAGE * unitsBase[SELECTED_CHAR.ord].attackdamage,
        attackrange: BASE_ATTACK_RANGE * unitsBase[SELECTED_CHAR.ord].attackrange,
        animation: newAnimation(unitsBase[SELECTED_CHAR.ord].animationdata, "IDLE"),
        hp: BASE_HP * unitsBase[SELECTED_CHAR.ord].hp
    )
    MAP_UNITS.add(newUnit)
    PLAYER = newUnit
    
proc logicFunction() =
    {.cast(gcsafe).}:
        while true:
            spawnMonster()
            updateUnits()
            waitTime(getFrameTime())

proc drawGame() =
    if MAP_UNITS.len == 0:
        initGame()
        createThread(logicThread, logicFunction)
    
    GAME_RUN_TIME += getFrameTime()
    updatePlayer()
    updateCamera()

    mode2D(PLAYER_CAMERA):
        drawMap()
        drawUnits()