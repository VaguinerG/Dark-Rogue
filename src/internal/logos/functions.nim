import ../core/[types, constants]
import raylib

proc drawScene*(scene: Logos.type) =
    var logosTextures = newSeq[Texture2D]()
    
    while not windowShouldClose():
        echo raw_logos
        drawing:
            clearBackground(MENU_BG_COLOR)