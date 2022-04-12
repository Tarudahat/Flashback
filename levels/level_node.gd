class_name Level
extends Node2D

export var index:int = 0

var max_orbs:int = 0

func _ready():
    Globals.current_level = self
    Globals.player_node.modulate.r = 1
    Globals.lights_on = true
