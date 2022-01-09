extends Node2D

export var boss_hp = 5000
var velocity
var current_attack: int = -1
var att_start_hp: int 

func attack(id):
    match id:
        0:
            $cager_fist.position=Vector2(1200,332)
            $cager_fist.rotation_degrees=90
    current_attack = id
    att_start_hp=$cager_fist.hp

func _ready():
    attack(0)

func _process(_delta):
    #velocity = Vector2()
    match current_attack:
        0:
            velocity = Vector2(-1,0)

    $cager_fist.move_and_slide(velocity.normalized()*175,Vector2.UP)

    for i in $cager_fist.get_slide_count():
        var collision = $cager_fist.get_slide_collision(i)
        if collision.collider is Entity:
            var temp_node = collision.collider
            temp_node.damage($cager_fist.dmg,true)

    if $cager_fist.hp != att_start_hp and current_attack != -1:
    
        boss_hp-=att_start_hp-$cager_fist.hp
        velocity = velocity*-5
        current_attack=-1
