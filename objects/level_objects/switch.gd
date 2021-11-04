extends StaticBody2D

export var active_:bool = false
export var rewind_switch:bool = false

func _process(_delta):
	if rewind_switch:
		if Globals.player_node.rewinding:
			active_=Globals.switch_bool(active_)
