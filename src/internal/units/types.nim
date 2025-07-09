type 
    UnitType = enum
        HERO

    UnitClass = enum
        MOONSTONE, ARCANE_ARCHER

    Unit = ref object
        class: UnitClass
        pos: Vector2
        speed: float
        animation: AnimationState