let 
    rectangleWidth = 64
    rectangleHeight = 150
    rectangleSPacing = 4
    startX = rectangleWidth

var selectionStates: array[UnitClass, AnimationState]

proc drawCharacterSelection =
    clearBackground(MENU_BG_COLOR)
    for i, HERO in unitsBase.mpairs:
        if HERO.type == UnitType.HERO:
            if selectionStates[UnitClass(i)].name == "":
                selectionStates[UnitClass(i)] = newAnimation(HERO.animationdata, "IDLE")
            updateAnimation(selectionStates[UnitClass(i)])
            let x = startX + (i * rectangleSPacing) + (i * rectangleWidth)
            let rectangle = Rectangle(
                x: x.float,
                y: rectangleHeight.float,
                width: rectangleWidth.float,
                height: rectangleHeight.float,
            )
            drawRectangleLines(rectangle, 1, WHITE)
            let rectangleCenter = Vector2(
                x: rectangle.x + (rectangle.width / 2),
                y: rectangle.y + (rectangle.height / 2)
            )
            let animationPos = Vector2(
                x: rectangleCenter.x - (selectionStates[UnitClass(i)].currentFrame.sourceSize.x / 2),
                y: rectangleCenter.y - (selectionStates[UnitClass(i)].currentFrame.sourceSize.y / 2)
            )
            if checkCollisionPointRec(getMousePosition(), rectangle) and isMouseButtonPressed(LEFT):
                SELECTED_CHAR = UnitClass(i)
                CURRENT_SCENE = MAP_SELECTION
                fillMapLevels()

            drawAnimation(selectionStates[UnitClass(i)], animationPos)