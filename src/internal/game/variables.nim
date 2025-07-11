var
    SELECTED_CHAR: UnitClass
    MAP_UNITS: seq[Unit]
    PLAYER: Unit
    PLAYER_CAMERA: Camera2d

var
    GAME_RUN_TIME = 0.0
    LAST_UNIT_SPAWN_TIME = times.getTime().toUnixFloat()
    LAST_UNIT_CLEANUP_TIME = times.getTime().toUnixFloat()
    MAP_UNITS_SPAWN_OVERLOADED = false

var
    cameraZoom = 1.0
    targetZoom = 1.0

var
    BASE_MOVE_SPEED = 100.0
    BASE_HP = 50.0
    BASE_ATTACK_RANGE = 20.0
    BASE_ATTACK_DAMAGE = 2.0