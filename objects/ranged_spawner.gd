extends Node2D
class_name RangeSpawner

export var range_:int = 500
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
    object.position=position
        
func _process(_delta):

    if sqrt(pow(abs(Globals.player_node.position.x-position.x),2)+pow(abs(Globals.player_node.position.y-position.y),2))-range_<=0:
        spawn = true
    if Globals.co_op:
        if sqrt(pow(abs(Globals.player_node2.position.x-position.x),2)+pow(abs(Globals.player_node2.position.y-position.y),2))-range_<=0:
            spawn = true

    if spawn:
        get_parent().add_child(object)
        queue_free()
