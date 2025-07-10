type 
    UnitType = enum
        HERO, MONSTER

    UnitClass = enum
        MOONSTONE, ARCANE_ARCHER, BAT

    Unit = ref object
        class: UnitClass
        pos: Vector2
        speed: float
        animation: AnimationState
        hp: float
        attackrange: float
        attackdamage: float
        updating: bool