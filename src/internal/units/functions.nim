proc initUnitsAsset() =
    for i, unit in unitsBase.mpairs:
        unit.texture = loadTextureFromImage(loadImageFromMemory(".png", unit.imgBytes))
        unit.animationdata = loadAnimationData(unit.json, unit.texture)