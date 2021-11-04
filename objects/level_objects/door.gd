extends KinematicBody2D

export var inverted_active:bool = false
export var movement_speed:int = 5
var active_:bool = false
var start_position:Vector2 = get_global_position()
export var open_height:int = start_position.y-50
var prev_active:bool
var target_height:float
var velocity:Vector2

func _process(_delta):
	active_ = get_parent().active_
	if inverted_active:
		active_ = Globals.switch_bool(get_parent().active_)

	if active_ != prev_active:
		match active_:
			true:
				target_height = open_height
				velocity = Vector2(0,-1)
			false:
				target_height = start_position.y
				velocity = Vector2(0,1)
				

	if (get_global_position().y>=target_height and velocity.y<0) or (get_global_position().y<=target_height and velocity.y>0):
		move_and_slide(velocity*movement_speed,Vector2.UP)
				
	prev_active = active_
