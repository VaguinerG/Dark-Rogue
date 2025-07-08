proc fillMapLevels() =
    var 
        greenDark = Color(r: 0, g: 40, b: 0, a: 255)
        greenLight = Color(r: 0, g: 80, b: 20, a: 255)
        img = genImageChecked(MAP_SIZE, MAP_SIZE, 1, 1, greenDark, greenLight)
    
    imageMipmaps(img)
    MAP_LEVELS[0] = loadTextureFromImage(img)