import admob # required because of android version, even if not used
import os, sequtils, raylib, raygui, macros

import external/[nimsystemfonts, nayanim]

include internal/[core/constants, core/types, core/variables, core/functions]
include internal/[logos/variables]
include internal/[fonts/constants, fonts/variables, fonts/functions]
include internal/[units/types, units/variables]

include scenes/[logo, menu, character_selection]

setTraceLogLevel(None)
setConfigFlags(flags(WindowResizable, Msaa4xHint, VsyncHint))

initWindow(BASE_WINDOW_WIDTH, BASE_WINDOW_HEIGHT, "Dark Rogue")

block:
    loadSystemFont()
    while not windowShouldClose():
        updateVars()
        drawing:
            clearBackground(MENU_BG_COLOR)
            case CURRENT_SCENE:
                of LOGO:
                    drawLogoScene()
                of MENU:
                    drawMenuScreen()
                of CHAR_SELECTION:
                    drawCharacterSelection()

closeWindow()