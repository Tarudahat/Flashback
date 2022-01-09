extends Entity

var velocity:Vector2
var should_fall:bool = false
var timer_:int = -1
var og_position:Vector2

func _ready():
    og_position = get_global_position()
    max_hp = hp

func _process(delta):
    position.x = og_position.x
    velocity.x = 0

    if hp<=0 and timer_== -1:
        should_fall=true
        timer_ = OS.get_system_time_secs()+2

    if timer_<= OS.get_system_time_secs() and timer_!= -1:
        should_fall=false
        hp=max_hp
        timer_ = -1

    if should_fall:
        if velocity.y<=3500:
            velocity.y += ENTITY_WEIGHT*Globals.gravity*delta
    else:
        if position.y>og_position.y:
            velocity.y = -50
        else:
            velocity.y =0

    velocity = move_and_slide(velocity,Vector2.UP)


    for i in get_slide_count():
        var collision = get_slide_collision(i)
        if collision.collider is Entity:
            var temp_node = collision.collider
            temp_node.damage(dmg,true)
    
