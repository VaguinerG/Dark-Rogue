import ../core/functions
import sequtils, raylib

const raw_logos = @[
    (name: "nim", raw: staticReadBytes("../../assets/images/logos/nim.png")),
    (name: "raylib", raw: staticReadBytes("../../assets/images/logos/raylib.png"))
]