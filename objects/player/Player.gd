extends Entity

var player_movements:PoolVector2Array
var rewind_movements:PoolVector2Array
var velocity:Vector2
var jumping:bool = false
var jump_velocity:Vector2
var MAXJUMPY:int = 750
var rewinding:bool = false

func _ready():
	movement_speed=150

func _process(_delta):
	velocity = Vector2(0,0)

	if Input.is_action_pressed("in_left"):
		velocity.x -= movement_speed
		$AnimatedSprite.flip_h=true
	if Input.is_action_pressed("in_right"):
		velocity.x += movement_speed
		$AnimatedSprite.flip_h=false

	if is_on_floor():
		if !jumping:
			if Input.is_action_pressed("in_jump"):
				jump_velocity.y = MAXJUMPY
				jumping = true
		else:
			jumping=false
	else:
		velocity.y += ENTITY_WEIGHT*4

	if jumping:
		if is_on_ceiling():
			jump_velocity.y -= 350
		velocity.y -= jump_velocity.y
		jump_velocity.y -= 22
		if jump_velocity.y<0:
			jumping=false	
			jump_velocity.y=0		
			
	if Input.is_action_just_pressed("in_rewind"):
		player_movements.invert()
	if Input.is_action_just_released("in_rewind") and rewinding:
		player_movements.resize(0)
		player_movements=rewind_movements
	
	if Input.is_action_pressed("in_rewind"):
		if player_movements.size()>0:
			velocity=player_movements[0]
			player_movements.remove(0)
		rewinding=true
	else:
		rewinding=false
	
	velocity = move_and_slide(velocity, Vector2.UP)

	if is_on_floor():
		velocity.y=0

	if rewinding:
		rewind_movements.append(velocity*-1)
	else:
		player_movements.append(velocity*-1)

	if player_movements.size()>=500:
		player_movements.remove(0)
