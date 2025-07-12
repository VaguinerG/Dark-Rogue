proc getCenterOffset(): Vector2 =
    Vector2(x: getScreenWidth().float32 / 2.0, y: getScreenHeight().float32 / 2.0)

proc updateCamera() =
    let deltaTime = getFrameTime()
    let elasticity = 5.0

    PLAYER_CAMERA.target = lerp(PLAYER_CAMERA.target, PLAYER.pos, elasticity * deltaTime)

    targetZoom = clamp(targetZoom + getMouseWheelMove() * 0.1f, 0.5f, 3.0f)

    cameraZoom = lerp(cameraZoom, targetZoom, elasticity * deltaTime)

    PLAYER_CAMERA.offset = getCenterOffset()
    PLAYER_CAMERA.rotation = 0.0
    PLAYER_CAMERA.zoom = cameraZoom

proc drawMap() =
    let range = 16
    
    let centerX = (PLAYER_CAMERA.target.x / MAP_SIZE).int
    let centerY = (PLAYER_CAMERA.target.y / MAP_SIZE).int
    
    for x in (centerX - range)..(centerX + range):
        for y in (centerY - range)..(centerY + range):
            let pos = Vector2(x: x.float32 * MAP_SIZE, y: y.float32 * MAP_SIZE)
            drawTexture(MAP_LEVELS[SELECTED_MAP], pos, WHITE)

proc drawUnits() =
    withLock MAP_UNITS_LOCK:
        for unit in MAP_UNITS:
            updateAnimation(unit.animation)
            let frameSize = unit.animation.frameSize
            let centeredPos = subtract(unit.pos, scale(frameSize, 0.5f))
            drawAnimation(unit.animation, centeredPos)

proc spawnMonster() =
    if not MAP_UNITS_SPAWN_OVERLOADED:
        let currentTime = times.getTime().toUnixFloat()
        let spawnRate = GAME_RUN_TIME / 60
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
            var batAnimation = newAnimation(unitsBase[batIndex].animationdata, "IDLE")
            let newBat = Unit(
                class: BAT,
                pos: spawnPos,
                speed: BASE_MOVE_SPEED * unitsBase[batIndex].speed,
                attackrange: BASE_ATTACK_RANGE * unitsBase[batIndex].attackrange,
                attackdamage: BASE_ATTACK_DAMAGE * unitsBase[batIndex].attackdamage,
                animation: batAnimation,
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
            
            if movement.x != 0.0:
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
    if target.animation.animationData.frames.getOrDefault("HIT").len > 0:
        target.animation.name = "HIT"
        target.animation.frame = 0
        target.animation.playOnce = true
        target.animation.finished = false
        target.animation.paused = false
    else:
        target.animation.color = RED
    if target.hp < 1:
        target.animation.name = "DEATH"
        target.animation.frame = 0
        target.animation.playOnce = true
        target.animation.finished = false
        target.animation.paused = false

proc updateUnits() =
    let startTime = times.getTime().toUnixFloat()
    
    if (times.getTime().toUnixFloat() - LAST_UNIT_CLEANUP_TIME) > 5.0:
        if tryAcquire(MAP_UNITS_LOCK):
            MAP_UNITS.keepItIf(not (it.hp < 1 and it.animation.name == "DEATH" and it.animation.finished))
            release(MAP_UNITS_LOCK)
            LAST_UNIT_CLEANUP_TIME = times.getTime().toUnixFloat()

    for unit in MAP_UNITS:
        if unit.hp < 1 :
            continue
        if unit.animation.color == RED: 
            unit.animation.color = Color(r: 255, g: 255, b: 255, a: 255)
        if unit.animation.name == "HIT" and unit.animation.finished:
            unit.animation.name = "IDLE"
            unit.animation.frame = 0
            unit.animation.playOnce = false
            unit.animation.finished = false
            unit.animation.paused = false
        case unit.class:
            of BAT:
                if isUnitMovable(unit) and PLAYER.hp > 0:
                    if distance(unit.pos, PLAYER.pos) > unit.attackrange:
                        moveUnitToUnit(unit, PLAYER)
                    else:
                        unitAnimateOnce(unit, "ATTACK1", "ATTACK2")
                        damageUnit(unit, PLAYER)
            of MOONSTONE:
                if isUnitMovable(unit):
                    let nearbyUnits = getNearbyUnits(unit, unit.attackrange)
                    if nearbyUnits.len > 0:
                        unitAnimateOnce(unit, "ATTACK1", "ATTACK2")
                        for target in nearbyUnits:
                            damageUnit(PLAYER, target)
                        
            else:
                discard
    let endTime = times.getTime().toUnixFloat()
    let executionTime = endTime - startTime
    
    MAP_UNITS_SPAWN_OVERLOADED = executionTime > getFrameTime()
    
proc initGame() =
    initLock(MAP_UNITS_LOCK)

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


proc drawTime() =
    let totalSeconds = int(GAME_RUN_TIME)
    let minutes = totalSeconds div 60
    let seconds = totalSeconds mod 60
    let timeText = fmt"{minutes:02d}:{seconds:02d}"
    
    let textSize = measureText(MENU_FONT, timeText, 20.0, 0.0)
    let centerX = (getScreenWidth() - int(textSize.x)) div 2
    
    let position = Vector2(x: float32(centerX), y: 10.0)
    drawText(MENU_FONT, timeText, position, 20.0, 0.0, BLUE)

proc drawUI() =
    drawTime()

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
    drawUI()