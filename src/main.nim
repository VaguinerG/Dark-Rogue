import admob # required because of android version, even if not used
import sequtils, raylib, raygui, macros, strutils, unicode, raymath

import external/[nayanim]

include internal/[core/constants, core/types, core/variables, core/functions]
include internal/[maps/variables, maps/functions]
include internal/[translations/constants, translations/variables, translations/functions]
include internal/[logos/variables]
include internal/[units/types, units/variables]
include internal/[game/variables]

include scenes/[logo, menu, character_selection, language_selection, map_selection, game]

#setTraceLogLevel(None)
setConfigFlags(flags(WindowResizable, Msaa4xHint, VsyncHint))

initWindow(BASE_WINDOW_WIDTH, BASE_WINDOW_HEIGHT, "Dark Rogue")

block:
    loadFonts()
    guiLoadStyleDark()
    while not windowShouldClose():
        updateVars()
        drawing:
            case CURRENT_SCENE:
                of LANGUAGE_SELECTION:
                    drawLanguageSelectionScene()
                of LOGO:
                    drawLogoScene()
                of MENU:
                    drawMenuScreen()
                of CHAR_SELECTION:
                    drawCharacterSelection()
                of MAP_SELECTION:
                    drawMapSelectionScene()
                of GAME:
                    drawGame()

closeWindow()