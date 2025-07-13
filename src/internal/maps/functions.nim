proc fillMapLevels() =
    const
        greenShades = [
            Color(r: 0, g: 40, b: 0, a: 255),
            Color(r: 0, g: 60, b: 15, a: 255),
            Color(r: 0, g: 80, b: 20, a: 255)
        ]
    
    var 
        img = genImageColor(map_size, map_size, greenShades[1])
        pixels = newSeqWith(map_size, newSeq[Color](map_size))
    
    for row in pixels.mitems:
        for pixel in row.mitems:
            pixel = greenShades[1]
    
    randomize()
    
    template wrap(coord, size: int): int = 
        ((coord mod size) + size) mod size
    
    template `[]`(arr: seq[seq[Color]], x, y: int): Color =
        arr[wrap(y, map_size)][wrap(x, map_size)]
    
    template `[]=`(arr: var seq[seq[Color]], x, y: int, color: Color) =
        arr[wrap(y, map_size)][wrap(x, map_size)] = color
    
    proc sample[T](arr: seq[T]): T = arr[rand(arr.len - 1)]
    
    for _ in 0..<(map_size shr 3):
        pixels[rand(map_size), rand(map_size)] = sample(greenShades)
    
    for pass in 1..3:
        for y in 0..<map_size:
            for x in 0..<map_size:
                var neighbors: seq[Color] = @[]
                for dy in -1..1:
                    for dx in -1..1:
                        if dx != 0 or dy != 0:
                            neighbors.add(pixels[x + dx, y + dy])
                
                pixels[x, y] = if rand(1.0) < 0.85:
                    sample(neighbors)
                else:
                    sample(greenShades)
    
    for y in 0..<map_size:
        for x in 0..<map_size:
            imageDrawPixel(img, x.int32, y.int32, pixels[y][x])
    
    imageMipmaps(img)
    MAP_LEVELS[0] = loadTextureFromImage(img)