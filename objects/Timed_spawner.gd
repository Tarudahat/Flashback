extends Node2D

export var use_path:bool = false
export(String, FILE) var object_path = ""

var object

func _ready():
    if get_child_count()>=2:
        object = get_child(1).duplicate()
        get_child(1).queue_free()
    if use_path:
        object = load(object_path).instance()
    
func _on_Timer_timeout():
    if use_path:
        var pain_node = load(object_path).instance()
        pain_node.position=position
        get_parent().add_child(pain_node)
    else:
        object.position=position
        get_parent().add_child(object.duplicate())
