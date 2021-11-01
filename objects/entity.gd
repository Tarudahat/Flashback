class_name Entity
extends KinematicBody2D

export var hp:int = 1000
export var dmg:int = 50

export var disappear_on_death:bool = true
export var knock_back:bool = false
export var immortal:bool = false
export var movement_speed:int = 125
export var ENTITY_WEIGHT:int = 75
export var ENTITY_TYPE:int = Globals.ENTITY_TYPES.ENEMY

var max_hp:int = hp

var prev_hp:int
var knock_back_timer:int 

func damage(input_dmg):
	hp -= input_dmg

func _process(_delta):
	#cap hp
	if immortal:
		hp = max_hp

	if hp > max_hp:
		hp = max_hp
	if hp <= 0:
		hp=0

	if prev_hp > hp and knock_back:
		print("got hit")
		#bad code VVVVV 
		#get_child(1).emitting = true
		
		knock_back_timer = OS.get_system_time_secs()+1

	if hp <= 0 and disappear_on_death:
		queue_free()

	prev_hp = hp



func _physics_process(_delta):
	#knock-back stuff
	if knock_back_timer >= OS.get_system_time_secs():
		hp = prev_hp
