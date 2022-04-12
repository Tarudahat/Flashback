extends Entity

var velocity:Vector2 = Vector2()
var vortex = preload("res://objects/enemies/vortex.tscn").instance()

func _process(_delta):
    closest_player = Globals.get_closest_player(position)
    velocity = (closest_player.position-position).normalized()

    if velocity.x>0:
        $eye_sprite.frame=1
    elif velocity.x<0:
        $eye_sprite.frame=0
    
    velocity = move_and_slide(velocity*movement_speed)
    for i in get_slide_count():
        var collision = get_slide_collision(0)
        if collision.collider is Entity:
            if collision.collider.ENTITY_TYPE==collision.collider.ENTITY_TYPES.PLAYER and is_queued_for_deletion()==false:
                vortex.position=position
                get_parent().add_child(vortex)
                queue_free()
