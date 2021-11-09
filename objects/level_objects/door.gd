extends KinematicBody2D

#clean this code please

var target_height:float 
var active_:bool
onready var start_height:float = position.y
var opening_height:float = 75
export var inverted_open:bool = false
export var movement_speed:int = 450
var velocity:Vector2
onready var start_x:float = position.x

func _process(_delta):
	velocity=Vector2(0,0)

	active_=get_parent().active_
	if inverted_open:
		active_=Globals.switch_bool(get_parent().active_)
	match active_:
		false:
			target_height=start_height
			velocity=Vector2(0,1)
		true:
			target_height=start_height-opening_height
			velocity=Vector2(0,-1)

	if (velocity.y == -1 and position.y>target_height) or (velocity.y == 1 and position.y<target_height):
		velocity = move_and_slide(velocity*movement_speed)
	else:#fix overshoots
		position.y=target_height

func _physics_process(_delta):
	position.x=start_x
	
	

	
