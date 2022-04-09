class_name Level
extends Node2D

export var index:int = 0
export var multiplayer_active:bool = false

var max_orbs:int = 0

func _ready():
    Globals.current_level = self
    match index:
        2:
            Globals.player_node.get_node("Camera2D").limit_bottom=700
            Globals.player_node.get_node("Camera2D").limit_left=-22
            Globals.player_node.get_node("Camera2D").limit_right=659
