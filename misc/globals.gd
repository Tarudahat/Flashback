extends Node

var gravity:float = 13
var player_node:Node
var current_level:Node

func switch_bool(input_bool):
	match input_bool:
		true:
			return false
		false:
			return true

#needs improvements
func is_in_name(search_name,node_name):
	if search_name in node_name:
		if search_name+"_" in node_name:
			return false
		else:
			return true
