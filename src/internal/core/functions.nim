import macros

macro staticReadBytes*(filename: static[string]): seq[uint8] =
    let content = staticRead(filename)
    result = quote do:
        toSeq(`content`.items).mapIt(it.uint8)