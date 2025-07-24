import admob  # required because of android compiler, even if not used
import raylib # core graphics library

include internal/[core/constants, core/types, core/globals]


setTraceLogLevel(None)
setConfigFlags(flags(WindowResizable, Msaa4xHint, VsyncHint))

initWindow(BASE_WINDOW_HEIGHT, BASE_WINDOW_WIDTH, "Dark Rogue")

proc drawScene(_: Logos.type) =
    echo true

block:
    while not windowShouldClose():
        drawScene(currentScene)