import random

proc fillMapLevels() =
    const
        greenShades = [
            Color(r: 0, g: 40, b: 0, a: 255),
            Color(r: 0, g: 60, b: 15, a: 255),
            Color(r: 0, g: 80, b: 20, a: 255)
        ]
    
    var 
        img = genImageColor(MAP_SIZE, MAP_SIZE, greenShades[1])
        pixels = newSeqWith(MAP_SIZE, newSeq[Color](MAP_SIZE))
    
    for row in pixels.mitems:
        for pixel in row.mitems:
            pixel = greenShades[1]
    
    randomize()
    
    template wrap(coord, size: int): int = 
        ((coord mod size) + size) mod size
    
    template `[]`(arr: seq[seq[Color]], x, y: int): Color =
        arr[wrap(y, MAP_SIZE)][wrap(x, MAP_SIZE)]
    
    template `[]=`(arr: var seq[seq[Color]], x, y: int, color: Color) =
        arr[wrap(y, MAP_SIZE)][wrap(x, MAP_SIZE)] = color
    
    proc sample[T](arr: seq[T]): T = arr[rand(arr.len - 1)]
    
    for _ in 0..<(MAP_SIZE shr 3):
        pixels[rand(MAP_SIZE), rand(MAP_SIZE)] = sample(greenShades)
    
    for pass in 1..3:
        for y in 0..<MAP_SIZE:
            for x in 0..<MAP_SIZE:
                var neighbors: seq[Color] = @[]
                for dy in -1..1:
                    for dx in -1..1:
                        if dx != 0 or dy != 0:
                            neighbors.add(pixels[x + dx, y + dy])
                
                pixels[x, y] = if rand(1.0) < 0.85:
                    sample(neighbors)
                else:
                    sample(greenShades)
    
    for y in 0..<MAP_SIZE:
        for x in 0..<MAP_SIZE:
            imageDrawPixel(img, x.int32, y.int32, pixels[y][x])
    
    imageMipmaps(img)
    MAP_LEVELS[0] = loadTextureFromImage(img)