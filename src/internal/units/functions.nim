proc unitBasicAttackAI(unit: var Unit, deltaTime: float) =
    const attackRange = 50.0
    
    if unit.animation.name == "ATTACK1" and unit.animation.finished:
        unit.animation.name = "IDLE"
        unit.animation.playOnce = false
        unit.animation.finished = false
        unit.animation.paused = false
        return
    
    let direction = subtract(PLAYER.pos, unit.pos)
    let distanceToPlayer = length(direction)
    
    if distanceToPlayer <= attackRange:
        if unit.animation.name != "ATTACK1":
            unit.animation.name = "ATTACK1"
            unit.animation.frame = 0
            unit.animation.playOnce = true
            
            if direction.x < 0.0:
                unit.animation.horizontalFlip = true
            elif direction.x > 0.0:
                unit.animation.horizontalFlip = false
    
    elif unit.animation.name != "ATTACK1" and distanceToPlayer > 0.0:
        let normalizedDirection = normalize(direction)
        let velocity = scale(normalizedDirection, unit.speed * deltaTime)
        unit.pos = add(unit.pos, velocity)
        unit.animation.name = "RUN"
        
        if normalizedDirection.x < 0.0:
            unit.animation.horizontalFlip = true
        elif normalizedDirection.x > 0.0:
            unit.animation.horizontalFlip = false
    
    elif unit.animation.name != "ATTACK1":
        unit.animation.name = "IDLE"