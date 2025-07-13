converter toVector2*(v: Vec2): Vector2 =
    Vector2(x: v.x, y: v.y)

converter toVec2*(v: Vector2): Vec2 =
    vec2(v.x, v.y)

proc getCenterOffset(): Vec2 =
    vec2(getScreenWidth().float32 / 2.0, getScreenHeight().float32 / 2.0)

proc updateCamera() =
    let deltaTime = getFrameTime()

    player_camera.target = raymath.lerp(player_camera.target, PLAYER.pos, camera_elasticity * deltaTime)

    camera_zoom_target = clamp(camera_zoom_target + getMouseWheelMove() * 0.1f, 0.5f, 3.0f)

    camera_zoom_current = raymath.lerp(camera_zoom_current, camera_zoom_target, camera_elasticity * deltaTime)

    player_camera.offset = getCenterOffset()
    player_camera.rotation = 0.0
    player_camera.zoom = camera_zoom_current

proc drawMap() =
    const
        range = 16
    
    let
        centerX = (player_camera.target.x / map_size).int
        centerY = (player_camera.target.y / map_size).int
    
    for x in (centerX - range)..(centerX + range):
        for y in (centerY - range)..(centerY + range):
            let pos = Vector2(x: x.float32 * map_size, y: y.float32 * map_size)
            drawTexture(MAP_LEVELS[SELECTED_MAP], pos, WHITE)

proc worldToQuadPos(worldPos: Vector2): Vec2 =
    let screenBounds = Vector2(x: getScreenWidth().float32 / camera_zoom_current, y: getScreenHeight().float32 / camera_zoom_current)
    let relativePos = Vector2(
        x: (worldPos.x - player_camera.target.x + screenBounds.x * 0.5) / screenBounds.x,
        y: (worldPos.y - player_camera.target.y + screenBounds.y * 0.5) / screenBounds.y
    )
    return vec2(relativePos.x, relativePos.y)

proc isInCameraView(worldPos: Vector2): bool =
    let screenBounds = Vector2(x: getScreenWidth().float32 / camera_zoom_current, y: getScreenHeight().float32 / camera_zoom_current)
    let relativePos = Vector2(
        x: worldPos.x - player_camera.target.x,
        y: worldPos.y - player_camera.target.y
    )
    return abs(relativePos.x) <= screenBounds.x * 0.6 and abs(relativePos.y) <= screenBounds.y * 0.6
