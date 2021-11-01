extends Entity

var player_positions:PoolVector3Array#save positions and looking direction
var velocity:Vector2
var jumping:bool = false
var jump_velocity:Vector2
var MAXJUMPY:int = 775
var looking_dir:int
var cooldown_timer:int

func _ready():
	movement_speed=150

func _process(_delta):
	velocity = Vector2(0,0)

	if Input.is_action_pressed("in_left"):
		velocity.x -= movement_speed
		$AnimatedSprite.flip_h=true
		looking_dir=1
	if Input.is_action_pressed("in_right"):
		velocity.x += movement_speed
		$AnimatedSprite.flip_h=false
		looking_dir=0

	if is_on_floor():
		if !jumping:
			if Input.is_action_pressed("in_jump"):
				jump_velocity.y = MAXJUMPY
				jumping = true
		else:
			jumping=false
	else:
		velocity.y += ENTITY_WEIGHT*4.2

	if jumping:
		if is_on_ceiling():
			jump_velocity.y -= 250
		velocity.y -= jump_velocity.y
		jump_velocity.y -= 22
		if jump_velocity.y<0:
			jumping=false	
			jump_velocity.y=0				
			
	if Input.is_action_just_pressed("in_rewind"):
		player_positions.invert()
	if Input.is_action_just_released("in_rewind"):
		cooldown_timer = OS.get_system_time_secs()+3
		if player_positions.size()>=1:
			player_positions.resize(0)
		$CollisionShape2D.disabled=false
	
	if Input.is_action_pressed("in_rewind") and OS.get_system_time_secs() >= cooldown_timer:
		if player_positions.size()>0:
			position=Vector2(player_positions[0].x,player_positions[0].y)
			match player_positions[0].z:
				0.0:
					$AnimatedSprite.flip_h=false
				1.0:
					$AnimatedSprite.flip_h=true
			player_positions.remove(0)
		else:
			cooldown_timer = OS.get_system_time_secs()+3
	
		$CollisionShape2D.disabled=true
	else:
		$CollisionShape2D.disabled=false
		velocity = move_and_slide(velocity, Vector2.UP)
		if OS.get_system_time_secs() >= cooldown_timer:
			player_positions.append(Vector3(position.x,position.y,looking_dir))

	if player_positions.size()>=500:
		player_positions.remove(0)
