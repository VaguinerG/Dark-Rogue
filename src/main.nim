import admob # required because of android version, even if not used
import os, sequtils, raylib, raygui, macros
import external/nimsystemfonts
include settings, setup
include internal/[assets]
include scenes/[logo, menu, character]

initWindow(baseWidth, baseHeight, "Dark Rogue")
initAssets()

block:
    while not windowShouldClose():
        updateVars()
        drawing:
            clearBackground(MENU_BG_COLOR)
            case GAME_SCENE:
                of LOGO:
                    drawLogoScene()
                of MENU:
                    drawMenuScreen()
                of CHAR_SELECTION:
                    drawCharacterSelection()
                else:
                    discard

closeWindow()