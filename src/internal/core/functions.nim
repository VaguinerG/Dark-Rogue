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

proc extractUniqueChars(translations: seq[tuple]): seq[int32] =
  var codepoints: seq[int32] = @[]
  
  for trans in translations:
    for field in trans.fields:
      for rune in field.runes:
        let cp = rune.int32
        if cp notin codepoints:
          codepoints.add(cp)
  
  return codepoints

proc guiLoadStyleDark() =
    # DEFAULT
    guiSetStyle(Default, BorderColorNormal, colorToInt(Color(r: 135, g: 135, b: 135, a: 255)))
    guiSetStyle(Default, BaseColorNormal, colorToInt(Color(r: 44, g: 44, b: 44, a: 255)))
    guiSetStyle(Default, TextColorNormal, colorToInt(Color(r: 195, g: 195, b: 195, a: 255)))
    guiSetStyle(Default, BorderColorFocused, colorToInt(Color(r: 225, g: 225, b: 225, a: 255)))
    guiSetStyle(Default, BaseColorFocused, colorToInt(Color(r: 132, g: 132, b: 132, a: 255)))
    guiSetStyle(Default, TextColorFocused, colorToInt(Color(r: 24, g: 24, b: 24, a: 255)))
    guiSetStyle(Default, BorderColorPressed, colorToInt(Color(r: 0, g: 0, b: 0, a: 255)))
    guiSetStyle(Default, BaseColorPressed, colorToInt(Color(r: 239, g: 239, b: 239, a: 255)))
    guiSetStyle(Default, TextColorPressed, colorToInt(Color(r: 32, g: 32, b: 32, a: 255)))
    guiSetStyle(Default, BorderColorDisabled, colorToInt(Color(r: 106, g: 106, b: 106, a: 255)))
    guiSetStyle(Default, BaseColorDisabled, colorToInt(Color(r: 129, g: 129, b: 129, a: 255)))
    guiSetStyle(Default, TextColorDisabled, colorToInt(Color(r: 96, g: 96, b: 96, a: 255)))
    guiSetStyle(Default, TextSpacing, 0)  # era 0x00000000, que é só 0
    guiSetStyle(Default, LineColor, colorToInt(Color(r: 157, g: 157, b: 157, a: 255)))
    guiSetStyle(Default, BackgroundColor, colorToInt(Color(r: 60, g: 60, b: 60, a: 255)))

    # LABEL
    guiSetStyle(Label, TextColorFocused, colorToInt(Color(r: 247, g: 247, b: 247, a: 255)))
    guiSetStyle(Label, TextColorPressed, colorToInt(Color(r: 137, g: 137, b: 137, a: 255)))

    # SLIDER
    guiSetStyle(Slider, TextColorFocused, colorToInt(Color(r: 176, g: 176, b: 176, a: 255)))

    # PROGRESSBAR
    guiSetStyle(Progressbar, TextColorFocused, colorToInt(Color(r: 132, g: 132, b: 132, a: 255)))

    # TEXTBOX
    guiSetStyle(Textbox, TextColorFocused, colorToInt(Color(r: 245, g: 245, b: 245, a: 255)))

    # VALUEBOX
    guiSetStyle(Valuebox, TextColorFocused, colorToInt(Color(r: 246, g: 246, b: 246, a: 255)))