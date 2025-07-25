import raylib

const
    # Base windows size. Needed to fix mouse offset on webassembly at updateVars() 
    BASE_WINDOW_WIDTH* = 800
    BASE_WINDOW_HEIGHT* = 600

    # Default colors
    MENU_BG_COLOR* = Color(r: 32, g: 32, b: 29, a: 255)