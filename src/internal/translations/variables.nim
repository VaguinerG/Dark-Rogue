proc setlocale(category: cint, locale: cstring): cstring {.header: "<locale.h>", importc.}
discard setlocale(0, "")
LOCALE = $setlocale(0, nil)
LANGUAGE = abbrev(LOCALE.split('_')[0], translations.mapIt(it.locale))
if LANGUAGE < 0: 
    CURRENT_SCENE = LANGUAGE_SELECTION
else: 
    CURRENT_SCENE = LOGO