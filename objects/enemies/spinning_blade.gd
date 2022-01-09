extends Entity

var velocity:Vector2 = Vector2(rand_range(0,1),rand_range(0,1)).normalized()

func _ready():
    dmg = 10
    velocity*=movement_speed


func _process(delta):
    rotate(delta*(movement_speed/5.0))
    velocity = move_and_slide(velocity.normalized()*movement_speed)

    for i in get_slide_count():
        var collision = get_slide_collision(i)
        if collision.collider is TileMap:
            velocity = (velocity.reflect(collision.normal)+collision.normal*15)
        elif collision.collider is Entity:
            if Globals.is_in_name("Player", collision.collider.name):
                Globals.player_node.damage(dmg,true)
