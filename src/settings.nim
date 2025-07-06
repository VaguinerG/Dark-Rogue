setTraceLogLevel(None)
setConfigFlags(flags(WindowResizable, Msaa4xHint, VsyncHint))

macro staticReadBytes(filename: static[string]): seq[uint8] =
  let content = staticRead(filename)
  result = quote do:
    toSeq(`content`.items).mapIt(it.uint8)

type GameScenes = enum
    LOGO, MENU, CHAR_SELECTION

const
    baseWidth = 800
    baseHeight = 600

const
    SYSTEM_FONTS = getSystemFonts()

var
    MENU_BG_COLOR = Color(r: 32, g: 32, b: 29, a: 255)
    MENU_FONT = getFontDefault()
    GAME_SCENE: GameScenes = LOGO
    WINDOW_CENTER: Vector2

proc updateVars() =
    WINDOW_CENTER = Vector2(x: getScreenWidth() / 2, y: getScreenHeight() / 2)
    when defined(emscripten):
        let scaleX = getScreenWidth().float / baseWidth.float
        let scaleY = getScreenHeight().float / baseHeight.float
        setMouseScale(scaleX, scaleY)

const
    NIM_LOGO_BYTES = staticReadBytes("assets/images/logos/nim.png")
    RAYLIB_LOGO_BYTES = staticReadBytes("assets/images/logos/raylib.png")

var
    NIM_LOGO: Texture2D
    RAYLIB_LOGO: Texture2D

