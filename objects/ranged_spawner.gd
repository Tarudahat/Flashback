extends Node2D
class_name RangeSpawner

export var range_:int = 250
export var use_path:bool = false
export(String, FILE) var object_path = ""

var object
var spawn:bool = false

func _ready():
    if get_child_count()!=0:
        object = get_child(0).duplicate()
        get_child(0).queue_free()
    if use_path:
        object = load(object_path).instance()
        
func _process(_delta):

    if Globals.player_node.position.distance_to(position)-range_<=0:
        spawn = true
    if Globals.co_op:
        if Globals.player_node2.position.distance_to(position)-range_<=0:
            spawn = true

    if spawn:
        object.position=position
        get_parent().add_child(object)
        queue_free()
