class_name Level
extends Node2D

export var index:int = 0
export var multiplayer_active:bool = false

var max_orbs:int = 0

func _ready():
	Globals.current_level = self
