# The order must respect UnitClass enum order
var unitsBase = @[
  (
    name: "Moonstone",
    imgBytes: staticReadBytes("../../assets/images/units/heroes/moonstone/moonstone_opt.png"),
    jsonBytes: staticReadBytes("../../assets/images/units/heroes/moonstone/moonstone.json"),
    texture: Texture2D(),
    animation: AnimationData(),
    type: HERO,
  ),
  (
    name: "Arcane Archer",
    imgBytes: staticReadBytes("../../assets/images/units/heroes/arcane_archer/arcane_archer_opt.png"),
    jsonBytes: staticReadBytes("../../assets/images/units/heroes/arcane_archer/arcane_archer.json"),
    texture: Texture2D(),
    animation: AnimationData(),
    type: HERO,
  )
]