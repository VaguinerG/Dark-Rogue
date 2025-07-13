proc getCenterOffset(): Vector2 =
    Vector2(x: getScreenWidth().float32 / 2.0, y: getScreenHeight().float32 / 2.0)

proc updateCamera() =
    let deltaTime = getFrameTime()

    player_camera.target = lerp(player_camera.target, PLAYER.pos, camera_elasticity * deltaTime)

    camera_zoom_target = clamp(camera_zoom_target + getMouseWheelMove() * 0.1f, 0.5f, 3.0f)

    camera_zoom_current = lerp(camera_zoom_current, camera_zoom_target, camera_elasticity * deltaTime)

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