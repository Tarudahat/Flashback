extends Entity

var velocity:Vector2 = Vector2(0,0)
export var free_on_timeout:bool = true

func _process(delta):
    velocity = Vector2()
    velocity = Vector2(sin(delta),cos(delta)).normalized()
    velocity = move_and_slide(velocity*sin(delta))
    for i in get_slide_count():
        var collision = get_slide_collision(i)
        if collision.collider is Entity:
            collision.collider.damage(dmg,true)
            queue_free()


func _on_Timer_timeout():
    if free_on_timeout:
        queue_free()
