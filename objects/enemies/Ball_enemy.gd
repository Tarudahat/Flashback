extends Entity

export var velocity:Vector2 = Vector2(0,0)
var og_velocity:Vector2

func _ready():
    og_velocity = velocity


func _process(delta):
    velocity.x = og_velocity.x*movement_speed
    rotate(delta*velocity.x/35.0)
    
    if velocity.y<=350:
        velocity.y+=ENTITY_WEIGHT*Globals.gravity*delta
    else:
        velocity.y=350

    velocity = move_and_slide(velocity)
    for i in get_slide_count():
        var collision = get_slide_collision(i)
        if collision.collider is Entity:
            if collision.collider.ENTITY_TYPE==collision.collider.ENTITY_TYPES.PLAYER:
                collision.collider.damage(dmg,true)
