var
    SELECTED_CHAR: UnitClass
    MAP_UNITS: seq[Unit]
    PLAYER: Unit
    PLAYER_CAMERA: Camera2d

var
    LAST_UNIT_SPAWN_TIME = getTime()

var
    cameraZoom = 1.0

var
    BASE_MOVE_SPEED = 100.0
    BASE_HP = 50.0