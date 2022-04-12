extends Node

var gravity:float = 13
var player_node:Node
var player_node2:Node
var co_op:bool 
var current_level:Node
var lights_on:bool = true

func get_closest_player(position_:Vector2):
    if co_op:
        if player_node.position.distance_squared_to(position_)<player_node2.position.distance_squared_to(position_):
            return player_node
        else:
            return player_node2
    return player_node

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
