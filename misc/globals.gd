extends Node

enum ENTITY_TYPES{ENEMY,OBJECT,PLAYER}
var gravity:float = 13
var player_node:Node

func switch_bool(input_bool):
    match input_bool:
        true:
            return false
        false:
            return true