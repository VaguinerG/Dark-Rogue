when defined(android):
    import admob

import raylib # core graphics library

import internal/[core, logos]

setTraceLogLevel(None)
setConfigFlags(flags(WindowResizable, Msaa4xHint, VsyncHint))

initWindow(BASE_WINDOW_HEIGHT, BASE_WINDOW_WIDTH, "Dark Rogue")

block:
    while not windowShouldClose():
        drawScene(currentScene)