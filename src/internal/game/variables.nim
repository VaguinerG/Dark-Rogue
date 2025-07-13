var
    player_camera: Camera2d
    camera_zoom_target: float = 3.0
    camera_zoom_current: float = 50.0
    camera_elasticity = 5.0

var
    unit_quadspace: QuadSpace

var
    SELECTED_CHAR: UnitClass
    MAP_UNITS: seq[Unit]
    PLAYER: Unit

var
    GAME_RUN_TIME = 0.0
    LAST_UNIT_SPAWN_TIME = times.getTime().toUnixFloat()
    LAST_UNIT_CLEANUP_TIME = times.getTime().toUnixFloat()
    MAP_UNITS_SPAWN_OVERLOADED = false

var
    BASE_MOVE_SPEED = 100.0
    BASE_HP = 50.0
    BASE_ATTACK_RANGE = 20.0
    BASE_ATTACK_DAMAGE = 2.0