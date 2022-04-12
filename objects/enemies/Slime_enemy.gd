extends Entity

const JUMP_POWER:int = 325
var should_jump:bool = false
var timers:Dictionary = {"jump_timer":0}
var velocity:Vector2

func _process(delta):
    closest_player=Globals.get_closest_player(position)
    if abs(position.length()-closest_player.position.length())<500:

        if velocity.y<=3500:
            velocity.y += ENTITY_WEIGHT*Globals.gravity*delta
        if abs(position.length()-closest_player.position.length())<170 and timers["jump_timer"]<=OS.get_system_time_secs():
            should_jump = true
        
        velocity.x -= delta
        if abs(velocity.x)<1:
            velocity.x = 0
        if closest_player.position.x > position.x+15:
            $AnimatedSprite.flip_h=true
            velocity.x = 1*movement_speed
        elif closest_player.position.x < position.x-15:
            $AnimatedSprite.flip_h=false
            velocity.x = -1*movement_speed

        if is_on_floor() and should_jump:
            timers["jump_timer"]=OS.get_system_time_secs()+round(rand_range(3,5))
            velocity.y=-JUMP_POWER
            should_jump = false
        
        if is_on_floor():
            movement_speed=15
        else:
            movement_speed=35

        velocity = move_and_slide(velocity,Vector2.UP)

        for i in get_slide_count():
            var collision = get_slide_collision(i)
            if collision.collider is Entity:
                if collision.collider.ENTITY_TYPE==collision.collider.ENTITY_TYPES.PLAYER:
                    collision.collider.damage(dmg,true)

    
