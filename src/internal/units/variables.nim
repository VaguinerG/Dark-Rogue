var logicThread: Thread[void]

# The order must respect UnitClass enum order
var unitsBase = @[
    (
        name: "Moonstone",
        imgBytes: staticReadBytes("../../assets/images/units/heroes/moonstone/moonstone_opt.png"),
        json: staticReadString("../../assets/images/units/heroes/moonstone/moonstone.json"),
        texture: Texture2D(),
        animationdata: AnimationData(),
        type: HERO,
        speed: 1.1,
        hp: 2.0
    ),
    (
        name: "Arcane Archer",
        imgBytes: staticReadBytes("../../assets/images/units/heroes/arcane_archer/arcane_archer_opt.png"),
        json: staticReadString("../../assets/images/units/heroes/arcane_archer/arcane_archer.json"),
        texture: Texture2D(),
        animationdata: AnimationData(),
        type: HERO,
        speed: 1.6,
        hp: 0.5
    ),
    (
        name: "Bat",
        imgBytes: staticReadBytes("../../assets/images/units/monsters/bat/bat_opt.png"),
        json: staticReadString("../../assets/images/units/monsters/bat/bat.json"),
        texture: Texture2D(),
        animationdata: AnimationData(),
        type: MONSTER,
        speed: 0.7,
        hp: 0.1
    )
]