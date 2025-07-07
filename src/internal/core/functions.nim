macro staticReadBytes(filename: static[string]): seq[uint8] =
    let content = staticRead(filename)
    result = quote do:
        toSeq(`content`.items).mapIt(it.uint8)

macro staticReadString(filename: static[string]): string =
  let content = staticRead(filename)
  result = quote do:
    `content`
    
proc updateVars() =
    WINDOW_CENTER = Vector2(x: getScreenWidth() / 2, y: getScreenHeight() / 2)
    when defined(emscripten):
        let scaleX = getScreenWidth().float / BASE_WINDOW_WIDTH.float
        let scaleY = getScreenHeight().float / BASE_WINDOW_HEIGHT.float
        setMouseScale(scaleX, scaleY)