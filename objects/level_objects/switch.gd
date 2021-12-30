extends StaticBody2D

export var active_:bool = false
export var rewind_switch:bool = false
var has_parent_switch:bool = false

func _ready():
    if Globals.is_in_name("Switch",get_parent().name):
        has_parent_switch=true

func _process(_delta):
    if has_parent_switch:
        get_parent().active_=active_
    if rewind_switch:
        if Globals.player_node.rewinded:
            active_=Globals.switch_bool(active_)
