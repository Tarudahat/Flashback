extends Node

enum ENTITY_TYPES{ENEMY,OBJECT,PLAYER}

func switch_bool(input_bool):
    match input_bool:
        true:
            return false
        false:
            return true