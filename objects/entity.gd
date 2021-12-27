class_name Entity
extends KinematicBody2D

export var hp:int = 350
export var dmg:int = 50

export var disappear_on_death:bool = true
export var knock_back:bool = false
export var immortal:bool = false
export var movement_speed:int = 125
export var ENTITY_WEIGHT:int = 75
export var ENTITY_TYPE:int = Globals.ENTITY_TYPES.ENEMY #ENEMY=0, OBJECT=1, PLAYER=2

var max_hp:int = hp

var prev_hp:int
var entity_timers: Dictionary = {"knock_back_timer":0,"flicker_timer":0}

func _ready():
	self.material = preload("res://objects/entity_material.tres").duplicate(true)

func damage(dmg_amount,respect_knockback):
	if !immortal and (entity_timers["knock_back_timer"]<=OS.get_system_time_secs() or respect_knockback==false):
		entity_timers["flicker_timer"] = OS.get_system_time_msecs()+250

		if dmg_amount>0:
			material.set_shader_param("should_flicker", true)
		if (Globals.player_node.blast_power!=0 or Globals.player_node.rewinding==true):
			material.set_shader_param("should_flicker", false)
		hp-=dmg_amount
		
		if hp > max_hp:
			hp = max_hp
		if hp <= 0:
			hp=0

		if prev_hp > hp and knock_back:
			print("Entity,",self.name," damaged: ",prev_hp-hp)
			entity_timers["knock_back_timer"] = OS.get_system_time_secs()+1
		
		prev_hp = hp

		if hp <= 0 and disappear_on_death:
			queue_free()

func _process(_delta):
	if entity_timers["flicker_timer"] <= OS.get_system_time_msecs():
		material.set_shader_param("should_flicker", false)
